%% set up folder path
cd('D:\002 MATLAB codes\000 Routine\000 img analysis\')
AB00_experimentalConditions;
material_fdpth = fullfile('D:\SURFdrive folder\002 Academic writing',...
                 '180225 [Manuscript] for Cis-Trans difference',...
                 'material');
phaseDynamicsTable = table;

%% control panel
strain = 'wt';

%% generate experiment_path_list
switch strain 
    case 'wt'
        AB00_importExperimentPathList
        
    case 'ptx1'
        AB00_importExperimentPathList_ptx1
end
N_cell = numel(experiment_path_list);



%% Cell level
for i_cell = 1:N_cell
    experiment_path       = experiment_path_list{i_cell};
    [experiment,rootPath] = parseExperimentPath(experiment_path);
    FitFdpth = fullfile(rootPath,'005 Fit coupling and noise');
    
    AB00_experimentalConditions;
    flowDirectionList = {cisTransFlow{1},'03Axial',...
                         cisTransFlow{2},'04Cross'};
    flowNameList = {'Cis','Axial','Trans','Cross'};
    N_flow       = numel(flowDirectionList);
    
    fprintf('Registering %s,%d/%d\n',experiment,i_cell,N_cell);
    %% Flow level

    for i_flow = 1: N_flow
        % e    : Epsilon
        % _1(2): Flagellum 1(2)
        % _SFs : Single fits
        % _FAO : Fit at once
        
        flowDirection    = flowDirectionList{i_flow};
        flowName         = flowNameList{i_flow};
        matFilePath      = fullfile(FitFdpth,[flowDirection,...
                             '_fittingResults.mat']); 
        if ~exist(matFilePath,'file')
            disp(['Fitting for ',flowDirection,' of ',...
                 experiment,' not found'])
            [e_SFs_1,e_SFs_2,e_std_SFs_1,e_std_SFs_2,...
             e_FAO_1,e_FAO_2,T_eff_SFs_1,T_eff_SFs_2,...
             T_eff_std_SFs_1,        T_eff_std_SFs_2,...
             T_eff_FAO_1,T_eff_FAO_2,f0_SFs_1,f0_SFs_2,...
             f0_std_SFs_1,f0_std_SFs_2,f0_FAO_1,f0_FAO_2]  = deal(NaN);
            continue
        end
        
        %% If file exist, register to table
        load(matFilePath,'fitAllExpAtOnce','subtable1','subtable2');
        e_SFs_1         =  mean(subtable1.epsilon);
        e_SFs_2         =  mean(subtable2.epsilon);
        e_std_SFs_2     =  std(subtable1.epsilon);
        e_std_SFs_1     =  std(subtable2.epsilon);
        e_FAO_1         =  fitAllExpAtOnce.flag1.epsilon;
        e_FAO_2         =  fitAllExpAtOnce.flag2.epsilon;
        
        T_eff_SFs_1     =  mean(subtable1.T_eff);
        T_eff_SFs_2     =  mean(subtable2.T_eff);
        T_eff_std_SFs_1 =  std(subtable1.T_eff);
        T_eff_std_SFs_2 =  std(subtable2.T_eff);
        T_eff_FAO_1     =  fitAllExpAtOnce.flag1.T_eff;
        T_eff_FAO_2     =  fitAllExpAtOnce.flag2.T_eff;
        
        f0_SFs_1        =  mean(subtable1.f0);
        f0_SFs_2        =  mean(subtable2.f0);
        f0_std_SFs_1    =  std (subtable1.f0);
        f0_std_SFs_2    =  std (subtable2.f0);
        f0_FAO_1        =  fitAllExpAtOnce.flag1.f0;
        f0_FAO_2        =  fitAllExpAtOnce.flag2.f0;
        
        calciumConcentration = getCalciumConcentration(expCondition);
        resultThisExp = {experiment,expCondition,calciumConcentration,...
                         flowName   , flowDirection,...
                         e_SFs_1    , e_std_SFs_1    , e_FAO_1    ,...
                         T_eff_SFs_1, T_eff_std_SFs_1, T_eff_FAO_1,...
                         f0_SFs_1   , f0_std_SFs_1   , f0_FAO_1   ,...
                         e_SFs_2    , e_std_SFs_2    , e_FAO_2    ,...
                         T_eff_SFs_2, T_eff_std_SFs_2, T_eff_FAO_2,...
                         f0_SFs_2   , f0_std_SFs_2   , f0_FAO_2}  ;
        
        phaseDynamicsTable = [phaseDynamicsTable;resultThisExp];%#ok<AGROW>
    end  
end

%% save table         
varNames = {'experiment','expCondition','calciumConcentration',...
            'flowName'  ,'flowDircection',...
            'meanEpsilonSingleFits1', 'stdEpsilonSingleFits1',...
            'epsilonFitAtOnce1'     ,...
            'meanTeffSingleFits1'   , 'stdTeffSingleFits1'   ,...
            'TeffFitAtOnce1'        ,...
            'meanf0SingleFits1'     , 'stdf0SingleFits1'     ,...
            'f0FitAtOnce1'          ,...
            'meanEpsilonSingleFits2', 'stdEpsilonSingleFits2',...
            'epsilonFitAtOnce2'     ,...
            'meanTeffSingleFits2'   , 'stdTeffSingleFits2'   ,...
            'TeffFitAtOnce2'        ,...
            'meanf0SingleFits2'     , 'stdf0SingleFits2'     ,...
            'f0FitAtOnce2'};

phaseDynamicsTable.Properties.VariableNames= varNames;
processDate  = datestr(now,30); 
processDate  = strrep(processDate,'T','-');
processDate  = processDate(3:end); % YYMMDD-HHMMSS
saveFileName = sprintf('phaseDynamicsTable_%s_%s.mat',...
               strain,processDate);
% save(fullfile(material_fdpth,saveFileName),'phaseDynamicsTable')





cd('D:\002 MATLAB codes\000 Routine\000 img analysis\')
AB00_experimentalConditions;
saveToFdPath  = 'D:\000 RAW DATA FILES\180807 study cell behavior in different Ca conc';
syncTable = table;


%%
AB00_importExperimentPathList
N_cell = numel(experiment_path_list);

%%
figure()
set(gcf,'DefaultAxesFontSize',10,'DefaultAxesFontWeight','normal',...
    'DefaultAxesLineWidth',1.5,'unit','normalized',...
    'position',[0.1,0.05,0.7,0.8],'PaperPositionMode','auto',...
    'DefaultTextInterpreter','Latex')


for i_cell = 1:N_cell
    
    experiment_path   = experiment_path_list{i_cell};
    experiment        = parseExperimentPath(experiment_path);
    AB00_experimentalConditions;
    flowFolderNameList = {cisTransFlow{1},'03Axial',cisTransFlow{2},...
                          '04Cross'};
    plotFlowList       = {'Cis','Axial','Trans','Cross'};
    N_flow             = numel(flowFolderNameList);
    
    %% variables to register
    temp = strsplit(experiment);
    expDate = temp{1};     cellNo  = temp{2};  clearvars temp
    FWHMList          = zeros(N_flow,1);
    FWHMNoteList      = cell(N_flow,1);
    freqRangList      = cell(N_flow,1);
    singleFlagSync    = '';
    
    %%
    for i_flow = 1: N_flow
        flowName        =  flowFolderNameList{i_flow};
        flowFolderPath  =  fullfile(experiment_path,flowName);
        if ~exist(flowFolderPath,'dir')
            disp(['Folder of ',experiment,'-',flowName,' not found'])
            FWHMList(i_flow) = NaN;
            FWHMNoteList{i_flow} = NaN;
            continue
        end
        %% If this flow exist
        synMatFilePath  =  fullfile(experiment_path,flowName,...
                                   'Synchronization.mat');
        if exist(synMatFilePath,'file')                       
            load(synMatFilePath,'TSync1Ratio_list','TSync2Ratio_list',...
            'freqList');
            if strcmp(cisTransFlow{1},'01XY')
                TSyncRatioList_cis   = TSync1Ratio_list;
                TSyncRatioList_trans = TSync2Ratio_list;
            else
                TSyncRatioList_cis   = TSync2Ratio_list;
                TSyncRatioList_trans = TSync1Ratio_list;
            end
            
            TSyncRatioList    = max([TSyncRatioList_cis,...
                                     TSyncRatioList_trans],[],2);
            
                      
                                    
            %% Sync ratio > 0.5 termed as Sync Range 
            threshold = 0.5;
            [FWHM,...
             freqSyncRange,...
             FWHMNote,reason] = measureSyncRangeByThreshold(...
                                    TSyncRatioList,...
                                    freqList,threshold);
            FWHMList(i_flow)     = FWHM;
            FWHMNoteList{i_flow} = FWHMNote;
            freqRangList(i_flow) = {freqSyncRange};
            if ~strcmp(FWHMNote,'certain')
                 disp({'Cannot determine sync range for:';...
                      ['the ',plotFlowList{i_flow},' of ',experiment];...
                      ['Due to ',reason]})
            end
  
            
            %% Check if there is one flag sync
            diff_TSyncRatio   = TSyncRatioList_cis - ...
                                TSyncRatioList_trans;    
            flowAbbreviation  = {'c','a','t','x'};
            if ~isempty(find(diff_TSyncRatio>0.25)) %#ok<EFIND>
                singleFlagSync = [singleFlagSync,...
                                  '[',flowAbbreviation{i_flow},...
                                  '-cis]'];  %#ok<AGROW>
            end
            if ~isempty(find(diff_TSyncRatio<-0.25)) %#ok<EFIND>
                singleFlagSync = [singleFlagSync,...
                                  '[',flowAbbreviation{i_flow},...
                                  '-trans]'];  %#ok<AGROW>
            end
        else % this sync's data is unavailable
            disp(['.../Synchronization.mat for ',...
                  experiment,'-',flowName,' not found'])
            FWHMNoteList{i_flow} = NaN;
            FWHMList(i_flow)     = NaN;
            freqRangList(i_flow) = {[NaN,NaN]};
        end
    end
    
    %% Plot
    subplot(3,3,find(strcmp(expConditionSet,expCondition)))
    hold on
    plot(1:N_flow,FWHMList,'o-',...
        'Color',expColorSetting(expCondition),...
        'MarkerFaceColor',expColorSetting(expCondition),...
        'MarkerSize',5,'LineWidth',1);
    set(gca,'DefaultTextInterpreter','Latex',...
        'TickLabelInterpreter','Latex')
    
    xlim([0,5])
    ylim([0,10])
    xticks(1:N_flow)
    xticklabels(plotFlowList)
    xtickangle(45)
    
    calciumConcentration = getCalciumConcentration(expCondition);
    title([num2str(calciumConcentration,'%.1e'),' M'])
   
    xlabel('Flow direction')
    ylabel('$\epsilon$ (Hz)')

    %%
    calciumConcentration = getCalciumConcentration(expCondition);
    resultThisExp = {experiment,expDate,cellNo,...
                     expCondition,calciumConcentration,...
                     FWHMList(1),FWHMList(2),FWHMList(3),FWHMList(4),...
                     freqRangList(1),freqRangList(2),...
                     freqRangList(3),freqRangList(4),...
                     FWHMNoteList(1),FWHMNoteList(2),...
                     FWHMNoteList(3),FWHMNoteList(4),...
                     singleFlagSync};
    syncTable = [syncTable;resultThisExp]; %#ok<AGROW>

end
varNames    = {'experiment','date','cellNo',...
               'expCondition','calciumConcentration',...
               'epsilonCis'  ,'epsilonAxial',...
               'epsilonTrans','epsilonCross',...
               'syncRangeCis','syncRangeAxial',...
               'syncRangeTrans','syncRangeCross',...
               'NoteCis'     ,'NoteAxial',...
               'NoteTrans'   ,'NoteCross',...
               'singleFlagSync'
               };
syncTable.Properties.VariableNames= varNames;
earliestDate = min(str2double(syncTable.date));
latestDate   = max(str2double(syncTable.date));
saveFileName = sprintf('DirectionalFlowSynchrony_from%dto%d_%dCells.mat',...
                        earliestDate,latestDate,N_cell);
save(fullfile(saveToFdPath,saveFileName),'syncTable')

    
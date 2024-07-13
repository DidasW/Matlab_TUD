%% Doc
%{
  This code creates 

%}
clear all
close all

%% switchs and parameter setting
NoBins      = 60;           % Number of bins to calc Phase PDF
plotFitting = 1;
useWhichPhase = 'theoretical';
saveFig     = 1;
strain = 'oda1';
IPFreqUpperBound = 60;     % [Hz]

%% define flow types and strain
AB00_experimentalConditions;
switch strain
    case 'wt'
        AB00_importExperimentPathList
    case 'ptx1'
        AB00_importExperimentPathList_ptx1
    case 'oda1'
        AB00_importExperimentPathList_oda1
    otherwise
        error('Which strain to process?')
end

experiment_path_list=keepExperimentListByDate(experiment_path_list,...
    {'190727','190728'});

NoCell = numel(experiment_path_list);

%% Loop cell
for i_cell = 1:NoCell
    %% prepare folder
    experiment_path       = experiment_path_list{i_cell};
    [experiment,rootPath] = parseExperimentPath(experiment_path);
    AB00_experimentalConditions;
    
    %% folder paths
    disp(['processing: ',experiment])
    PDFFdpth = fullfile(rootPath,'006 interflag phase distribution');
    FitFdpth = fullfile(rootPath,'007 Fit interflag phase PDF');
    if ~exist(FitFdpth,'dir') ; mkdir(FitFdpth); end
      
    %% Check folder existence and load phase distributions
    if ~exist(fullfile(PDFFdpth,'interflagPhasePDF.mat'),'file')
        continue
    else
         load(fullfile(PDFFdpth,'interflagPhasePDF.mat'),...
              'fdNameList','NoBins','BinEdges_pi','BinCenters_pi',...
              'interFlagPhPDF_h_list' , 'interFlagPhPDF_Th_list')
    end
    NoRecord = numel(fdNameList);
    
    %% Get stress-free beating frequency
    [f0_mean,f0_std] = getStressFreeBeatFreq(experiment_path);
    if isempty(f0_mean); f0_mean = centralFreq; f0_std=1; end

    %% Switch which phase to use
    switch useWhichPhase %#ok<*UNRCH>
        case 'hibert';      PDFListToUse = interFlagPhPDF_h_list;
        case 'theoretical'; PDFListToUse = interFlagPhPDF_Th_list;
        otherwise
            disp('Unrecognized string, use default\n')
            PDFListToUse = interFlagPhPDF_Th_list;
    end
        
    %% Fit each PDF separately
    fitSummaryTable = table;
    for i_record = 1:NoRecord
        fdName   = fdNameList{i_record};

        %% choice of input
        PDFExpToUse= PDFListToUse{i_record}; 
        PDFPh_norm  = PDFExpToUse/trapz(BinCenters_pi,PDFExpToUse);
        PDFListToUse{i_record} = PDFPh_norm;

        %% Fit each of PDF separately
        opts = optimoptions(@fmincon,'Display','iter');
        x0   = [0.1   ,  1 ,   eps,         0];
        lb   = [0.001 , 0.1,   -f0_std, -pi];
        ub   = [1.5   , 5.5,   f0_std,   pi];

        [x_fit,~,~] = fmincon(@(x) lsqFitPhaseLockPDF_interFlag(...
                                   x,BinCenters_pi,PDFPh_norm),...
                                   x0,[],[],[],[],lb,ub,[],opts);
            
        T_eff  = x_fit(1);
        epsilon= x_fit(2);
        nu     = x_fit(3);
        psi_0  = x_fit(4);
            
            
        %% Fill the table of fitting results
        caConc = getCalciumConcentration(expCondition);
        resultThisExp   = {experiment,strain,expCondition,caConc,...
                           fdName,useWhichPhase,f0_mean,f0_std,...
                           T_eff,epsilon,nu,psi_0};
        fitSummaryTable = [fitSummaryTable;resultThisExp];
            
        %% plot them
                
        if plotFitting
            figure(1)
            set(gcf,'DefaultAxesFontSize',10,...
                'DefaultAxesFontWeight','normal',...
                'DefaultAxesLineWidth',1.0,'Units','inches',...
                'position',[1,2,4,3],'PaperPositionMode','auto',...
                'DefaultTextInterpreter','Latex');
            
            
            plot_fitAndExpPhasePDF(NoBins,T_eff,epsilon,nu,psi_0,...
                f0_mean,BinCenters_pi,PDFPh_norm,[0.85 0.08 0.25])
        end
        
        varNames  = {'experiment','strain','expCondition',...
                     'calciumConcentration','folderName','method',...
                     'f0_mean','f0_std','T_eff','epsilon','nu','psi_0'};
        fitSummaryTable.Properties.VariableNames= varNames;
               
        %% save figure
        if saveFig
            savefig(1,fullfile(FitFdpth,...
                    [strain,'_',experiment,'_',fdName,'.fig']))
            print  (1,fullfile(FitFdpth,...
                    [strain,'_',experiment,'_',fdName,'.png']),...
                    '-dpng','-r300');
            close all
        elseif plotFitting
            pause
            close all
        end
    end
    %% save each fitting variable
    save(fullfile(FitFdpth,'FittingResults.mat'),...
        'useWhichPhase','strain', 'IPFreqUpperBound',...
        'experiment','fdNameList',...
        'NoBins','BinEdges_pi','BinCenters_pi',...
        'fitSummaryTable')
end


    

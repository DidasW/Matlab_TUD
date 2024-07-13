%% Doc
%{
  This code creates 

%}
color_palette
clearvars -except JieGengZi GuHuang
close all

%% switchs and parameter setting
NoBins      = 60;           % Number of bins to calc Phase PDF
useWhichPhase = 'theoretical';
strain = 'ptx1';
IPFreqUpperBound = 60;     % [Hz]

%% define flow types and strain
AB00_experimentalConditions;
AB00_importExperimentPathList_ptx1
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
             'interFlagPhPDF_h_IP_list' , 'interFlagPhPDF_Th_IP_list',...
             'interFlagPhPDF_h_AP_list' , 'interFlagPhPDF_Th_AP_list')
    end
    NoRecord = numel(fdNameList);
    
    %% Get stress-free beating frequency
    [f_IP_mean,f_IP_std,~,...
     f_AP_mean,f_AP_std,~] = getStressFreeBeatFreq(experiment_path,...
                             'Strain','ptx1');
    if isempty(f_IP_mean); f_IP_mean = centralFreq; f_IP_std=1; end
    if isempty(f_AP_mean); f_AP_mean = 65; f_AP_std=2; end

    
        
    %% Fitting
    fitSummaryTable = table;
    for i_record = 1:NoRecord
        fdName   = fdNameList{i_record};
        figure(1)
        set(gcf,'DefaultAxesFontSize',10,...
            'DefaultAxesFontWeight','normal',...
            'DefaultAxesLineWidth',1.0,'Units','inches',...
            'position',[1,2,6,3],'PaperPositionMode','auto',...
            'DefaultTextInterpreter','Latex');

        for i_IPAP   = 1:2
            switch i_IPAP
                case 1
                    PDFListToUse = interFlagPhPDF_Th_IP_list;
                    f_std        = f_IP_std;
                    f_mean       = f_IP_mean;
                    modeLabel    = 'IP';
                    color        = JieGengZi;
                case 2
                    PDFListToUse = interFlagPhPDF_Th_AP_list;
                    f_std        = f_AP_std;
                    f_mean       = f_AP_mean;
                    modeLabel    = 'AP';
                    color        = GuHuang;
            end
        
            %% choice of input
            PDFExpToUse= PDFListToUse{i_record}; 
            PDFPh_norm  = PDFExpToUse/trapz(BinCenters_pi,PDFExpToUse);
            PDFListToUse{i_record} = PDFPh_norm;

            %% Fit each of PDF separately
            opts = optimoptions(@fmincon,'Display','iter');
            x0   = [0.1   ,  1 ,   eps,         0];
            lb   = [0.001 , 0.1,   -f_std, -pi];
            ub   = [1.5   , 5.5,   f_std,   pi];

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
                               fdName,modeLabel,useWhichPhase,...
                               f_mean,f_std,T_eff,epsilon,nu,psi_0};
            fitSummaryTable = [fitSummaryTable;resultThisExp];

            %% plot them
            subplot(1,2,i_IPAP)
            plot_fitAndExpPhasePDF(NoBins,T_eff,epsilon,nu,psi_0,...
                f_mean,BinCenters_pi,PDFPh_norm,color)

        end
        %% name columns' names
        varNames  = {'experiment','strain','expCondition',...
                     'calciumConcentration','folderName','beatMode',...
                     'method','f0_mean','f0_std',...
                     'T_eff','epsilon','nu','psi_0'};
        fitSummaryTable.Properties.VariableNames= varNames;

        %% save figure
        savefig(1,fullfile(FitFdpth,...
                [strain,'_',experiment,'_',fdName,'.fig']))
        print  (1,fullfile(FitFdpth,...
                [strain,'_',experiment,'_',fdName,'.png']),...
                '-dpng','-r300');
        close all
    end

    %% save results for each cell
    save(fullfile(FitFdpth,'FittingResults.mat'),...
        'useWhichPhase','strain', 'IPFreqUpperBound',...
        'experiment','fdNameList',...
        'NoBins','BinEdges_pi','BinCenters_pi',...
        'fitSummaryTable')
end


    

%% Doc
%{
  This code creates 

%}
close all

%% switchs and parameter setting
NoBins      = 30;           % Number of bins to calc Phase PDF
plotFitting = 1;
useWhichPhase = 'theoretical';
saveFig     = 1;
processStrain = 'wt';
IPFreqUpperBound = 60;     % [Hz]

%% define flow types and strain
flowTypeList= {'01XY','02MinXY','03Axial','04Cross'};
AB00_experimentalConditions;
switch processStrain
    case 'wt'
        AB00_importExperimentPathList
        experiment_path_list  = keepExperimentListByDate(...
                                experiment_path_list,{'190320','190319'});
    case 'ptx1'
        AB00_importExperimentPathList_ptx1
    otherwise
        error('Which strain to process?')
end
NoCell = numel(experiment_path_list);

%% Loop cell
for i_cell = 1:NoCell
    %% prepare folder
    experiment_path       = experiment_path_list{i_cell};
    [experiment,rootPath] = parseExperimentPath(experiment_path);
    AB00_experimentalConditions;
    disp(['processing: ',experiment])
    FitFdpth = fullfile(rootPath,'005 Fit coupling and noise');
    if ~exist(FitFdpth,'dir') ; mkdir(FitFdpth); end
      
    %% Loop flow type
    for i_flow = 1:numel(flowTypeList)
        flowType = flowTypeList{i_flow};
        
        %% Check folder existence and load phase distributions
        PDFFdpth = fullfile(rootPath,'004 phase distribution');
        if ~exist(fullfile(PDFFdpth,[flowType,'_PhasePDF.mat']),'file')
            continue
        else
             load(fullfile(PDFFdpth,[flowType,'_PhasePDF.mat']),...
             'freqList',...
             't_Fstart_list','t_Fend_list', 't_start_list',...
             'NoBins','BinEdges_pi','BinCenters_pi',...
             'PhPDF_1_h_list' , 'PhPDF_2_h_list',...
             'PhPDF_1_Th_list','PhPDF_2_Th_list')
        end
        NoFreq = numel(freqList);
        
        %% Setup figure if needed
        if plotFitting
            figure(1)
            h_title = suptitle([strain,'-',experiment,'-',flowType]);
            set(h_title,'fontsize',10)
            set(gcf,'DefaultAxesFontSize',10,...
                'DefaultAxesFontWeight','normal',...
                'DefaultAxesLineWidth',1.0,'Units','inches',...
                'position',[1,0.2,12,8.1],'PaperPositionMode','auto',...
                'DefaultTextInterpreter','Latex',...
                'Name',[strain,'-',experiment,'-',flowType,'_singleFits']);
            
            figure(2)
            h_title = suptitle([strain,'-',experiment,'-',flowType]);
            set(h_title,'fontsize',10)
            set(gcf,'DefaultAxesFontSize',10,...
                'DefaultAxesFontWeight','normal',...
                'DefaultAxesLineWidth',1.0,'Units','inches',...
                'position',[1,0.2,12,8.1],'PaperPositionMode','auto',...
                'DefaultTextInterpreter','Latex',...
                'Name',[strain,'-',experiment,'-',flowType,'_fitAtOnce']);
        end
       
        %% Get stress-free beating frequency
        [f0_mean,f0_std] = getStressFreeBeatFreq(experiment_path);
        if isempty(f0_mean); f0_mean = centralFreq; f0_std=1; end

        %% Switch which phase to use
        switch useWhichPhase %#ok<*UNRCH>
            case 'hibert'
                PDFExpListToUse1 = PhPDF_1_h_list;
                PDFExpListToUse2 = PhPDF_2_h_list;
            case 'theoretical'
                PDFExpListToUse1 = PhPDF_1_Th_list;
                PDFExpListToUse2 = PhPDF_2_Th_list;
            otherwise
                disp('Unrecognized string, use default\n')
                PDFExpListToUse1 = PhPDF_1_h_list;
                PDFExpListToUse2 = PhPDF_2_h_list;
        end
        
        %% Fit each PDF separately
        fitSummaryTable = table;
        for i_piezoFreq = 1:NoFreq
            %% choice of input
            piezoFreq   = freqList(i_piezoFreq);
            PDFExpToUse1= PDFExpListToUse1{i_piezoFreq}; 
            PDFExpToUse2= PDFExpListToUse2{i_piezoFreq}; 
            % 1 is the right flagellum in the image when the cell is
            % heading down, 2 is the left one. This is Da's convention.
            PDFPh_norm1  = PDFExpToUse1/trapz(BinCenters_pi,PDFExpToUse1);
            PDFPh_norm2  = PDFExpToUse2/trapz(BinCenters_pi,PDFExpToUse2);
            
            PDFExpListToUse1{i_piezoFreq} = PDFPh_norm1;
            PDFExpListToUse2{i_piezoFreq} = PDFPh_norm2;
            
            %% Fit each of PDF separately
            opts = optimoptions(@fmincon,'Display','iter');
            % T_eff, epsilon, nu, psi0
            % psi0 centers the phase distribution around 0
            % epsilon, nu, 
            x0   = [0.1   ,  1 ,   f0_mean,          0];
            lb   = [0.001 , 0.1,   f0_mean-f0_std, -pi];
            ub   = [1.5   , 5.5,   f0_mean+f0_std,  pi];
            % flag1
            [x_fit1,~,~] = fmincon(@(x) lsqFitPhaseLockPDF_single(...
                                       x,BinCenters_pi,PDFPh_norm1,piezoFreq),...
                                       x0,[],[],[],[],lb,ub,[],opts);
            % flag2
            [x_fit2,~,~] = fmincon(@(x) lsqFitPhaseLockPDF_single(...
                                       x,BinCenters_pi,PDFPh_norm2,piezoFreq),...
                                       x0,[],[],[],[],lb,ub,[],opts);
            
            T_eff_1  = x_fit1(1);
            epsilon_1= x_fit1(2);
            f0_1     = x_fit1(3);
            psi_0_1  = x_fit1(4);
            nu_1     = (piezoFreq-f0_1);      
            
            T_eff_2  = x_fit2(1);
            epsilon_2= x_fit2(2);
            f0_2     = x_fit2(3);
            psi_0_2  = x_fit2(4);
            nu_2     = (piezoFreq-f0_2);  
            
            %% Fill the table of fitting results
            resultThisExp1  = {experiment,strain,flowType,'right',...
                               T_eff_1,epsilon_1,f0_1,psi_0_1,nu_1,...
                               piezoFreq};
            resultThisExp2  = {experiment,strain,flowType,'left',...
                               T_eff_2,epsilon_2,f0_2,psi_0_2,nu_2,...
                               piezoFreq};
            fitSummaryTable = [fitSummaryTable;...
                               resultThisExp1;resultThisExp2];
            
            %% plot them
            if plotFitting
                figure(1)
                NoCol = ceil(NoFreq/2);
                % flag1
                subplot(4,NoCol,i_piezoFreq)
                plot_fitAndExpPhasePDF(20,T_eff_1,epsilon_1,nu_1,psi_0_1,...
                    piezoFreq,BinCenters_pi,PDFPh_norm1,YangHong)
                % flag2
                subplot(4,NoCol,i_piezoFreq+2*NoCol)
                plot_fitAndExpPhasePDF(20,T_eff_2,epsilon_2,nu_2,psi_0_2,...
                    piezoFreq,BinCenters_pi,PDFPh_norm2,BaoLan)
            end
        end
        
        varNames  = {'experiment','strain','flowType','flagellum',...
                     'T_eff','epsilon','f0','psi_0','nu','piezoFreq'};
        fitSummaryTable.Properties.VariableNames= varNames;
               
        
        %% Fit all input PDFs with one (T_eff,epslion,nu) setting
        subtable1 = fitSummaryTable(...
                    strcmp(fitSummaryTable.flagellum,'right'),:);
        subtable2 = fitSummaryTable(...
                    strcmp(fitSummaryTable.flagellum,'left'),:);
        [x0_1,lb_1,ub_1] = prepareFittingMultiplePDFs(subtable1);
        [x0_2,lb_2,ub_2] = prepareFittingMultiplePDFs(subtable2);

        opts = optimoptions(@fmincon,'Display','iter');
        [x_fitAll_1,~,~] = fmincon(@(x) lsqFitPhaseLockPDF_multiple(...
                               x,BinCenters_pi,PDFExpListToUse1,freqList),...
                               x0_1,[],[],[],[],lb_1,ub_1,[],opts);
        [x_fitAll_2,~,~] = fmincon(@(x) lsqFitPhaseLockPDF_multiple(...
                               x,BinCenters_pi,PDFExpListToUse2,freqList),...
                               x0_2,[],[],[],[],lb_2,ub_2,[],opts);


        fitAllExpAtOnce.flag1.T_eff  = x_fitAll_1(1);
        fitAllExpAtOnce.flag1.epsilon= x_fitAll_1(2);
        fitAllExpAtOnce.flag1.f0     = x_fitAll_1(3);
        fitAllExpAtOnce.flag1.psi_0  = x_fitAll_1(4:end);
        fitAllExpAtOnce.flag1.nuList = (freqList-x_fitAll_1(3));
        
        fitAllExpAtOnce.flag2.T_eff  = x_fitAll_2(1);
        fitAllExpAtOnce.flag2.epsilon= x_fitAll_2(2);
        fitAllExpAtOnce.flag2.f0     = x_fitAll_2(3);
        fitAllExpAtOnce.flag2.psi_0  = x_fitAll_2(4:end);
        fitAllExpAtOnce.flag2.nuList = (freqList-x_fitAll_2(3));
        
        %% plot fitting results
        if plotFitting
            NoCol = ceil(NoFreq/2);
            figure(2)
            for i_piezoFreq = 1:NoFreq
                piezoFreq   = freqList(i_piezoFreq);
                % flag1
                subplot(4,NoCol,i_piezoFreq)
                plot_fitAndExpPhasePDF(20,...
                    fitAllExpAtOnce.flag1.T_eff ,...
                    fitAllExpAtOnce.flag1.epsilon,...
                    fitAllExpAtOnce.flag1.nuList(i_piezoFreq) ,...
                    fitAllExpAtOnce.flag1.psi_0(i_piezoFreq)  ,...
                    piezoFreq,BinCenters_pi,...
                    PDFExpListToUse1{i_piezoFreq},YangHong)
                % flag2
                subplot(4,NoCol,i_piezoFreq+2*NoCol)
                plot_fitAndExpPhasePDF(20,...
                    fitAllExpAtOnce.flag2.T_eff ,...
                    fitAllExpAtOnce.flag2.epsilon,...
                    fitAllExpAtOnce.flag2.nuList(i_piezoFreq) ,...
                    fitAllExpAtOnce.flag2.psi_0(i_piezoFreq)  ,...
                    piezoFreq,BinCenters_pi,...
                    PDFExpListToUse1{i_piezoFreq},BaoLan)
            end
        end
        
        %% save each fitting variable 
        save(fullfile(FitFdpth,[flowType,'_fittingResults.mat']),...
            'useWhichPhase','strain', 'IPFreqUpperBound',...
             'experiment','flowType','freqList',...
             'NoBins','BinEdges_pi','BinCenters_pi',...
             'fitAllExpAtOnce' , 'fitSummaryTable',...
             'subtable1','subtable2')
        
        %% save figure
        if saveFig
            savefig(1,fullfile(FitFdpth,...
                    ['SingleFits_',strain,'_',experiment,...
                    '_',flowType,'.fig']))
            print  (1,fullfile(FitFdpth,...
                    ['SingleFits_',strain,'_',experiment,...
                    '_',flowType,'.png']),...
                    '-dpng','-r300');
            savefig(2,fullfile(FitFdpth,...
                    ['FitAtOnce_',strain,'_',experiment,...
                    '_',flowType,'.fig']))
            print  (2,fullfile(FitFdpth,...
                    ['FitAtOnce_',strain,'_',experiment,...
                    '_',flowType,'.png']),...
                    '-dpng','-r300');
            close all
        elseif plotFitting
            pause
            close all
        end
    end
end


    

%% Doc
%{
  This code creates 

%}
clear all

%% switchs and parameter setting
NoBins      = 30;           % Number of bins to calc Phase PDF
plotPDF     = 1;
useWhichPhase = 'theoretical_flag_1';
saveFig     = 1;
processStrain = 'wt';
IPFreqUpperBound = 60;     % [Hz]

%% define flow types and strain
flowTypeList= {'01XY','02MinXY','03Axial','04Cross'};
AB00_experimentalConditions;
switch processStrain
    case 'wt'
        AB00_importExperimentPathList
    case 'ptx1'
        AB00_importExperimentPathList_ptx1
    otherwise
        error('Which strain to process?')
end
NoCell = numel(experiment_path_list);

%% Loop cell
for i_cell = 1:NoCell 
    experiment_path       = experiment_path_list{i_cell};
    [experiment,rootPath] = parseExperimentPath(experiment_path);
    AB00_experimentalConditions;

    FitFdpth = fullfile(rootPath,'005 Fit coupling and noise');
    if ~exist(FitFdpth,'dir') ; mkdir(FitFdpth); end
      
    %% Loop flow type
    for i_flow = 1:numel(flowTypeList)
        
        %% Check folder existence and load phase distributions
        flowType = flowTypeList{i_flow};
        
        PDFFdpth = fullfile(rootPath,'004 phase distribution');
        if ~exist(fullfile(PDFFdpth,flowType),'dir')
            continue
        else
             load(fullfile(PDFFdpth,[flowType,'_PhasePDF.mat']),...
             'freqList',...
             't_Fstart_list','t_Fend_list', 't_start_list',...
             'NoBins','BinEdges_pi','BinCenters_pi',...
             'PhPDF_1_h_list' , 'PhPDF_2_h_list',...
             'PhPDF_1_Th_list','PhPDF_2_Th_list')
        end
        
        %% Setup figure if needed
        if plotPDF
            figure()
            h_title = suptitle([strain,'-',experiment,'-',flowType]);
            set(h_title,'fontsize',10)
            set(gcf,'DefaultAxesFontSize',10,...
                'DefaultAxesFontWeight','normal',...
                'DefaultAxesLineWidth',1.0,'Units','inches',...
                'position',[1,2.5,12,4],'PaperPositionMode','auto',...
                'DefaultTextInterpreter','Latex',...
                'Name',[strain,'-',experiment,'-',flowType]);
        end
       
        %% Get stress-free beating frequency
        %
        %
        for i_piezoFreq = 1:NoDiffFreq
            PhPDF_1_h  = PhPDF_1_h_list{i_piezoFreq}; 
            PhPDF_2_h  = PhPDF_2_h_list{i_piezoFreq};
            PhPDF_1_Th = PhPDF_1_Th_list{i_piezoFreq};
            PhPDF_2_Th = PhPDF_2_Th_list{i_piezoFreq};  
            
            %% Fit each of them separately
            
            %% Generate a table to be saved
            
            
            %% plot them
            if plotPDF
                switch useWhichPhase %#ok<*UNRCH>
                    case 'hibert_flag_1'
                        Ph_plot = h_Ph1_unwrapped;
                    case 'hibert_flag_2'
                        Ph_plot = h_Ph2_unwrapped;
                    case 'theoretical_flag_1'
                        Ph_plot = ThPh1_unwrapped;
                    case 'theoretical_flag_2'
                        Ph_plot = ThPh2_unwrapped;
                    otherwise
                        disp('Unrecognized string, use default\n')
                        Ph_plot = h_Ph1_unwrapped;
                end
                subplot(2,ceil(NoDiffFreq/2),i_piezoFreq)
                set(gca,'defaulttextinterpreter','Latex',...
                    'TickLabelInterpreter','Latex')
                hold on, box on, grid on
                plot_histogram_with_boundary(...
                    wrapToPi(Ph_plot-Ph_piezo-BinCenters_pi(idx_max)),...
                    BinEdges_pi,JieGengZi);
                % The first input is the same as centering the distribution 
                % around 0. 
                infoStr = sprintf('$f_{flow}$=%.2fHz',piezoFreq);
                text(0,0.28,infoStr,'Interpreter','Latex',...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment', 'top','FontSize',10)
                ylim([0,0.30])
                xlim([-pi,pi]);
                xticks([-pi,0,pi])
                xticklabels({'-$\pi$','0','$\pi$'})
                xlabel('$\Delta$ (2$\pi$)')
                ylabel('PDF')
            end
            
            %% save the table
            
        end
        
        %% Use the fitting results from separate fitting as initial value for fitting all at once
        
        %% generate figure
        
        %% save each fitting variable 
        
        
        
        
        %% save figure
        if saveFig
            savefig(gcf,fullfile(FitFdpth,...
                    ['wt_',experiment,'_',flowType,'.fig']))
            print  (gcf,fullfile(FitFdpth,...
                    ['wt_',experiment,'_',flowType,'.png']),...
                    '-dpng','-r300');
            close(gcf)
        end
    end
end


    

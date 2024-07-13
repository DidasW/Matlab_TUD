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

%%
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

    PDFFdpth = fullfile(rootPath,'004 phase distribution');
    if ~exist(PDFFdpth,'dir') ; mkdir(PDFFdpth); end
      
    %% Loop flow type
    for i_flow = 1:numel(flowTypeList)
        %% Check folder existence
        flowType = flowTypeList{i_flow};
        if ~exist(fullfile(experiment_path,flowType),'dir')
            continue
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
        
        %% load flash chopping info
        synFilePath = fullfile(experiment_path,flowType,...
                      'Synchronization.mat');
        load(synFilePath,'t_Fend_list','t_Fstart_list','t_start_list',...
             'freqList')
        NoDiffFreq = numel(freqList);
        
        %% Pre-allocation of variables to save
        [PhPDF_1_h_list,PhPDF_2_h_list,...
         PhPDF_1_Th_list,PhPDF_2_Th_list] = deal(cell(NoDiffFreq,1));
     
        for i_piezoFreq = 1:NoDiffFreq
            
            [t_Fstart,...
             t_Fend,...
             t_start,...
             piezoFreq  ] = takeTheseIndices([i_piezoFreq],...
                            t_Fstart_list,t_Fend_list,...
                            t_start_list,freqList ) ;  % [ms], [Hz]

            matfilepath   = fullfile(experiment_path,flowType,...
                            ['Folder_',num2str(piezoFreq,'%.2f'),'.mat']);

            %% load Phase variables
            varNames = who('-file',matfilepath);
            load(matfilepath,'H_Ph1','H_Ph2')
            
            % Hilbert phase
            if ismember(varNames,'h_Ph1_unwrapped') 
                load(matfilepath,'h_Ph1_unwrapped','h_Ph2_unwrapped')
            else
                [h_Ph1_unwrapped,...
                 h_Ph2_unwrapped ]  =  deal(unwrap(H_Ph1),unwrap(H_Ph2));
            end
            
            % Observable-independent phase, PRE 77,066205(2008)
            if sum(ismember(varNames,'calculateTheoreticalPhase'))
                load(matfilepath,'calculateTheoreticalPhase')
            else
                calculateTheoreticalPhase = 0;
            end
            
            if sum(ismember(varNames,'ThPh1_unwrapped')) && ...
               calculateTheoreticalPhase == 1
                load(matfilepath,'ThPh1_unwrapped','ThPh2_unwrapped')
            else
                ThPh1_unwrapped = transformProtoPhase(h_Ph1_unwrapped); 
                ThPh2_unwrapped = transformProtoPhase(h_Ph2_unwrapped);
                calculateTheoreticalPhase = 1;
                save(matfilepath,'-append',...
                    'ThPh1_unwrapped','ThPh2_unwrapped',...
                    'calculateTheoreticalPhase');
            end
            
            flag1_f = smooth(diff(ThPh1_unwrapped)*fps/2/pi,0.1*fps);
            flag2_f = smooth(diff(ThPh2_unwrapped)*fps/2/pi,0.1*fps);
            
            %% Take the signal after the flash, compute phase difference
            t = make_time_series(H_Ph1,fps,'s');
            % note: H_Ph1(2)_(unwrapped), ThPh1(2)_(unwrapped) are all the
            % same size N; length(flag1_f) = N-1;
            
            % generate an accurate phase of piezo motion
            Ph_piezo = generatePiezoPhase(t*1000,t_Fend,piezoFreq);
            
            % middle part: 0.2 s after flash, duration 10 seconds.
            idx_middlePart = find(t>  (t_Fstart+t_start)/1000 + 0.2 &...
                                  t<  (t_Fstart+t_start)/1000 + 10.2);
            
            [t,...
            h_Ph1_unwrapped,...
            h_Ph2_unwrapped,...
            ThPh1_unwrapped,...
            ThPh2_unwrapped,...
            Ph_piezo        ]  = takeTheseIndices(idx_middlePart,...
                                                 t,...
                                                 h_Ph1_unwrapped,...
                                                 h_Ph2_unwrapped,...
                                                 ThPh1_unwrapped,...
                                                 ThPh2_unwrapped,...
                                                 Ph_piezo);
            %  
            if idx_middlePart(end) > numel(flag1_f)
                [flag1_f,flag2_f] = takeTheseIndices(...
                                    idx_middlePart(1):numel(flag1_f),...
                                    flag1_f,flag2_f);
            else
                [flag1_f,flag2_f] = takeTheseIndices(idx_middlePart,...
                                    flag1_f,flag2_f);
            end
            
            %% take only IP beating if it is ptx1 
            if strcmp(processStrain,'ptx1')
                idx_IPbeating  = find(flag1_f < IPFreqUpperBound & ...
                                      flag2_f < IPFreqUpperBound);
                [t_IP,...
                 h_Ph1_unwrapped,...
                 h_Ph2_unwrapped,...
                 ThPh1_unwrapped,...
                 ThPh2_unwrapped,...
                 Ph_piezo       ]  = takeTheseIndices(idx_IPbeating,t,...
                                                      h_Ph1_unwrapped,...
                                                      h_Ph2_unwrapped,...
                                                      ThPh1_unwrapped,...
                                                      ThPh2_unwrapped,...
                                                      Ph_piezo);
            end
            
            
            
            
            %% calc
            [PhPDF_1_h, ~    ] = calcPhasePDF_wrapToPi(...
                                 h_Ph1_unwrapped,Ph_piezo,NoBins);
            [PhPDF_2_h, ~    ] = calcPhasePDF_wrapToPi(...
                                 h_Ph2_unwrapped,Ph_piezo,NoBins);
            [PhPDF_1_Th, ~   ] = calcPhasePDF_wrapToPi(...
                                 ThPh1_unwrapped,Ph_piezo,NoBins);
            [PhPDF_2_Th, ~   ] = calcPhasePDF_wrapToPi(...
                                 ThPh2_unwrapped,Ph_piezo,NoBins);
            [~,idx_max]        = max(PhPDF_1_h);
                        
            %% center the distribution around 0
            BinEdges_pi   = linspace(-pi,pi,NoBins+1);
            BinCenters_pi = (BinEdges_pi(1:end-1) + BinEdges_pi(2:end))/2;
            PhPDF_1_h  = centerPhasePDF_wrapToPi(PhPDF_1_h,BinCenters_pi);
            PhPDF_2_h  = centerPhasePDF_wrapToPi(PhPDF_2_h,BinCenters_pi);
            PhPDF_1_Th = centerPhasePDF_wrapToPi(PhPDF_1_Th,BinCenters_pi);
            PhPDF_2_Th = centerPhasePDF_wrapToPi(PhPDF_2_Th,BinCenters_pi);
                        
            %% plot
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
            
            %% save variables
            PhPDF_1_h_list{i_piezoFreq}  = PhPDF_1_h;
            PhPDF_2_h_list{i_piezoFreq}  = PhPDF_2_h;
            PhPDF_1_Th_list{i_piezoFreq} = PhPDF_1_Th;
            PhPDF_2_Th_list{i_piezoFreq} = PhPDF_2_Th;
            
            %% 
            clearvars calculateTheoreticalPhase
        end
        save(fullfile(PDFFdpth,[flowType,'_PhasePDF.mat']),'freqList',...
             't_Fstart_list','t_Fend_list', 't_start_list',...
             'NoBins','BinEdges_pi','BinCenters_pi',...
             'PhPDF_1_h_list' , 'PhPDF_2_h_list',...
             'PhPDF_1_Th_list','PhPDF_2_Th_list')
        if saveFig
            savefig(gcf,fullfile(PDFFdpth,...
                    ['wt_',experiment,'_',flowType,'.fig']))
            print  (gcf,fullfile(PDFFdpth,...
                    ['wt_',experiment,'_',flowType,'.png']),...
                    '-dpng','-r300');
            close(gcf)
        end
    end
end


    
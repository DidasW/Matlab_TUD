%% Doc
%{
    Fit the interflagellar phase distribution, so as to obtain T_eff,
    \epsilon, and \niu
%}
clear all

%% switchs and parameter setting
NoBins      = 60;           % Number of bins to calc Phase PDF
plotPDF     = 1;
useWhichPhase = 'theoretical'; % theoretical
saveFig     = 1;
strain      = 'oda1';
%%
AB00_experimentalConditions;
switch strain
    case 'oda1'
        AB00_importExperimentPathList_oda1
    case 'wt'
        AB00_importExperimentPathList
end
experiment_path_list=keepExperimentListByDate(experiment_path_list,...
    {'190727','190728'});

NoCell = numel(experiment_path_list);

%% Loop cell
for i_cell = 1:NoCell 
    experiment_path       = experiment_path_list{i_cell};
    [experiment,rootPath] = parseExperimentPath(experiment_path);
    fprintf('Processing %s\n',experiment);
    AB00_experimentalConditions;

    PDFFdpth = fullfile(rootPath,'006 interflag phase distribution');
    if ~exist(PDFFdpth,'dir') ; mkdir(PDFFdpth); end
      
        
    %% load flash chopping info
    noFlowFdpth = fullfile(experiment_path,'00NoFlow');
    if exist(noFlowFdpth,'dir')
        flowFreeRocordingFolders = dir(noFlowFdpth);
        flowFreeRocordingFolders = flowFreeRocordingFolders(...
                                   [flowFreeRocordingFolders.isdir]);
        flowFreeRocordingFolders(1:2) = [];   
        NoRecord = numel(flowFreeRocordingFolders);
    else
        continue
    end

    %% Pre-allocation of variables to save
    [interFlagPhPDF_h_list,...
     interFlagPhPDF_Th_list]    = deal(cell(NoRecord,1));
    fdNameList                  = {flowFreeRocordingFolders.name};
 
 
    for i_record = 1:NoRecord
        fdName = fdNameList{i_record};
        matfilepath   = fullfile(experiment_path,'00NoFlow',...
                        ['Folder_',fdName,'.mat']);


        %% load Phase variables
        varNames = who('-file',matfilepath);
        load(matfilepath,'H_Ph1','H_Ph2',...
            'h_Ph1_unwrapped','h_Ph2_unwrapped',...
            'ThPh1_unwrapped','ThPh2_unwrapped')
        
        flag1_f = smooth(diff(ThPh1_unwrapped)*fps/2/pi,0.1*fps); 
        flag2_f = smooth(diff(ThPh2_unwrapped)*fps/2/pi,0.1*fps);
        % 0.1 sec for ~5 beats in wt and ptx1 cells, need to change to 0.3
        % for oda1,6 mutants
        
        %% calc PDF
        [interFlagPhPDF_h, ~] = calcPhasePDF_wrapToPi(...
                                h_Ph1_unwrapped,h_Ph2_unwrapped,NoBins);
        [interFlagPhPDF_Th,~] = calcPhasePDF_wrapToPi(...
                                ThPh1_unwrapped,ThPh2_unwrapped,NoBins);
        [~,idx_max]        = max(interFlagPhPDF_h);

        %% center the distribution around 0
        BinEdges_pi     = linspace(-pi,pi,NoBins+1);
        BinCenters_pi   = (BinEdges_pi(1:end-1) + BinEdges_pi(2:end))/2;
        interFlagPhPDF_h  = centerPhasePDF_wrapToPi(...
                            interFlagPhPDF_h,BinCenters_pi);
        interFlagPhPDF_Th = centerPhasePDF_wrapToPi(...
                            interFlagPhPDF_Th,BinCenters_pi);
        
        %% plot
        if plotPDF
            figure()
            set(gcf,'DefaultAxesFontSize',10,...
                'DefaultAxesFontWeight','normal',...
                'DefaultAxesLineWidth',1.0,'Units','inches',...
                'position',[1,2.5,5,4],'PaperPositionMode','auto',...
                'DefaultTextInterpreter','Latex',...
                'Name',[strain,'-',experiment,'-',fdName]);
            h_title = title([strain,'-',experiment,'-',fdName]);

            switch useWhichPhase %#ok<*UNRCH>
                case 'hibert'
                    Ph_plot = h_Ph1_unwrapped-h_Ph2_unwrapped;
                case 'theoretical'
                    Ph_plot = ThPh1_unwrapped-ThPh2_unwrapped;
                otherwise
                    disp('Unrecognized string, use default\n')
                    Ph_plot = ThPh1_unwrapped-ThPh2_unwrapped;
            end
            
            set(gca,'defaulttextinterpreter','Latex',...
                'TickLabelInterpreter','Latex')
            hold on, box on, grid on
            plot_histogram_with_boundary(...
                wrapToPi(Ph_plot-BinCenters_pi(idx_max)),...
                BinEdges_pi,[1,0.6,0.2]);
            ylim([0,0.50])
            xlim([-pi,pi]);
            xticks([-pi,0,pi])
            xticklabels({'-$\pi$','0','$\pi$'})
            xlabel('$\Delta$ (2$\pi$)')
            ylabel('PDF')
            
        end

        %% save variables
        interFlagPhPDF_h_list{i_record}  = interFlagPhPDF_h;
        interFlagPhPDF_Th_list{i_record} = interFlagPhPDF_Th;
       
        if exist(fullfile(PDFFdpth,'interflagPhasePDF.mat'),'file')
            save(fullfile(PDFFdpth,'interflagPhasePDF.mat'),...
            '-append',...
            'fdNameList','NoBins','BinEdges_pi','BinCenters_pi',...
            'interFlagPhPDF_h_list' , 'interFlagPhPDF_Th_list')
        else
            save(fullfile(PDFFdpth,'interflagPhasePDF.mat'),...
            'fdNameList','NoBins','BinEdges_pi','BinCenters_pi',...
            'interFlagPhPDF_h_list' , 'interFlagPhPDF_Th_list')
        end

        if saveFig
            savefig(gcf,fullfile(PDFFdpth,...
                    [strain,'_',experiment,'_',fdName,'.fig']))
            print  (gcf,fullfile(PDFFdpth,...
                    [strain,'_',experiment,'_',fdName,'.png']),...
                    '-dpng','-r300');
            close(gcf)
        end
    end
end


    
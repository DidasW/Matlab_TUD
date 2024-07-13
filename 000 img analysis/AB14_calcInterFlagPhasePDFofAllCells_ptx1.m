%% Doc
%{
    Fit the interflagellar phase distribution, so as to obtain T_eff,
    \epsilon, and \niu
%}
color_palette
clearvars -except JieGengZi GuHuang

%% switchs and parameter setting
NoBins      = 60;           % Number of bins to calc Phase PDF
useWhichPhase = 'theoretical'; % theoretical
saveFig     = 1;
strain      = 'ptx1';
IPFreqUpperBound = 60; % [Hz] 55 Hz for 181130 c5
%%
AB00_experimentalConditions;
AB00_importExperimentPathList_ptx1
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
    [interFlagPhPDF_h_IP_list,...
     interFlagPhPDF_Th_IP_list]    = deal(cell(NoRecord,1));
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
        
        %% isolate IP and AP beating
        t       = make_time_series(h_Ph1_unwrapped,fps,'s');
        idx_IPbeating  = find(flag1_f < IPFreqUpperBound & ...
                              flag2_f < IPFreqUpperBound);
        [t_IP,...
         h_Ph1_unwrapped_IP,...
         h_Ph2_unwrapped_IP,...
         ThPh1_unwrapped_IP,...
         ThPh2_unwrapped_IP]  = takeTheseIndices(idx_IPbeating,t,...
                                                 h_Ph1_unwrapped,...
                                                 h_Ph2_unwrapped,...
                                                 ThPh1_unwrapped,...
                                                 ThPh2_unwrapped);
        IPFraction         = numel(t_IP)/numel(t);    
          
        idx_APbeating  = find(flag1_f > IPFreqUpperBound & ...
                              flag2_f > IPFreqUpperBound);
        [t_AP,...
         h_Ph1_unwrapped_AP,...
         h_Ph2_unwrapped_AP,...
         ThPh1_unwrapped_AP,...
         ThPh2_unwrapped_AP]  = takeTheseIndices(idx_APbeating,t,...
                                                  h_Ph1_unwrapped,...
                                                  h_Ph2_unwrapped,...
                                                  ThPh1_unwrapped,...
                                                  ThPh2_unwrapped);
        APFraction         = numel(t_AP)/numel(t);    
         
        %% calc PDF
        [interFlagPhPDF_h_IP, ~] = calcPhasePDF_wrapToPi(...
                                   h_Ph1_unwrapped_IP,h_Ph2_unwrapped_IP,...
                                   NoBins);
        [interFlagPhPDF_Th_IP,~] = calcPhasePDF_wrapToPi(...
                                   ThPh1_unwrapped_IP,ThPh2_unwrapped_IP,...
                                   NoBins);
        [~,idx_max_IP]           = max(interFlagPhPDF_h_IP);

        [interFlagPhPDF_h_AP, ~] = calcPhasePDF_wrapToPi(...
                                   h_Ph1_unwrapped_AP,h_Ph2_unwrapped_AP,...
                                   NoBins);
        [interFlagPhPDF_Th_AP,~] = calcPhasePDF_wrapToPi(...
                                   ThPh1_unwrapped_AP,ThPh2_unwrapped_AP,...
                                   NoBins);
        [~,idx_max_AP]           = max(interFlagPhPDF_h_AP);

        %% center the distribution around 0
        BinEdges_pi     = linspace(-pi,pi,NoBins+1);
        BinCenters_pi   = (BinEdges_pi(1:end-1) + BinEdges_pi(2:end))/2;
        
        interFlagPhPDF_h_IP  = centerPhasePDF_wrapToPi(...
                            interFlagPhPDF_h_IP,BinCenters_pi);
        interFlagPhPDF_Th_IP = centerPhasePDF_wrapToPi(...
                            interFlagPhPDF_Th_IP,BinCenters_pi);
        interFlagPhPDF_h_AP  = centerPhasePDF_wrapToPi(...
                            interFlagPhPDF_h_AP,BinCenters_pi);
        interFlagPhPDF_Th_AP = centerPhasePDF_wrapToPi(...
                            interFlagPhPDF_Th_AP,BinCenters_pi);

        %% plot
        figure()
        set(gcf,'DefaultAxesFontSize',10,...
            'DefaultAxesFontWeight','normal',...
            'DefaultAxesLineWidth',1.0,'Units','inches',...
            'position',[1,2.5,6,3],'PaperPositionMode','auto',...
            'DefaultTextInterpreter','Latex',...
            'Name',[strain,'-',experiment,'-',fdName]);
        h_title = title([strain,'-',experiment,'-',fdName]);

        for i_ax = 1:2
            switch i_ax %#ok<*UNRCH>
                case 1 
                    Ph_plot = ThPh1_unwrapped_IP-ThPh2_unwrapped_IP - ...
                              BinCenters_pi(idx_max_IP);
                    color   = JieGengZi; 
                case 2 
                    Ph_plot = ThPh1_unwrapped_AP-ThPh2_unwrapped_AP - ...
                              BinCenters_pi(idx_max_AP);
                    color   = GuHuang;  
                    textStr = [sprintf('AP: %.1f',APFraction*100),'%'];
            end
            subplot(1,2,i_ax)
            set(gca,'defaulttextinterpreter','Latex',...
                'TickLabelInterpreter','Latex')
            hold on, box on, grid on
            plot_histogram_with_boundary(wrapToPi(Ph_plot),BinEdges_pi,...
                color);
            ylim([0,0.3])
            xlim([-pi,pi]);
            xticks([-pi,0,pi])
            xticklabels({'-$\pi$','0','$\pi$'})
            xlabel('$\Delta$ (2$\pi$)')
            ylabel('PDF')
            if exist('textStr','var') 
                text(pi*0.95,0.25,textStr,'HorizontalAlignment','right',...
                    'Interpreter','latex'); 
                clearvars textStr
            end
        end

        %% save variables
        interFlagPhPDF_h_IP_list {i_record} = interFlagPhPDF_h_IP;
        interFlagPhPDF_Th_IP_list{i_record} = interFlagPhPDF_Th_IP;
        interFlagPhPDF_h_AP_list {i_record} = interFlagPhPDF_h_AP;
        interFlagPhPDF_Th_AP_list{i_record} = interFlagPhPDF_Th_AP;
       
        if exist(fullfile(PDFFdpth,'interflagPhasePDF.mat'),'file')
            save(fullfile(PDFFdpth,'interflagPhasePDF.mat'),...
            '-append',...
            'IPFreqUpperBound','IPFraction','APFraction',...
            'fdNameList','NoBins','BinEdges_pi','BinCenters_pi',...
            'interFlagPhPDF_h_IP_list' , 'interFlagPhPDF_Th_IP_list',...
            'interFlagPhPDF_h_AP_list' , 'interFlagPhPDF_Th_AP_list')
        else
            save(fullfile(PDFFdpth,'interflagPhasePDF.mat'),...
            'IPFreqUpperBound','IPFraction','APFraction',...
            'fdNameList','NoBins','BinEdges_pi','BinCenters_pi',...
            'interFlagPhPDF_h_IP_list' , 'interFlagPhPDF_Th_IP_list',...
            'interFlagPhPDF_h_AP_list' , 'interFlagPhPDF_Th_AP_list')
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


    
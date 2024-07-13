%% mamafolder path list
experiment_path_list = {...
    'O:\001 Full Arnold Tongue\190610 c2\c2\'};
mama_folder_path_list = formMamaFdList(experiment_path_list,0);

%% settings, criteria for synchrony
syncThresTime = 0.2 ; % [sec]
syncThresSlope= 1e-3;
piezoDuration= 6 ; % [sec]
piezoStartsBeforeRecording = 0;
color_palette
IPFreqUpperBound = 60;
Fs_interp        = 1000;
%Magic number 1000 was the interpolation fps in the get_phase_info code
%%
for i_mamafd = 1:numel(mama_folder_path_list)
    %% Folders to rename
    mama_folder_path              = mama_folder_path_list{i_mamafd};  
    [mamaFolderName,experiment,~] = parseMamaFolderPath(mama_folder_path);
    AB00_experimentalConditions;
    %%
        
    imgSeqIsChopped = 0;
    if contains(mamaFolderName,'_Chopped')
    	idx_untilSuffix    = strfind(mamaFolderName,'_Chopped');
    	mamaFolderNameStem = mamaFolderName(1:idx_untilSuffix-1);
        imgSeqIsChopped    = 1;
    else
    	mamaFolderNameStem = mamaFolderName;
    end
    %%
    flashDetectFdPath   = defFlashDectionFolderPath(mama_folder_path);
    TSyncFigFdPath      = defTSynFolderPath(mama_folder_path);
    
    cd(mama_folder_path)
    subfolderStructList= dir(mama_folder_path); 
    subfolderStructList(1:2) = [];
    subfolderStructList(~[subfolderStructList.isdir]) = [];    
    NoSubFd            = numel(subfolderStructList);
    %%
    AB00_experimentalConditions;
    % fps, central frequency, experimental conditions are defined in AB00
    
    %%
    t_Fstart_list      = zeros(NoSubFd,1);
    t_Fspan_list       = zeros(NoSubFd,1);
    t_Fend_list        = zeros(NoSubFd,1);
    start_frame_list   = zeros(NoSubFd,1);
    t_start_list       = zeros(NoSubFd,1);
    t_left_list        = zeros(NoSubFd,1);
    t_IP_list          = zeros(NoSubFd,1);
    TSync1_list        = zeros(NoSubFd,1);
    TSync2_list        = zeros(NoSubFd,1);
    TSync1Ratio_list   = zeros(NoSubFd,1);
    TSync2Ratio_list   = zeros(NoSubFd,1);
    TSync1Ratio_IP_list= zeros(NoSubFd,1);
    TSync2Ratio_IP_list= zeros(NoSubFd,1);
    freqList           = zeros(NoSubFd,1);
    %%
    
    
    for i_subfd = 1:NoSubFd
        subfolderName    = subfolderStructList(i_subfd).name;
        freqList(i_subfd)= str2double(subfolderName);
        flashDetectFigPath = [fullfile(...
                             flashDetectFdPath,mamaFolderNameStem),'\'];
        if ~exist(flashDetectFigPath,'dir'); mkdir(flashDetectFigPath); end
        disp([subfolderName,' time cost to find flash:'])
        %% find or load when piezo onsets
        tic
        if exist('Synchronization.mat','file')
            load('Synchronization.mat','t_Fstart_list','t_Fspan_list',...
                 't_Fend_list','start_frame_list','t_start_list')
             t_Fstart    = t_Fstart_list(i_subfd);
             t_Fspan     = t_Fspan_list(i_subfd);
             t_Fend      = t_Fend_list(i_subfd) ;
             start_frame = start_frame_list(i_subfd);
             t_start     = t_start_list(i_subfd);
        elseif imgSeqIsChopped 
        % It is possible to load them from
        % mamaFolderNameStem_CutLogFolder\Cut Log.mat
             t_Fstart    = -10;
             t_Fspan     = 10;
             t_Fend      = 0;
             start_frame = 1;
             t_start     = 0;
        elseif piezoStartsBeforeRecording
             t_Fstart    = -10;
             t_Fspan     = 10;
             t_Fend      = 0;
             start_frame = 1;
             t_start     = 0;
        else
            [t_Fstart,t_Fspan,...
            t_Fend,start_frame,...
            t_start]               = determine1flash_VID_v2(...
                                     [subfolderName,'\'],...
                                     fps,0,flashDetectFigPath);
        end
        toc
        t_Fstart_list(i_subfd)      = t_Fstart;
        t_Fspan_list(i_subfd)       = t_Fspan;
        t_Fend_list(i_subfd)        = t_Fend;
        start_frame_list(i_subfd)   = start_frame;
        t_start_list(i_subfd)       = t_start;
          
        %%
        matfilepath   = ['Folder_',subfolderName,'.mat'];
        load(matfilepath,'d_H_Ph1_interp','d_H_Ph2_interp',...
             't_imp_interp2','t_interflag_interp',...
             'Ph_interflag_interp','flag1_f','flag2_f')
        t = make_time_series(d_H_Ph1_interp,Fs_interp,'s');
        %%
        t_FendInSec = t_Fend/Fs_interp;
        t_left = numel(t(t>t_FendInSec))/Fs_interp;
        t_left_list(i_subfd) = t_left;
        %%
        idx_piezoOn   = find(t>t_FendInSec&t<piezoDuration+t_FendInSec);
        d_Ph1_piezoOn = d_H_Ph1_interp(idx_piezoOn);
        d_Ph2_piezoOn = d_H_Ph2_interp(idx_piezoOn);
        d_Ph_betweenFlag_piezoOn = Ph_interflag_interp(idx_piezoOn);
        t_piezoOn     = t(idx_piezoOn);
        t_piezoOn     = t_piezoOn-t_piezoOn(1);
        %%
        t_flag         = make_time_series(flag1_f,fps,'s');
        flag1_f_interp = interp1(t_flag,flag1_f,t,'spline');
        flag2_f_interp = interp1(t_flag,flag2_f,t,'spline');
        idx_IPbeating  = find(flag1_f_interp < IPFreqUpperBound & ...
                              flag2_f_interp < IPFreqUpperBound);
        idx_IPduringPiezo = intersect(idx_IPbeating,idx_piezoOn);
        IPduration_piezoOn = numel(idx_IPduringPiezo)/Fs_interp;
        t_IP_list(i_subfd) = IPduration_piezoOn;
        %%
        idxSyncThres  = syncThresTime*Fs_interp;       
        slope_d_Ph1   = abs(diff(smooth(d_Ph1_piezoOn,idxSyncThres)));
        slope_d_Ph2   = abs(diff(smooth(d_Ph2_piezoOn,idxSyncThres)));
        slope_d_PhFlag= abs(diff(smooth(d_Ph_betweenFlag_piezoOn,...
                        idxSyncThres)));
        %% figure
        figure(2);
        set(gcf,'DefaultAxesFontSize',12,...
            'DefaultAxesFontWeight','normal',...
            'DefaultAxesLineWidth',1.5,'unit','normalized',...
            'position',[0.2,0.2,0.5,0.6],'PaperPositionMode','auto')

        subplot(2,1,1)
        ax11=plot(t_piezoOn,d_Ph1_piezoOn,'LineWidth',2,...
                  'color',[BaoLan,.6]);
        hold on
        ax12=plot(t_piezoOn,d_Ph2_piezoOn,'LineWidth',2,...
                  'color',[YangHong,.6]);
        ax13=plot(t_piezoOn,d_Ph_betweenFlag_piezoOn,'LineWidth',2,...
                  'color',[SanLv,.6]);
        legend([ax11,ax12,ax13],{'between flag 1 and piezo',...
               'between flag 2 and piezo','between flag 1 and 2'},...
               'Location','southeast','fontsize',8,...
               'Box','off')
        ylabel('Phase difference (2pi)')
        subplot(2,1,2)
        ax21=plot(t_piezoOn(1:end-1),slope_d_Ph1,'LineWidth',1.5,...
            'color',[BaoLan,.6]);
        hold on
        ax22=plot(t_piezoOn(1:end-1),slope_d_Ph2,'LineWidth',1.5,...
            'color',[YangHong,.6]);
        ax23=plot(t_piezoOn(1:end-1),slope_d_PhFlag,'LineWidth',1,...
            'color',[YingWuLv,.4]);
        ax24=patch([t_piezoOn(1),t_piezoOn(1),...
                   t_piezoOn(end),t_piezoOn(end)],...
                   [0,syncThresSlope,syncThresSlope,0],...
                   NingMengHuang,'EdgeColor','None',...
                   'FaceColor',NingMengHuang,'FaceAlpha',0.2);
        ylim([-1e-5,2.5e-3])
        [~,legendIcons] = legend([ax21,ax22,ax23,ax24],...
                {'d/dt,btw flag1 and piezo',...
                 'd/dt,btw flag2 and piezo',...
                 'd/dt,btw flag1 and flag2',...
                 'Considered in sync'},...
                 'Location','northeast','fontsize',8,...
                 'Box','off');
        PatchInLegend = findobj(legendIcons, 'type', 'patch');
        set(PatchInLegend, 'facea', 0.2)  
        ylabel('Slope of the phase difference')
        xlabel('Time (s)')

        %%
        idx_flag1Sync = find(slope_d_Ph1<syncThresSlope);
        idx_flag2Sync = find(slope_d_Ph2<syncThresSlope);
        
        TSync1  = numel(idx_flag1Sync)/1000;
        TSyncRatio1 = TSync1/piezoDuration;
        TSyncRatio1_IP = TSync1/IPduration_piezoOn;
        
        TSync2  = numel(idx_flag2Sync)/1000;
        TSyncRatio2 = TSync2/piezoDuration;
        TSyncRatio2_IP = TSync2/IPduration_piezoOn;
        
        TSync1_list(i_subfd)      = TSync1;
        TSync2_list(i_subfd)      = TSync2;
        TSync1Ratio_list(i_subfd) = TSyncRatio1;
        TSync2Ratio_list(i_subfd) = TSyncRatio2;
        TSync1Ratio_IP_list(i_subfd) = TSyncRatio1_IP;
        TSync2Ratio_IP_list(i_subfd) = TSyncRatio2_IP;
        TSyncRatio = max([TSyncRatio1_IP,TSyncRatio2_IP]);
        
        %% figure texting
        subplot(2,1,1)
        title(sprintf('f=%.2fHz,f0=%.2fHz,MVASize=%.2fs,slopeThreshold:%.1e',...
             freqList(i_subfd),centralFreq,syncThresTime,syncThresSlope),...
             'FontSize',8)
        subplot(2,1,1)
        yrange = get(gca,'ylim'); ymid = mean(yrange);
        text(7,ymid,{['Time% IP beating:',...
            num2str(IPduration_piezoOn/piezoDuration*100,'%.1f'),'%'];...
            'Time% IP in sync with the';...
            ['external flow: ',num2str(TSyncRatio*100,'%.1f'),'%']},...
            'FontSize',8);
         
        %%
        TSyncSubFdPath  = fullfile(TSyncFigFdPath,mamaFolderNameStem);
        if ~exist(TSyncSubFdPath,'dir'); mkdir(TSyncSubFdPath); end
        findSyncFigPath = fullfile(TSyncSubFdPath,...
                          ['findSyncFor_',mamaFolderNameStem,...
                          '-',subfolderName,'.png']);
        print(gcf, findSyncFigPath,'-dpng','-r200');
        
        close all
    end
    save('Synchronization.mat',...
        't_Fstart_list','t_Fspan_list',...
        't_Fend_list','start_frame_list','t_start_list','t_left_list',...
        't_IP_list','piezoDuration',...
        'TSync1_list','TSync2_list',...
        'TSync1Ratio_list','TSync2Ratio_list',...
        'TSync1Ratio_IP_list','TSync2Ratio_IP_list',...
        'freqList','centralFreq',...
        'syncThresSlope','syncThresTime',...
        't_piezoOn','d_Ph1_piezoOn','d_Ph2_piezoOn',...
        'slope_d_Ph1','slope_d_Ph2','slope_d_PhFlag');

end

function flashDetectionFolderPath = defFlashDectionFolderPath(...
                                    mama_folder_path)
   
    if mama_folder_path(end) == '\' || mama_folder_path(end) == '/'
        [temp,~,~] = fileparts(mama_folder_path(1:end-1));
    else
        [temp,~,~] = fileparts(mama_folder_path);
    end
    
    [experiment_path,~,~]    = fileparts(temp); clear temp

    flashDetectionFolderPath = [fullfile(experiment_path,...
                                '002 flash figures'),'\'];
    if ~exist(flashDetectionFolderPath,'dir')
        mkdir(flashDetectionFolderPath);
    end
end

function TSyncFolderPath = defTSynFolderPath(...
                           mama_folder_path)
   
    if mama_folder_path(end) == '\' || mama_folder_path(end) == '/'
        [temp,~,~] = fileparts(mama_folder_path(1:end-1));
    else
        [temp,~,~] = fileparts(mama_folder_path);
    end
    
    [experiment_path,~,~] = fileparts(temp); clear temp

    TSyncFolderPath = [fullfile(experiment_path,'003 TSync figures'),'\'];
    if ~exist(TSyncFolderPath,'dir')
        mkdir(TSyncFolderPath);
    end
end
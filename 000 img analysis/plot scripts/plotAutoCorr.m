%% mamafolder path list
cd('D:\002 MATLAB codes\000 Routine\000 img analysis\')
AB00_experimentalConditions;

mama_folder_path_list = {...
%     'F:\180703 c1\c1\03Axial\',...
    'F:\180703 c2\c2\03Axial\'...
};

syncThresTime = 0.2 ; % [sec]
syncThresSlope= 7e-4;
piezoDuration= 6.1 ; % [sec]
%Magic number 1000 was the interpolation fps in the get_phase_info code
%%

for i_mamafd = 1:1%numel(mama_folder_path_list)
    %% Folders to rename
    mama_folder_path    = mama_folder_path_list{i_mamafd};  
    if mama_folder_path(end) == '\' || mama_folder_path(end) == '/'
        [temp,mamaFolderName,~]= fileparts(mama_folder_path(1:end-1)); 
    else
        [temp,mamaFolderName,~]= fileparts(mama_folder_path); 
    end
    [experiment_fullpath,~,~] = fileparts(temp); clearvars temp    
    [~,experiment,~]          = fileparts(experiment_fullpath);   
    AB00_experimentalConditions;
    
    %%getNoiseTeffByExpFitOfPhaseAutoCorr
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
    TSync1_list        = zeros(NoSubFd,1);
    TSync2_list        = zeros(NoSubFd,1);
    TSync1Ratio_list   = zeros(NoSubFd,1);
    TSync2Ratio_list   = zeros(NoSubFd,1);
    freqList           = zeros(NoSubFd,1);
    
    
    
    figure();
    set(gcf,'DefaultAxesFontSize',12,...
        'DefaultAxesFontWeight','normal',...
        'DefaultAxesLineWidth',1.5,'unit','normalized',...
        'position',[0.2,0.2,0.5,0.6],'PaperPositionMode','auto')
    set(gca,'defaultTextInterpreter','Latex',...
        'TickLabelInterpreter','Latex')
    %%
    for i_subfd = [3:9]
        subfolderName    = subfolderStructList(i_subfd).name;
        freqList(i_subfd)= str2double(subfolderName);
        disp([subfolderName,' time cost to find flash:'])
        %%
        tic
        if exist('Synchronization.mat','file')
            load('Synchronization.mat','t_Fstart_list','t_Fspan_list',...
                 't_Fend_list','start_frame_list','t_start_list')
             t_Fstart    = t_Fstart_list(i_subfd);
             t_Fspan     = t_Fspan_list(i_subfd);
             t_Fend      = t_Fend_list(i_subfd) ;
             start_frame = start_frame_list(i_subfd);
             t_start     = t_start_list(i_subfd);
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
        load(matfilepath,...
            't_imp_interp1','d_H_Ph1_interp',...
            't_imp_interp2','d_H_Ph2_interp',...
            't_interflag_interp','Ph_interflag_interp',...
            'f_imp')
        t = make_time_series(d_H_Ph1_interp,1000,'s');
        %%
        d_H_Ph2_interp      = interp1(t_imp_interp2,d_H_Ph2_interp,...
                                      t,'spline');
        Ph_interflag_interp = interp1(t_interflag_interp,...
                                      Ph_interflag_interp,t,'spline');
        %%
        t_FendInSec = t_Fend/1000;
        t_left = numel(t(t>t_FendInSec))/1000;
        t_left_list(i_subfd) = t_left;
        
        idx_AFto10   = find(t>t_FendInSec&t<piezoDuration+t_FendInSec);
        d_Ph1_AFto10 = d_H_Ph1_interp(idx_AFto10);
        d_Ph2_AFto10 = d_H_Ph2_interp(idx_AFto10);
        d_Ph_btweenFlag_AFto10 = Ph_interflag_interp(idx_AFto10);
        t_AFto10     = t(idx_AFto10);
        t_AFto10     = t_AFto10-t_AFto10(1);
        
        slope_d_Ph1   = abs(diff(smooth(d_Ph1_AFto10,syncThresTime*1000)));
        slope_d_Ph2   = abs(diff(smooth(d_Ph2_AFto10,syncThresTime*1000)));
        slope_d_PhFlag= abs(diff(smooth(d_Ph_btweenFlag_AFto10,...
                        syncThresTime*1000)));
        
        %%
        CMat = zeros(5,1000);
        for jj = 1:5
            sig_temp = d_Ph_btweenFlag_AFto10((1+jj*1000):(jj+1)*1000);
            sig_temp = sig_temp - mean(sig_temp);
            [C_temp,lag] =xcorr(sig_temp,sig_temp);
            C_temp(lag<0)=[];
            lag(lag<0) = [];
            CMat(jj,:) = C_temp;
        end
        C_avg = mean(CMat,1);
        
        %%
        idx_flag1Sync = find(slope_d_Ph1<syncThresSlope);
        idx_flag2Sync = find(slope_d_Ph2<syncThresSlope);
        TSync1  = numel(idx_flag1Sync)/1000;
        TSyncRatio1 = TSync1/piezoDuration;
        TSync2  = numel(idx_flag2Sync)/1000;
        TSyncRatio2 = TSync2/piezoDuration;
        avgTSyncRatio = (TSyncRatio1+TSyncRatio2)/2;

        plot  (lag/1000*1000,C_avg,'.-','markersize',10,...
               'LineWidth',0.5,...
               'DisplayName',['f_{piezo}=',...
               num2str(f_imp,'%.2f'),'Hz ',...
               num2str(avgTSyncRatio*100,'%.1f'),'% in sync with piezo'] );
        hold on
        xlim  ([0,450])
        xlabel('lag (ms)')
        ylabel('Autocorrelation')

    end
    legend()
end

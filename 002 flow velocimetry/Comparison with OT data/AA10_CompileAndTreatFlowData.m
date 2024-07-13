%% Add paths
close all
run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')

%% Set experiment parameters 
experiment = '170703c9l';
experiment_date = experiment(1:6);
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters
%%%%%%% set a filter around ~ line 110%%%%%%%%%%%%                                     

%% Description of the direction
% Due to historical reason, only 'v_x' and 'v_y' are indeed horizontal and
% vertical directions of in the image. Note that the positive direction of
% v_x is leftwards.
% From these two variables on, other x and y in variables' names have no
% physical meanings. In the experimental setting after 2017-05-02, vx is
% the axial direction of the cell. Positive direction downwards. vy is the
% lateral direction, positive on the right.

%% Import bead position dictionary
if ~exist('beadcoords_pth','var')
    error('bead coordinates filepath not specified, add in AA05.m')
end
beadcoords = dlmread(beadcoords_pth);
[xgb_list,ygb_list] = BeadCoordsFromFile(beadcoords_pth,pt_list,experiment);
Nopos               = length(pt_list); % number of positions, 

%% Plot setting
include_time_shift = 0; % 0: plot raw over lay of CFD and EXP time series
                        % 1: plot S_CFD(t) together with S_EXP(t+t_delay_x)
include_v_shift    = 0; % 0: not plot velocity shift in resultant figures
                        % 1: include.
save_figures    = 1;    % 0: don't save, but pause after each treatment
                        % 1: save, no pause.
save_filt_feature= 1;   % 0: apply filter 
                        % 1: apply filter and also keep images showing how
                        %    the signal was filtered 
                        
%% Creating saving paths
if exist('result_fdpth', 'var')
    if ~exist(result_fdpth,'dir'); mkdir(result_fdpth);  end
    fig1_fdpth = [result_fdpth,'01. determine cycle/'];
    fig2_fdpth = [result_fdpth,'02. avg. cycle/'];
    fig3_fdpth = [result_fdpth,'03. limit cycle/'];
    fig4_fdpth = [result_fdpth,'04. quiver plot/'];
    fig5_fdpth = [result_fdpth,'05. filter feature/'];
    TreatmentResult_filepath = [result_fdpth,experiment,'_FitSegAvg.mat'];
    if ~exist(fig1_fdpth,  'dir'); mkdir(fig1_fdpth);    end
    if ~exist(fig2_fdpth,  'dir'); mkdir(fig2_fdpth);    end
    if ~exist(fig3_fdpth,  'dir'); mkdir(fig3_fdpth);    end
    if ~exist(fig4_fdpth,  'dir'); mkdir(fig4_fdpth);    end
    if ~exist(fig5_fdpth,  'dir'); mkdir(fig5_fdpth);    end
else
    error('Define folder path for storing the results.')
end    

%% Preallocation of vector fields
% 0th section: store previously calculated vectors in batch. 
temp1           = zeros(Nopos,1);  % array to store a list of scalars
temp2           = cell (Nopos,1);  % cell to store a list of vectors
[vx_raw_list,vy_raw_list,vx_list,vy_list,t_psd_list,...
 U_raw_list ,V_raw_list ,U_list ,V_list ,t_vid_list ]   = deal(temp2);

pos_info        = zeros(Nopos,4);
pos_info(:,1)   = pt_list; 
pos_info(:,2)   = xgb_list;
pos_info(:,3)   = ygb_list;
% use pos_info(:,4) = any temp_list, to study positional variability 

% 1st section preallocates all arrays for storing fitting parameters for
% different pos. The order is the same with pt_list defined in AA05_...
[t_vid_start_list,factor_x_list ,factor_y_list ,...
vx_shift_list   ,vy_shift_list ,t_shift_list_x,...
t_shift_list_y  ,freqx_list      ,freqy_list   ]        = deal(temp1);

% 2nd section preallocates all arrays for storing segmentation info 
[NoCyc_list , avg_period_list ,t_avg_start_list]        = deal(temp1);     

% cells storing the cyc-averaged flow speed at positions
[avg_vx_list,avg_vy_list,avg_U_list,avg_V_list ]        = deal(temp2);

% third section preallocates all arrays designed for investigating how 
% the properties of the flow fields varies with bead-to-cell distance.
[U_max_list ,V_max_list  ,U_min_list,V_min_list   ,...
U_mean_list ,V_mean_list ,U_ampl_list ,V_ampl_list ,...
vx_max_list ,vy_max_list ,vx_min_list ,vy_min_list ,...
vx_mean_list,vy_mean_list,vx_ampl_list,vy_ampl_list ] = deal(temp1);
% value of <name of the variable> is stored in the 4th column
clear temp1 temp2

%% LOOP
for i = 1:Nopos
    close all
    %% Find bead position
    pt      = pt_list(i);
    xgb     = xgb_list(i);
    ygb     = ygb_list(i); 
    BeadCellDistance = sqrt(xgb^2+ygb^2);
    
    %% Load t_vid_start from previous video sequence cut
    AFLogFilePath_02d = [AFpsd_fdpth,uni_name,'_',...
                         num2str(pt,'%02d'),'_log.mat'];
    AFLogFilePath_d =   [AFpsd_fdpth,uni_name,'_',...
                         num2str(pt,'%d'),  '_log.mat'];                 
    if exist(AFLogFilePath_02d,'file')
        load(AFLogFilePath_02d,'t_start')
    else
        if exist(AFLogFilePath_d,'file')
            load(AFLogFilePath_d,'t_start')
        end
    end
    % As log files were stored sometimes of '%02d' format and sometimes '%d' 
    t_vid_start_list(i) = t_start;
    
    %% Load U,V from first CFD then from tweezers data
    %%%%%%%%%%%%%%%%%%%%%%%%%
    load([scenario_fdpth, num2str(pt,'%02d'),...
        '\FlowSpeed_rf0.2_',uni_name,'_',num2str(pt,'%02d'),'.mat'],...
         'Uflowb','Vflowb');
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(experiment,'170130c2g')
        load([AFpsd_fdpth,num2str(pt,'%02d'),'_AF_nm,ums,pN.mat'],...
              'v_x','v_y'); 
    else
        load([AFpsd_fdpth,num2str(pt),'_AF_nm,ums,pN.mat'],...
              'v_x','v_y'); 
    end
    %% Orientation of the speed vector
    % In this file,vx_ means v_axial, vy_ means v_lateral     
    [vx_raw,vy_raw] =       orient_flow_from_ScreenFrame_to_CellFrame(...
                            v_x,v_y,experiment); 

    %% Filtering noise
%     use simple syntax of vx = filter(vx) to enhance readability
%     user is encouraged to customize a filter function elsewhere
    
    [vx,pksx,locsx] = AutoBPF_FlagSig_v2(vx_raw,Fs,45,59); 
    [vy,pksy,locsy] = AutoBPF_FlagSig_v2(vy_raw,Fs,45,59);
    if ~isempty(locsy) && isempty(locsx) 
        [~,~,locsy,wy ] = AutoBPF_FlagSig_v2(vy_raw,Fs); 
        HPf_temp        = locsy(1)   -  0.85*wy(1); 
        LPf_temp        = locsy(end) +  0.85*wy(end);
        [vx,~,~]        = AutoBPF_FlagSig_v2(vx_raw,Fs,HPf_temp,LPf_temp);
        clearvars HPf_temp LPf_temp
    end
    if ~isempty(locsx) && isempty(locsy)
        [~,~,locsx,wx ] = AutoBPF_FlagSig_v2(vx_raw,Fs); 
        HPf_temp        = locsx(1)   -  0.85*wx(1); 
        LPf_temp        = locsx(end) +  0.85*wx(end);
        [vy,~,~]        = AutoBPF_FlagSig_v2(vy_raw,Fs,HPf_temp,LPf_temp);
        clearvars HPf_temp LPf_temp
    end
%     if str2double(experiment_date)<170502
%         wo = 124/Fs*2; % normalized freq (with Nyquist freq)
%         bw = wo/20;  % normalized notch width
%         [bsfan,asfan]  = iirnotch(wo,bw);
%         vx = filtfilt(bsfan,asfan,vx); 
%         vy = filtfilt(bsfan,asfan,vy);
%     end

    %%%%%% manual smoothing %%%%%%    
%     pksx = []; pksy = []; locsx = []; locsy = [];
%     vx = smooth(vx_raw,floor(10*Fs/1000)); % smooth: 10 ms
%     vy = smooth(vy_raw,floor(10*Fs/1000)); 

    if ~isempty(locsx); freqx_list(i) = min(locsx); end
    if ~isempty(locsy); freqy_list(i) = min(locsy); end
    figure(5)
    plot_filter_feature;
    
    % Using a median filter to recognize and get rid of spikes. 
    Uflowb_raw = Uflowb;
    Vflowb_raw = Vflowb;
    Uflowb = medfilt1(Uflowb_raw,5);
    Vflowb = medfilt1(Vflowb_raw,5);
%     if fps >600
        Uflowb = smooth(Uflowb,3);
        Vflowb = smooth(Vflowb,3);
%     end 
    %% Make time series
    t_vid_start    = (start_frame-1)/fps_real*1000;  % ms
    t_vid_start    = t_vid_start + t_vid_start_list(i);
    % t_vid_start means the starting time from the middle of the falling 
    % edge of the flash light. 
    % Two factors contribute to it.     
    % 1: the analysed images may not start from 1_0001.tif (unsync. beating)
    %    e.g. starting from 1_0100.tif, the starting time will be 99*1000/fps (ms)    
    % 2: the first image is not exactly at the middle of the falling flash 
    %    edge. The maximum difference can be 1000/fps (ms), that is, 
    %    1.2 ~ 3.0 ms. And it is critical for calculating vortex diffusion.
    
    t_vid          = make_time_series(Uflowb,fps_real,'ms')+t_vid_start;
    t_psd          = make_time_series(vx,    Fs,      'ms');
      
    %% Determine coarsely the time shift 
    % Use correlation function to determine,
    % Based only on x direction (lab screen) signal 
    t_shift_corr_x = get_time_shift_by_correlation(vx,Uflowb,t_vid,...
                                                    Fs,t_vid(1));
    t_shift_corr_y = get_time_shift_by_correlation(vy,Vflowb,t_vid,...
                                                    Fs,t_vid(1));
    t_shift_x = t_shift_corr_x;
    t_shift_y = t_shift_corr_y;
    
    %% Fit x component and save
    A = []; b=[]; Aeq =[]; beq = [];
    options = optimset('Display','notify','TolFun',0.001,'MaxIter',1e10);
    % Fitting is to compare the difference in amplitudes and refine time
    % shift for short BEM signal
    ub = [3,       t_shift_x+5,   50];
    lb = [0.33,    t_shift_x-5,  -50];
    x0 = [1 ,      t_shift_x  ,    0];
    
    fun = @(x)match_EXP_and_CFD(x,vx,t_psd,Uflowb,t_vid);
    fit_parameters = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,[],options);
    factor_x    = fit_parameters(1);
%     t_shift_x   = fit_parameters(2);
    vx_shift    = fit_parameters(3);
    
    %% Fit y component and save
    ub = [3,       t_shift_y+5,   50];
    lb = [0.33,    t_shift_y-5,  -50];
    x0 = [1 ,      t_shift_y  ,    0];
    
    fun = @(x)match_EXP_and_CFD(x,vy,t_psd,Vflowb,t_vid);
    fit_parameters = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,[],options);
    factor_y    = fit_parameters(1);
%     t_shift_y   = fit_parameters(2);
    vy_shift    = fit_parameters(3);
 
    %% Segmentization, using matched CFD as the reference
    if include_time_shift == 1
        t_plot_shift        = t_shift_x;
    else
        t_plot_shift        = 0;    % not to plot with shift in time   
    end
    t_vid_shift         = t_vid + t_plot_shift;
    t_vid_shift_interp  = t_vid_shift(1):1/Fs*1000:t_vid_shift(end);
    % NOTE: <t_vid + t_shift_x> is the time span of the video sequence,
    %       after matching with the experimental data locally, in the 
    %       flash-defined reference frame. 
    
    % Interpolation
    Uflowb_interp = interp1(t_vid_shift,Uflowb,t_vid_shift_interp,'spline');
    Vflowb_interp = interp1(t_vid_shift,Vflowb,t_vid_shift_interp,'spline');
    % NOTE: x,y signal are all shifted according to fit results of x
    % NOTE: part of the names of the variables have been used in the
    %       previous fitting section.
    
    % Determine number of cycles contained in the simulation
    [~,local_max_idx]  = findpeaks( Uflowb_interp,'MinPeakProminence',6,...
                                   'MinPeakDistance',12.5*Fs/1000 );
    [~,local_min_idx]  = findpeaks(-1*Uflowb_interp,'MinPeakProminence',6,...
                                   'MinPeakDistance',12.5*Fs/1000);
    % NOTE: MinPeakDistance suggest that two local maxima (minima) must be
    %       away from each other for at least 12.5 ms ~ max 80 Hz .
    % NOTE: Hereafter, signal is segmentized into periods, with boundaries 
    %       determined by the two nearest local minima. In theory, using 
    %       local maxima would be equivalent.
    
    %% Plot: Check matching and segmentization results
    if include_v_shift == 0
        vx_plot_shift = 0; vy_plot_shift = 0;
    else
        vx_plot_shift = vx_shift; vy_plot_shift = vy_shift;    
    end
    
    plt_v_span_min = min([min(vx),min(vy),min(Uflowb),min(Vflowb)]);
    plt_v_span_max = max([max(vx),max(vy),max(Uflowb),max(Vflowb)]);
    plt_v_span_min =  floor(plt_v_span_min/25)   *25; 
    plt_v_span_max = (floor(plt_v_span_max/25)+1)*25; 
    figure(1)
    double_panel_fig_setting;
    color_palette;  % import readable colors 
    plot_overlay_of_CFD_and_EXP_flow;
   
    
    %% Rescale and average signal
    cyc            = diff(local_min_idx)/ Fs * 1000 ; % ms
    % get rid of slips
    med_cyc        = median(cyc);
    deviation_cyc  = median(abs(cyc - med_cyc));
    idx_goodones   = find(abs(cyc-med_cyc)<0.5+3*deviation_cyc); 
    avg_period     = mean(cyc(idx_goodones));  % ms
    
    t_avg          = 0:1/Fs*1000:avg_period;
    NoPts_avgCyc   = length(t_avg);         % No. of points for an avg. cyc
    avg_vx         = zeros(NoPts_avgCyc,1); 
    avg_vy         = zeros(NoPts_avgCyc,1);
    avg_U          = zeros(NoPts_avgCyc,1);
    avg_V          = zeros(NoPts_avgCyc,1);
    TotNoCyc       = length(cyc);             % Total no. of cycles.
    NoCyc          = length(idx_goodones);    % If no misrecog: 
                                              %   NoCyc = TotNoCyc
                                              
    for idx_cyc = 1:NoCyc
        % e.g. 7 local minima         ===> 6 cycles recog
        %   If there is no misrecog, NoCyc = NoLocalMin - 1         (1)
        %   the 2nd one is a misrecog ===> 5 good cycles
        %   idx_goodones = [1,3,4,5,6] 
        %   NoCyc        = 5,  idx_cyc = 1,2,3,4,5
        %   when j = 1: cyc is t(local_min(1)) to t(local_min(2))
        %        j = 3: cyc is t(local_min(3)) to t(local_min(4))
        %        ...
        %   condition (1) ensures that j+1 = NoCyc+1 would not exceed index
        %   limit.
        j          = idx_goodones(idx_cyc);
        %% for EXP data
        t_seg_start = t_vid_shift_interp(local_min_idx(j));
        t_seg_end   = t_vid_shift_interp(local_min_idx(j+1));
        t_seg       = linspace(t_seg_start,t_seg_end,NoPts_avgCyc); 
        % t_seg here will re-sample each period with the SAME NO. of points.
        % Resampled signal (vx, vy) will be added up to obtain an average.
        % This process is equivalent to rescale each period to the same
        % duration, which is the average period.
        vx_interp   = interp1(t_psd,vx,t_seg);
        vy_interp   = interp1(t_psd,vy,t_seg);
        avg_vx      = avg_vx + vx_interp';
        avg_vy      = avg_vy + vy_interp';
        
        %% for CFD data
        t_seg_start = t_vid_shift_interp(local_min_idx(j));
        t_seg_end   = t_vid_shift_interp(local_min_idx(j+1));
        t_seg       = linspace(t_seg_start,t_seg_end,NoPts_avgCyc); 
        U_interp    = interp1(t_vid_shift_interp,Uflowb_interp,t_seg);
        V_interp    = interp1(t_vid_shift_interp,Vflowb_interp,t_seg);
        avg_U       = avg_U + U_interp';
        avg_V       = avg_V + V_interp';
    end
    
    avg_vx          = avg_vx/NoCyc;    avg_vy        = avg_vy/NoCyc;
    avg_U           = avg_U/NoCyc;     avg_V         = avg_V/NoCyc;
    t_avg_start     = t_vid_shift_interp(local_min_idx(1));


    %% Plot: Compare CFD and EXP avg cycle
    figure(2)
    double_panel_fig_setting;
    plot_overlay_avg_cyc;
    
    %% Plot: compare limit cycle    
    figure(3)
    plot_overlay_limit_cycle_of_flow_speed;
    
    %% Save the values
    % 0th section, from load
    vx_raw_list(i)   = {vx_raw};  
    vy_raw_list(i)   = {vy_raw};
    vx_list(i)       = {vx};  
    vy_list(i)       = {vy};
    U_raw_list(i)    = {Uflowb_raw};
    V_raw_list(i)    = {Vflowb_raw};
    U_list(i)        = {Uflowb};
    V_list(i)        = {Vflowb};
    t_psd_list(i)    = {t_psd};
    t_vid_list(i)    = {t_vid};
    
    % 1st section,from fitting
    factor_x_list   (i)=  factor_x;      factor_y_list (i)=  factor_y;
    vx_shift_list   (i)=  vx_shift;      vy_shift_list (i)=  vy_shift;
    if t_shift_x < -5   
        t_shift_x = t_shift_x + avg_period; 
    end
    if t_shift_y < -5   
        t_shift_y = t_shift_y + avg_period; 
    end
    t_shift_list_x  (i)=  t_shift_x;     t_shift_list_y(i)=  t_shift_y;
        
    % 2nd section, cycle average
    NoCyc_list      (i)=  NoCyc;
    avg_period_list (i)=  avg_period;
    avg_vx_list     (i)= {avg_vx};       avg_vy_list   (i)= {avg_vy};
    avg_U_list      (i)= {avg_U};        avg_V_list    (i)= {avg_V};
    t_avg_start_list(i)=  t_avg_start;  
    
    % 3rd section, flow speed characteristics
    U_max_list(i)   = prctile(Uflowb,97); 
    V_max_list(i)   = prctile(Vflowb,97);
    U_min_list(i)   = prctile(Uflowb,3);
    V_min_list(i)   = prctile(Vflowb,3);
    U_mean_list(i)  = mean(avg_U);
    V_mean_list(i)  = mean(avg_V);
    U_ampl_list(i)  = U_max_list(i)- U_min_list(i);
    V_ampl_list(i)  = V_max_list(i)- V_min_list(i);
    
    vx_max_list(i)  = prctile(vx,97) - vx_shift;
    vy_max_list(i)  = prctile(vy,97) - vy_shift; 
    vx_min_list(i)  = prctile(vx,3)  - vx_shift;  
    vy_min_list(i)  = prctile(vy,3)  - vy_shift;  
    vx_mean_list(i) = mean(avg_vx);
    vy_mean_list(i) = mean(avg_vy);
    vx_ampl_list(i) = vx_max_list(i)- vx_min_list(i);
    vy_ampl_list(i) = vy_max_list(i)- vy_min_list(i);

    %% Save the figures
    fig1_pth = fullfile(fig1_fdpth,[num2str(pt,'%02d'),...
                '_determine_cycle.png']);
    fig2_pth = fullfile(fig2_fdpth,[num2str(pt,'%02d'),...
                '_compare_avg_cyc.png']);
    fig3_pth = fullfile(fig3_fdpth,[num2str(pt,'%02d'),...
                '_compare_limit_cyc.png']);
    fig5_pth = fullfile(fig5_fdpth,[num2str(pt,'%02d'),...
                '_filter_feature.png']);
    if save_figures
        print(1,fig1_pth,'-dpng','-r300');
        print(2,fig2_pth,'-dpng','-r300');
        print(3,fig3_pth,'-dpng','-r300');
    else
        pause();
    end
    if save_filt_feature
        print(5,fig5_pth,'-dpng','-r300');
    end
end

save(TreatmentResult_filepath,'experiment','result_fdpth',...
             'beadcoords','xgb_list','ygb_list','pt_list',...
             'Nopos'          ,  'pos_info'      ,...
             't_vid_start_list', 'Fs',  'fps'    ,...
             'vx_raw_list'    ,  'vy_raw_list'   ,...  
             'vx_list'        ,  'vy_list'       ,...
             'U_raw_list'     ,  'V_raw_list'    ,...
             'U_list'         ,  'V_list'        ,...
             't_vid_list'     ,  't_psd_list'    ,...
             'ub'             ,  'lb'            ,...
             'factor_x_list'  ,  'factor_y_list' ,...
             'vx_shift_list'  ,  'vy_shift_list' ,...
             't_shift_list_x' ,  't_shift_list_y',...
             'NoCyc_list'     ,...
             'avg_period_list',...
             't_avg_start_list',...     
             'avg_vx_list'    ,  'avg_vy_list'  ,...
             'avg_U_list'     ,  'avg_V_list'   ,...
             'U_max_list'     ,  'V_max_list'   ,...
             'U_min_list'     ,  'V_min_list'   ,...
             'U_mean_list'    ,  'V_mean_list'  ,...
             'U_ampl_list'    ,  'V_ampl_list'  ,...
             'vx_max_list'    ,  'vy_max_list'  ,...
             'vx_min_list'    ,  'vy_min_list'  ,...
             'vx_mean_list'   ,  'vy_mean_list' ,...
             'vx_ampl_list'   ,  'vy_ampl_list' ,...
             'freqx_list'     ,  'freqy_list'    );
    

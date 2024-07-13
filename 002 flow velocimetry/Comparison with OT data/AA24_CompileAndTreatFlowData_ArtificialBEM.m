%% Doc
% Compile the data from c16l1, double flash delay


%%
close all
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
experiment = '180903c20a';
start_frame = 1;
AA05_experiment_based_parameter_setting;

%%
% The completeness of the files is confirmed.
% NoFile      = length(matfilelist)
[xgb_list,ygb_list] = BeadCoordsFromFile(beadcoords_pth,pt_list,experiment);
Nopos               = length(pt_list); % number of positions, 
NoFile              = Nopos;

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
PhDelay_result_fdpth = result_fdpth;
if exist('PhDelay_result_fdpth', 'var')
    if ~exist(result_fdpth,'dir'); mkdir(result_fdpth);  end
    fig1_fdpth = [PhDelay_result_fdpth,'01. determine cycle\'];
    fig2_fdpth = [PhDelay_result_fdpth,'02. avg. cycle\'];
    fig3_fdpth = [PhDelay_result_fdpth,'03. limit cycle\'];
    fig4_fdpth = [PhDelay_result_fdpth,'04. quiver plot\'];
    fig5_fdpth = [PhDelay_result_fdpth,'05. filter feature\'];
    TreatmentResult_filepath = [PhDelay_result_fdpth,experiment,'_FitSegAvg.mat'];
    if ~exist(fig1_fdpth,  'dir'); mkdir(fig1_fdpth);    end
    if ~exist(fig2_fdpth,  'dir'); mkdir(fig2_fdpth);    end
    if ~exist(fig3_fdpth,  'dir'); mkdir(fig3_fdpth);    end
    if ~exist(fig4_fdpth,  'dir'); mkdir(fig4_fdpth);    end
    if ~exist(fig5_fdpth,  'dir'); mkdir(fig5_fdpth);    end
else
    error('Define folder path for storing the results.')
end    


%% Preallocation
temp1           = zeros(Nopos,1);  % array to store a list of scalars
temp2           = cell (Nopos,1);  % cell to store a list of vectors    

vx_raw_list     = temp2;  vy_raw_list     = temp2;
vx_list         = temp2;  vy_list         = temp2;
t_psd_list      = temp2;
U_raw_list      = temp2;  V_raw_list      = temp2;
U_list          = temp2;  V_list          = temp2;
t_vid_list      = temp2;
t_vid_start_list= temp1; %#ok<NASGU>
factor_x_list   = temp1;  factor_y_list   = temp1;
vx_shift_list   = temp1;  vy_shift_list   = temp1;
t_shift_list_x  = temp1;  t_shift_list_y  = temp1;
freqx_list      = temp1;  freqy_list      = temp1;


pos_info        = zeros(Nopos,4);
pos_info(:,1)   = pt_list;
pos_info(:,2)   = xgb_list;
pos_info(:,3)   = ygb_list;
clear temp1 temp2

%%
load([material_fdpth,'v_raw_list.mat'],'v_ax_raw_list','v_lat_raw_list')


%% t_start_list
if exist([material_fdpth,'t_start_list.mat'],'file')
    load([material_fdpth,'t_start_list.mat'],'t_start_list');
else
    load([material_fdpth,'t_start_list,t_span_list.mat'],...
        't_start_list');
end

%% modular flow
load([material_fdpth,'modular_flows_list.mat'],'Uflowb_modular_list',...
      'Vflowb_modular_list');

%% marked frames with most far reaching flagella position
load([material_fdpth,'all_marked_list.mat'],'marked_image_list_cell');

%%
for i = 1:Nopos
    close all
    pt= pt_list(i);
    pt_str = num2str(pt,'%02d');
    [xgb,ygb] = BeadCoordsFromFile(beadcoords_pth,pt,experiment);
    %% Uflowb, Vflowb. Raw and treated
    t_vid_start          = t_start_list(i);
    Uflowb_modular_cycle = Uflowb_modular_list{i};
    Vflowb_modular_cycle = Vflowb_modular_list{i};
    Uflowb_modular_cycle = medfilt1(Uflowb_modular_cycle);
    Vflowb_modular_cycle = medfilt1(Vflowb_modular_cycle);
    marked_list          = marked_image_list_cell{i};
    marked_list          = sort(marked_list);
    marked_list    = extractLongestConsecutiveMarkedCycles(marked_list,19);
                     % avg freq ~50, each cyc lasts 12 frame for c17l. If
                     % the interval between two event (farthest reaching)
                     % is more than 16 frms, it's treated as a break
                     % is chosen based on this.
    
    
    % _Art for artificial. Manually replicating and stretching the averaged
    % cycle to construct the flow signal
    [Uflowb_Art,t_CFD_Art]= generate_artificial_signal_by_marked_list(...
                            Uflowb_modular_cycle,marked_list,t_vid_start,...
                            fps,Fs);
    Uflowb_raw            = Uflowb_Art;
    [Vflowb_Art,~        ]= generate_artificial_signal_by_marked_list(...
                            Vflowb_modular_cycle,marked_list,t_vid_start,...
                            fps,Fs);
    Vflowb_raw            = Vflowb_Art;
    
    Uflowb = Uflowb_raw;
    Vflowb = Vflowb_raw;


    %% v_ax_raw and v_lat_raw
    vx_raw  = v_ax_raw_list{i};
    vy_raw  = v_lat_raw_list{i};
    [vx,pksx,locsx] = AutoBPF_FlagSig_v2(vx_raw,Fs,45,65); 
    [vy,pksy,locsy] = AutoBPF_FlagSig_v2(vy_raw,Fs,45,65);
    if ~isempty(locsy) && isempty(locsx) 
        [~,~,locsy,wy ] = AutoBPF_FlagSig_v2(vy_raw,Fs); 
        HPf_temp        = locsy(1)   -  1.5*wy(1); 
        LPf_temp        = locsy(end) +  1.5*wy(end);
        [vx,~,~]        = AutoBPF_FlagSig_v2(vx_raw,Fs,HPf_temp,LPf_temp);
        clearvars HPf_temp LPf_temp
    end
    if ~isempty(locsx) && isempty(locsy)
        [~,~,locsx,wx ] = AutoBPF_FlagSig_v2(vx_raw,Fs); 
        HPf_temp        = locsx(1)   -  1.5*wx(1); 
        LPf_temp        = locsx(end) +  1.5*wx(end);
        [vy,~,~]        = AutoBPF_FlagSig_v2(vy_raw,Fs,HPf_temp,LPf_temp);
        clearvars HPf_temp LPf_temp
    end
    
    
    %% v_ax, v_lat
    if ~isempty(locsx); freqx_list(i) = min(locsx); end
    if ~isempty(locsy); freqy_list(i) = min(locsy); end
    figure(5)
    plot_filter_feature;
    
    %% Make time series
    t_vid        = t_CFD_Art; %historical reason, not renaming this variable
    t_psd        = make_time_series(vx,    Fs,      'ms');
      
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
    % As it is periodic and noisy signal, fit results depend on initial
    % values. So be careful.
    ub = [3,       0,   50];
    lb = [0.33,    0,  -50];
    x0 = [1 , 0 ,0];
    
    fun = @(x)match_EXP_and_CFD(x,vx,t_psd,Uflowb,t_vid);
    fit_parameters = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,[],options);
    factor_x    = fit_parameters(1);
%     t_shift_x   = fit_parameters(2);
    vx_shift    = fit_parameters(3);
    
    %% Fit y component and save
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
%     plt_v_span = max(max(vx)-min(vx),max(vy)-min(vy)); 
%     plt_v_span = (floor(plt_v_span/15)+1)*15; 
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
    if t_shift_x > 12   
        t_shift_x = t_shift_x - avg_period; 
    end
    if t_shift_y < -5   
        t_shift_y = t_shift_y + avg_period; 
    end
    if t_shift_y > 12   
        t_shift_y = t_shift_y - avg_period; 
    end

    t_shift_list_x  (i)=  t_shift_x;     t_shift_list_y(i)=  t_shift_y;
        
    %% Save the figures
    fig1_pth = [fig1_fdpth,num2str(pt,'%02d'),'_determine_cycle.png'];
    fig2_pth = [fig2_fdpth,num2str(pt,'%02d'),'_compare_avg_cyc.png'];
    fig3_pth = [fig3_fdpth,num2str(pt,'%02d'),'_compare_limit_cyc.png'];
    fig5_pth = [fig5_fdpth,num2str(pt,'%02d'),'_filter_feature.png'];
    if save_figures
        print(1,fig1_pth,'-dpng','-r300');
        print(2,fig2_pth,'-dpng','-r300');
        print(3,fig3_pth,'-dpng','-r300');
    else
%         pause;
    end
    if save_filt_feature
        print(5,fig5_pth,'-dpng','-r300');
    end
% pause
end


save(TreatmentResult_filepath,'experiment','PhDelay_result_fdpth',...
             'xgb_list','ygb_list','pt_list',...
             'Nopos'          ,  'pos_info',...
             't_vid_start_list', 'Fs',  'fps'    ,...
             'vx_raw_list'    ,  'vy_raw_list'   ,...  
             'vx_list'        ,  'vy_list'       ,...
             'U_raw_list'     ,  'V_raw_list'    ,...
             't_vid_list'     ,  't_psd_list'    ,...             
             'U_list'         ,  'V_list'        ,...
             'ub'             ,  'lb'            ,...
             'factor_x_list'  ,  'factor_y_list' ,...
             'vx_shift_list'  ,  'vy_shift_list' ,...
             't_shift_list_x' ,  't_shift_list_y',...
             'freqx_list'     ,  'freqy_list'    );
    
    
    
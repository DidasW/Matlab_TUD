%% Add paths
run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')

%% Set experiment parameters 
experiment = '170130c1g';
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters
% This part is due to different case uses different section in the movie.
% The aim in the first place was to find synchronous beating witout much
% interflagellar lag.
pt = 32;
switch pt
    case 45
        start_frame    = 200;
    case 51
        start_frame    = 510;
    otherwise
        start_frame    = 100;
end

load(['D:\004 FLOW VELOCIMETRY DATA\c1g\',num2str(pt,'%02d'),...
      '\rf=0.2_FlowSpeed_c1g_',     num2str(pt,'%02d'),...
      '_ModifyMobilityFile.mat']);
load(['D:\000 RAW DATA FILES\170130\c1g_AF\',...
      num2str(pt,'%02d'),'_AF_nm,ums,pN.mat']); 
vx            = -1*smooth(v_x,5,'sgolay');
vy            = -1*smooth(v_y,5,'sgolay');

%% Make time series
t_vid_start    = start_frame/fps_real*1000;  % ms
% t_vid_start means the starting time from the ending of the flash light
% it exists as the analysed image sequence doesn't start from 1_0001.tif.
t_vid          = make_time_series(Uflowb,fps_real,'ms')+t_vid_start;
t_psd          = make_time_series(v_x,   Fs,      'ms');


%% Result storage
% store_fdpth = 'D:\000 RAW DATA FILES\170130\c1g_matching results\';
% filename    = 'c1g_MatchResults.dat';
% if exist([store_fdpth,filename],'file')
% else
% end


%% Fit: initial, x, y
% Use correlation function to determine the time shift
% Based only on x direction (lab screen) signal 
t_shift_initial = get_time_shift_by_correlation(vx,  Uflowb,t_vid,...
                                                Fs,  t_vid_start     );
 

% Fit x component and save
A = []; b=[]; Aeq =[]; beq = [];
options = optimset('Display','notify','TolFun',0.001,'MaxIter',1e10);
% As it is periodic and noisy signal, fit results depend on initial
% values. So be careful.
ub = [2.5, 8,   50];
lb = [0,  -8,  -50];
x0 = [2,t_shift_initial,0];

fun = @(x)match_EXP_and_CFD(x,vx,t_psd,Uflowb,t_vid);
fit_parameters = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,[],options);
factor_x    = fit_parameters(1);
t_shift_x   = fit_parameters(2);
vx_shift    = fit_parameters(3);

% Fit y component and save
fun = @(x)match_EXP_and_CFD(x,vy,t_psd,Vflowb,t_vid);
fit_parameters = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,[],options);
factor_y    = fit_parameters(1);
t_shift_y   = fit_parameters(2);
vy_shift   = fit_parameters(3);


%% interpoloate and segmentize signal
t_vid_shift         = t_vid + t_shift_x;
t_vid_shift_interp  = t_vid_shift(1):1/Fs*1000:t_vid_shift(end);

% interpolation 
Uflowb_interp = interp1(t_vid+t_shift_x,Uflowb,t_vid_shift_interp,'spline');
Vflowb_interp = interp1(t_vid+t_shift_x,Vflowb,t_vid_shift_interp,'spline');
% NOTE: x,y signal are all shifted according to fit results of x

% determine number of cycles in the simulation
[~,local_max_idx]  = findpeaks( Uflowb_interp  ,'MinPeakProminence',20);
[~,local_min_idx]  = findpeaks(-1*Uflowb_interp,'MinPeakProminence',20);


%% Plot to see the matching results
color_palette;  % import readable colors 

figure(1)
double_panel_fig_setting;
set(gcf,)
h = suptitle([sprintf('exp:%s, position:%02d\n',experiment,pt),...
              'Match signals and segmentize them into periods']);
set(h,'FontSize',12,'FontWeight','normal')

% x signal
subplot(211)
    ax11 = plot(t_psd,vx-vx_shift,'x-','markersize',3,'linewidth',0.2,...
                'color','b'  ); hold on 
    ax12 = plot(t_vid_shift_interp,factor_x*Uflowb_interp,'-','linewidth',2,...
                'color',orange);  

    for i = local_max_idx
        plot([t_vid_shift_interp(i),t_vid_shift_interp(i)],[-1000,1000],...
             '--', 'linewidth', 1, 'color', lightpurple)
    end
    for i = local_min_idx
        plot([t_vid_shift_interp(i),t_vid_shift_interp(i)],[-1000,1000],...
             '--','linewidth', 1, 'color', lightblue  )
    end

    xlabel('Time (ms)');         ylabel('flow speed ($\mu$m/s)');
    xlim([t_vid_start-10,t_vid_start+200]); ylim([-200,200]);
    legend([ax11,ax12],{'x signal','x simulation'})
    
    info       = sprintf(['$factor_{x}$= %.2f\n',...
                          '$t_{shift}$ = %.2f ms\n',...
                          '$v_{shift}$ = %.2f $\\mu$m/s'],...
                          factor_x, t_shift_x, vx_shift);
    h_txt      = text   (t_vid_start-6, 150,   info,...
                         'Fontsize', 8, 'Margin', 2,...
                         'BackgroundColor', 'w',...
                         'EdgeColor'      , 'k');
   
% y signal
subplot(212)
    ax21 = plot(t_psd,vy-vy_shift,'x-','markersize',3,'linewidth',0.2,...
                'color','b'  ); hold on 
    ax22 = plot(t_vid_shift_interp,factor_y*Vflowb_interp,'-','linewidth',2,...
                'color',orange);  

    for i = local_max_idx
        plot([t_vid_shift_interp(i),t_vid_shift_interp(i)],[-1000,1000],'--','linewidth',1,...
             'color',lightpurple)
    end
    for i = local_min_idx
        plot([t_vid_shift_interp(i),t_vid_shift_interp(i)],[-1000,1000],'--','linewidth',1,...
             'color',lightblue)
    end

    xlabel('Time (ms)');         ylabel('flow speed ($\mu$m/s)');
    xlim([t_vid_start-10,t_vid_start+200]); 
    ylim([-200,200]);
    legend([ax21,ax22],{'y signal','y simulation'})
    info       = sprintf(['$factor_{y}$= %.2f\n',...
                          '$t_{shift}$ = %.2f ms\n',...
                          '$v_{shift}$ = %.2f $\\mu$m/s'],...
                          factor_y, t_shift_x, vy_shift);
    h_txt      = text   (t_vid_start-6, 150,   info,...
                         'Fontsize', 8, 'Margin', 2,...
                         'BackgroundColor', 'w',...
                         'EdgeColor'      , 'k');

    
%% Re-sample and rescale
avg_period     = mean(diff(local_min_idx))/Fs * 1000 ;% unit ms
t_avg          = 0:1/Fs*1000:avg_period;
N              = length(t_avg);
avg_vx        = zeros(N,1);
avg_vy        = zeros(N,1);

NoCyc          = 0;

% NOTE: periods are recognized using local minima. In theory, using local
% maxima would be equivalent.
for i = 1:(length(local_min_idx)-1)
    t_seg_start = t_vid_shift_interp(local_min_idx(i));
    t_seg_end   = t_vid_shift_interp(local_min_idx(i+1));
    t_seg       = linspace(t_seg_start,t_seg_end,N); 
    % t_win here will sample each period with the same number of points.
    % Resampled signal (vx, vy) will be added up to obtain an average.
    % This process is equivalent to rescale each period to the same
    % duration, which is the average period.
    vx_interp  = interp1(t_psd,vx,t_seg);
    vy_interp  = interp1(t_psd,vy,t_seg);
    avg_vx     = avg_vx + vx_interp';
    avg_vy     = avg_vy + vy_interp';
    NoCyc       = NoCyc   + 1 ; 
end
t_avg_start = t_vid_shift_interp(local_min_idx(1));
avg_vx     = avg_vx/NoCyc;
avg_vy     = avg_vy/NoCyc;

%% make equal number of cycles to look better
% For the sake of plot, make repeated signal trains.
avg_vx_Nfold = [];   avg_vy_Nfold = [];
t_avg_Nfold  = [];
for i = 1:NoCyc
    avg_vx_Nfold = [avg_vx_Nfold;avg_vx]; 
    avg_vy_Nfold = [avg_vy_Nfold;avg_vy]; 
    t_avg_Nfold  = [t_avg_Nfold,t_avg+(i-1)*avg_period]; 
end

%% Plot the average cycle

figure(2)
double_panel_fig_setting;
h = suptitle([sprintf('exp:%s, position:%02d\n',experiment,pt),...
              'Averaging signal by rescaling each cycle']);
set(h,'FontSize',12,'FontWeight','normal')
subplot(211)
    ax11 = plot(t_psd,vx-vx_shift,'x-',...
                'markersize',4,'linewidth',0.2,...
                'color',lightblue ); hold on 
    ax12 = plot(t_avg_Nfold+t_avg_start,avg_vx_Nfold-vx_shift,'r-',...
                'linewidth',2)';
    xlabel('Time (ms)');            ylabel('flow speed ($\mu$m/s)');
    xlim([t_vid_start-10,t_vid_start+200]); ylim([-200,200]);
    ylim([-200,200]);
    legend([ax11,ax12],{'x raw','x averaged'});    legend('boxoff');

subplot(212)
    ax21 = plot(t_psd,vy-vy_shift,'x-',...
                'markersize',4,'linewidth',0.2,...
                'color',lightblue  );      hold on 
    ax22 = plot(t_avg_Nfold+t_avg_start,avg_vy_Nfold-vy_shift,'b-',...
                'linewidth',2)';
    xlabel('Time (ms)');         ylabel('flow speed ($\mu$m/s)');
    xlim([t_vid_start-10,t_vid_start+200]); ylim([-200,200]);
    ylim([-200,200]);
    legend([ax21,ax22],{'y raw','y averaged'});    legend('boxoff');



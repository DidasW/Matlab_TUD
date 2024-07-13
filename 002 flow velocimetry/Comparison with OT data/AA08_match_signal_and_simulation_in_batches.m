%% Add paths
 
%% Set experiment parameters 
experiment = '170130c1g';
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters

 %% Load and save

pt =21;
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
  
%% Result storage
store_fdpth = 'D:\000 RAW DATA FILES\170130\c1g_matching results\';
filename    = 'c1g_MatchResults.dat';
if exist([store_fdpth,filename],'file')
    fileID      = fopen([store_fdpth,filename],'a+t');
else
    fileID      = fopen([store_fdpth,filename],'a+t');
    fwrite(fileID,sprintf('pos\tx_b\ty_b\tfx\tt_s_x\tv_s_x\tfy\tt_s_y\tv_s_y\n'));
end

%% Fit and plot
t_vid_start    = start_frame/fps_real*1000;  % ms
t_vid          = make_time_series(Uflowb,fps_real,'ms')+t_vid_start;
t_psd          = make_time_series(v_x,   Fs,      'ms');
v_x            = -1*smooth(v_x,5);
v_y            = -1*smooth(v_y,5);
% v_x          = -1*smooth(v_x,5,'sgolay');
% v_y          = -1*smooth(v_y,5,'sgolay');

    %% Use correlation function to determine the time shift
    % Based only on x direction (lab screen) signal 
    t_vid_interp    = min(t_vid): 1/Fs*1000  :max(t_vid);
    Uflowb_interp   = interp1(t_vid,Uflowb,t_vid_interp);
    [C1,lag1]       = xcorr(v_x,Uflowb_interp);        
    [~,locs]        = findpeaks(C1,lag1/Fs*1000);
    [~,argmin]      = min(abs(locs-t_vid_start));
    % The signal is periodical, thus the correlation function is periodical too.
    % This argmin finds the samllest shift of time to maximize correlation,
    % instead trying to read global maximum.
    t_shift_initial = locs(argmin)-t_vid_start;


    %% Fit x component and save
    A = []; b=[]; Aeq =[]; beq = [];
    options = optimset('Display','notify','TolFun',0.001,'MaxIter',1e10);
    % As it is periodic and noisy signal, fit results depend on initial
    % values. So be careful.
    ub = [2.5, 8,   50];
    lb = [0,  -8,  -50];
    x0 = [2,t_shift_initial,0];
    
    fun = @(x)match_EXP_and_CFD(x,v_x,t_psd,Uflowb,t_vid);
    fit_parameters = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,[],options);
    factor_x    = fit_parameters(1);
    t_shift_x   = fit_parameters(2);
    v_shift_x   = fit_parameters(3);

    %% Fit y component and save
    fun = @(x)match(x,v_y,t_psd,Vflowb,t_vid);
    fit_parameters = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,[],options);
    factor_y    = fit_parameters(1);
    t_shift_y   = fit_parameters(2);
    v_shift_y   = fit_parameters(3);

    fwrite(fileID,sprintf('%02d\t%.2f\t%.2f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n',...
                    pt,  xgb,  ygb,  factor_x, t_shift_x, v_shift_x,...
                    factor_y, t_shift_y, v_shift_y));
    fclose(fileID);
    
%% Plot Fit results
color = [1,0.6,0.2];
figure(1);
set(1,'PaperUnits','centimeters','PaperSize',[20,26],...
    'defaulttextinterpreter','LaTex','Unit','Normalized',...
    'Position',[0.1,0.1,0.6,0.7])
h = suptitle([sprintf('$Sig_{trap}(t) = factor*Sig_{CFD}(t+t_{shift})+v_{shift}$, $(factor,t_{shift},v_{shift})$:\n'),...
              sprintf('x:(%.3f, %.3f ms, %.3f um/s) y:(%.3f, %.3f ms, %.3f um/s)',...
              factor_x,t_shift_x,v_shift_x,factor_y,t_shift_y,v_shift_y)]);
set(h,'FontSize',12,'FontWeight','normal')

    %% x signal 
    subplot(211);
    ax11 = plot(t_psd,v_x-v_shift_x,'x-','markersize',3,'linewidth',0.5,...
                'color','b'); hold on;
    ax12 = plot(t_vid+t_shift_x,factor_x*Uflowb,'o-','linewidth',1.5,...
                'color',color);
    xlabel('Time (ms)');          ylabel('flow speed ($\mu$m/s)');
    xlim([t_vid_start-10,t_vid_start+200]);  ylim([-200,200]);
    legend([ax11,ax12],{'x signal','x simulation'}); 

    %% y signal 
    subplot(212);
    ax21 = plot(t_psd,v_y-v_shift_y,'x-','markersize',3,'linewidth',0.5,...
                'color','b'); hold on;
    ax22 = plot(t_vid+t_shift_y,factor_y*Vflowb,'o-','linewidth',1.5,...
                'color',color);
    xlabel('Time (ms)');          ylabel('flow speed ($\mu$m/s)');
    xlim([t_vid_start-10,t_vid_start+200]);  ylim([-200,200]);
    legend([ax21,ax22],{'y signal','y simulation'});

    sprintf('t_shift from fitting: %.3f ms\nt_shift from correlation: %.3f ms',...
            t_shift_x,t_shift_initial)

    %% save the figure
    figure_path    = [store_fdpth,num2str(pt,'%02d'),'_MatchResults.png'];
    print(figure_path,'-dpng','-r300');    
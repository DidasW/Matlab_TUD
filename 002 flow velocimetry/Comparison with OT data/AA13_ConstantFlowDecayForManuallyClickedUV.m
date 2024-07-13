%% Define path
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
color_palette
% clear all
% close all
%% Parameter setting 
% experiment = '170703c7l'
AA05_experiment_based_parameter_setting
% plot_axOrLatComponent = 'lateral';
% plot_axOrLatDistance  = 'lateral';
% plot_BEM              = 0;
lateralKeywords = {'Lateral','lateral','Lat','lat','L','l'};
axialKeywords   = {'Axial','axial','Ax','ax','A','a'};
%% Load
load(compiledData_pth);

%% Sort by distance
if ~exist('plot_axOrLatDistance','var')
    [~,idx]         = sort(abs(ygb_list));
else
    switch plot_axOrLatDistance
        case axialKeywords  ;  [~,idx] = sort(abs(xgb_list));
        case lateralKeywords;  [~,idx] = sort(abs(ygb_list));
    end
end

pt_list  = pt_list(idx);    pos_info = pos_info(idx,:);
xgb_list = xgb_list(idx);   ygb_list = ygb_list(idx);

vx_raw_list  = vx_raw_list(idx);   
vy_raw_list  = vy_raw_list(idx);   
U_raw_list   = U_raw_list(idx);    
V_raw_list   = V_raw_list(idx);   
U_mean_list  = U_mean_list(idx);   
V_mean_list  = V_mean_list(idx);
avg_period_list = avg_period_list(idx);
    
d_lat_list            = abs(ygb_list);
d_ax_list             = abs(xgb_list);
d_abs_list            = sqrt(d_lat_list.^2+d_ax_list.^2);
lf                    = flag_length;
v_ax_raw_list         = vx_raw_list;
v_lat_raw_list        = vy_raw_list;

%%
gcf;
hold on

%% constant flow and oscillatory flow
NoPos = length(pt_list);
for i_pos = 1:NoPos         % position level
    v_ax_raw       = v_ax_raw_list{i_pos};
    v_lat_raw      = v_lat_raw_list{i_pos};

    avg_period     = avg_period_list(i_pos);          % [ms]
    avg_freq       = 1000/avg_period;                 % [Hz]
    norm_speed     = avg_freq*lf;                     % [micron/sec]
    norm_dist      = 1000*sqrt(0.9565/avg_freq);
    d_lat          = d_lat_list(i_pos);
    d_ax           = d_ax_list(i_pos);
    d_abs          = d_abs_list(i_pos);
    d_latScaled    = d_lat/norm_dist;
    d_axScaled     = d_ax/norm_dist;
    d_absScaled    = d_abs/norm_dist;

    v_ax_OneCycAvg = smooth(v_ax_raw,avg_period/1000*Fs);
    Avg_v_ax_Const = mean(v_ax_OneCycAvg);
    Std_v_ax_Const = std (v_ax_OneCycAvg);

    v_lat_OneCycAvg = smooth(v_lat_raw,avg_period/1000*Fs);
    Avg_v_lat_Const = mean(v_lat_OneCycAvg);
    Std_v_lat_Const = std (v_lat_OneCycAvg);

    Avg_U_Const    = U_mean_list(i_pos);
    Avg_V_Const    = V_mean_list(i_pos);

    if beadsize>3.5
        markercolor = BaoLan;
    else
        markercolor = YangHong;
    end

    if markersolid == 0
        markerface = 'None';
    else
        markerface = markercolor;
    end

    if ~exist('markertype','var')
        markertype = 'o';
    end

    
    if ~exist('plot_axOrLatDistance','var')
        d_plotScaled = d_latScaled;
    else
        switch plot_axOrLatDistance
            case axialKeywords  ; d_plotScaled = d_axScaled;
            case lateralKeywords; d_plotScaled = d_latScaled;
        end
    end
    
   
    switch plot_axOrLatComponent
        case axialKeywords
            plt_exp = plot(d_plotScaled, ...
                abs(Avg_v_ax_Const)  /norm_speed,...
                markertype,'MarkerSize',markersize,'LineWidth',...
                0.5,'Color',markercolor,'MarkerFaceColor',markerface);
            hold on
            if plot_BEM
                plt_b = plot(d_plotScaled,...
                    abs(Avg_U_Const)/norm_speed,...
                    markertype,'MarkerSize',markersize-2,...
                    'LineWidth',1,'Color',orange);
            end
        case lateralKeywords
            plt_exp = plot(d_plotScaled, ...
                abs(Avg_v_lat_Const)  /norm_speed,...
                markertype,'MarkerSize',markersize,'LineWidth',...
                0.5,'Color',markercolor,'MarkerFaceColor',markerface);
            hold on
            if plot_BEM
                plt_cfd = plot(d_lat/norm_dist,...
                      abs(Avg_V_Const)/norm_speed,...
                      markertype,'MarkerSize',markersize-2,...
                      'LineWidth',1,'Color',orange); 
            end
    end
end

%%
if exist('plt_exp','var')
    if ~isprop(plt_exp,'plot_axOrLatComponent') && ...
            ~isprop(plt_exp,'plot_axOrLatDistance') && ...
            ~isprop(plt_exp,'plot_osciOrAvg')
        addprop(plt_exp,'plot_axOrLatComponent');
        addprop(plt_exp,'plot_axOrLatDistance');
        addprop(plt_exp,'plot_osciOrAvg');
    end
    set(plt_exp,'plot_axOrLatComponent',plot_axOrLatComponent);
    set(plt_exp,'plot_axOrLatDistance' ,plot_axOrLatDistance);
    set(plt_exp,'plot_osciOrAvg'       ,'average');
    if ~isprop(plt_exp,'experiment')
        addprop(plt_exp,'experiment');
    end
    set(plt_exp,'experiment',experiment);
end
clearvars markercolor markertype markersize 

%% Group the measurement of this exp
groupPointsFromTheSameExp;
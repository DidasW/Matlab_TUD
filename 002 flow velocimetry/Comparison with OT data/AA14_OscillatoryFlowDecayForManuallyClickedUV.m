%% addpath
% run(fullfile('D:','002 MATLAB codes','000 Routine',...
%     'subunit of img treatment routines','add_path_for_all.m'))
clearvars plt_exp
%% Control panel
% experiment = '170703c7l'
% plot_axOrLatComponent = 'lateral';
% plot_axOrLatDistance  = 'lateral';
% plot_osciOrAvg        = 'osci';
% plot_BEM              = 0;
AA05_experiment_based_parameter_setting
lateralKeywords = {'Lateral','lateral','Lat','lat','L','l'};
axialKeywords   = {'Axial','axial','Ax','ax','A','a'};

%% Load
load(compiledData_pth);

%% Sort by distance
if ~exist('plot_axOrLatDistance','var')
    [~,idx]         = sort(abs(ygb_list));
else
    switch plot_axOrLatDistance
        case axialKeywords
            [~,idx]         = sort(abs(xgb_list));
        case lateralKeywords
            [~,idx]         = sort(abs(ygb_list));
    end
end

pt_list  = pt_list(idx);    pos_info = pos_info(idx,:);
xgb_list = xgb_list(idx);   ygb_list = ygb_list(idx);

vx_raw_list  = vx_raw_list(idx);   
vy_raw_list  = vy_raw_list(idx);   
U_raw_list   = U_raw_list(idx);    
V_raw_list   = V_raw_list(idx);   
avg_period_list = avg_period_list(idx);

%% initialize plotting variables
d_lat_list            = abs(ygb_list);
d_ax_list             = abs(xgb_list);
d_abs_list            = sqrt(d_lat_list.^2+d_ax_list.^2);
lf                    = flag_length;
v_ax_raw_list         = vx_raw_list;
v_lat_raw_list        = vy_raw_list;

%% plot setting
if ~exist('markerColor','var'); markerColor = 'k';      end
if ~exist('markerType' ,'var'); markerType  = 's';      end
if ~exist('markerSize' ,'var'); markerSize  = 6  ;      end
if beadsize<3; markerFaceColor = 'none';
else; markerFaceColor = markerColor; end
gcf; hold on

%% constant flow and oscillatory flow
NoPos = length(pt_list);
for i_pos = 1:NoPos         % position level
    v_ax_raw       = v_ax_raw_list{i_pos};
    v_lat_raw      = v_lat_raw_list{i_pos};
    U_raw          = U_raw_list{i_pos};
    V_raw          = U_raw_list{i_pos};
    
    %% Intrinsic delay and damping calculation
    avg_period     = avg_period_list(i_pos);          % [ms]
    avg_freq       = 1000/avg_period;                 % [Hz]
    norm_speed     = avg_freq*lf;                     % [micron/sec]
    norm_dist      = 1000*sqrt(0.9565/avg_freq);
    stiff_mean     = mean([stiff_x,stiff_y]);
    f_corner       = stiff_mean/(5.65e-5*beadsize);
    damping        = f_corner/sqrt(f_corner^2 + avg_freq^2);

    %% Scaling
    d_lat          = d_lat_list(i_pos);
    d_ax           = d_ax_list(i_pos);
    d_abs          = d_abs_list(i_pos);
    d_latScaled    = d_lat/norm_dist;
    d_axScaled     = d_ax/norm_dist;
    d_absScaled    = d_abs/norm_dist;

    %% BPF on EXP data
    switch experiment
        case '170703c7l'
            v_ax_BPF   = AutoBPF_FlagSig_v2(v_ax_raw,Fs,30,60);
            v_lat_BPF  = AutoBPF_FlagSig_v2(v_lat_raw,Fs,30,60);
        otherwise
            v_ax_BPF   = AutoBPF_FlagSig_v2(v_ax_raw,Fs);
            v_lat_BPF  = AutoBPF_FlagSig_v2(v_lat_raw,Fs);
    end

    v_ax_BPF = v_ax_BPF/damping;
    v_lat_BPF= v_lat_BPF/damping;
    
    %% Medfilt for BEM data
    U = medfilt1(U_raw,5);
    V = medfilt1(V_raw,5);
    if fps > 600
        U = smooth(U,3);
        V = smooth(V,3);
    end
    ampl_U_Osci    = osciAmplByStatisticalPeakFinding(U,'CFD',0);
    ampl_V_Osci    = osciAmplByStatisticalPeakFinding(V,'CFD',0);
%     fprintf(fileID,'%.4f\t%.4f\t',ampl_U_Osci,ampl_V_Osci);
    
    %% what to plot
    if ~exist('plot_axOrLatDistance','var')
        d_plotScaled = d_latScaled;
    else
        switch plot_axOrLatDistance
            case axialKeywords
                d_plotScaled = d_axScaled;
            case lateralKeywords
                d_plotScaled = d_latScaled;
        end
    end
    
    %% Double peak structure used to measure oscillatory amplitude
    [osciPPAmpl_ax,~] = osciAmplByStatisticalPeakFinding(...
        v_ax_BPF,'EXP',0);
    if ~isempty(osciPPAmpl_ax)
        ampl_v_ax_stat_bpf  = num2str(osciPPAmpl_ax,'%.2f');
        if ismember(plot_axOrLatComponent,axialKeywords)
            plt_exp = plot(d_plotScaled, osciPPAmpl_ax/norm_speed,...
                markerType,'MarkerSize',markersize,...
                'LineWidth',0.5,'Color',markerColor,...
                'MarkerFaceColor',markerFaceColor);
            if plot_BEM
                plt_bem = plot(d_plotScaled, ampl_U_Osci/norm_speed,...
                             markerType,'MarkerSize',markersize,...
                             'LineWidth',1,'Color',orange);
            end
        end
    else
        ampl_v_ax_stat_bpf  = '-';
    end
    
    [osciPPAmpl_lat,~] = osciAmplByStatisticalPeakFinding(...
        v_lat_BPF,'EXP',0);
    if ~isempty(osciPPAmpl_lat)
        ampl_v_lat_stat_bpf  = num2str(osciPPAmpl_lat,'%.2f');
        if ismember(plot_axOrLatComponent,lateralKeywords)
            plt_exp = plot(d_plotScaled, osciPPAmpl_lat/norm_speed,...
                markerType,'MarkerSize',markersize,...
                'LineWidth',0.5,'Color',markerColor,...
                'MarkerFaceColor',markerFaceColor);
            if plot_BEM
                plt_bem = plot(d_plotScaled, ampl_V_Osci/norm_speed,...
                            markerType,'MarkerSize',markersize,...
                            'LineWidth',1,'Color',orange);
            end
        end
    else
        ampl_v_lat_stat_bpf  = '-';
    end
    %%
    if exist('plt_exp','var')
        if ~isprop(plt_exp,'plot_axOrLatComponent')
            addprop(plt_exp,'plot_axOrLatComponent');
        end
        set(plt_exp,'plot_axOrLatComponent',plot_axOrLatComponent);

        if ~isprop(plt_exp,'plot_axOrLatDistance') 
            addprop(plt_exp,'plot_axOrLatDistance');
        end
        set(plt_exp,'plot_axOrLatComponent',plot_axOrLatComponent);

        if ~isprop(plt_exp,'plot_osciOrAvg')
            addprop(plt_exp,'plot_osciOrAvg');  
        end
        set(plt_exp,'plot_osciOrAvg' ,'oscillatory');

        if ~isprop(plt_exp,'experiment')
            addprop(plt_exp,'experiment');
        end
        set(plt_exp,'experiment',experiment);
    end
%     clearvars plt_exp
end

%% Group the measurement of this exp
groupPointsFromTheSameExp

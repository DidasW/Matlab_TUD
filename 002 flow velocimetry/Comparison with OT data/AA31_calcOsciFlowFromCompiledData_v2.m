%% Addpath
% run(fullfile('D:','002 MATLAB codes','000 Routine',...
%     'subunit of img treatment routines','add_path_for_all.m'))

%% Control panel
% experiment = '180810c3c'
% plot_axOrLatComponent = 'axial';
% plot_axOrLatDistance  = 'lateral';
% plot_osciOrAvg        = 'oscillatory'
sortByDistance        = 1;

idx_letters       = find(isletter(experiment));
experimentKeyword = experiment(idx_letters(2:end)); 
AA05_experiment_based_parameter_setting;
clearvars plt_exp
lateralKeywords = {'Lateral','lateral','Lat','lat','L','l'};
axialKeywords   = {'Axial','axial','Ax','ax','A','a'};

%% Check settings
if ~exist('plot_axOrLatDistance','var')
    switch experimentKeyword(1)
        case 'l'; plot_axOrLatDistance = 'lateral';  % Lateral
        case 'a'; plot_axOrLatDistance = 'axial';    % Axial
        case 'z'; plot_axOrLatDistance = 'z';
        otherwise % Lateral intersection as default
            error('Define plot_axOrLatDistance')
    end
end

if ~exist('plot_axOrLatComponent','var')||~exist('plot_osciOrAvg','var')
    error('Define what to plot');
end

if ~exist('sortByDistance','var'); sortByDistance = 0; end

fprintf(['exp:%s \nPlot the %s component\n',...
         'Of the %s flow \nOver %s distance\n'],...
         experiment,plot_axOrLatComponent,...
         plot_osciOrAvg,plot_axOrLatDistance)
     
%% Load data
load(compiledData_pth, 'Fs','fps','pt_list' ,...
    'xgb_list','ygb_list','pos_info',...
    'vx_raw_list'    ,  'vy_raw_list'   ,...
    'U_raw_list'     ,  'V_raw_list'    ,...
    'freqx_list'     ,  'freqy_list'    )

%% Discard
switch plot_axOrLatComponent
    case lateralKeywords; AA98_discardPt_osciFlow_V;
    case axialKeywords  ; AA98_discardPt_osciFlow_U;
    otherwise           ; error('plot_axOrLatComponent unrecognized')
end

idx_keep = ~ismember(pt_list,pt_discard);
[pt_list,xgb_list,ygb_list,...
vx_raw_list,vy_raw_list,...
U_raw_list,V_raw_list,...
freqx_list,freqy_list] = takeTheseIndices(idx_keep,...
                                          pt_list,xgb_list,ygb_list,...
                                          vx_raw_list,vy_raw_list,...
                                          U_raw_list,V_raw_list,...
                                          freqx_list,freqy_list);

%% Sort by distance
if sortByDistance == 1
    switch plot_axOrLatDistance
        case axialKeywords  ; [~,idx] = sort(abs(xgb_list));
        case lateralKeywords; [~,idx] = sort(abs(ygb_list));
    end
end
[pt_list,xgb_list,ygb_list,...
vx_raw_list,vy_raw_list,...
U_raw_list,V_raw_list,...
freqx_list,freqy_list] = takeTheseIndices(idx,...
                                          pt_list,xgb_list,ygb_list,...
                                          vx_raw_list,vy_raw_list,...
                                          U_raw_list,V_raw_list,...
                                          freqx_list,freqy_list);
lf                    = flag_length;
v_ax_raw_list         = vx_raw_list;
v_lat_raw_list        = vy_raw_list;
%% Prepare beating frequency for each position
freqx_list(freqx_list==0 | freqx_list==-1) = NaN;
freqy_list(freqy_list==0 | freqy_list==-1) = NaN;

freq_list = mean([freqx_list,freqy_list],2,'omitnan');
freq_list(isnan(freq_list))   = mean(freq_list(~isnan(freq_list)));

[period_list,avg_period_list] = deal(1000./freq_list);
        
%% Oscillatory flow
NoPos              = length(pt_list);
[ampl_v_ax_list,ampl_v_lat_list] = deal(zeros(NoPos,1));  

for i_pos = 1:NoPos         
    v_ax_raw  = v_ax_raw_list{i_pos};
    v_lat_raw = v_lat_raw_list{i_pos};
    freq      = freq_list(i_pos);
    
    [v_ax_BPF ,~,freq_ax ]= AutoBPF_FlagSig_v2(v_ax_raw ,Fs,freq-6,freq+6);
    [v_lat_BPF,~,freq_lat]= AutoBPF_FlagSig_v2(v_lat_raw,Fs,freq-6,freq+6);
    
    if numel(freq_ax)>=2 % deviation from sinusoidal shape
        ampl_v_ax_bpf     = prctile(v_ax_BPF,95) - prctile(v_ax_BPF,5);
    else
        [ampl_v_ax_bpf,~] = osciAmplByStatisticalPeakFinding(...
                             v_ax_BPF,'EXP',0);
    end
    
    if numel(freq_lat)>=2 % deviation from sinusoidal shape
        ampl_v_lat_bpf    = prctile(v_lat_BPF,95) - prctile(v_lat_BPF,5);
    else
        [ampl_v_lat_bpf,~]= osciAmplByStatisticalPeakFinding(...
                             v_lat_BPF,'EXP',0);
    end
    
    if isempty(ampl_v_ax_bpf);   ampl_v_ax_bpf =nan;  end
    if isempty(ampl_v_lat_bpf);  ampl_v_lat_bpf=nan;  end
    
    ampl_v_ax_list(i_pos) = ampl_v_ax_bpf;
    ampl_v_lat_list(i_pos)= ampl_v_lat_bpf;  
    
end

%% Signal correction
stiff_mean      = mean([stiff_x,stiff_y]);
f_corner        = stiff_mean/(5.65e-5*beadsize);
damping_list    = f_corner./sqrt(f_corner^2 + freq_list.^2);
norm_speed_list = freq_list.*flag_length;    % [micron/sec]
norm_dist_list  = 1000*sqrt(0.9565./freq_list);

ampl_v_ax_list    = ampl_v_ax_list ./damping_list;
ampl_v_lat_list   = ampl_v_lat_list./damping_list;

d_lat_list    = abs(ygb_list);
d_ax_list     = abs(xgb_list);
d_abs_list    = sqrt(d_lat_list.^2+d_ax_list.^2);

d_axScaled_list   = d_ax_list   ./norm_dist_list;
d_latScaled_list  = d_lat_list  ./norm_dist_list;

%% Plot settings
if ~exist('markerColor','var'); markerColor = 'k';      end
if ~exist('markerType' ,'var'); markerType  = 's';      end
if ~exist('markerSize' ,'var'); markerSize  = 6  ;      end
if beadsize<3;  markerFaceColor = 'none';
else;           markerFaceColor = markerColor;          end
  
%% Plot
switch plot_axOrLatDistance
    case axialKeywords  ; d_plotScaled_list = d_axScaled_list;
    case lateralKeywords; d_plotScaled_list = d_latScaled_list;
end

switch plot_axOrLatComponent
    case axialKeywords 
        v_plotScaled_list = ampl_v_ax_list./norm_speed_list;
    case lateralKeywords 
        v_plotScaled_list = ampl_v_lat_list./norm_speed_list;
end

gcf; hold on
plt_exp = plot(d_plotScaled_list, v_plotScaled_list,...
          markerType,'MarkerSize',markerSize,'LineWidth',1,...
          'Color',markerColor,'MarkerFaceColor',markerFaceColor);

%% add properties to the plotted lines/points
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
clearvars markerColor markerType markerSize
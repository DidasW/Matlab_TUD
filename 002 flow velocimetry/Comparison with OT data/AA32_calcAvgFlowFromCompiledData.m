%% Addpath
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))

%%
% experiment = '180419c17l'
% plot_axOrLatComponent = 'lateral';
% plot_axOrLatDistance  = 'lateral';
% plot_osciOrAvg        = 'average'
sortByDistance        = 1;

AA05_experiment_based_parameter_setting;
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
AA99_discardPt_avgFlow

idx_keep     = ~ismember(pt_list,pt_discard);
pos_info = pos_info(idx_keep,:);
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

%% Prepare beating frequency for each case
freqx_list(freqx_list==0 | freqx_list==-1) = NaN;
freqy_list(freqy_list==0 | freqy_list==-1) = NaN;

freq_list = mean([freqx_list,freqy_list],2,'omitnan');
freq_list(isnan(freq_list))   = mean(freq_list(~isnan(freq_list)));

[period_list,avg_period_list] = deal(1000./freq_list);
     
%% Average flow 
d_lat_list            = abs(ygb_list);
d_ax_list             = abs(xgb_list);
d_abs_list            = sqrt(d_lat_list.^2+d_ax_list.^2);

NoPos = length(d_lat_list);

norm_speed_list       = freq_list.*lf;           % [micron/sec]
norm_dist_list        = 1000*sqrt(0.9565./freq_list);
d_latScaled_list      = d_lat_list./norm_dist_list;
d_axScaled_list       = d_ax_list./norm_dist_list;
d_absScaled_list      = d_abs_list./norm_dist_list;

[avg_v_ax_list, avg_v_lat_list,...
 avg_U_list   , avg_V_list     ] = deal(zeros(NoPos,1));  

for i_pos = 1:NoPos
    v_ax_raw             = v_ax_raw_list{i_pos};
    U                    = U_raw_list{i_pos};
    avg_v_ax_list(i_pos) = mean(v_ax_raw);
    avg_U_list(i_pos)    = mean(U);
    
    v_lat_raw            = v_lat_raw_list{i_pos};
    V                    = V_raw_list{i_pos};
    avg_v_lat_list(i_pos)= mean(v_lat_raw);
    avg_V_list(i_pos)    = mean(V);
end

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
        v_plotScaled_list =  -avg_v_ax_list   ./norm_speed_list;
    case lateralKeywords
        v_plotScaled_list = abs(avg_v_lat_list)./norm_speed_list;
end

plt_exp = plot(d_plotScaled_list,v_plotScaled_list,...
          markerType,'MarkerSize',markerSize,'LineWidth',1,...
         'Color',markerColor,'MarkerFaceColor',markerFaceColor);

%% add properties to the plotted lines/points
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
set(plt_exp,'plot_osciOrAvg' ,'average');

if ~isprop(plt_exp,'experiment')
    addprop(plt_exp,'experiment');
end
set(plt_exp,'experiment',experiment);
clearvars markerColor markerType markerSize
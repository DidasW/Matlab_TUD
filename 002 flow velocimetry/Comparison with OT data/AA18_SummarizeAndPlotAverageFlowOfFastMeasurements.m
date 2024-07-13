%% Doc
% Load the multiple fast measurements prepared by AA15, load and pack the
% data, and apply the treatment as that done on c7l-c9l. 
% clear all
% close all

%% Add path of necessary functions
% run(fullfile('D:','002 MATLAB codes','000 Routine',...
%     'subunit of img treatment routines','add_path_for_all.m'))
% color_palette;

%% Experiment setting
% experiment = '171015c11l3';
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters
camera_orientation = 'after 201704';
draw_error_bar     = 0;                  % 1: draw error bar
                                         % 0: not to draw
% plot_axOrLatComponent='axial';  
% plot_axOrLatDistance ='lateral';
% plot_osciOrAvg       = 'avg'

lateralKeywords = {'Lateral','lateral','Lat','lat','L','l'};
axialKeywords   = {'Axial','axial','Ax','ax','A','a'};

%% Plot settings
if ~exist('markerColor','var'); markerColor = 'k';      end
if ~exist('markerType' ,'var'); markerType  = 's';      end
if ~exist('markerSize' ,'var'); markerSize  = 6  ;      end
if beadsize<3;  markerFaceColor = 'none';
else;           markerFaceColor = markerColor;          end
                                        
%% Preallocation
temp  = dir(fullfile(matfiles_checked_fdpth,'*.mat')) ; % defined in AA05
MatFileList = {temp.name}; % each name in this cell leads to one measurement
NoTotMeas   = length(MatFileList);
temp1           = cell (NoTotMeas,1);
temp2           = zeros(NoTotMeas,1);
v_ax_raw_list   = temp1;     
v_lat_raw_list  = temp1; 
avg_freq_list   = temp2-1; % set all to -1
lat_dist_list   = temp2;
ax_dist_list    = temp2;
distance_list   = temp2;
PosCode_list    = temp2;
MeasCode_list   = temp2;
ampl_v_ax_bpf_AccumuMeas       = temp2-1;
clear temp temp1 temp2

%% Load
for i = 1:NoTotMeas
    matfilename = MatFileList{i};
    load(fullfile(matfiles_fdpth,matfilename),...
        '-regexp',['^(?!(beadcoords_pth|rawfiles_fdpth|matfiles_fdpth|',...
        'AFpsd_fdpth|result_fdpth|i|pt_list|pt)$).']);

    PosCode_list(i)    = pos_code;
    MeasCode_list(i)   = meas_code;
    v_ax_raw_list(i)   = {v_ax_raw};
    v_lat_raw_list(i)  = {v_lat_raw};
    
    lat_dist_list(i)   = ygb;
    ax_dist_list(i)    = xgb;
    distance_list(i)   = abs(lat_dist_list(i));  %%%%%
    
    [~,~,locs_ax]     = freq_filter_for_flagellar_signal(v_ax_raw,Fs);
    locs_ax(locs_ax<40) = [];   locs_ax(locs_ax>75)   = [];
    [~,~,locs_lat]    = freq_filter_for_flagellar_signal(v_ax_raw,Fs);
    locs_lat(locs_lat<40) = []; locs_lat(locs_lat>75) = [];
    
    if ~isempty(locs_ax)
        avg_freq_list(i)    = locs_ax(1);       % [Hz]
    else
        if ~isempty(locs_lat)
            avg_freq_list(i)    = locs_lat(1);
        else
            avg_freq_list(i)    = -1;
        end
    end
end
found_freq = avg_freq_list(avg_freq_list>0);  
avg_freq_list(avg_freq_list<0) = mean(found_freq);   %[Hz]
avg_period_list                = 1000./avg_freq_list;%[ms]

%% Plot the recognized cases of flagellar frequency 
% figure(7)
% bin_edges  = linspace(45,65,11);
% histogram(found_freq,bin_edges,'FaceColor',lightpurple,'FaceAlpha',0.5,...
%           'EdgeAlpha',0);
% text(46,5,sprintf(['Total No. of measurements: %d\n',...
%                   'No. of recognized flagellar freq.: %d\n',...
%                   'Avg. +/- std: %.2f +/- %.2f Hz'],...
%                   NoTotMeas,length(found_freq),mean(found_freq),...
%                   std(found_freq)),...
%     'FontSize',8);
% xlabel('Flagellar frequency (Hz)')
% ylabel('Count')
% title('OTHERS ARE SET TO THE AVG. FREQ. RECOGNIZED',...
%       'FontSize',14,'FontWeight','bold')

%% Wrapping the list by measurement code
NoPos           = length(pt_list);
temp1           = cell (NoPos,1); % each element will be another cell
                                  % or array containing results from each
                                  % measurement
v_ax_raw_list_wrapped   = temp1;     
v_lat_raw_list_wrapped  = temp1; 
avg_period_list_wrapped = temp1; 
avg_freq_list_wrapped   = temp1; 
PosCode_list_wrapped    = pt_list;
MeasCode_list_wrapped   = temp1;
lat_dist_list_wrapped   = temp1;
ax_dist_list_wrapped    = temp1;
distance_list_wrapped   = temp1;


clear temp1 
for i = 1:NoPos         
    pos_code    = pt_list(i);
    idx_ThisPos = find(PosCode_list==pos_code);
    v_ax_raw_list_wrapped(i)  = {v_ax_raw_list(idx_ThisPos)};
    v_lat_raw_list_wrapped(i) = {v_lat_raw_list(idx_ThisPos)};
    avg_period_list_wrapped(i)= {avg_period_list(idx_ThisPos)};
    avg_freq_list_wrapped(i)  = {avg_freq_list(idx_ThisPos)};
    MeasCode_list_wrapped(i)  = {MeasCode_list(idx_ThisPos)};
    ax_dist_list_wrapped(i)   = {ax_dist_list(idx_ThisPos)};
    lat_dist_list_wrapped(i)  = {lat_dist_list(idx_ThisPos)};
    distance_list_wrapped(i)  = {distance_list(idx_ThisPos)};
    
end

%% Avg flow
for i = 1:NoPos % cell level

    gcf; hold on
    pos_code              = pt_list(i);
    distance_PosLevel     = distance_list_wrapped{i};
    lf                    = flag_length;            % defined in AA05
    v_ax_raw_PosLevel     = v_ax_raw_list_wrapped{i};
    v_lat_raw_PosLevel    = v_lat_raw_list_wrapped{i};
    avg_period_PosLevel   = avg_period_list_wrapped{i};
    MeasCode_PosLevel     = MeasCode_list_wrapped{i};
        
    NoMeas                = length(distance_PosLevel);
    Avg_avgFlow_ax_PosLevel= zeros(NoMeas,1);
    Std_avgFlow_ax_PosLevel= zeros(NoMeas,1);    
    Avg_avgFlow_lat_PosLevel= zeros(NoMeas,1);
    Std_avgFlow_lat_PosLevel= zeros(NoMeas,1);    

    for k = 1:NoMeas         % position level
        meas_code      = MeasCode_PosLevel(k);
        v_ax_raw       = v_ax_raw_PosLevel{k};
        v_lat_raw      = v_lat_raw_PosLevel{k};
        
        t_EXP          = make_time_series(v_ax_raw,Fs,'ms');
        avg_period     = avg_period_PosLevel(k);         % [ms]
        avg_freq       = 1000/avg_period;                 % [Hz]
        norm_speed     = avg_freq*lf;                     % [micron/sec]
        norm_dist      = 1000*sqrt(0.9565/avg_freq);
        d_lat          = distance_PosLevel(k);
        d_latScaled    = d_lat/norm_dist;
        EXP_code       = [num2str(pos_code,'%02d'),'-',num2str(meas_code,'%02d')];
                    
        v_ax_OneCycAvg  = smooth(v_ax_raw,avg_period/1000*Fs);
        v_lat_OneCycAvg = smooth(v_lat_raw,avg_period/1000*Fs);
        
        Avg_avgFlow_ax_ThisMeas   = mean(v_ax_OneCycAvg);
        Std_avgFlow_ax_ThisMeas   = std(v_ax_OneCycAvg);
        Avg_avgFlow_lat_ThisMeas  = mean(v_lat_OneCycAvg);
        Std_avgFlow_lat_ThisMeas  = std(v_lat_OneCycAvg);
        
        Avg_avgFlow_ax_PosLevel(k) = Avg_avgFlow_ax_ThisMeas;
        Std_avgFlow_ax_PosLevel(k) = Std_avgFlow_ax_ThisMeas;
        Avg_avgFlow_lat_PosLevel(k)= Avg_avgFlow_lat_ThisMeas;
        Std_avgFlow_lat_PosLevel(k)= Std_avgFlow_lat_ThisMeas;
        
        if k == NoMeas
            %% summarize all the measurements at this position
            Avg_avgFlow_ax_OverMeas = mean(Avg_avgFlow_ax_PosLevel);
            Std_avgFlow_ax_OverMeas = std(Avg_avgFlow_ax_PosLevel);   
            Avg_avgFlow_lat_OverMeas = mean(Avg_avgFlow_lat_PosLevel);
            Std_avgFlow_lat_OverMeas = std(Avg_avgFlow_lat_PosLevel);  
        
            switch plot_axOrLatComponent
                case axialKeywords
                    plt_exp_OverMeas = plot(d_latScaled,...
                                       -Avg_avgFlow_ax_OverMeas/...
                                       norm_speed,...
                                       markerType,'MarkerSize',markersize,...
                                       'LineWidth',0.5,...
                                       'Color',markerColor,...
                                       'MarkerFaceColor',markerFaceColor);
                    if NoMeas >= 3 && draw_error_bar == 1
                        errorbar(d_latScaled, -Avg_avgFlow_ax_OverMeas/...
                            norm_speed,...
                            Std_avgFlow_ax_OverMeas/ norm_speed,...
                            'LineWidth',1,'Color',[markerColor,0.8]);          
                    end
                case lateralKeywords
                    plt_exp_OverMeas = plot(d_latScaled, ...
                                       abs(Avg_avgFlow_lat_OverMeas)/...
                                       norm_speed,...
                                       markerType,'MarkerSize',markersize,...
                                       'LineWidth',0.5,...
                                       'Color',markerColor,...
                                       'MarkerFaceColor',markerFaceColor);
                    if NoMeas >= 3 && draw_error_bar == 1
                        errorbar(d_latScaled, -Avg_avgFlow_ax_OverMeas/...
                           norm_speed,...
                           Std_avgFlow_ax_OverMeas/ norm_speed,...
                           'LineWidth',1,'Color',[markerColor,0.8]);          
                    end
            end
            
            %%
            if ~isprop(plt_exp_OverMeas,'plot_axOrLatComponent') && ...
                    ~isprop(plt_exp_OverMeas,'plot_axOrLatDistance') && ...
                    ~isprop(plt_exp_OverMeas,'plot_osciOrAvg')
                addprop(plt_exp_OverMeas,'plot_axOrLatComponent');
                addprop(plt_exp_OverMeas,'plot_axOrLatDistance');
                addprop(plt_exp_OverMeas,'plot_osciOrAvg');
            end
            set(plt_exp_OverMeas,'plot_axOrLatComponent',plot_axOrLatComponent);
            set(plt_exp_OverMeas,'plot_axOrLatDistance' ,plot_axOrLatDistance);
            set(plt_exp_OverMeas,'plot_osciOrAvg'       ,'average');
            if ~isprop(plt_exp_OverMeas,'experiment')
                addprop(plt_exp_OverMeas,'experiment');
            end
            set(plt_exp_OverMeas,'experiment',experiment);
        end
    end
end

%% Group the measurement of this exp
groupPointsFromTheSameExp;

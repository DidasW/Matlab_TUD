%% Doc
% Load the multiple fast measurements prepared by AA15, load and pack the
% data, and apply the treatment as that done on c7l-c9l. 
% clear all
% close all

%% Add path of necessary functions
% run(fullfile('D:','002 MATLAB codes','000 Routine',...
%     'subunit of img treatment routines','add_path_for_all.m'))
color_palette;
lateralKeywords = {'Lateral','lateral','Lat','lat','L','l'};
axialKeywords   = {'Axial','axial','Ax','ax','A','a'};

%% Experiment setting
% experiment = '171015c11l3';
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters
camera_orientation = 'after 201704';
conversion_method  = 1;                  % 0: use 5th order polinomial
                                         % 1: correct 5th order polynomial
                                         %    with linear conversion
                                         % 2: use linear plane conversion
intermediate_plot  = 0;                  % 1: show intermediate plots, showing
                                         %    the recognized flag. freq.
                                         %    and the bi-peak statistics.
                                         % 0: no show.
% plot_axOrLatComponent='lateral';
% plot_axOrLatDistance  = 'lateral';
% plot_osciOrAvg        = 'oscillatory'
% HPF   = 40; LPF   = 70; order = 3 ;
% [bbp,abp] = butter(order,[HPF,LPF]/Fs*2,'bandpass');

%% Plot settings
if ~exist('markerColor','var'); markerColor = 'k';      end
if ~exist('markerType' ,'var'); markerType  = 's';      end
if ~exist('markerSize' ,'var'); markerSize  = 6  ;      end
if beadsize<3; markerFaceColor = 'none';
else; markerFaceColor = markerColor; end
gcf; hold on
 
%% Preallocation
temp  = dir(fullfile(matfiles_checked_fdpth,'*.mat')) ;  % defined in AA05
MatFileList = {temp.name}; % each name is one measurement
NoTotMeas   = length(MatFileList);
temp1       = cell (NoTotMeas,1);
temp2       = zeros(NoTotMeas,1);

[v_ax_raw_list, v_lat_raw_list] = deal(temp1);     
[lat_dist_list,ax_dist_list,...    
 distance_list,PosCode_list,...   
 MeasCode_list                 ]= deal(temp2);

[avg_freq_list,...   
 ampl_v_ax_bpf_AccumuMeas      ]= deal(temp2-1); %set default to -1
clear temp temp1 temp2

%% Load
for i = 1:NoTotMeas
    matfilename = MatFileList{i};
    load(fullfile(matfiles_checked_fdpth,matfilename),...
        '-regexp',['^(?!(beadcoords_pth|rawfiles_fdpth|matfiles_fdpth|',...
        'matfiles_checked_fdpth|AFpsd_fdpth|result_fdpth|NoTotMeas|',...
        'i|pt_list)$).']);

    PosCode_list(i)    = pos_code;
    MeasCode_list(i)   = meas_code;
    v_ax_raw_list(i)   = {v_ax_raw};
    v_lat_raw_list(i)  = {v_lat_raw};
    
    lat_dist_list(i)   = ygb;
    ax_dist_list(i)    = xgb;
    distance_list(i)   = abs(lat_dist_list(i));  %%%%%
    
    [~,~,locs_ax]     = AutoBPF_FlagSig_v2(v_ax_raw,Fs);
    locs_ax(locs_ax<40) = [];   locs_ax(locs_ax>75)   = [];
    [~,~,locs_lat]    = AutoBPF_FlagSig_v2(v_ax_raw,Fs);
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
if intermediate_plot
    figure(7)
    bin_edges  = linspace(45,65,11);
    histogram(found_freq,bin_edges,'FaceColor',lightpurple,'FaceAlpha',0.5,...
              'EdgeAlpha',0);
    text(46,5,sprintf(['Total No. of measurements: %d\n',...
                      'No. of recognized flagellar freq.: %d\n',...
                      'Avg. +/- std: %.2f +/- %.2f Hz'],...
                      NoTotMeas,length(found_freq),mean(found_freq),...
                      std(found_freq)),...
        'FontSize',8);
    xlabel('Flagellar frequency (Hz)')
    ylabel('Count')
    title('OTHERS ARE SET TO THE AVG. FREQ. RECOGNIZED',...
          'FontSize',14,'FontWeight','bold')
end

%% Wrapping the list by measurement code
NoPos           = length(pt_list);
temp1           = cell (NoPos,1); % each element will be another cell
                                  % or array containing results from each
                                  % measurement
[v_ax_raw_list_wrapped  , v_lat_raw_list_wrapped,... 
 avg_period_list_wrapped, avg_freq_list_wrapped ,... 
 ax_dist_list_wrapped   , lat_dist_list_wrapped ,...
 distance_list_wrapped  , MeasCode_list_wrapped   ] = deal(temp1);
PosCode_list_wrapped    = pt_list;

clear temp1 
for i = 1:NoPos         % Nopos defined in AA15 as length(pt_list)
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

%% Oscillatory flow

for i = 1:NoPos % cell level
    %% constant flow and oscillatory flow
    gcf; hold on
    pos_code              = pt_list(i);
    distance_PosLevel     = distance_list_wrapped{i};
    lf                    = flag_length;            % defined in AA05
    v_ax_raw_PosLevel     = v_ax_raw_list_wrapped{i};
    v_lat_raw_PosLevel    = v_lat_raw_list_wrapped{i};
    avg_period_PosLevel   = avg_period_list_wrapped{i};
    MeasCode_PosLevel     = MeasCode_list_wrapped{i};
    
    
    NoMeas                = length(distance_PosLevel);
    ampl_v_ax_bpf_PosLevel= zeros(NoMeas,1)-1;
    ampl_v_lat_bpf_PosLevel=zeros(NoMeas,1)-1;
    count_accumu_ax  = 0;
    count_accumu_lat = 0;
    NoFound2Pks_ax   = 0;
    NoFound2Pks_lat   = 0;    
    
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
        
        stiff_mean     = mean([stiff_x,stiff_y]);
        f_corner       = stiff_mean/(5.65e-5*beadsize);
        damping        = f_corner/sqrt(f_corner^2 + avg_freq^2);
        
        EXP_code       = [num2str(pos_code,'%02d'),'-',...
                          num2str(meas_code,'%02d')];
        
        v_ax_BPF       = AutoBPF_FlagSig_v2(v_ax_raw,Fs);
        v_lat_BPF      = AutoBPF_FlagSig_v2(v_lat_raw,Fs);
        v_ax_BPF       = v_ax_BPF/damping;
        v_lat_BPF      = v_lat_BPF/damping;

        %% Histogram used in finding the oscillatory amplitude     
        %% v_ax
        MinPeakHeight = 0.003;
        MinPeakProminence = 0.0005;       
       
        [~,count_v_ax_bpf] = speedStatistics(v_ax_BPF,...
                             MinPeakHeight,MinPeakProminence);
        if max(count_v_ax_bpf) < 0.03
            MinPeakHeight = 0.001;
            MinPeakProminence = 0.0001;
        end
                     
        [locs_v_ax_bpf,~,...
         ~,bin_centers ] = speedStatistics(v_ax_BPF,...
                           MinPeakHeight,MinPeakProminence);
        count_accumu_ax  = count_accumu_ax + count_v_ax_bpf ;

        % if BPF statistic found 2 peaks
        if length(locs_v_ax_bpf)>= 2
            ampl_v_ax_bpf      = locs_v_ax_bpf(end)-locs_v_ax_bpf(1);
            ampl_v_ax_bpf_str  = num2str(ampl_v_ax_bpf,'%.2f');
            NoFound2Pks_ax        = NoFound2Pks_ax + 1;
            ampl_v_ax_bpf_PosLevel(k) = ampl_v_ax_bpf;
        else
            ampl_v_ax_bpf_str  = '-';
        end
        
        % Plot when all the measurements are done
        if k == NoMeas
            %% summarize all the measurements at this position
            temp3  = ampl_v_ax_bpf_PosLevel(ampl_v_ax_bpf_PosLevel>0);
            AvgMeasAmpl_PosLevel= mean(temp3);
            StdMeasAmpl_PosLevel= std(temp3);
            clear temp3
            count_accumu_ax = count_accumu_ax/NoMeas;
 
            [~,locs_v_ax_accum] = findpeaks(smooth(count_accumu_ax,6),...
                                  bin_centers,'MinPeakHeight',MinPeakHeight,...
                                  'MinPeakProminence',MinPeakProminence); 
           
            %% find amplitude by accumulating all measurements, write the result to file
            if length(locs_v_ax_accum)>= 2
                ampl_v_ax_accum = locs_v_ax_accum(end)-locs_v_ax_accum(1);
                if ismember(plot_axOrLatComponent,axialKeywords)
                    plt_exp_AccumMeas = plot(d_latScaled,...
                                        ampl_v_ax_accum / norm_speed,...
                                        markerType,'MarkerSize',...
                                        markerSize,'LineWidth',1,...
                                        'Color',markerColor,...
                                        'MarkerFaceColor',markerFaceColor);
                end
                hold on
            else
                ampl_v_ax_accum = NaN;
            end
        end
        
        %% v_lat
        MinPeakHeight = 0.003;
        MinPeakProminence = 0.0005;       
       
        [~,count_v_lat_bpf] = speedStatistics(v_lat_BPF,...
                             MinPeakHeight,MinPeakProminence);
        if max(count_v_lat_bpf) < 0.03
            MinPeakHeight = 0.001;
            MinPeakProminence = 0.0001;
        end
                     
        [locs_v_lat_bpf,~,...
            ~,bin_centers  ]= speedStatistics(v_lat_BPF,...
                             MinPeakHeight,MinPeakProminence);
        count_accumu_lat  = count_accumu_lat + count_v_lat_bpf ;

        % if BPF statistic found 2 peaks
        if length(locs_v_lat_bpf)>= 2
            ampl_v_lat_bpf      = locs_v_lat_bpf(end)-locs_v_lat_bpf(1);
            ampl_v_lat_bpf_str  = num2str(ampl_v_lat_bpf,'%.2f');
            NoFound2Pks_lat        = NoFound2Pks_lat + 1;
            ampl_v_lat_bpf_PosLevel(k) = ampl_v_lat_bpf;
        else
            ampl_v_lat_bpf_str  = '-';
        end
        
        % save when all the measurements are done
        if k == NoMeas
            %% summarize all the measurements at this position
            temp3  = ampl_v_lat_bpf_PosLevel(ampl_v_lat_bpf_PosLevel>0);
            AvgMeasAmpl_PosLevel= mean(temp3);
            StdMeasAmpl_PosLevel= std(temp3);
            clear temp3
            count_accumu_lat = count_accumu_lat/NoMeas;
                      
            [~,locs_v_lat_accum] = findpeaks(smooth(count_accumu_lat,5),...
                                  bin_centers,'MinPeakHeight',MinPeakHeight,...
                                  'MinPeakProminence',MinPeakProminence); 
           
            %% find amplitude by accumulating all measurements, write the result to file
            if length(locs_v_lat_accum)>= 2
                ampl_v_lat_accum = locs_v_lat_accum(end)-locs_v_lat_accum(1);
                if ismember(plot_axOrLatComponent,lateralKeywords)
                    plt_exp_AccumMeas = plot(d_latScaled,...
                                        ampl_v_lat_accum / norm_speed,...
                                        markerType,'MarkerSize',...
                                        markersize,'LineWidth',1,...
                                        'Color',markerColor,...
                                        'MarkerFaceColor',markerFaceColor);
                end
                hold on
            end
        end
    end
    %% plot accumulative statistics
    if intermediate_plot
        figure(4);
        hold on
        plot(bin_centers,count_accumu_ax,'LineWidth',2)
        findpeaks(smooth(count_accumu_ax,5),bin_centers,...
                  'MinPeakHeight',MinPeakHeight,'MinPeakProminence',MinPeakProminence)
        legend({'Speed statistics of all measurements'},'Location','southeast')
        xlabel('Axial Flow speed (\mum/s)')
        ylabel('Probability (a.u.)')
        title(experiment)
    end
    
    %%
    if exist('plt_exp_AccumMeas','var')
        if  ~isprop(plt_exp_AccumMeas,'plot_axOrLatComponent') && ...
            ~isprop(plt_exp_AccumMeas,'plot_axOrLatDistance') && ...
            ~isprop(plt_exp_AccumMeas,'plot_osciOrAvg')

            addprop(plt_exp_AccumMeas,'plot_axOrLatComponent');
            addprop(plt_exp_AccumMeas,'plot_axOrLatDistance');
            addprop(plt_exp_AccumMeas,'plot_osciOrAvg');
        end
        set(plt_exp_AccumMeas,'plot_axOrLatComponent',plot_axOrLatComponent);
        set(plt_exp_AccumMeas,'plot_axOrLatDistance' ,plot_axOrLatDistance);
        set(plt_exp_AccumMeas,'plot_osciOrAvg'       ,'oscillatory');
        if ~isprop(plt_exp_AccumMeas,'experiment')
            addprop(plt_exp_AccumMeas,'experiment');
        end
        set(plt_exp_AccumMeas,'experiment',experiment);
    end        
end
clearvars plt_exp_AccumMeas

%% Group the measurement of this exp
groupPointsFromTheSameExp;

%% 
function [locs_sig,count_sig,varargout]=speedStatistics(...
                                        signal,MinPeakHeight,...
                                        MinPeakProminence)
    sigRange = max(signal) - min(signal);
    lb   = min(signal) - sigRange/2;
    ub   = max(signal) + sigRange/2;
    NoBin = 120;
    bin_edges   = linspace(lb,ub,NoBin);
    bin_centers = (bin_edges(1:end-1) + bin_edges(2:end))/2;
    [count_sig,~] = histcounts(signal,bin_edges,...
        'Normalization', 'probability');
    count_sig_smth = smooth(count_sig,6);
    [~,locs_sig] = findpeaks(count_sig_smth,bin_centers,...
        'MinPeakHeight',MinPeakHeight,...
        'MinPeakProminence',MinPeakProminence);
    varargout{1} = bin_edges;
    varargout{2} = bin_centers;
end


%% Doc measurement checker
% plot the 1-cyc-avg of both the voltage substrate recording and the
% recording of the flow.


clear all
close all

%% Add path of necessary functions
run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')
color_palette;

%% Experiment setting
experiment = '171029c16l2';
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters
camera_orientation = 'after 201704';
conversion_method  = 1;                  % 0: use 5th order polinomial
                                         % 1: correct 5th order polynomial
                                         %    with linear conversion
                                         % 2: use linear plane conversion

%% 
Pos_To_Find  = 0;
Meas_To_Find = 1;
search_str  = sprintf('Pos%02d_Meas%02d.mat',Pos_To_Find,Meas_To_Find);

%%
temp        = dir(fullfile(matfiles_fdpth,'*.mat')) ; % defined in AA05
MatFileList = {temp.name}; % each name in this cell leads to one measurement
NoTotMeas   = length(MatFileList);
avg_period_list = zeros(NoTotMeas,1)-1; % set all to -1
avg_freq_list   = zeros(NoTotMeas,1)-1; % set all to -1

clear temp
J  = -1; % target idx

if ~exist([matfiles_fdpth,uni_name,'_AllMeasurements.mat'],'file')
    
    temp  = dir(fullfile(matfiles_fdpth,'*.mat')) ;     % defined in AA05
    MatFileList = {temp.name}; % each name in this cell leads to one measurement
    NoTotMeas   = length(MatFileList);
    temp1           = cell (NoTotMeas,1);
    temp2           = zeros(NoTotMeas,1);
    v_ax_raw_list   = temp1;     
    v_lat_raw_list  = temp1; 
    nm_ax_list      = temp1;
    nm_lat_list     = temp1;
    sub_ax_list     = temp1;
    sub_lat_list    = temp1;
    avg_period_list = temp2-1; % set all to -1
    avg_freq_list   = temp2-1; % set all to -1
    lat_dist_list   = temp2;
    ax_dist_list    = temp2;
    distance_list   = temp2;
    PosCode_list    = temp2;
    MeasCode_list   = temp2;
    
    ampl_v_ax_bpf_AccumuMeas       = temp2-1;
    clear temp temp1 temp2

    for j = 1:NoTotMeas
        % mark found result
        matfilename = MatFileList{j};
        if ~isempty(strfind(matfilename,search_str))
            J = j;
        end
        % load
        load(fullfile(matfiles_fdpth,matfilename),...
            '-regexp',['^(?!(beadcoords_pth|rawfiles_fdpth|matfiles_fdpth|',...
            'AFpsd_fdpth|result_fdpth)$).']);
        PosCode_list(j)    = pos_code;
        MeasCode_list(j)   = meas_code;
        v_ax_raw_list(j)   = {v_ax_raw};
        v_lat_raw_list(j)  = {v_lat_raw};
        nm_ax_list(j)      = {nmy};
        nm_lat_list(j)     = {nmx};
        sub_ax_list(j)     = {suby_nm};
        sub_lat_list(j)    = {subx_nm};
        lat_dist_list(j)   = ygb;
        ax_dist_list(j)    = xgb;
        distance_list(j)   = abs(lat_dist_list(j));  %%%%%

        [~,~,locs_ax]     = freq_filter_for_flagellar_signal(v_ax_raw,Fs);
        locs_ax(locs_ax<40) = [];   locs_ax(locs_ax>75)   = [];
        [~,~,locs_lat]    = freq_filter_for_flagellar_signal(v_ax_raw,Fs);
        locs_lat(locs_lat<40) = []; locs_lat(locs_lat>75) = [];

        if ~isempty(locs_ax)
            avg_freq_list(j)    = locs_ax(1);       % [Hz]
        else
            if ~isempty(locs_lat)
                avg_freq_list(j)    = locs_lat(1);
            else
                avg_freq_list(j)    = -1;
            end
        end
    end
    found_freq = avg_freq_list(avg_freq_list>0);  
    avg_freq_list(avg_freq_list<0) = mean(found_freq);   %[Hz]
    avg_period_list                = 1000./avg_freq_list;%[ms]
       
    save([matfiles_fdpth,uni_name,'_AllMeasurements.mat'],...
        'MatFileList','PosCode_list','MeasCode_list',...
        'nm_ax_list','nm_lat_list','sub_ax_list','sub_lat_list',...
        'v_ax_raw_list','v_lat_raw_list','ax_dist_list' ,'lat_dist_list',...
        'distance_list','avg_period_list','avg_freq_list')
else
    load([matfiles_fdpth,uni_name,'_AllMeasurements.mat'],...
    'MatFileList','PosCode_list','MeasCode_list',...
    'nm_ax_list','nm_lat_list','sub_ax_list','sub_lat_list',...
    'v_ax_raw_list','v_lat_raw_list','ax_dist_list' ,'lat_dist_list',...
    'distance_list','avg_period_list','avg_freq_list')
    temp = strfind(MatFileList,search_str);
    J = find(~cellfun('isempty', temp));
end

%% Load target data
avg_period       = avg_period_list(J);
v_ax_raw         = v_ax_raw_list{J};
v_lat_raw        = v_lat_raw_list{J};
nm_ax            = nm_ax_list{J};
nm_lat           = nm_lat_list{J};
sub_ax           = sub_ax_list{J};
sub_lat          = sub_lat_list{J};
v_ax_OneCycAvg   = smooth(v_ax_raw,avg_period/1000*Fs);
v_lat_OneCycAvg  = smooth(v_lat_raw,avg_period/1000*Fs);
nm_ax_OneCycAvg  = smooth(nm_ax,   avg_period/1000*Fs);
nm_lat_OneCycAvg = smooth(nm_lat,  avg_period/1000*Fs);
sub_ax_OneCycAvg = smooth(sub_ax,  avg_period/1000*50000);
sub_lat_OneCycAvg= smooth(sub_lat, avg_period/1000*50000);
t_EXP            = make_time_series(nm_ax,Fs,'ms');    
t_CALIB          = make_time_series(sub_ax,50000,'ms');

idx_SamePos = find(PosCode_list == Pos_To_Find);
Avg_OtherMeas_ax = [];
Std_OtherMeas_ax = [];
figure(3); hold on
for k = 1:length(idx_SamePos)
    K = idx_SamePos(k);
%     v_ax_OneCycAvg_temp   = smooth(v_ax_raw_list{K},10*avg_period_list(K)/1000*Fs);
v_ax_OneCycAvg_temp   = smooth(v_ax_raw_list{K},0.2*avg_period_list(K)/1000*Fs);
    t_exp_temp            = make_time_series(v_ax_OneCycAvg_temp,Fs,'ms');
    plot(t_exp_temp, v_ax_OneCycAvg_temp,'-','LineWidth',2);
    if K ~= J
        Avg_OtherMeas_ax          = [Avg_OtherMeas_ax , mean(v_ax_OneCycAvg_temp)];
        Std_OtherMeas_ax          = [Std_OtherMeas_ax , std(v_ax_OneCycAvg_temp)];
    end
end
legend_cell = MatFileList(idx_SamePos);
for i = 1:length(legend_cell)
    temp = legend_cell{i};
    temp_element = strsplit(temp,'_');
    legend_cell(i) = temp_element(end);
end
legend(legend_cell)
clear v_ax_OneCycAvg_temp

%% Plot
% fig 1. subx_nm,suby_nm the voltage recordings converted into nm during
% calibration.
% fig 2. nmx, nmy, the position of the bead during the measurements
if beadsize >4
    yplotrange = [-150,150];
    ytext      = -70;
else
    yplotrange = [-40,40];
    ytext      = -30;
end
Experiment_name       = [uni_name,' - ',search_str(1:end-4)];
distance              = distance_list(J);

%%
figure(1)
plot(t_EXP,-nm_ax_OneCycAvg, '-','LineWidth',2); hold on
plot(t_EXP,-nm_lat_OneCycAvg,'-','LineWidth',2);%
title(['EXP - ',Experiment_name,sprintf(' - LatDist %.2f um',distance)])
xlabel('Time (ms)');
ylim(yplotrange)
ylabel('Position(nm)');
legend({'1-cyc-avg,axial, cell beating',...
        '1-cyc-avg,lateral, cell beating'})
text(50,ytext,sprintf(['avg. this meas.: %.2f/%.2f um/s (%.2f/%.2f nm)\n',...
                    'std. this meas.: %.2f/%.2f um/s (%.2f/%.2f nm)\n',...
                    'Mean avg. of other meas: %.2f (ax) um/s\n',...
                    'Mean std. of other meas: %.2f (ax) um/s\n'],...
                    mean(v_ax_OneCycAvg) ,mean(v_lat_OneCycAvg),...
                    mean(nm_ax_OneCycAvg),mean(nm_lat_OneCycAvg),...
                    std(v_ax_OneCycAvg)  ,std(v_lat_OneCycAvg),...
                    std(nm_ax_OneCycAvg) ,std(nm_lat_OneCycAvg),...
                    mean(Avg_OtherMeas_ax),std(Std_OtherMeas_ax)),...
     'FontSize',10)

%%
figure(2)
plot(t_CALIB,-sub_ax_OneCycAvg, '-','LineWidth',2); hold on
plot(t_CALIB,-sub_lat_OneCycAvg,'-','LineWidth',2);%
title(['CALIB - ',Experiment_name,sprintf(' - LatDist %.2f um',distance)])
xlabel('Time (ms)');
ylim(yplotrange)
ylabel('Position(nm)');
legend({'1-cyc-avg,axial, calib',...
        '1-cyc-avg,lateral, calib'})
text(50,ytext,sprintf(['avg. this calib.: %.2f/%.2f nm\n',...
                    'std. this calib.: %.2f/%.2f nm\n'],...
                    mean(sub_ax),mean(sub_lat),...
                    std(sub_ax) ,std(sub_lat)),...
     'FontSize',10)

%% 
figure(3)
xlabel('Time (ms)');
ylim([-400,400])
ylabel('Axial flow speed (micron/s)');
title('10-cyc-avg of all the meas at the same position',...
    'FontSize',10,'FontWeight','bold')
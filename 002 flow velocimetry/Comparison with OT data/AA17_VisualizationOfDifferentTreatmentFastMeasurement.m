%% Load C7-C9 data
savefig_fdpth = 'D:\000 RAW DATA FILES\171020 oscillatory flow c11-c12\figure intermediate\';
%% Preallocation and Experiment setting
experiment = '171015c12l';
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters
camera_orientation = 'after 201704';
conversion_method  = 1;                  % 0: use 5th order polinomial
                                         % 1: correct 5th order polynomial
                                         %    with linear conversion
                                         % 2: use linear plane conversion

%% Preallocation
temp  = dir(fullfile(matfiles_fdpth,'*.mat')) ;     % defined in AA05
MatFileList = {temp.name}; % each name in this cell leads to one measurement
NoTotMeas   = length(MatFileList);
temp1           = cell (NoTotMeas,1);
temp2           = zeros(NoTotMeas,1);
v_ax_raw_list   = temp1;     
v_lat_raw_list  = temp1; 
avg_period_list = temp2-1; % set all to -1
avg_freq_list   = temp2-1; % set all to -1
lat_dist_list   = temp2;
ax_dist_list    = temp2;
distance_list   = temp2;
PosCode_list    = temp2;
MeasCode_list   = temp2;
clear temp temp1 temp2


%% Load
for j = 1:NoTotMeas
    matfilename = MatFileList{j};
    load(fullfile(matfiles_fdpth,matfilename),...
        '-regexp',['^(?!(beadcoords_pth|rawfiles_fdpth|matfiles_fdpth|',...
        'AFpsd_fdpth|result_fdpth)$).']);

    PosCode_list(j)    = pos_code;
    MeasCode_list(j)   = meas_code;
    v_ax_raw_list(j)   = {v_ax_raw};
    v_lat_raw_list(j)  = {v_lat_raw};
    
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
Experiment_names        = temp1;
clear temp1 

for j = 1:NoPos         % Nopos defined in AA15 as length(pt_list)
    pos_code    = pt_list(j);
    idx_ThisPos = find(PosCode_list==pos_code);
    v_ax_raw_list_wrapped(j)  = {v_ax_raw_list(idx_ThisPos)};
    v_lat_raw_list_wrapped(j) = {v_lat_raw_list(idx_ThisPos)};
    avg_period_list_wrapped(j)= {avg_period_list(idx_ThisPos)};
    avg_freq_list_wrapped(j)  = {avg_freq_list(idx_ThisPos)};
    MeasCode_list_wrapped(j)  = {MeasCode_list(idx_ThisPos)};
    ax_dist_list_wrapped(j)   = {ax_dist_list(idx_ThisPos)};
    lat_dist_list_wrapped(j)  = {lat_dist_list(idx_ThisPos)};
    distance_list_wrapped(j)  = {distance_list(idx_ThisPos)};
    Experiment_names{j}       = [uni_name,'-Pos',num2str(pos_code)];
end

%%
J = 7

HPF   = 30; 
LPF   = 70;
order = 3 ;
[bbp,abp] = butter(order,[HPF,LPF]/Fs*2,'bandpass');
%%
%% Oscillatory flow
for j = J % cell level
    %% constant flow and oscillatory flow
    pos_code              = pt_list(j);
    distance_PosLevel     = distance_list_wrapped{j};
    lf                    = flag_length;            % defined in AA05
    v_ax_raw_PosLevel     = v_ax_raw_list_wrapped{j};
    avg_period_PosLevel   = avg_period_list_wrapped{j};
    MeasCode_PosLevel     = MeasCode_list_wrapped{j};
    
    NoMeas = length(distance_PosLevel);
    for k = 1:NoMeas         % position level
        meas_code      = MeasCode_PosLevel(k);
        v_ax_raw       = v_ax_raw_PosLevel{k};
        t_EXP          = make_time_series(v_ax_raw,Fs,'ms');
        avg_period     = avg_period_PosLevel(k);         % [ms]
        avg_freq       = 1000/avg_period;                 % [Hz]
        norm_speed     = avg_freq*lf;                     % [micron/sec]
        norm_dist      = 1000*sqrt(0.9565/avg_freq);
        distance       = distance_PosLevel(k);
        dist_scaled    = distance/(sqrt(0.9565/avg_freq)*1000);
        v_ax_OneCycAvg = smooth(v_ax_raw,avg_period/1000*Fs);
        v_ax_Osci      = v_ax_raw - v_ax_OneCycAvg;
        
        v_ax_BPF           = filtfilt(bbp,abp,v_ax_raw);
        v_ax_smth_temp     = smooth(v_ax_Osci,0.2*avg_period/1000*Fs);
        [pks_pk,locs_pk]   = findpeaks(v_ax_smth_temp,t_EXP,...
                                'MinPeakDistance',round(0.6*avg_period),...
                                'MinPeakProminence',5);
        [pks_val,locs_val] = findpeaks(-v_ax_smth_temp ,t_EXP,...
                                'MinPeakDistance',round(0.6*avg_period),...
                                'MinPeakProminence',5);

% %%
%         figure();
%         set(gcf,'Units','normalized','Position',[0.1,0.1,0.8,0.8])
%         hold on ;
%         plot(t_EXP,v_ax_Osci,'.','MarkerSize',5,'Color',[0.7,0.7,0.7]);
%         plot(t_EXP,v_ax_smth_temp,'-','LineWidth',2);
%         plot(locs_pk,pks_pk+1,'bv','MarkerSize',8,'LineWidth',2);
%         plot(locs_val,-pks_val-1,'k^','MarkerSize',8,'LineWidth',2)
%         xlabel('Time (ms)');
%         ylabel('Axial speed (micron/s)')
%         xlim([0,500])
%         ylim([-60,60])
%         legend({'Subtract 1-cyc-smth','Further smooth(0.2cyc)'},...
%                'Location','southwest')
%         title([Experiment_names{j},...
%               sprintf(' - Lateral Distance %.2f micron',distance)])
%         text(2,50,sprintf(['No. local maxima: %d, avg: %.2f micron/s\n',...
%                            'No. local manima: %d  avg: %.2f micron/s'],...
%                            length(locs_pk),  mean(pks_pk),...
%                            length(locs_val),-mean(pks_val)),...
%              'FontSize',10);
%         print(1,[savefig_fdpth,'FindLocalAmpl_' ,Experiment_names{j},'_Pos',...
%                  num2str(k,'%02d'),'.png'],'-dpng','-r300');

%%
%         figure(2)
%         set(gcf,'Units','normalized','Position',[0.1,0.1,0.6,0.8])
%         suptitle([Experiment_names{j},sprintf('-%.2f micron',distance)])
%         ImgVec1 = [0.12, 0.55, 0.35, 0.35];   
%         ImgVec2 = [0.57, 0.55, 0.35, 0.35];   
%         ImgVec3 = [0.11, 0.1, 0.82, 0.35];   
%         
%         subplot('Position',ImgVec1);
%         plot(t_EXP,v_ax_raw,'.','MarkerSize',3,'Color',[0.7 0.7 0.7])
%         hold on
%         plot(t_EXP,v_ax_OneCycAvg,'r-','LineWidth',3)
%         xlabel('Time (ms)');
%         ylabel('Axial speed (micron/s)')
%         legend({'raw data','1-cyc-smooth'})
%         set(gca,'FontSize',10)
%         
%         subplot('Position',ImgVec2)
%         plot(t_EXP,v_ax_raw,'.','MarkerSize',3,'Color',[0.7 0.7 0.7]),hold on;
%         plot(t_EXP,v_ax_Osci,'-','LineWidth',2)
%         plot(t_EXP,v_ax_BPF,'-','LineWidth',2)
%         legend({'raw data','subtract 1-cyc-smooth','BPF'},...
%                 'FontSize',8)
%         xlabel('Time (ms)');
%         ylabel('Axial speed (micron/s)')
%         set(gca,'FontSize',10)
%         
%         subplot('Position',ImgVec3)
%         plot(t_EXP,v_ax_Osci,'-','LineWidth',2), hold on
%         plot(t_EXP,v_ax_smth_temp,'-','LineWidth',2)
%         plot(t_EXP,v_ax_BPF,'-','LineWidth',2)
%         legend({'raw - 1-cyc-smooth','raw - 1-cyc-smooth,smoothed 0.2cyc','BPF'},...
%                'FontSize',8)
%         xlabel('Time (ms)');
%         ylabel('Axial speed (micron/s)')
%         xlim([0,400])
%         set(gca,'FontSize',10,'FontWeight','bold')
%         print(2,[savefig_fdpth,'TimeSeries_' ,Experiment_names{j},'_Pos',...
%                  num2str(k,'%02d'),'.png'],'-dpng','-r300');
%         
%%     Use statistical feature to identify oscillatory flow

        figure();
        hold on
        bin_edges = linspace(-110,110,221);
        bin_centers = (bin_edges(1:end-1) + bin_edges(2:end))/2;
        histogram(v_ax_Osci,bin_edges,'FaceAlpha',0.3,'EdgeAlpha',0.1,...
                  'Normalization', 'probability');
        histogram(v_ax_BPF,bin_edges,'FaceAlpha',0.3,'EdgeAlpha',0.1,...
                  'Normalization', 'probability');
        [count_v_ax_BPF,~] = histcounts(v_ax_BPF,bin_edges,...
                                        'Normalization', 'probability');
        findpeaks(smooth(count_v_ax_BPF,5),bin_centers,...
                  'MinPeakHeight',0.01,'MinPeakProminence',0.001)
        legend({'Subtract 1-cyc-avg','BPF'},'Location','southeast')

%         histogram(v_ax_smth_temp,bin_edges,'FaceAlpha',0.3,'EdgeAlpha',0.1,...
%                   'Normalization', 'probability');
%         [count_v_ax_smth,~] = histcounts(v_ax_smth_temp,bin_edges,...
%                              'Normalization', 'probability');
%         findpeaks(smooth(count_v_ax_smth,3),bin_centers,...
%                   'MinPeakHeight',0.01,'MinPeakProminence',0.002) 
%         legend({'Subtract 1-cyc-avg','further smth 0.2cyc'},'Location','southeast')
        
        xlabel('Axial Flow speed (\mum/s)')
        ylabel('Probability (a.u.)')
        title([Experiment_names{j},...
              sprintf(' - Lateral Distance %.2f micron',distance)])
       
%         print(3,[savefig_fdpth,'vstat_' ,Experiment_names{j},'_Pos',...
%                  num2str(k,'%02d'),'.png'],'-dpng','-r300');
%         plot(pks_pk,ones(length(pks_pk),1)*800   , 'bv', 'MarkerSize', 6);
%         plot(-pks_val,ones(length(pks_val),1)*800, 'kv', 'MarkerSize', 6)


% %%
%         figure()
%         [f_raw,pow_raw] = fft_mag(v_ax_raw,Fs);
%         loglog(f_raw,smooth(pow_raw,10))
%         hold on 
%         [f,pow] = fft_mag(v_ax_Osci,Fs);
%         loglog(f,smooth(pow,10))
%         [f_bpf,pow_bpf] = fft_mag(v_ax_BPF,Fs);
%         loglog(f_bpf,smooth(pow_bpf,10))
%         [f_smth,pow_smth] = fft_mag(v_ax_smth_temp,Fs);
%         loglog(f_smth,smooth(pow_smth,10))
%         xlabel('Frequency (Hz)');
%         ylabel('Magnitude')
%         legend({'raw data','subtract 1-cyc-smooth','BPF','Smooth(0.2cyc)'},...
%                'Location','southwest')
%         title([Experiment_names{j},...
%               sprintf(' - Lateral Distance %.2f micron',distance)])
%         print(4,[savefig_fdpth,'fspec_' ,Experiment_names{j},'_Pos',...
%                  num2str(k,'%02d'),'.png'],'-dpng','-r300');
%         clear v_ax_smth_temp
%         close all
    end
    pause
end


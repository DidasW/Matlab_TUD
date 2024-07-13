%% Load C7-C9 data
% savefig_fdpth = 'D:\000 RAW DATA FILES\171017 oscillatory flow\c7-9,BPF+statistic\';

%% Preallocation
% clear all
% close all
NoCell = 3;
temp   = cell (NoCell,1);
Experiment_names= {'c7l','c8l','c9l'};
pos_info_cell   = temp;
distance_cell   = temp;
vx_raw_cell     = temp;     vy_raw_cell     = temp; 
vx_cell         = temp;     vy_cell         = temp; 
t_shift_cell_x  = temp;     t_shift_cell_y  = temp;
vx_shift_cell   = temp;     vy_shift_cell   = temp;
vx_ampl_cell    = temp;     vy_ampl_cell    = temp;
U_ampl_cell     = temp;     V_ampl_cell     = temp;
vx_mean_cell    = temp;     vy_mean_cell    = temp;
U_mean_cell     = temp;     V_mean_cell     = temp;    
avg_period_cell = temp;
matfilepath_cell= temp;
flag_length     = [12.64,10.20,11.27]; 

matfilepath_cell(1) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c7l\170703c7l_FitSegAvg.mat'};
matfilepath_cell(2) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c8l\170703c8l_FitSegAvg.mat'};
matfilepath_cell(3) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c9l\170703c9l_FitSegAvg.mat'};


%% Load
for j = 1:NoCell
    matfilepath = char(matfilepath_cell(j));
    load(matfilepath);
    distance_CellLevel = abs(pos_info(:,3));
    [~,idx] = sort(distance_CellLevel);
    distance_cell(j)   = {distance_CellLevel(idx)};
    t_shift_cell_x(j)  = {t_shift_list_x(idx)};
    t_shift_cell_y(j)  = {t_shift_list_y(idx)};
    vx_shift_cell(j)   = {vx_shift_list(idx)};
    vy_shift_cell(j)   = {vy_shift_list(idx)};
    vx_ampl_cell(j)    = {vx_ampl_list(idx)};
    vy_ampl_cell(j)    = {vy_ampl_list(idx)};
    U_ampl_cell(j)     = {U_ampl_list(idx)};
    V_ampl_cell(j)     = {V_ampl_list(idx)};
    vx_mean_cell(j)    = {vx_mean_list(idx)};
    vy_mean_cell(j)    = {vy_mean_list(idx)};
    U_mean_cell(j)     = {U_mean_list(idx)};
    V_mean_cell(j)     = {V_mean_list(idx)};
    avg_period_cell(j) = {avg_period_list(idx)};
    vx_raw_cell(j)     = {vx_raw_list(idx)};
    vy_raw_cell(j)     = {vy_raw_list(idx)};
    vx_cell(j)         = {vx_list(idx)};
    vy_cell(j)         = {vy_list(idx)};
end


Fs = 10000;

% cell 
J = 3
%position
K = 5
% temp = distance_cell{J};
% temp(K)
% clear temp

%% Oscillatory flow
% figure(11);
for j = [J] % cell level
    %% constant flow and oscillatory flow
    distance_CellLevel  = distance_cell{j};
    lf                  = flag_length(j);
    v_ax_raw_CellLevel  = vx_raw_cell{j};
    avg_period_CellLevel= avg_period_cell{j};
    NoPos = length(distance_CellLevel);
    for k = [K]
%     for k = 1:NoPos         % position level
        v_ax_raw       = v_ax_raw_CellLevel{k};
        t_EXP          = make_time_series(v_ax_raw,Fs,'ms');
        avg_period     = avg_period_CellLevel(k);         % [ms]
        avg_freq       = 1000/avg_period;                 % [Hz]
        norm_speed     = avg_freq*lf;                     % [micron/sec]
        norm_dist      = 1000*sqrt(0.9565/avg_freq);
        distance       = distance_CellLevel(k);
        
        v_ax_OneCycAvg = smooth(v_ax_raw,avg_period/1000*Fs);
        v_ax_Osci      = v_ax_raw - v_ax_OneCycAvg;
        
        if j == 1
            [v_ax_BPF,~,~]     = AutoBPF_FlagSig_v2(v_ax_raw,Fs,30,60);
        else
            [v_ax_BPF,~,~]     = AutoBPF_FlagSig_v2(v_ax_raw,Fs);
        end
        v_ax_smth_temp     = smooth(v_ax_Osci,0.2*avg_period/1000*Fs);
        [pks_pk,locs_pk]   = findpeaks(v_ax_smth_temp,t_EXP,...
                                'MinPeakDistance',round(0.6*avg_period),...
                                'MinPeakProminence',5);
        [pks_val,locs_val] = findpeaks(-v_ax_smth_temp ,t_EXP,...
                                'MinPeakDistance',round(0.6*avg_period),...
                                'MinPeakProminence',5);

%% Showing the FIND-PEAK results.
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

%% Overlaying different smoothed result in one figure
        figure(2)
        set(gcf,'Units','normalized','Position',[0.1,0.1,0.6,0.8])
        suptitle([Experiment_names{j},sprintf('-%.2f micron',distance)])
        ImgVec1 = [0.12, 0.55, 0.35, 0.35];   
        ImgVec2 = [0.57, 0.55, 0.35, 0.35];   
        ImgVec3 = [0.11, 0.1, 0.82, 0.35];   
        
        subplot('Position',ImgVec1);
        plot(t_EXP,v_ax_raw,'.','MarkerSize',3,'Color',[0.7 0.7 0.7])
        hold on
        plot(t_EXP,v_ax_OneCycAvg,'r-','LineWidth',3)
        xlabel('Time (ms)');
        ylabel('Axial speed (micron/s)')
        legend({'raw data','1-cyc-smooth'})
        set(gca,'FontSize',10)
        
        subplot('Position',ImgVec2)
        plot(t_EXP,v_ax_raw,'.','MarkerSize',3,'Color',[0.7 0.7 0.7]),hold on;
        plot(t_EXP,v_ax_Osci,'-','LineWidth',2)
        plot(t_EXP,v_ax_BPF,'-','LineWidth',2)
        legend({'raw data','subtract 1-cyc-smooth','BPF'},...
                'FontSize',8)
        xlabel('Time (ms)');
        ylabel('Axial speed (micron/s)')
        set(gca,'FontSize',10)
        
        subplot('Position',ImgVec3)
        plot(t_EXP,v_ax_Osci,'-','LineWidth',2), hold on
        plot(t_EXP,v_ax_smth_temp,'-','LineWidth',2)
        plot(t_EXP,v_ax_BPF,'-','LineWidth',2)
        legend({'raw - 1-cyc-smooth','raw - 1-cyc-smooth,smoothed 0.2cyc','BPF'},...
               'FontSize',8)
        xlabel('Time (ms)');
        ylabel('Axial speed (micron/s)')
        xlim([0,400])
        set(gca,'FontSize',10,'FontWeight','bold')
%         print(2,[savefig_fdpth,'TimeSeries_' ,Experiment_names{j},'_Pos',...
%                  num2str(k,'%02d'),'.png'],'-dpng','-r300');
%         
%%     Use statistical feature to identify oscillatory flow
% 
        figure(5);
        hold on
        bin_edges = linspace(-60,60,121);
        bin_centers = (bin_edges(1:end-1) + bin_edges(2:end))/2;
        histogram(v_ax_Osci,bin_edges,'FaceAlpha',0.3,'EdgeAlpha',0.1,...
                  'Normalization', 'probability');
        %% use AUTO BPF.
        histogram(v_ax_BPF,bin_edges,'FaceAlpha',0.3,'EdgeAlpha',0.1,...
                  'Normalization', 'probability');
        [count_v_ax_BPF,~] = histcounts(v_ax_BPF,bin_edges,...
                                        'Normalization', 'probability');
        findpeaks(smooth(count_v_ax_BPF,3),bin_centers,...
                  'MinPeakHeight',0.005,'MinPeakProminence',0.001)
        legend({'Subtract 1-cyc-avg','BPF'},'Location','southeast')
        %% use smooth over 0.2 cyc.
%         histogram(v_ax_smth_temp,bin_edges,'FaceAlpha',0.3,'EdgeAlpha',0.1,...
%                   'Normalization', 'probability');
%         [count_v_ax_smth,~] = histcounts(v_ax_smth_temp,bin_edges,...
%                              'Normalization', 'probability');
%         findpeaks(smooth(count_v_ax_smth,3),bin_centers,...
%                   'MinPeakHeight',0.005,'MinPeakProminence',0.001)
%         legend({'Subtract 1-cyc-avg','further smth 0.2cyc'},'Location','southeast')
%         
        xlabel('Axial Flow speed (\mum/s)')
        ylabel('Probability (a.u.)')
        title([Experiment_names{j},...
              sprintf(' - Lateral Distance %.2f micron',distance)])
       
%         print(3,[savefig_fdpth,'vstat_' ,Experiment_names{j},'_Pos',...
%                  num2str(k,'%02d'),'.png'],'-dpng','-r300');
%         plot(pks_pk,ones(length(pks_pk),1)*800   , 'bv', 'MarkerSize', 6);
%         plot(-pks_val,ones(length(pks_val),1)*800, 'kv', 'MarkerSize', 6)


%%
        fig_spec = figure(4);
        [f_raw,pow_raw] = fft_mag(v_ax_raw,Fs);
        loglog(f_raw,smooth(pow_raw,100),'LineWidth',4,'Color',[0.4,0.4,0.4,0.4])
        hold on 
%         [f,pow] = fft_mag(v_ax_Osci,Fs);
%         loglog(f,smooth(pow,100))
        [f_bpf,pow_bpf] = fft_mag(v_ax_BPF,Fs);
        loglog(f_bpf,smooth(pow_bpf,100),'LineWidth',2.5,'Color',[BaoLan,0.8])
%         [f_smth,pow_smth] = fft_mag(v_ax_smth_temp,Fs);
%         loglog(f_smth,smooth(pow_smth,100))
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (-)')
%         legend({'raw data','subtract 1-cyc-smooth','BPF','Smooth(0.2cyc)'},...
%                'Location','southwest')
        legend({'Raw signal','BPF applied'},...
               'Location','Northwest')
        xlim([10,800])
        ylim([1e-2,10])
        title([Experiment_names{j},...
              sprintf(' - Lateral Distance %.2f micron',distance)])
%         print(4,[savefig_fdpth,'fspec_' ,Experiment_names{j},'_Pos',...
%                  num2str(k,'%02d'),'.png'],'-dpng','-r300');
%         clear v_ax_smth_temp
%         close all
    end
end


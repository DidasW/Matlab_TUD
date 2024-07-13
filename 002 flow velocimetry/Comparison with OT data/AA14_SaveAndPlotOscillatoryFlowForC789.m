%% Define path
run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')
savetofdpth = 'D:\000 RAW DATA FILES\171214 oscillatory flow, all\';
%% Preallocation
% clear all
% close all
NoCell = 3;
Fs = 10000;
temp   = cell (NoCell,1);
Experiment_names= {'c7l','c8l','c9l'};
Marker_types    = {'+','x','*'};
pos_info_cell   = temp;
distance_cell   = temp;
vx_raw_cell     = temp;     vy_raw_cell     = temp; 
U_ampl_cell     = temp;     V_ampl_cell     = temp;   
avg_period_cell = temp;
matfilepath_cell= temp;
matfilepath_cell(1) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c7l\170703c7l_FitSegAvg.mat'};
matfilepath_cell(2) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c8l\170703c8l_FitSegAvg.mat'};
matfilepath_cell(3) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c9l\170703c9l_FitSegAvg.mat'};
flag_length     = [12.64,10.20,11.27]; 
color_palette;



%% Load
for j = 1:NoCell
    matfilepath = char(matfilepath_cell(j));
    load(matfilepath);
    distance_CellLevel = abs(pos_info(:,3));
    [~,idx] = sort(distance_CellLevel);
    distance_cell(j)   = {distance_CellLevel(idx)};
    U_ampl_cell(j)     = {U_ampl_list(idx)};
    V_ampl_cell(j)     = {V_ampl_list(idx)};
    avg_period_cell(j) = {avg_period_list(idx)};
    vx_raw_cell(j)     = {vx_raw_list(idx)};
    vy_raw_cell(j)     = {vy_raw_list(idx)};
end



%% Oscillatory flow
for j = 1:NoCell % cell level
    
    gcf;
    hold on

    %% constant flow and oscillatory flow
    distance_CellLevel    = distance_cell{j};
    lf                    = flag_length(j);
    v_ax_raw_CellLevel    = vx_raw_cell{j};
    avg_period_CellLevel  = avg_period_cell{j};
    ampl_U_Osci_CellLevel = U_ampl_cell{j};
    markertype            = Marker_types{j};
    fileID                = fopen([savetofdpth,Experiment_names{j},...
                                   '_OsciFlow.dat'],'wt');
    fprintf(fileID,['ExpCode\tLatDist\tScaledDist\tFlagLength\tAvgCyc\tAvgFreq\t',...
                'AmplVaxMin1Cyc\tAmplVaxBPF\tAmplU\t',...
                'AmplVaxBPFStat\n']);
    NoPos = length(distance_CellLevel);
    for k = 1:NoPos         % position level
        v_ax_raw       = v_ax_raw_CellLevel{k};
        t_EXP          = make_time_series(v_ax_raw,Fs,'ms');
        avg_period     = avg_period_CellLevel(k);         % [ms]
        avg_freq       = 1000/avg_period;                 % [Hz]
        norm_speed     = avg_freq*lf;                     % [micron/sec]
        norm_dist      = 1000*sqrt(0.9565/avg_freq);
%         norm_dist      = 2*a;
        d_lat          = distance_CellLevel(k);
        d_latScaled    = d_lat./norm_dist;
        
        beadsize       = 5.40;
        stiff_mean     = 0.022;
        f_corner       = stiff_mean/(5.65e-5*beadsize);
        damping        = f_corner/sqrt(f_corner^2 + avg_freq^2);

        fprintf(fileID,'%02d\t%.2f\t%.2f\t%.2f\t%.4f\t%.4f\t',...
                        k, d_lat,d_latScaled , lf,  avg_period, avg_freq);
                    
        
        v_ax_OneCycAvg = smooth(v_ax_raw,avg_period/1000*Fs);
        v_ax_MinOneCyc = v_ax_raw - v_ax_OneCycAvg; % raw minus one cycle avg
        
        if j == 1
            v_ax_BPF   = AutoBPF_FlagSig_v2(v_ax_raw,Fs,30,60);
        else
            v_ax_BPF   = AutoBPF_FlagSig_v2(v_ax_raw,Fs);
        end
        v_ax_BPF = v_ax_BPF/damping;
        ampl_v_ax      = prctile(v_ax_MinOneCyc,95)-prctile(v_ax_MinOneCyc,5);
        ampl_v_ax_BPF  = prctile(v_ax_BPF,      95)-prctile(v_ax_BPF,      5);
        
        ampl_U_Osci    = ampl_U_Osci_CellLevel(k);
        fprintf(fileID,'%.4f\t%.4f\t%.4f\t',ampl_v_ax,ampl_v_ax_BPF,ampl_U_Osci);

       
%% BPF treatment of the data
 
%% Histogram used in finding the oscillatory amplitude         
        [osciPPAmpl,~] = osciAmplByStatisticalPeakFinding(v_ax_BPF,'EXP',0);             
        if ~isempty(osciPPAmpl) 
            ampl_v_ax_stat_bpf  = num2str(osciPPAmpl,'%.2f');
            plt_exp = plot(d_latScaled, osciPPAmpl/norm_speed,...
                           markertype,'MarkerSize',9,...
                           'LineWidth',0.5,'Color',BaoLan);
        else
            ampl_v_ax_stat_bpf  = '-';
        end
        fprintf(fileID,'%s\n',ampl_v_ax_stat_bpf);

    end
    fclose(fileID);
end


%% Plot rendering and reference lines
set(gca,'XScale','log','YScale','log')
set(gcf,'defaulttextinterpreter','LaTex')
% hold on;
% 50 Hz, 10 micron flagellum
% title('Oscillatory flow decay of cell 7-9, BPF + statistic method',...
%       'FontSize',14,'FontWeight','bold')
% xlabel('Scaled lateral distance ($d_{lat}/\delta$)',...
%        'FontSize',12,'FontWeight','bold')
% ylabel('Scaled flow speed ampltude ($Ampl/L_{flag}f_0$)',...
%        'FontSize',12,'FontWeight','bold')
% xlim([5e-2,5])
% ylim([1e-2,1])
% xticks([0.05,0.1,0.5,1,5])

% print(gcf,'D:\StatisticMethod,c7-12.png','-dpng','-r1200')

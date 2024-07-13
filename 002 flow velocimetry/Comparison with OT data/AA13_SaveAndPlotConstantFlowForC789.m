%% Define path
run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')
savetofdpth = 'D:\000 RAW DATA FILES\171214 oscillatory flow, all\';
%% Preallocation
% clear all
% close all
NoCell = 4;
Fs = 10000;
temp   = cell (NoCell,1);
Experiment_names= {'c5l','c7l','c8l','c9l'};
Marker_types    = {'x','+','x','*'};
pos_info_cell   = temp;
distance_cell   = temp;
vx_raw_cell     = temp;     vy_raw_cell     = temp; 
U_mean_cell     = temp;     V_mean_cell     = temp;    
avg_period_cell = temp;
matfilepath_cell= temp;
matfilepath_cell(1) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c5l\170502c5l_FitSegAvg.mat'};
matfilepath_cell(2) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c7l\170703c7l_FitSegAvg.mat'};
matfilepath_cell(3) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c8l\170703c8l_FitSegAvg.mat'};
matfilepath_cell(4) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c9l\170703c9l_FitSegAvg.mat'};
flag_length     = [13.30,12.64,10.20,11.27]; 
color_palette;


%% Load
for j = 1:NoCell
    matfilepath = char(matfilepath_cell(j));
    load(matfilepath);
    distance_CellLevel = abs(pos_info(:,3));
    [~,idx] = sort(distance_CellLevel);
    distance_cell(j)   = {distance_CellLevel(idx)};
    U_mean_cell(j)     = {U_mean_list(idx)};
    V_mean_cell(j)     = {V_mean_list(idx)};
    avg_period_cell(j) = {avg_period_list(idx)};
    vx_raw_cell(j)     = {vx_raw_list(idx)};
    vy_raw_cell(j)     = {vy_raw_list(idx)};
end



%% Oscillatory flow
for j = 1:NoCell
    gcf;
    hold on

    %% constant flow and oscillatory flow
    distance_CellLevel    = distance_cell{j};
    lf                    = flag_length(j);
    v_ax_raw_CellLevel    = vx_raw_cell{j};
    avg_period_CellLevel  = avg_period_cell{j};
    Avg_U_Const_CellLevel = U_mean_cell{j};
    markertype            = Marker_types{j};
    fileID                = fopen([savetofdpth,Experiment_names{j},...
                                   '_ConstFlow.dat'],'wt');
    fprintf(fileID,['ExpCode\tLatDist\tScaledDist\tFlagLength\tAvgCyc\tAvgFreq\t',...
                'AvgConstVax\tStdConstVax\tAvgConstU\n']);
    NoPos = length(distance_CellLevel);
    for k = 1:NoPos         % position level
        v_ax_raw       = v_ax_raw_CellLevel{k};
        t_EXP          = make_time_series(v_ax_raw,Fs,'ms');
        avg_period     = avg_period_CellLevel(k);         % [ms]
        avg_freq       = 1000/avg_period;                 % [Hz]
        norm_speed     = avg_freq*lf;                     % [micron/sec]
        norm_dist      = 1000*sqrt(0.9565/avg_freq);
%         norm_dist      = 2*a;
        distance       = distance_CellLevel(k);
        dist_scaled    = distance/norm_dist;
        fprintf(fileID,'%02d\t%.2f\t%.2f\t%.2f\t%.4f\t%.4f\t',...
                        k, distance,dist_scaled , lf,  avg_period, avg_freq);
        v_ax_OneCycAvg = smooth(v_ax_raw,avg_period/1000*Fs);
        Avg_v_ax_Const = mean(v_ax_OneCycAvg);
        Std_v_ax_Const = std (v_ax_OneCycAvg);      
        Avg_U_Const    = Avg_U_Const_CellLevel(k);
        fprintf(fileID,'%.4f\t%.4f\t%.4f\n',Avg_v_ax_Const,Std_v_ax_Const,...
                Avg_U_Const);
if j ==2                   
        plt_exp = plot(distance/norm_dist, abs(Avg_v_ax_Const)  /norm_speed,...
            markertype,'MarkerSize',9,'LineWidth',0.5,'Color',BaoLan);
%         errorbar(distance/norm_dist, abs(Avg_v_ax_Const)  /norm_speed,...
%             Std_v_ax_Const  /norm_speed,'LineWidth',2,'Color','b');
        hold on
end
%         plt_cfd = plot(distance/norm_dist, abs(Avg_U_Const)/norm_speed,...
%             markertype,'MarkerSize',5,'LineWidth',1,'Color',orange);      
    end
    fclose(fileID);
end


%% Plot rendering and reference lines
% set(gca,'XScale','log','YScale','log')
% set(gcf,'defaulttextinterpreter','LaTex')
% 
% dis = linspace(0.05,5);
% kBT = 4.075; % 22 degrees, pN*nm
% sigma_nm = sqrt(kBT/0.02); % 0.02 for an average stiffness used in C789
% FlowSpeed2nm = 0.8995*5.40/0.02/100;   %~2.2 nm per 1um/s
% sigma_FlowSpeed = sigma_nm/FlowSpeed2nm;
% % plt_ref = plot(dis,ones(size(dis))*4*sigma_FlowSpeed/50/11,':','Color',[0,0,0,0.3],'LineWidth',2);
% plt_ref2 = plot(dis,1./dis*0.02,'--','Color',lightorange,'LineWidth',2);
% % plt_ref3 = plot(dis,1./dis.^3*0.01*(0.38)^3,'--','Color',lightblue,'LineWidth',2);
% 
% 
% hold on;
% % 50 Hz, 10 micron flagellum
% title('Oscillatory flow decay of cell 7-9, BPF + statistic method',...
%       'FontSize',14,'FontWeight','bold')
% xlabel('Scaled lateral distance ($d_{lat}/\delta$)',...
%        'FontSize',12,'FontWeight','bold')
% ylabel('Scaled flow speed ampltude ($Ampl/L_{flag}f_0$)',...
%        'FontSize',12,'FontWeight','bold')
% % xlim([5e-2,5])
% % ylim([1e-2,1])
% % xticks([0.05,0.1,0.5,1,5])
% 
% print(gcf,'D:\StatisticMethod,c7-12.png','-dpng','-r1200')

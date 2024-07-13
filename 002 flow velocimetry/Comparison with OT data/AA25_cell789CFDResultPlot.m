run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')
color_palette;
% 
plot_osciOrAvg = 'average';
Experiment_names= {'c7l','c8l','c9l'};
NoCell          = length(Experiment_names);
Marker_types    = {'+','x','*'};

flag_length     = [12.64,10.20,11.27]; 
freq_for_each   = [39.10,57.47,48.96];

  
matfilepath_list= {};
matfilepath_list(1) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c7l\170703c7l_FitSegAvg.mat'};
matfilepath_list(2) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c8l\170703c8l_FitSegAvg.mat'};
matfilepath_list(3) = {'D:\000 RAW DATA FILES\171129 c5-c9\002 results\c9l\170703c9l_FitSegAvg.mat'};
simupath_list = {};
simupath(1) = {'D:\000 RAW DATA FILES\171214 oscillatory flow, all\simulation\c7l CFD.mat'};
simupath(2) = {'D:\000 RAW DATA FILES\171214 oscillatory flow, all\simulation\c8l CFD.mat'};
simupath(3) = {'D:\000 RAW DATA FILES\171214 oscillatory flow, all\simulation\c9l CFD.mat'};

start_end_frame_list = {[12,117],[9,108],[10,109]};
% figure()
for j = 1:1 % cell level
    
    gcf,hold on
    
    matfilepath = char(matfilepath_list(j));
    load(matfilepath);

    load(simupath{j});
    %% constant flow and oscillatory flow
    lf             = flag_length(j);
    markertype     = Marker_types{j};
    start_end_frame= start_end_frame_list{j};
    start_frame    = start_end_frame(1);
    end_frame      = start_end_frame(2);
    avg_freq       = freq_for_each(j);               % [Hz]
    norm_speed     = avg_freq*lf;                    % [micron/sec]
    norm_dist      = 1000*sqrt(0.9565/avg_freq);
    distance       = abs(ygb);
    dist_scaled    = distance./norm_dist;
    
    ampl_osci_U    = zeros([length(ygb),1]);
    ampl_osci_V    = zeros([length(ygb),1]);
    ampl_const_U   = zeros([length(ygb),1]);
    ampl_const_V   = zeros([length(ygb),1]);
    for jj = 1: length(ygb)
        U = Uflowb(:,jj);
        V = Vflowb(:,jj);
        U = smooth(medfilt1(U,5),3);
        V = smooth(medfilt1(V,5),3);
%         ampl_osci_U(jj) = prctile(U,95) -  prctile(U,5);
%         ampl_osci_V(jj) = prctile(V,95) -  prctile(V,5);
        [ampl_osci_U(jj),~] = osciAmplByStatisticalPeakFinding(U,'CFD',0);
%         [ampl_osci_V(jj),~] = osciAmplByStatisticalPeakFinding(V,'CFD',0);
        
        ampl_const_U(jj)= mean(U(start_frame:end_frame));
        ampl_const_V(jj)= mean(V(start_frame:end_frame));
    end
    %% oscillatory part
    if exist('plot_osciOrAvg','var')
       switch plot_osciOrAvg
           case {'oscillatory','osci'}
               plt_osci = plot(dist_scaled([1:10,11:2:56]), ...
                          ampl_osci_U([1:10,11:2:56])/norm_speed,...
                          '-','LineWidth',1.5,'Color',[orange,0.8]);
           case {'average','avg'}
               plt_const= plot(dist_scaled([1:10,11:2:56]),...
                          abs(ampl_const_U([1:10,11:2:56])/norm_speed),...
                          '-','LineWidth',1.5,'Color',[orange,0.8]);
       end
    else
        plt_osci = plot(dist_scaled([1:10,11:2:56]), ...
                   ampl_osci_U([1:10,11:2:56])/norm_speed,...
                   '-','LineWidth',1.5,'Color',[orange,0.8]);
    end
end
set(gca,'XScale','log','YScale','log')
set(gcf,'defaulttextinterpreter','LaTex')
grid on
%% test plot setting
% dis = linspace(0.01,10);
% 
% % title('Oscillatory flow decay of cell 7-16',...
% %       'FontSize',14,'FontWeight','bold')
% xlabel('Scaled lateral distance ($d_{lat}/\delta$)',...
%        'FontSize',12,'FontWeight','bold')
% ylabel('Scaled flow ampltude ($Ampl/L_{flag}f_0$)',...
%        'FontSize',12,'FontWeight','bold')
% xlim([0.05,5])
% ylim([5e-3,5e-1])
% xticks([0.1,0.5,1])
% yticks([1e-4,1e-3,1e-2,1e-1])
% % % 
% set(gcf,'Units','inches','InnerPosition',[1,1,5,5])
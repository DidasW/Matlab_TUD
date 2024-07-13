color_palette;
material_fdpth = 'D:\000 RAW DATA FILES\171113 double flash phase delay\001 gathered material\';
to_fdpth       = 'D:\000 RAW DATA FILES\171113 double flash phase delay\002 results\';
experiment =  '171029c16l1';
AA05_experiment_based_parameter_setting;

matfilestruct = dir([material_fdpth,'*.mat']);
for j = 1:length(matfilestruct)
    load([material_fdpth,matfilestruct(j).name])
end

NoPt = length(pt_list);
[xgb_list,ygb_list] = BeadCoordsFromFile(beadcoords_pth,pt_list,experiment);
t_shift_list        = zeros(NoPt,1);

for i = 1:NoPt
    
    xgb = xgb_list(i);
    ygb = ygb_list(i);
    pt  = pt_list(i);
    t_start = t_start_list(i);
%     if pt == 9
%         t_start = t_start + 4.2;
%     end
%     modular_cycle = sig_modular_list{i};
    modular_cycle = Uflowb_modular_list{i};
    marked_list = marked_image_list_cell{i};
    [Uflowb_Art,t_CFD_Art] = generate_artificial_signal_by_marked_list(...
                             modular_cycle,marked_list,t_start,fps,Fs);
    v_ax_raw = v_ax_raw_list{i};
    t_psd = make_time_series(v_ax_raw,Fs,'ms');
    vx_raw = v_ax_raw;
    % [vx,pksx,locsx] = freq_filter_for_flagellar_signal(vx_raw,Fs);
    
    if abs(ygb) > 40
        HPf0   = 45; 
        LPf0   = 70;
    else
        HPf0   = 45; 
        LPf0   = 180;
    end
    order0 = 2;
    [bbp0,abp0] = butter(order0,[HPf0,LPf0]/Fs*2,'bandpass');
    vx =  filtfilt(bbp0,abp0,vx_raw);
%     Uflowb_Art = Uflowb_Art - mean(Uflowb_Art);
%     plot(Uflowb_Art)
%     hold on 
%     plot(Uflowb_Art_sub)
%     const = mean(vx_raw);
%     vx = vx+const;

    %% Plot frequency feature
    figure(5)
    f_smth      = 10; % Hz
    NoP_smth    = f_smth*length(vx_raw)/Fs;
    title([sprintf('exp:%s, position:%02d-%.1f micron away\n',experiment,pt,abs(ygb)),...
                  'Frequency domain characteristics'],'fontsize',10);

    set(gca,'Yscale','log','Xscale','log')
    hold on 
    % raw sig spec
    [f0x,pow0x]   =  fft_mag(vx_raw,Fs);
    pow0x_smth    =  smooth(pow0x,NoP_smth);
    plt_fftx0     =  plot(f0x,pow0x_smth,'r');
    % filtered sig spec
    [f1x,pow1x]   =  fft_mag(vx,Fs);
    pow1x_smth    =  smooth(pow1x,NoP_smth);
    plt_fftx1     =  plot(f1x,pow1x_smth,'b'); 

    xlim([10,Fs/2])
    ylim([min(pow0x_smth(f0x>10))*0.5,max(pow0x_smth(f0x>10))*2])
    ylabel('Magnitude (-)', 'FontSize', 10, 'FontWeight', 'bold')
    legend([plt_fftx0,plt_fftx1],{'Raw data (axial)','BPF'});
    legend('boxoff')
%     print(5,[to_fdpth,num2str(pt,'%02d'),'-FilterFeature.png'],...
%           '-dpng','-r300');
%     savefig(5,[to_fdpth,num2str(pt,'%02d'),'-FilterFeature.fig']);
    
    
    
    %%
    figure(1)
    set(gcf,'Units','normalized','Position',[0.1,0.1,0.8,0.5],...
        'defaulttextinterpreter','LaTex')
    plot(t_CFD_Art,Uflowb_Art,'LineWidth',4,'Color',[orange,0.8]);
    hold on
%     plot(t_psd,vx_raw,'-','LineWidth',2,'Color',[0.5,0.5,0.5,0.4]);
    plot(t_psd,vx,'-','LineWidth',4,'Color',[BaoLan,0.8]);
    
%     plot(t_psd,smooth(vx_raw,Fs*0.01)-smooth(vx_raw,(2*Fs*54.02)),'-','LineWidth',3,'Color',[QianNiuZi,0.6]);
%     legend({'CFD','Experiment: raw','Experimental: bpf'},'FontSize',10,...
%             'Location','southeast')
    grid on
    legend({'CFD',sprintf('Experiment: [%d,%d] Hz passband',HPf0,LPf0)},...
           'FontSize',10,'Location','southeast')
%     xlim([t_CFD_Art(1),t_CFD_Art(end)+20])
    xlim([0,350])
    ylim([1.3*min(min(vx),min(Uflowb_Art)),1.3*max(max(vx),max(Uflowb_Art))])
%     ylim([-60,25])
    xlabel('Time (ms)')
    ylabel('Axial flow speed ($\mu$m/s)')
    title([sprintf('exp:%s, position:%02d-%.1f micron away\n',experiment,pt,abs(ygb)),...
                  'Phase difference']);
%     print(1,[to_fdpth,num2str(pt,'%02d'),'-Phase.png'],...
%           '-dpng','-r300');
%     savefig(1,[to_fdpth,num2str(pt,'%02d'),'-Phase.fig'],'compact');
    
    t_shift_list(i) = get_time_shift_by_correlation(vx,Uflowb_Art,t_CFD_Art,...
                                            Fs,t_CFD_Art(1));
    if t_shift_list(i) <-5 
        t_shift_list(i) = t_shift_list(i) +1000/57.0;
    end
    if t_shift_list(i) > 12
        t_shift_list(i) = t_shift_list(i) - 1000/57.0;
    end
    close all
% pause 
end


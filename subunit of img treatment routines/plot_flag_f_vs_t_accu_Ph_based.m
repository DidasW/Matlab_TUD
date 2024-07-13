function fig_f_vs_t_accu_Ph_based = plot_flag_f_vs_t_accu_Ph_based(flag1_f,flag2_f,Fs,f_imp,SFN,freq_range)


fig_f_vs_t_accu_Ph_based = figure('Name','Flag. freq. vs. time, instantaneous'); % figure 6
set(fig_f_vs_t_accu_Ph_based ,'DefaultAxesFontSize', 15,...
    'DefaultAxesFontWeight','bold','defaultaxeslinewidth',2,...
    'defaultpatchlinewidth',1);
hold on

t = (0:(length(flag1_f)-1)) * 1/Fs ;
F_IMP = ones(length(t),1)   * f_imp;

plt6_1 = plot(t,flag1_f,'b','linewidth',2);
plt6_2 = plot(t,flag2_f,'r','linewidth',2);
plt6_3 = plot(t,F_IMP,'k--','linewidth',1);
ylim(freq_range);


if f_imp ~= 0
    legend([plt6_1,plt6_2,plt6_3],{'Flag. 1 freq.','Flag. 2 freq.','Imposed freq.'},'Location','northwest');
    legend('boxoff');
else
    legend([plt6_1,plt6_2],{'Flag. 1 freq.','Flag. 2 freq.'},'Location','northwest');
    legend('boxoff');   
end
xlabel(  'Time (s)'    ,'FontSize',18,'Fontweight','bold');
ylabel('Frequency (Hz)','FontSize',18,'Fontweight','bold');
title(['Flagella frequency vs. time, Fd: ',SFN]);

end
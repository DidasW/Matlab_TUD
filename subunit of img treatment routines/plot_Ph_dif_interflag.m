function fig_Ph_dif_interflag = plot_Ph_dif_interflag(t_interflag_interp,Ph_interflag_interp,SFN)


fig_Ph_dif_interflag  = figure('Name','Phase dif. between two flag.'); % figure 3
set(fig_Ph_dif_interflag ,'DefaultAxesFontSize', 15,...
        'DefaultAxesFontWeight','bold','defaultaxeslinewidth',2,...
        'defaultpatchlinewidth',1);
hold on


plt3 = plot(t_interflag_interp,Ph_interflag_interp,'k','linewidth',2);
legend(plt3,'Inter-flag. phase difference');
legend('boxoff')


title(['Phase difference between flag. from folder: ',SFN]);
xlabel('Time (s)'   ,'FontSize',18,'Fontweight','bold');
ylabel('\phi (2\pi)','FontSize',18,'Fontweight','bold');

end
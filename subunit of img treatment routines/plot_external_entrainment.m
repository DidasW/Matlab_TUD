function fig_external_entrainment = plot_external_entrainment(t1,d_Ph1,t2,d_Ph2,SFN)
    fig_external_entrainment = figure('Name','Entrainment of two flag. to imposed stimulus'); 
    % figure2
    set(fig_external_entrainment ,'DefaultAxesFontSize', 15,...
        'DefaultAxesFontWeight','bold','defaultaxeslinewidth',2,...
        'defaultpatchlinewidth',1);
    hold on

    plt2_1 = plot(t1,d_Ph1,'b.');
    plt2_2 = plot(t2,d_Ph2,'r.');
    title(['Phase dif. info. from folder: ',SFN]);
    legend([plt2_1,plt2_2],{'Flag. 1','Flag. 2'});
    legend('boxoff')
    
    xlabel('Time(s)'    ,'FontSize',18,'Fontweight','bold');
    ylabel('\phi (2\pi)','FontSize',18,'Fontweight','bold');
    
end
    
function plot_fitAndExpPhasePDF_noPiezo(N,T_eff,epsilon,nu,psi_0,...
                                BinCenters_pi,PDFExp,color)
    %% set axis and text
    gca
    set(gca,'defaulttextinterpreter','Latex',...
        'TickLabelInterpreter','Latex')
    hold on, box on, grid on
    infoStr = {sprintf('$\\varepsilon$=%.2fHz',epsilon);
               sprintf('$\\nu$=%.2fHz',nu);
               sprintf('$T_{eff}$=%.2f rad$^2$/s',T_eff*2*pi);};
    text(0,4.9,infoStr,'Interpreter','Latex',...
        'HorizontalAlignment','center',...
        'VerticalAlignment', 'top','FontSize',10)
    
    %% plot
    psi     = linspace(-pi,pi,N);
    P       = P_delta(N,T_eff,epsilon,nu,psi_0);
    bar(BinCenters_pi,PDFExp,'EdgeAlpha',0,...
        'FaceColor',color,'FaceAlpha',0.15)
    plot(psi,P,'LineWidth',1.5,'Color',color)

    %% set labels 
    ylim([0,5])
    xlim([-pi,pi]);
    xticks([-pi,0,pi])
    xticklabels({'-$\pi$','0','$\pi$'})
    xlabel('$\Delta$ (2$\pi$)')
    ylabel('PDF')
end
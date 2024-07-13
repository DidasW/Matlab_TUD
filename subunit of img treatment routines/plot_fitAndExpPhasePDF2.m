function plot_fitAndExpPhasePDF2(N,T_eff,epsilon,nu,piezoFreq,...
                                BinCenters_pi,PDFExp,color)
    %% set axis and text
    gca
    set(gca,'defaulttextinterpreter','Latex',...
        'TickLabelInterpreter','Latex')
    hold on, box on, grid on
    infoStr = sprintf('$f_{flow}$=%.2fHz',piezoFreq);
    text(0,0.28,infoStr,'Interpreter','Latex',...
        'HorizontalAlignment','center',...
        'VerticalAlignment', 'top','FontSize',10)
    
    %% plot
    psi     = linspace(-pi,pi,N);
    P       = P_delta2(N,T_eff,epsilon,nu);
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
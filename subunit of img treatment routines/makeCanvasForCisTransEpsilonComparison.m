function makeCanvasForCisTransEpsilonComparison(plotRange)
    if isempty(plotRange);  plotRange = 3.5; end
        
    set(gcf,'DefaultAxesFontSize',12,'DefaultAxesFontWeight','normal',...
        'DefaultAxesLineWidth',1.5,'Units','inches',...
        'position',[1,1,3.0,3.0],'PaperPositionMode','auto',...
        'DefaultTextInterpreter','Latex')
    set(gca,'DefaultTextInterpreter','Latex',...
        'TickLabelInterpreter','Latex')
    hold on, box on, grid on
    plot([0,plotRange],[0,plotRange],'-','LineWidth',1,'Color','k');
    text(2,2,'$\varepsilon_{cis}$ = $\varepsilon_{trans}$',...
        'HorizontalAlignment','center','VerticalAlignment','bottom',...
        'FontSize',12,'Rotation',45);
    xlim([0,plotRange]),ylim([0,plotRange]);
    xticks(0:2:6);
    yticks(0:2:6);
    axis equal
    xlabel('$\epsilon_{cis}$  (Hz)')
    ylabel('$\epsilon_{trans}$ (Hz)')
    
end
function makeCanvasForCisTransTSyncComparison(varargin)
       
    if ~isempty(varargin)
        figNum = varargin{1};
        figure(figNum)
    end
    
    set(gcf,'DefaultAxesFontSize',12,'DefaultAxesFontWeight','normal',...
        'DefaultAxesLineWidth',1.5,'Units','inches',...
        'position',[1,1,4,4],'PaperPositionMode','auto',...
        'DefaultTextInterpreter','Latex')
    set(gca,'DefaultTextInterpreter','Latex',...
        'TickLabelInterpreter','Latex')
    hold on, box on, grid on
    plot([-1,2],[-1,2],'-','LineWidth',1,'Color','k');
    text(0.8,0.8,'$\xi_{cis} = \xi_{trans}$',...
        'HorizontalAlignment','center','VerticalAlignment','bottom',...
        'FontSize',10,'Rotation',45);
    xlim([-0.05,1.05]), ylim([-0.05,1.05]);
    xticks(0:0.2:1)   , yticks(0:0.2:1)
    axis equal
    xlabel('$\xi_{cis}$  (-)')
    ylabel('$\xi_{trans}$  (-)')
    
end



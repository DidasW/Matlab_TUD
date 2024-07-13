function makeCanvasForScaledWaveform(h_fig,varargin)
    %% parse input
    titleStr = '';
    temp = strcmp(varargin,'title');
    if any(temp)
        titleStr = varargin{find(temp)+1};
    end
    temp = strcmp(varargin,'ylim');
    if any(temp)
        set(gca,'ylim',varargin{find(temp)+1});
    end
    temp = strcmp(varargin,'xlim');
    if any(temp)
        set(gca,'xlim',varargin{find(temp)+1});
    end
    clearvars temp
    
    %%
    if ~isempty(h_fig)
        figure(h_fig);
    else
        figure();
    end
    set(gcf,'units','Inches','Position',[1,1,3.0,2.5],...
        'defaultTextInterpreter','latex')
    set(gca,...
        'defaultTextInterpreter','latex',...
        'TickLabelInterpreter','Latex','fontsize',10)
    hold on, box on, grid on
    plot([0 10],[0 0],'k-')
    
    xlim([-0.1,2*pi+0.1])
    ylim([-0.3 0.7])
    yticks([-0.4:0.2:0.8])
    ylabel('u,v/$U_0$ (-)')
    xlabel('Flagellar phase ($\phi$)')
    xticks([0:0.25:1]*2*pi)
    xticklabels({'0.0';'0.5$\pi$';'1.0$\pi$';'1.5$\pi$';'2.0$\pi$'})
    
    if ~isempty(titleStr); title(titleStr); end
end
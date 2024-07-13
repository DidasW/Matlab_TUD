function makeCanvasForOTVFlowDecay(plot_axOrLatComponent,...
                                   plot_axOrLatDistance,...
                                   plot_osciOrAvg,h_fig)
    %% check input
    if isempty(h_fig)
        h_fig = gcf;
    end
    
    %% prepare for labels and texts   
    switch plot_axOrLatDistance
        case {'axial','ax','Axial','Ax'}
            xLabelText = 'Scaled axial distance ($y/\delta$)';
        case {'lateral','lat','Lateral','Lat'}
            xLabelText = 'Scaled lateral distance ($x/\delta$)';
        case {'z','Z'}
            xLabelText = 'Scaled vertical distance ($z/\delta$)';
        otherwise
            xLabelText = 'Scaled distance ($x/\delta$)';
    end

    switch plot_osciOrAvg
        case {'oscillatory','osci','Oscillatory','Osci'}
            FT_s = 'osci';          % Flow Type Short/Long
            FT_l = 'oscillatory';   % Flow Type Short/Long
        case {'average','avg','Average','Avg'}
            FT_s = 'avg';           % Flow Type Short/Long
            FT_l = 'average';       % Flow Type Short/Long
        otherwise
            FT_s = 'osci';          % Flow Type Short/Long
            FT_l = 'oscillatory';   % Flow Type Short/Long
    end

    switch plot_axOrLatComponent
        case {'axial','ax','Axial','Ax'}
            FL = 'U';               % Flow Letter
        case {'lateral','lat','Lateral','Lat'}
            FL = 'V';
        case {'z','Z'}
            FL = 'W';
        otherwise
            FL = 'U';
    end

    yLabelText = sprintf('Scaled %s flow ($%s_{%s}/U_{scale}$)',...
                          FT_l, FL ,FT_s);
    %%
    figure(h_fig)
    hold on, grid on, box on
    set(h_fig,'Units','Inches','Position',[5 2 3.7000 3.7000],...
       'defaulttextinterpreter','LaTex')
    set(gca,'Units','Normalized','Position',[0.22, 0.15, 0.7, 0.7],...
       'XScale','log','YScale','log','fontsize',10.9,...
       'defaulttextinterpreter','Latex','TickLabelInterpreter','Latex')

    xlabel(xLabelText,'FontSize',12,'FontWeight','bold')
    ylabel(yLabelText,'FontSize',12,'FontWeight','bold')
    xlim([0.06,1.3])
    ylim([1e-3, 1 ])
    xticks([0.1,1])
    yticks([1e-2,1e-1])
end
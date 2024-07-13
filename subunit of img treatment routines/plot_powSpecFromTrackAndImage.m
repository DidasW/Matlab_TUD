%% Doc
%{
plot on the current axis the spectrum extracted from both image analysis
and tracking. Used in AC02 and AC03 for the beating freq. analysis of
different strains of cells.

1-series will be ploted against the left y-axis; 2, right
%}

function plot_powSpecFromTrackAndImage(f1,pow1,locs1,pks1,...
                                       f2,pow2,locs2,pks2)
    hold on, box on, grid on;
    %% colors 
    c1 = [0.2 0.2 0.2];
    c2 = [0.6 0.6 0.6]; 
    
    %% plot left y-axis
    h1   = plot(f1,pow1,'.-','LineWidth',1,'Color',c1);
    for i_pk = 1:numel(pks1)
        if locs1(i_pk)>=25 && locs1(i_pk)<=100
            plot(locs1(i_pk),pks1(i_pk)+0.06,'bv','MarkerSize',5,...
                 'MarkerFaceColor',c1,'MarkerEdgeColor','none')
            text(locs1(i_pk),pks1(i_pk)+0.08,...
                sprintf('%.1fHz',locs1(i_pk)),...
                'HorizontalAlignment','center',...
                'VerticalAlignment','bottom','FontSize',7)
        end
    end
    ylim([-0.1,1.25])
    ylabel('Mag (-)')


    %% plot right y-axis
    yyaxis right 
    h2 = plot(f2,pow2,'-','LineWidth',1.5,'color',c2);
    ylim([-0.1,1.2])
    ylabel('Mag (-)')
    for i_pk = 1:numel(pks2)
        if locs2(i_pk)>=25 && locs2(i_pk)<=100
            plot(locs2(i_pk)*ones(2,1),...
                [pks2(i_pk),0.07],':','color',c2,'LineWidth',1)
            plot(locs2(i_pk),0.07,'^','MarkerSize',5,...
                 'MarkerFaceColor',c2,'MarkerEdgeColor','none')
            text(locs2(i_pk),0.06,...
                sprintf('%.1fHz',locs2(i_pk)),...
                'HorizontalAlignment','center',...
                'VerticalAlignment','top','FontSize',7)
        end
    end
    
    %% setup x-axis, label, and legend
    xlim([20,110])
    ylim([-0.1,1.25])
    xlabel('Freq (Hz)')
    legend([h1,h2],{'Image','Track'},'box','off',...
        'Location','northeast','FontSize',6,'Interpreter','latex')
    


end
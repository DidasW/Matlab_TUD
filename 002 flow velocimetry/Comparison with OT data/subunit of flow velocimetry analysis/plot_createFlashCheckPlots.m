function h_fig = plot_createFlashCheckPlots(illumi_sum,fps,...
                                            start_frame,t_start,...
                                            t_Fstart,t_Fspan,t_Fend)
    NoImg           = length(illumi_sum);
    t               = (0:NoImg-1)/fps*1000;% [ms], the first frame is 
    interp_Fs       = 50.0;                       % unit: kHz
    t_interp        = t(1):1/interp_Fs:t(end);    % interpolation freq:50kHz
    illumi_interp   = interp1(t,illumi_sum,t_interp,'spline');
    illumi_sum_norm = normalize_MaxToMin(illumi_sum);
    
    search_F        = zeros(length(illumi_interp),1);
    search_F(2:end) = diff(illumi_interp);              % maintain the same length
    search_F(1)     = search_F(2);
    search_F        = abs(search_F);
    search_F        = normalize_MaxToMin(search_F);
    
    XzoomInRange     = [t_Fstart-140,t_Fstart+200];
    YzoomInRange     = [min(illumi_sum)*0.8,max(illumi_sum)*1.2];
    
    h_fig = figure();
    set(gcf,'DefaultAxesFontSize',14,'DefaultAxesFontWeight','normal',...
        'DefaultAxesLineWidth',1.5,'unit','normalized',...
        'position',[0.1,0.1,0.8,0.8],'PaperPositionMode','auto')
    
    subplot(2,1,1)
    set(gca,'yscale','log')
    ax1     = plot(t, illumi_sum, 'o-','MarkerSize',4,'LineWidth',1); hold on 
    patch([XzoomInRange,fliplr(XzoomInRange)],...
          [YzoomInRange(1),YzoomInRange(1),YzoomInRange(2),YzoomInRange(2)],...
          'b','FaceAlpha',0.01,'EdgeColor','r','LineStyle','--',...
          'LineWidth',0.5);
    
    legend([ax1],{'Total img intensity'},'FontSize',10);
    xlabel('Time (ms)');            
    ylabel('Img. intensity(-)');
    
    subplot(2,1,2)   
    ax2  = plot(t_interp,search_F,'color',[0,0,1,0.5],'Linewidth',2.5); 
    hold on;
    ax3  = plot(t,illumi_sum_norm,'o-','markersize',5,'linewidth',1);
    ax4  = plot([t_Fend,t_Fend],[-1,10],'r--','linewidth',1);
    ax5  = plot(t(start_frame),illumi_sum_norm(start_frame),...
                'o','markersize',8,'linewidth',2);
    text(t_Fend,0.7,sprintf(['start frame = %d\nstart time = %.3f ms\n',...
                             'flash duration %.3f ms'],...
                             start_frame,t_start,t_Fspan),...
         'FontSize',10);
    xlim(XzoomInRange);
    ylim([-0.1,1.5]);
    xlabel('Time (ms)');
    ylabel('Img. intensity(-) / Match score(-)');
    legend([ax2,ax3],{'Abs of differential signal,interp: spline',...
           'raw signal'},'FontSize',10);
    

end
%% Doc
% This plot affliate can only be used inside the routine AA10_draw.m
% It plots the overlay of the flow speed calculated by the CFD and the one
% from the optical trap.

%% Plot detail determination
info_factorx= sprintf('$factor_{ax}$= %.2f\n',factor_x);
info_factory = sprintf('$factor_{ax}$= %.2f\n',factor_y);
if include_time_shift == 1
    info_tshiftx = sprintf('$t_{shift}$ = %.2f ms\n',t_shift_x);
    info_tshifty = sprintf('$t_{shift}$ = %.2f ms\n',t_shift_y);
else
    info_tshiftx = sprintf('$t_{shift}$ = %.2f ms (unplotted)\n',t_shift_x);
    info_tshifty = sprintf('$t_{shift}$ = %.2f ms (unplotted)\n',t_shift_y);
end
if include_v_shift == 1
    info_vshiftx = sprintf('$v_{shift}$ = %.2f $\\mu$m/s',vx_shift);
    info_vshifty = sprintf('$v_{shift}$ = %.2f $\\mu$m/s',vy_shift);
else
    info_vshiftx = sprintf('$v_{shift}$ = %.2f $\\mu$m/s (unplotted)',vx_shift);
    info_vshifty = sprintf('$v_{shift}$ = %.2f $\\mu$m/s (unplotted)',vy_shift);
end

%% title
h = suptitle([sprintf('exp:%s, bead pos.: %02d--(%.1f,%.1f)$\\mu$m\n',...
                experiment,pt,xgb,ygb),...
              'Match signals and segmentize them into periods']);
set(h,'FontSize',12,'FontWeight','normal')

%% x signal
subplot(211)
    ax11 = plot(t_psd,vx-vx_plot_shift,...
                'x-','markersize',3,'linewidth',0.2,...
                'color','b'  ); hold on 
    ax12 = plot(t_vid_shift_interp,factor_x*Uflowb_interp,'-','linewidth',2,...
                'color',orange);  
    for j = local_max_idx
        plot([t_vid_shift_interp(j),t_vid_shift_interp(j)],...
             [-1000,1000],'--','linewidth',1,'color',[lightpurple,0.8])
    end
    for j = local_min_idx
        plot([t_vid_shift_interp(j),t_vid_shift_interp(j)],...
             [-1000,1000],'--','linewidth',1,'color',[lightblue,0.8])
    end

    
    xlabel('Time (ms)');         
    ylabel('Flow speed ($\mu$m/s)');
    
    if (t_vid_shift_interp(end)-t_vid_shift_interp(1))> 250 
        xlim([t_vid_start-10,t_vid_start+400]); 
    else
        xlim([t_vid_start-10,t_vid_start+200]); 
    end
    ylim  ([plt_v_span_min,plt_v_span_max]);
    
    legend([ax11,ax12],{'EXP, axial','CFD, axial'},'FontSize',12,...
           'FontWeight','normal')
    text  (t_vid_start-6, plt_v_span_max*0.7,...
           [info_factorx,info_tshiftx,info_vshiftx],...
           'Fontsize',8,'Margin',2,'BackgroundColor','w','EdgeColor','k');
%% y signal
subplot(212)
    ax21 = plot(t_psd,vy-vy_plot_shift,...
                'x-','markersize',3,'linewidth',0.2,...
                'color','b'  ); hold on 
    ax22 = plot(t_vid_shift_interp,factor_y*Vflowb_interp,'-','linewidth',2,...
                'color',orange);  
    for j = local_max_idx
        plot([t_vid_shift_interp(j),t_vid_shift_interp(j)],[-1000,1000],'--','linewidth',1,...
             'color',[lightpurple,0.8])
    end
    for j = local_min_idx
        plot([t_vid_shift_interp(j),t_vid_shift_interp(j)],[-1000,1000],'--','linewidth',1,...
             'color',[lightblue,0.8])
    end

    
    xlabel('Time (ms)');         
    ylabel('Flow speed ($\mu$m/s)');
    
    if (t_vid_shift_interp(end)-t_vid_shift_interp(1))> 250 
        xlim([t_vid_start-10,t_vid_start+400]); 
    else
        xlim([t_vid_start-10,t_vid_start+200]); 
    end
    ylim  ([plt_v_span_min,plt_v_span_max]);
    
    legend([ax21,ax22],{'EXP, lateral','CFD, lateral'},'FontSize',12,...
           'FontWeight','normal')
    text  (t_vid_start-6, plt_v_span_max*0.7,...
           [info_factory,info_tshifty,info_vshifty],...
           'Fontsize',8,'Margin',2,'BackgroundColor','w','EdgeColor','k');
%% Doc
% plotting affliate, can only be used within routine AA10_draw
% This script will overlay the averaged cycle from both CFD and EXP.
% The averaged cycle is constructed by adding up signal in different
% segments. Each segment is defined by two adjacent local minima in the CFD
% signal


%%
text_fig2 = sprintf(['Total no. of cycles: %d\n',...
                     'Cycles used in avg.: %d'],TotNoCyc,NoCyc);

set(gcf,'Position',[0.1,0.1,0.3,0.8]) 

h = suptitle([sprintf('exp:%s, bead pos.: %02d--(%.1f,%.1f)$\\mu$m\n',...
                      experiment,pt,xgb,ygb),...
              sprintf(['Compare EXP and CFD avg. cycle, ',...
                       '$v_{shift}$ compensated'])]);
set(h,'FontSize',12,'FontWeight','normal')

%% x signal
subplot(211)
    ax11 = plot(t_avg,avg_vx - vx_plot_shift,'-', 'linewidth', 2, ...
                'color','b'   ); hold on 
    ax12 = plot(t_avg,avg_U, '-', 'linewidth', 2, ...
                'color',orange);  
    xlabel('Time (ms)');         ylabel('Flow speed ($\mu$m/s)');
    xlim([-10,t_avg(end)+10]);   ylim([plt_v_span_min*0.8,plt_v_span_max*0.8]);
    legend([ax11,ax12],{'EXP, axial','CFD, axial'},...
           'FontSize',12,'FontWeight','normal')
    text(-9,plt_v_span_min*0.6,text_fig2,'fontsize',8,'fontweight','bold');

%% y signal
subplot(212)
    ax21 = plot(t_avg,avg_vy - vy_plot_shift,'-', 'linewidth', 2, ...
                'color','b'   ); hold on 
    ax22 = plot(t_avg,avg_V, '-', 'linewidth', 2, ...
                'color',orange);  
    xlabel('Time (ms)');         ylabel('Flow speed ($\mu$m/s)');
    xlim([-10,t_avg(end)+10]);   ylim([plt_v_span_min*0.8,plt_v_span_max*0.8]);
    legend([ax21,ax22],{'EXP, lateral','CFD, lateral'},...
           'FontSize',12,'FontWeight','normal')


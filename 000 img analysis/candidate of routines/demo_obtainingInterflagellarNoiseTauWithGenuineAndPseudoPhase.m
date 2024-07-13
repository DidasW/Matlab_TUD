clear all
% load('D:\000 RAW DATA FILES\181129 new phase\matfiles\180703 c2_after.mat');
load('D:\000 RAW DATA FILES\181129 new phase\matfiles\180803 c2_before.mat');

color_palette
% clearvars -except BaoLan YangHong
dPh_interflag_theo       =  Ph_interflag_interp;

[t,dPh_interflag_pseudo] =  compare_phase_between_flag(...
                            H_Ph1,H_Ph2,Fs);


%%
figure('defaulttextinterpreter','Latex')
segSize = 1000;
avg_corr = zeros(1,2*segSize-1);
NoSeg = floor(numel(t)/segSize)-1;
NoSeg_effect = NoSeg;

%% pseudo phase
for i_Ph = 1:2
    subplot(2,1,i_Ph)
    set(gca,'defaulttextinterpreter','Latex',...
        'TickLabelInterpreter','Latex')
    hold on, grid on, box on
    ylim  ([-0.03,0.5])
    xlim  ([0,segSize/2]);
    xlabel('t (ms)')
    ylabel('Auto-correlation (a.u.)')
    
    switch i_Ph
        case 1
            dPh_interflag = dPh_interflag_pseudo;
            color    = YingWuLv;
            colorFit = ZaoHong;
            noteStr  = 'Pseudo-phase';
        case 2
            dPh_interflag = dPh_interflag_theo;
            color    = BaoLan;
            colorFit = orange;
            noteStr  = 'Theoretical-phase';
    end
    
    for i_seg = 1:NoSeg
        idx = segSize/2 +[(i_seg-1)*segSize+1  : i_seg*segSize];
        sample = dPh_interflag(idx);
        if max(smooth(sample,60))-min(smooth(sample,60)) < 0.7
            sample = sample - mean(sample);
            [C,lag]       = xcorr(sample);
            h_seg = plot  (lag,C,'-','color',[color,0.15],'LineWidth',0.5);
            avg_corr = avg_corr+C;
        else
            NoSeg_effect = NoSeg_effect-1;
            continue
        end
    end
    
    
    title(sprintf(['Segment: %dms |No. of Segment: %d |',noteStr],...
          segSize,NoSeg_effect));

    fo = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[0,0],'Upper',[1.1,max(lag)],...
    'StartPoint',[0.3,1]);
    ft = fittype('a*exp(-x/tau)','options',fo);
    
    avg_corr = avg_corr/NoSeg_effect;
    h_avg = plot  (lag,avg_corr,'o','color',color,'MarkerFaceColor',color,...
           'LineWidth',1,'MarkerSize',2);
    fit_expDec = fit(lag(lag>=0)',avg_corr(lag>=0)',ft);
    h_fit = plot(fit_expDec(lag(lag>=0)),'--',...
            'LineWidth',1.5,'color',colorFit);
    
    legend([h_seg,h_avg,h_fit],{'autocorr, Each segment','average',...
           'fit with exp{-t/$\tau$}'},'Location','northeast','Box','off',...
           'Interpreter','latex')  
    
    a = fit_expDec.a;
    tau= fit_expDec.tau;
    xlimRange = get(gca,'xlim');
    xtext = xlimRange(2)*0.8;
    ylimRange = get(gca,'ylim');
    ymid = mean(ylimRange);
    
    text(xtext,ymid,sprintf('$\\tau$=%.2f ms',tau),...
        'HorizontalAlignment','center')
end
%%


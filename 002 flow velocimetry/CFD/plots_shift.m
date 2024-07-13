set(0, 'DefaultAxesFontSize',16)
close all

indshift0 = 9; %Index where the phase shift was previously 0
anglist = 0:pi/2:2*pi;
xloclist = anglist;
xsize = 0.2*pi;
%----------------------------------------------------------------------
% Compare average viscous power across experiments
% ----------------------------------------------------------------------
if 0
    cc=parula(datasets); %Colormaps
    windowtit = ['Viscous power comparison'];
    figure('name',windowtit,'NumberTitle','off'), hold on
    for n=1:datasets
        plot(datapts,avgbeat{n,3}.meanPvdl,'color',cc(n,:))
        legendstr{n} = name{n};
    end
    title('Viscous power - dimensionless'),grid on,ylim([0 inf]),legend(legendstr)
    xlabel('Relative phase [0-1]'),ylabel('$\tilde{P}$ [-]')
end
%--------------------------------------------------------------------------
%% Contour plot of dimensionless viscous rate of work vs phase diff between flow and cell
%--------------------------------------------------------------------------
if 0
    xdata = phi0;
    %Also add datapoints for 0 and 2pi to make contour plot look nice
    ydata = [0; mod(meanphasediff_act,2*pi); 2*pi;];
    zdata = zeros(length(ydata),length(xdata));
    for dd=1:datasets
        zdata(dd+1,:) = avgbeat{dd,3}.meanPvphidl;
    end
    [ydata,ind] = sort(ydata);
    zdata=zdata(ind,:);
    %Interpolate to get data at 0/2pi
    ind1 = length(ydata)-1; ind2=2;
    zbetween = zdata(ind1,:)+(2*pi-ydata(ind1)).*(zdata(ind2,:)-zdata(ind1,:))./((ydata(ind2)+2*pi)-ydata(ind1));
    zdata(1,:) = zbetween; zdata(end,:) = zbetween; 
    contourlevels = 30:30:240;
    
    windowtit = 'P - surf';
    fig=figure('name',windowtit,'NumberTitle','off'); hold on
    [C,h]=contour(xdata,ydata,zdata,contourlevels); colormap jet; grid on
    clabel(C,h,'FontSize',14);
    y0shift = mod(meanphasediff_act(indshift0),2*pi);
    plot([0 2*pi],[y0shift y0shift],'r--','LineWidth',0.8)
    % surf(xdata,ydata,zdata,'LineStyle','none'), colormap jet; grid on, shading interp
    % c=colorbar; c.Label.String = '$\tilde{\Phi}$ [-]'; grid on
    set(gca,...
         'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
         'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'},...
         'ylim',[0 2*pi],'ytick',0:pi/2:2*pi,...
         'yticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\Delta\phi$ [rad]')
    saveas(fig,'Shift_Pvdl_contour_vs_Delta_phi','epsc')
end
%--------------------------------------------------------------------------
%% Work per cycle vs phase difference between cell and flow
%--------------------------------------------------------------------------
if 0
    xdata = [0; mod(meanphasediff_act,2*pi); 2*pi;];
    ydata = zeros(size(xdata));
    for dd=1:datasets
       ydata(dd+1) = mean(avgbeat{dd,1}.Wv_cyc+avgbeat{dd,2}.Wv_cyc)./trapz(BC426.meantime,BC426.meanPv); 
    end
    ind1 = 7;  ind2 = 8;
    x1 = xdata(ind1); x2 = 2*pi+xdata(ind2); xbetween = 2*pi;
    y1 = ydata(ind1); y2 = ydata(ind2);
    ybetween = y1 + (xbetween-x1)*(y2-y1)/(x2-x1);
    ydata(1) = ybetween; ydata(end) = ybetween;
    [xdata,ind] = sort(xdata);
    ydata = ydata(ind);
    windowtit = 'Wv_cyc';
    fig=figure('name',windowtit,'NumberTitle','off');hold on
    plot(xdata,ydata,'b-'); plot(xdata(2:end-1),ydata(2:end-1),'bo')
    ymin = 0; ymax = 2; xnorm = mod(meanphasediff_act(indshift0),2*pi);
    plot([xnorm xnorm],[ymin ymax],'r--')
    grid on, xlabel('$\Delta\phi$ [rad]'),ylabel('$\tilde{W}_{cycle}$ [-]')
    set(gca,...
         'ylim',[ymin ymax],...
         'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
         'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
     saveas(fig,'Shift_Wv_cyc_vs_Delta_phi','epsc')
end
%--------------------------------------------------------------------------
%% Force average total force vs Delta phi
%--------------------------------------------------------------------------
if 0
    clear legstr
    xdata = [0; mod(meanphasediff_act,2*pi); 2*pi;];
    ydata = zeros(size(xdata,1),size(phi0,2));
    for dd=1:datasets
       ydata(dd+1,:) = smooth(avgbeat{dd,3}.meanEFtphi./BC426.meanEFtphi);
    end
    ydata2 = mean(ydata,2);
    ind1 = 7;  ind2 = 8;
    x1 = xdata(ind1);   x2 = 2*pi+xdata(ind2); xbetween = 2*pi;
    y21 = ydata2(ind1); y22 = ydata2(ind2);
    ybetween2 = y21 + (xbetween-x1)*(y22-y21)/(x2-x1);
    ydata2(1) = ybetween2; ydata2(end) = ybetween2;
    [xdata,ind] = sort(xdata);
    ydata2 = ydata2(ind);
    xnorm = mod(meanphasediff_act(indshift0),2*pi);

    figure,hold on,
    plot(xdata,ydata2,'b-'),plot(xdata(2:end-1),ydata2(2:end-1),'bo')
    ymin = 0; ymax = 2;
    plot([xnorm xnorm],[ymin ymax],'r--'),grid on
    xlabel('$\Delta \phi$ [rad]'), ylabel('$\langle \tilde{F_t} \rangle$ [-]')
    set(gca,...
        'ylim',[ymin ymax],...
         'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
         'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    saveas(gcf,'Shift_EFtphi','epsc')
end
%--------------------------------------------------------------------------
%% Total power profiles
%--------------------------------------------------------------------------
if 1
    clear legendstr
    xdata = [0; mod(meanphasediff_act,2*pi); 2*pi;];
    ydata = zeros(size(xdata,1),size(phi0,2));
    for dd=1:datasets
       ydata(dd+1,:) = avgbeat{dd,3}.meanPtphidl;
    end
    ind1 = 7;  ind2 = 8;
    x1 = xdata(ind1);   x2 = 2*pi+xdata(ind2); xbetween = 2*pi;
    y1 = ydata(ind1,:); y2 = ydata(ind2,:);
    ybetween = y1 + (xbetween-x1)*(y2-y1)/(x2-x1);
    ydata(1,:) = ybetween; ydata(end,:) = ybetween;
    [xdata,ind] = sort(xdata);
    ydata = ydata(ind,:);
    GIPPtphidl = griddedInterpolant({xdata,phi0},ydata);

    nplotsteps= 4;
    dplot = 2*pi/(nplotsteps);
    xdataplot = 0:dplot:2*pi-dplot;

    windowtit = 'Ptphidl';
    fig=figure('name',windowtit,'NumberTitle','off');hold on; 
    ax = fig.Children;
    cmap = jet(length(xdataplot));
    plot(phi0,smooth(BC426.meanPtphidl),'LineWidth',0.8,'color',cmap(1,:));
    legendstr{1} = 'No flow';
    for dd=1:length(xdataplot)
        plot(phi0,smooth(GIPPtphidl({xdataplot(dd),phi0})),'color',cmap(dd,:));
        legendstr{dd+1} = [num2str(round(xdataplot(dd)./pi,2)) '\pi rad'];
    end
    ymin = -500; ymax = 500; ysize = 0.12*(ymax-ymin); yloc = 70;
    plot_body_flags(ax,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    grid on, xlabel('$\phi_{C}$ [rad]'),ylabel('$\tilde{\mathcal{P}}$ [-]')
    set(gca,'ylim',[ymin ymax],'ytick',ymin:250:ymax,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    legend(legendstr,'Location','South')
    saveas(gcf,'Shift_total_power_profiles','epsc')
end
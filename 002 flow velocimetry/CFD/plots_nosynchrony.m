set(0,'defaulttextinterpreter','latex')
set(0,'DefaultAxesFontSize',16)
close all; clc

anglist = 0:pi/2:2*pi;
xloclist = anglist;
xsize = 0.2*pi;
%--------------------------------------------------------------------------
%% Plot beat phenomenon
%--------------------------------------------------------------------------
close all
cmap = lines(10); close(gcf);
color(1,:) = cmap(1,:); color(2,:) = cmap(2,:);
% color(1) = 'b'; color(2) = 'r';
if 0
    bind = 1; eind = 410; xmin = 0; xmax = datatime{2}(eind);
    locs = avgbeat{2,1}.locs(1:end-1)+0.5*(avgbeat{2,1}.locs(2:end)-avgbeat{2,1}.locs(1:end-1));
    xdata = interp1(dataind{2},datatime{2},locs);
    ydata1 = [phasediff_act{2,1}(bind:eind)'; phasediff_act{2,1}(bind:eind)';];
    ydata1 = mod(mean(ydata1,1),2*pi);
    ydata2 = mean([avgbeat{2,1}.xamp; avgbeat{2,2}.xamp]);
    ydata3 = mean([avgbeat{2,1}.area; avgbeat{2,2}.area]);
    ydata4 = avgbeat{2,1}.Pvdl_cyc+avgbeat{2,2}.Pvdl_cyc;
    
    figure,subplot(2,1,1),hold on
        [ax,h1,h2]=plotyy(datatime{2}(bind:eind),Pvdl{2,3}(bind:eind),...
           datatime{2}(bind:eind),smooth(ydata1));
        plot(ax(1),xdata,ydata4,'b-','color',color(1,:))
        grid on, xlabel('$t$ [s]')
        ylabel(ax(1),'$\tilde{\Phi}$ [-]')
        ylabel(ax(2),'$\Delta \phi$ [rad]')
        set(ax(1),'xlim',[xmin xmax],'ylim',[0 200],'YColor',color(1,:))
        set(h1,'Color',color(1,:));
        set(ax(2),'xlim',[xmin xmax],'ylim',[0 2*pi],'ytick',[0:pi:2*pi],...
            'yticklabel',{'0' '\pi' '2\pi'},'YColor',color(2,:))
        set(h2,'Color',color(2,:));
    subplot(2,1,2)
        [ax,h1,h2]=plotyy(datatime{2}(bind:eind),...
            sqrt(B{2,1}(bind:eind,1).^2+B{2,1}(bind:eind,2).^2),...
            xdata,ydata2);
        grid on, xlabel('$t$ [s]')
        ylabel(ax(1),'$|Z|$ [-]')
        ylabel(ax(2),'$\Delta x/L$ [-]')
        set(ax(1),'xlim',[xmin xmax],'ylim',[0 30],'YColor',color(1,:))
        set(h1,'Color',color(1,:));
        set(ax(2),'xlim',[xmin xmax],'ylim',[0 1.5],'ytick',[0:0.5:1.5],...
            'YColor',color(2,:))
        set(h2,'Color',color(2,:));
    saveas(gcf,'NoSync_beat_phenomenon_4-26_17','epsc')
end

%Correlation between work per cycle and stroke amplitude
if 0
   xmax = 1.2; ymax = 8e-16;
   figure,hold on
   plot(avgbeat{2,1}.xamp,avgbeat{2,1}.Wv_cyc,'k.','MarkerSize',10) 
   plot([0 xmax],[0 ymax],'r--')
   set(gca,'xlim',[0 xmax],'ylim',[0 ymax])
end
%--------------------------------------------------------------------------
%% Plot parameters vs \Delta\phi
%--------------------------------------------------------------------------
close all, clc, clear xdata Wcyc_anti fcyc_anti xamp_anti area_anti legstr
cmap = parula(3); close(gcf);
ind1 = 2; ind2=4;
for dd=ind1:ind2
    xdata{dd-ind1+1} = mod(phasediff_act_cyc{dd,1},2*pi);
    Wcyc_anti{dd-ind1+1} = 2.*avgbeat{dd,1}.Wv_cyc./trapz(BC426.meantime,BC426.meanPv);
    fcyc_anti{dd-ind1+1} = avgbeat{dd,1}.f_cyc;
    xamp_anti{dd-ind1+1} = avgbeat{dd,1}.xamp;
    area_anti{dd-ind1+1} = avgbeat{dd,1}.area;
    legstr{dd-ind1+1} = [num2str(round(flow.Apkpk(dd)*1e3,2)) ' mm/s'];
end

%Wcyc vs fcyc
if 0
    xmin = 0; xmax = 75; ymin = 0; ymax = 1.5;
    figure, hold on, xdata = []; ydata = [];
    for dd=1:3
        xdata = [xdata; fcyc_anti{dd}(:);];
        ydata = [ydata; Wcyc_anti{dd}(:);];
        plot(fcyc_anti{dd},Wcyc_anti{dd},'.','MarkerSize',10,'color',cmap(dd,:))
    end
    p = polyfit(xdata,ydata,1);
    plot([xmin xmax],polyval(p,[xmin xmax]),'r--')
    xlabel('$f_{cyc}$ [Hz]'),ylabel('$\tilde{W}_{cyc} [J]$'),grid on
    xlim([xmin xmax]),ylim([ymin ymax]),legend(legstr,'Location','SouthWest')
end

%Wcyc vs xamp
if 0
    xmin = 0; xmax = 1.5; ymin = 0; ymax = 1.5;
    figure, hold on, xdata = []; ydata = [];
    for dd=1:3
        xdata = [xdata; xamp_anti{dd}(:);];
        ydata = [ydata; Wcyc_anti{dd}(:);];
        plot(xamp_anti{dd},Wcyc_anti{dd},'.','MarkerSize',10,'color',cmap(dd,:))
    end
    a = xdata(:)\ydata(:);
    plot([xmin xmax],a.*[xmin xmax],'r--')
    xlabel('$\Delta x/l_f$ [-]'),ylabel('$\tilde{W}_{cyc} [-]$'),grid on
    xlim([xmin xmax]),ylim([ymin ymax]),legend(legstr,'Location','SouthWest')
end

%fcyc vs xamp
if 0
    xmin = 0; xmax = 75; ymin = 0; ymax = 1.5;
    figure, hold on, xdata = []; ydata = [];
    for dd=1:3
        xdata = [xdata; fcyc_anti{dd}(:);];
        ydata = [ydata; xamp_anti{dd}(:);];
        plot(fcyc_anti{dd},xamp_anti{dd},'.','MarkerSize',10,'color',cmap(dd,:))
    end
    p = polyfit(xdata,ydata,1);
    plot([xmin xmax],polyval(p,[xmin xmax]),'r--')
    xlabel('$f_{cyc}$ [Hz]'),ylabel('$\Delta x/l_f [-]$'),grid on
    xlim([xmin xmax]),ylim([ymin ymax]),legend(legstr,'Location','SouthWest')
end

%--------------------------------------------------------------------------
%% Highlight two beat modes
%--------------------------------------------------------------------------
%[Work per cycle, xamp, fcyc-f0] vs Delta phi
if 0
    figure, 
    hAx1 = axes('Position',[0.15 0.70 0.60 0.25]); 
    hAx2 = axes('Position',[0.15 0.40 0.60 0.20]); 
    hAx3 = axes('Position',[0.15 0.10 0.60 0.20]); 
    hold(hAx1,'on'), clear legstr, cmap = parula(datasets);
        for dd=2:datasets
            xdata = [mod(phasediff_act_cyc{dd,1},2*pi); mod(phasediff_act_cyc{dd,2},2*pi)];
            [xdata,ind] = sort(xdata);
            ydata = 2.*[avgbeat{dd,1}.Wv_cyc'; avgbeat{dd,2}.Wv_cyc';]./...
                trapz(BC426.meantime,BC426.meanPv);
            ydata = ydata(ind)';
            plot(hAx1,xdata,smooth(smooth(ydata,5,'sgolay',1)),'color',cmap(dd,:))
            legstr{dd-1} = [num2str(round(flow.Apkpk(dd).*1e3,1)) ' mm/s'];
        end
        set(hAx1,'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
            'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'},...
            'ylim',[0 1.6],'ytick',0:0.4:1.6);
        xlabel(hAx1,'$\Delta\phi$ [rad]'),ylabel(hAx1,'$\tilde{W}_{cycle}$ [-]')
        grid(hAx1,'on')
    hold(hAx2,'on')
        for dd=2:datasets
            ydata = [avgbeat{dd,1}.xamp'; avgbeat{dd,2}.xamp';]./BC426.xamp;
            ydata = ydata(ind)';
            plot(hAx2,xdata,smooth(smooth(ydata,5,'sgolay',1)),'color',cmap(dd,:))
            legstr{dd-1} = [num2str(round(flow.Apkpk(dd).*1e3,1)) ' mm/s'];
        end
        set(hAx2,'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
            'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'},...
            'ylim',[0.6 1.2],'ytick',0.6:0.2:1.2);
        xlabel(hAx2,'$\Delta\phi$ [rad]'),ylabel(hAx2,'$\Delta x/L$ [-]')
        grid(hAx2,'on')
    hold(hAx3,'on')
        for dd=2:datasets
            ydata = [avgbeat{dd,1}.f_cyc'; avgbeat{dd,2}.f_cyc';]-BC426.fcell;
            ydata = ydata(ind)';
            plot(hAx3,xdata,smooth(smooth(ydata,5,'sgolay',1)),'color',cmap(dd,:))
            legstr{dd-1} = [num2str(round(flow.Apkpk(dd).*1e3,1)) ' mm/s'];
        end
        ymin = -10; ymax = 15;
        set(hAx3,'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
            'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'},...
            'ylim',[ymin ymax],'ytick',ymin:5:ymax);
        xlabel(hAx3,'$\Delta\phi$ [rad]'),ylabel(hAx3,'$f_{cyc}-f_0$ [Hz]')
        grid(hAx3,'on')
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.34 pos(3:4)]);
    saveas(gcf,'NoSync_Wcyc_datasets','epsc')
end

%--------------------------------------------------------------------------
%% Plot full and truncated stroke cycles of 4-26/68
%--------------------------------------------------------------------------
if 0
    for dd=1:6
%         figure, plot(avgbeat{dd,1}.xamp), ylim([0.6 1.4]) %Identify full/truncated strokes
        data = [avgbeat{dd,1}.xamp(:); avgbeat{dd,2}.xamp(:);]./BC426.xamp;
        xamp.mean(dd) = mean(data);
        xamp.std(dd) = std(data);
        xamp.max(dd) = max(data);
        xamp.min(dd) = min(data);
        
        data = [avgbeat{dd,1}.area(:); avgbeat{dd,2}.area(:);]./BC426.area;
        area.mean(dd) = mean(data);
        area.std(dd) = std(data);
        area.max(dd) = max(data);
        area.min(dd) = min(data);
    end
        
    exp = 6; %Experiment to analyze
    
    ind(1)      = 25;   %n-th beat cycle is a full stroke
    ind(2)      = 23;   %n-th beat cycle is a reduced stroke

    %Calculate cell body perimeter
    rmindl  = Rcell(exp,1)*1e6./lflag{exp}; 
    rmajdl  = Rcell(exp,2)*1e6./lflag{exp};
    theta = linspace(0,2*pi,100);
    xcelldl = rmajdl + rmajdl.*cos(theta);
    ycelldl = rmindl.*sin(theta);
    greyclr = [230 230 240]./255;

    fig=figure;
    hAx1 = axes('Position',[0.10 0.15 0.40 0.40]); 
    hAx2 = axes('Position',[0.55 0.15 0.40 0.40]); 
    for ii=1:2
        ind1 = avgbeat{exp,1}.locs(ind(ii));
        ind2 = avgbeat{exp,1}.locs(ind(ii)+1);
        indices = [ind1 ceil(ind1):1:floor(ind2) ind2];
        cmap = jet(length(indices));

        if ii == 1
            ax = hAx1; set(fig, 'currentaxes', ax);
            hold(hAx1,'on'), hold(hAx2,'off')
        else
            ax = hAx2; set(fig, 'currentaxes', ax);
            hold(hAx1,'off'), hold(hAx2,'on')
        end
        plot(ax,xcelldl,ycelldl,'k','LineWidth',1) %Plot cell body
        h1=fill(avgbeat{exp,1}.xhull{ind(ii)},avgbeat{exp,1}.yhull{ind(ii)},greyclr); %Plot swept area
        h2=fill(avgbeat{exp,2}.xhull{ind(ii)},avgbeat{exp,2}.yhull{ind(ii)},greyclr);
        h1.EdgeColor = 'none';      h2.EdgeColor = 'none';
        for jj=1:length(indices)
            for kk=1:2
                xstrk(kk,:) = GIPxdl{exp,kk}({indices(jj),flaggriddl{exp}});
                ystrk(kk,:) = GIPydl{exp,kk}({indices(jj),flaggriddl{exp}});
            end
           plot(ax,xstrk(1,:),ystrk(1,:),'color',cmap(jj,:))
           plot(ax,xstrk(2,:),ystrk(2,:),'color',cmap(jj,:)) 
        end
        axis equal,set(ax,'xlim',[-1 1],'xtick',[-1:0.5:1],...
            'ylim',[-1 1],'ytick',[-1:0.5:1]),grid(ax,'on')
        xlabel(ax,'$x/L$ [-]'),ylabel(ax,'$y/L$ [-]')
        switch ii
            case 1, title('Full stroke')
            case 2, title('Reduced stroke')
        end
    end
    saveas(gcf,'NoSync_Full_trunc_strokes','epsc')
end

%--------------------------------------------------------------------------
%% Find stuff in antiphase
%--------------------------------------------------------------------------
cmap = parula(4);
close all, clear Wcyc_anti fcyc_anti xamp_anti area_anti
ind1 = 2; ind2 = 4;
Wcyc_anti(1) = trapz(BC426.meantime,BC426.meanPv);
fcyc_anti(1) = BC426.fcell;
Zarearelcyc_anti(1) = 1;
xamp_anti(1) = 1;
beta_anti(1,:) = ones(size(BC426.meanomegacphi));
alpha_anti(1,:) = ones(size(BC426.Zphi));
Pvdl_anti(1,:) = BC426.meanPvphidl;
Pedl_anti(1,:) = BC426.meanPephidl;
Ptdl_anti(1,:) = BC426.meanPephidl;
totalFphiscaled(1,:) = ones(size(BC426.meanEFtphi));
xdata = [0 flow.Apkpk(ind1:ind2)*1e3];
clear legstr, legstr{1} = 'No flow';
for dd=ind1:ind2
    ydata1 = mod(phasediff_act_cyc{dd,1},2*pi);
    tol     = 0.1*pi;
    ind = find(ydata1 > pi-tol & ydata1 < pi+tol);
    Wcyc_anti(dd-ind1+2) = 2.*mean(avgbeat{dd,1}.Wv_cyc(ind));
    fcyc_anti(dd-ind1+2) = mean(avgbeat{dd,1}.f_cyc(ind));
    Zarearelcyc_anti(dd-ind1+2) = mean(avgbeat{dd,1}.Z_area_cyc(ind)./BC426.Z_area);
    xamp_anti(dd-ind1+2) = mean(avgbeat{dd,1}.xamp(ind)./BC426.xamp);
    beta_anti(dd-ind1+2,:) = mean(avgbeat{dd,1}.omegacphi(ind,:))./BC426.meanomegacphi;
    alpha_anti(dd-ind1+2,:) = mean(avgbeat{dd,1}.Zphi(ind,:))./BC426.Zphi;
    Pvdl_anti(dd-ind1+2,:) = 2.*mean(avgbeat{dd,1}.Pvphi(ind,:)).*facdlP(dd);
    Pedl_anti(dd-ind1+2,:) = 2.*mean(avgbeat{dd,1}.Pephi(ind,:)).*facdlP(dd);
    Ptdl_anti(dd-ind1+2,:) = 2.*mean(avgbeat{dd,1}.Ptphi(ind,:)).*facdlP(dd);
    totalFphiscaled(dd-ind1+2,:) = avgbeat{dd,3}.meanEFtphi./BC426.meanEFtphi;
    legstr{dd-ind1+2} = [num2str(round(flow.Apkpk(dd)*1e3,2)) ' mm/s'];
end

%Various parameters vs flow velocity
if 0
    figure,plot(xdata,Wcyc_anti,'bo'),grid on
    xlabel('$U_F$ [mm/s]'),ylabel('$W_{cyc}$ [J]')
    ylim([0 2e-15])

    figure,plot(xdata,fcyc_anti,'bo'),grid on
    xlabel('$U_F$ [mm/s]'),ylabel('$f_{cyc}$ [Hz]')
    ylim([0 60])

    figure,plot(xdata,Zarearelcyc_anti,'bo'),grid on
    xlabel('$U_F$ [mm/s]'),ylabel('$Z_{area}$ [-]')
    ylim([0 1.2])

    figure,plot(xdata,xamp_anti,'bo'),grid on
    xlabel('$U_F$ [mm/s]'),ylabel('$x_{amp}$ [-]')
    ylim([0 1.2])
end

%Calculate susceptibility of normalized shape amplitude (alpha)
x = xdata;
X = [ones(length(x),1) x']; 
chi_alpha = zeros(size(phi0));
for pp=1:size(phi0,2)
    alphadata = 1;
    for dd=2:4
        alphadata = [alphadata; alpha_anti(dd,pp);];
    end
    b1 = X\alphadata;      y1 = X*b1;
    chi_alpha(pp) = b1(2);
end

if 0
    figure
    hAx1 = axes('Position',[0.15 0.65 0.60 0.325]); 
    hAx2 = axes('Position',[0.15 0.15 0.60 0.325]); 
    hold(hAx1,'on')
    for dd=1:4
        plot(hAx1,phi0,alpha_anti(dd,:),'color',cmap(dd,:))
    end
    ymin = 0; ymax = 2; ysize = 0.25*(ymax-ymin); yloc = 0.5;
    plot_body_flags(hAx1,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    xlabel(hAx1,'$\phi_{C}$ [rad]'),ylabel(hAx1,'$\alpha$ [-]'),grid(hAx1,'on')
    set(hAx1,'ylim',[ymin ymax],'ytick',ymin:0.5:ymax,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.70 pos(3:4)]);

    plot(hAx2,phi0,chi_alpha), grid on
    set(hAx2,'ylim',[-0.1 0.3],'ytick',-0.1:0.1:0.3,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\chi_{\alpha}$ [$(\mathrm{mm/s})^{-1}$]')
    saveas(gcf,'NoSync_alpha_antiphase','epsc')
end

%Calculate susceptibility of beta
x = xdata;
X = [ones(length(x),1) x']; 
chi_beta = zeros(size(phi0));
for pp=1:length(phi0)
    betadata = 1;
    for dd=2:4
        betadata = [betadata; beta_anti(dd,pp);];
    end
    b1 = X\betadata;      y1 = X*b1;
    chi_beta(pp) = b1(2);
end

if 0
    figure
    hAx1 = axes('Position',[0.15 0.65 0.60 0.325]); 
    hAx2 = axes('Position',[0.15 0.15 0.60 0.325]); 
    hold(hAx1,'on')
    for dd=1:4
        plot(hAx1,phi0,beta_anti(dd,:),'color',cmap(dd,:))
    end
    ymin = 0.6; ymax = 1.4; ysize = 0.25*(ymax-ymin); yloc = 0.8;
    plot_body_flags(hAx1,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    xlabel(hAx1,'$\phi_{C}$ [rad]'),ylabel(hAx1,'$\beta$ [-]'),grid(hAx1,'on')
    set(hAx1,'ylim',[ymin ymax],'ytick',ymin:0.4:ymax,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.70 pos(3:4)]);

    plot(hAx2,phi0,chi_beta), grid on
    set(hAx2,'ylim',[-0.2 0.2],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\chi_{\beta}$ [$(\mathrm{mm/s})^{-1}$]')
    saveas(gcf,'NoSync_beta_antiphase','epsc')
end

%Calculate susceptibility of viscous power
x = xdata;
X = [ones(length(x),1) x']; 
chi_Phi = zeros(size(phi0));
for pp=1:length(phi0)
    Phidata = [];
    for dd=1:4
        Phidata = [Phidata; Pvdl_anti(dd,pp);];
    end
    b1 = X\Phidata;      y1 = X*b1;
    chi_Phi(pp) = b1(2);
end

if 0
    figure
    hAx1 = axes('Position',[0.15 0.65 0.60 0.325]); 
    hAx2 = axes('Position',[0.15 0.15 0.60 0.325]); 
    hold(hAx1,'on')
    for dd=1:4
        plot(hAx1,phi0,Pvdl_anti(dd,:),'color',cmap(dd,:))
    end
    ymin = 0; ymax = 150; ysize = 0.25*(ymax-ymin); yloc = 25;
    plot_body_flags(hAx1,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    xlabel(hAx1,'$\phi_{C}$ [rad]'),ylabel(hAx1,'$\tilde{\Phi}$ [-]'),grid(hAx1,'on')
    set(hAx1,'ylim',[ymin ymax],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.70 pos(3:4)]);

    plot(hAx2,phi0,chi_Phi), grid on
    set(hAx2,'ylim',[-20 20],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\chi_{\tilde{\Phi}}$ [$(\mathrm{mm/s})^{-1}$]')
    saveas(gcf,'NoSync_Pvdl_antiphase','epsc')
end

%Calculate susceptibility of elastic power
x = xdata;
X = [ones(length(x),1) x']; 
chi_E = zeros(size(phi0));
for pp=1:length(phi0)
    PEdata = [];
    for dd=1:4
        PEdata = [PEdata; Pedl_anti(dd,pp);];
    end
    b1 = X\PEdata;      y1 = X*b1;
    chi_E(pp) = b1(2);
end

if 0
    figure
    hAx1 = axes('Position',[0.15 0.65 0.60 0.325]); 
    hAx2 = axes('Position',[0.15 0.15 0.60 0.325]); 
    hold(hAx1,'on')
    for dd=1:4
        plot(hAx1,phi0,Pedl_anti(dd,:),'color',cmap(dd,:))
    end
    ymin = -500; ymax = 500; ysize = 0.25*(ymax-ymin); yloc = -200;
    plot_body_flags(hAx1,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    xlabel(hAx1,'$\phi_{C}$ [rad]'),ylabel(hAx1,'$\tilde{\mathcal{E}}$ [-]'),grid(hAx1,'on')
    set(hAx1,'ylim',[ymin ymax],'ytick',ymin:250:ymax,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.70 pos(3:4)]);

    plot(hAx2,phi0,chi_E), grid on
    set(hAx2,'ylim',[-150 100],'ytick',-100:50:150,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\chi_{\tilde{\mathcal{E}}}$ [$(\mathrm{mm/s})^{-1}$]')
    saveas(gcf,'NoSync_Pedl_antiphase','epsc')
end

%Calculate susceptibility of total force
x = xdata;
X = [ones(length(x),1) x']; 
chi_ft = zeros(size(phi0));
for pp=1:length(phi0)
    FTdata = 1;
    for dd=2:4
        FTdata = [FTdata; totalFphiscaled(dd,pp);];
    end
    b1 = X\FTdata;      y1 = X*b1;
    chi_ft(pp) = b1(2);
end

if 0
    figure
    hAx1 = axes('Position',[0.15 0.65 0.60 0.325]); 
    hAx2 = axes('Position',[0.15 0.15 0.60 0.325]); 
    hold(hAx1,'on')
    for dd=1:4
        plot(hAx1,phi0,totalFphiscaled(dd,:),'color',cmap(dd,:))
    end
    ymin = 0.5; ymax = 1.25; ysize = 0.25*(ymax-ymin); yloc = 0.6;
    plot_body_flags(hAx1,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    xlabel(hAx1,'$\phi_{C}$ [rad]'),ylabel(hAx1,'$\tilde{F_t}$ [-]'),grid(hAx1,'on')
    set(hAx1,'ylim',[ymin ymax],'ytick',ymin:0.25:ymax,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.70 pos(3:4)]);

    plot(hAx2,phi0,chi_ft), grid on
    set(hAx2,'ylim',[-0.1 0.1],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\chi_{\tilde{F_t}}$ [$(\mathrm{mm/s})^{-1}$]')
    saveas(gcf,'NoSync_EFt_antiphase','epsc')
end

%Total power profiles
if 0
    fig=figure('name','Overall mean Ptotaldlphi','NumberTitle','off'); hold on
    ax = fig.Children;
    cmap = jet(4);
    plot(phi0,BC426.meanPtphidl,'LineWidth',1.2,'color',cmap(1,:));
    clear legendstr, legendstr{1} = 'No flow';
    for dd=2:4
        plot(phi0,Ptdl_anti(dd,:),'color',cmap(dd,:));
        legendstr{dd} = [num2str(round(flow.Apkpk(dd)*1e3,2)) ' mm/s'];
    end
    ymin = -500; ymax = 500; ysize = 0.12*(ymax-ymin); yloc = 425;
    plot_body_flags(ax,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    grid on
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\tilde{\mathcal{P}}$ [-]')
    legend(legendstr,'Location','South');
    set(gca,'ylim',[ymin ymax],'ytick',ymin:250:ymax,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    saveas(gcf,'NoSync_Ptdl_antiphase','epsc')
end

%--------------------------------------------------------------------------
%% Plot crosscorrelations for antiphase beat
%--------------------------------------------------------------------------
close all, clc, clear Wcyc_anti fcyc_anti xamp_anti totalFphiscaled
Wcyc_anti{1} = trapz(BC426.meantime,BC426.meanPv);
fcyc_anti{1} = BC426.fcell;
xamp_anti{1} = 1;
totalFphiscaled{1} = 1;
xdata = [0 flow.Apkpk(ind1:ind2)*1e3];
clear legstr, legstr{1} = 'No flow';
for dd=ind1:ind2
    ydata1 = mod(phasediff_act_cyc{dd,1},2*pi);
    tol     = 0.1*pi;
    ind = find(ydata1 > pi-tol & ydata1 < pi+tol);
    Wcyc_anti{dd-ind1+2} = 2.*avgbeat{dd,1}.Wv_cyc(ind);
    fcyc_anti{dd-ind1+2} = avgbeat{dd,1}.f_cyc(ind);
    xamp_anti{dd-ind1+2} = avgbeat{dd,1}.xamp(ind)./BC426.xamp;
    totalFphiscaled{dd-ind1+2} = avgbeat{dd,1}.meanEFt_cyc(ind)./BC426.meanEFt_cyc;
    legstr{dd-ind1+2} = [num2str(round(flow.Apkpk(dd)*1e3,2)) ' mm/s'];
end
mrksz = 20; %Marker size

%1) Wcyc vs fcyc
if 1
    xmin = 0; xmax = 60; ymin = 0; ymax = 3.5e-15;
    figure, hold on, xdata = []; ydata = [];
    for dd=1:4
        if dd>1
            xdata = [xdata; fcyc_anti{dd}(:);];
            ydata = [ydata; Wcyc_anti{dd}(:);];
        end
        plot(fcyc_anti{dd},Wcyc_anti{dd},'.','MarkerSize',mrksz,'color',cmap(dd,:))
    end
    p = polyfit(xdata,ydata,1);
    plot([xmin xmax],polyval(p,[xmin xmax]),'r--')
    xlabel('$f_{cyc}$ [Hz]'),ylabel('$W_{cyc} [J]$'),grid on
    xlim([xmin xmax]),ylim([ymin ymax]),legend(legstr,'Location','SouthWest')
    saveas(gcf,'Antiphase_fcyc_vs_Wcyc','epsc')
end

%2) Wcyc vs xamp
if 1
    xmin = 0; xmax = 1.5; ymin = 0; ymax = 2e-15;
    figure, hold on, xdata = []; ydata = [];
    for dd=1:4
        if dd>1
            xdata = [xdata; xamp_anti{dd}(:);];
            ydata = [ydata; Wcyc_anti{dd}(:);];
        end
        plot(xamp_anti{dd},Wcyc_anti{dd},'.','MarkerSize',mrksz,'color',cmap(dd,:))
    end
%     a = xdata(:)\ydata(:);
%     plot([xmin xmax],a.*[xmin xmax],'r--')
    p = polyfit(xdata,ydata,1);
    plot([xmin xmax],polyval(p,[xmin xmax]),'r--')
    xlabel('$\Delta x/L$ [-]'),ylabel('$W_{cyc} [J]$'),grid on
    xlim([xmin xmax]),ylim([ymin ymax]),legend(legstr,'Location','SouthWest')
    saveas(gcf,'Antiphase_xamp_vs_Wcyc','epsc')
end

%3) F vs fcyc
if 1
    xmin = 0; xmax = 60; ymin = 0; ymax = 1.5;
    figure, hold on, xdata = []; ydata = [];
    for dd=1:4
        if dd>1
            xdata = [xdata; fcyc_anti{dd}(:);];
            ydata = [ydata; totalFphiscaled{dd}(:);];
        end
        plot(fcyc_anti{dd},totalFphiscaled{dd},'.','MarkerSize',mrksz,'color',cmap(dd,:));
    end
    p = polyfit(xdata,ydata,1);
    plot([xmin xmax],polyval(p,[xmin xmax]),'r--')
    xlabel('$f_{cyc}$ [Hz]'),ylabel('$\tilde{F_t} [-]$'),grid on
    xlim([xmin xmax]),ylim([ymin ymax]),legend(legstr,'Location','SouthWest')
    saveas(gcf,'Antiphase_fcyc_vs_Ft','epsc')
end

%4) F vs xamp
if 1
    xmin = 0; xmax = 1.5; ymin = 0; ymax = 1.5;
    figure, hold on, xdata = []; ydata = [];
    for dd=1:4
        if dd>1
            xdata = [xdata; xamp_anti{dd}(:);];
            ydata = [ydata; totalFphiscaled{dd}(:);];
        end
        plot(xamp_anti{dd},totalFphiscaled{dd},'.','MarkerSize',mrksz,'color',cmap(dd,:));
    end
    p = polyfit(xdata,ydata,1);
    plot([xmin xmax],polyval(p,[xmin xmax]),'r--')
    xlabel('$\Delta x/L$ [Hz]'),ylabel('$\tilde{F_t} [-]$'),grid on
    xlim([xmin xmax]),ylim([ymin ymax]),legend(legstr,'Location','SouthWest')
    saveas(gcf,'Antiphase_xamp_vs_Ft','epsc')
end

%5) fcyc vs xamp
if 1
    xmin = 0; xmax = 60; ymin = 0; ymax = 1.5;
    figure, hold on, xdata = []; ydata = [];
    for dd=1:4
        if dd>1
            xdata = [xdata; fcyc_anti{dd}(:);];
            ydata = [ydata; xamp_anti{dd}(:);];
        end
        plot(fcyc_anti{dd},xamp_anti{dd},'.','MarkerSize',mrksz,'color',cmap(dd,:))
    end
    p = polyfit(xdata,ydata,1);
    plot([xmin xmax],polyval(p,[xmin xmax]),'r--')
    xlabel('$f_{cyc}$ [Hz]'),ylabel('$\Delta x/L [-]$'),grid on
    xlim([xmin xmax]),ylim([ymin ymax]),legend(legstr,'Location','SouthWest')
    saveas(gcf,'Antiphase_fcyc_vs_xamp','epsc')
end

% ----------------------------------------------------------------------
%% Plot stroke pattern in antiphase
% ----------------------------------------------------------------------
exp = 4; %Experiment to analyze

%Calculate cell body perimeter
rmindl  = Rcell(exp,1)*1e6./lflag{exp}; 
rmajdl  = Rcell(exp,2)*1e6./lflag{exp};
theta = linspace(0,2*pi,100);
xcelldl = rmajdl + rmajdl.*cos(theta);
ycelldl = rmindl.*sin(theta);
greyclr = 0.95.*[230 230 240]./255;

ydata1   = mod(phasediff_act_cyc{exp,1},2*pi);
tol     = 0.1*pi;
ind     = find(ydata1 > pi-tol & ydata1 < pi+tol);
indices = [];
for ii=1:min(length(ind),5)
   if length(ind) > 5
      ind = ind(1:5); 
   end
   ind1 = avgbeat{exp,1}.locs(ind(ii));
   ind2 = avgbeat{exp,1}.locs(ind(ii)+1);
   indices = [indices ind1 ceil(ind1):1:floor(ind2) ind2];
end
indices = unique(indices);

figure,hold on
cmap = plasma(length(phi0));
cinterp = griddedInterpolant({phi0,1:3},cmap);
plot(xcelldl,ycelldl,'k','LineWidth',1) %Plot cell body
for ii=1:length(ind)
h1=fill(avgbeat{exp,1}.xhull{ind(ii)},avgbeat{exp,1}.yhull{ind(ii)},greyclr); %Plot swept area
h2=fill(avgbeat{exp,2}.xhull{ind(ii)},avgbeat{exp,2}.yhull{ind(ii)},greyclr);
h1.EdgeColor = 'none';      h2.EdgeColor = 'none';
end
for jj=1:length(indices)
    for kk=1:2
        xstrk(kk,:) = GIPxdl{exp,kk}({indices(jj),flaggriddl{exp}});
        ystrk(kk,:) = GIPydl{exp,kk}({indices(jj),flaggriddl{exp}});
    end
   plot(xstrk(1,:),ystrk(1,:),'color',cinterp({mod(GIPphic{exp,1}(indices(jj)),2*pi),1:3}))
   plot(xstrk(2,:),ystrk(2,:),'color',cinterp({mod(GIPphic{exp,1}(indices(jj)),2*pi),1:3}))
end
axis equal, grid on
set(gca,'xlim',[-1 1],'xtick',-1:0.5:1,'ylim',[-1 1],'ytick',-1:0.5:1)
xlabel('$x/L$ [-]'),ylabel('$y/L$ [-]')

saveas(gcf,'NoSync_stroke_pattern_antiphase','epsc')
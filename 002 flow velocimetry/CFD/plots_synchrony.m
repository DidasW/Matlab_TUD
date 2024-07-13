clear legendstr
close all, clc, dbclear all
cmap = jet(datasets+1); close(gcf);

anglist = 0:pi/2:2*pi;
xloclist = anglist;
xsize = 0.2*pi;
%--------------------------------------------------------------------------
% Plot random shite
%--------------------------------------------------------------------------
%% Kinematics
close all

B1(1,:)     = BC426.BlimitGIP{1}(phi0); 
B2(1,:)     = BC426.BlimitGIP{2}(phi0); 
zeta(1,:)   = sqrt(B1(1,:).^2+B2(1,:).^2);
alpha(1,:)  = ones(size(phi0));
UFU0(1)     = 0;
meanxamp(1) = BC426.xamp;
meanarea(1) = BC426.area;
for dd=1:datasets
    B1(dd+1,:)      = 0.5.*(BlimitGIP{dd,1,1}(phi0)+BlimitGIP{dd,2,1}(phi0));
    B2(dd+1,:)      = 0.5.*(BlimitGIP{dd,1,2}(phi0)+BlimitGIP{dd,2,2}(phi0));
    zeta(dd+1,:)    = sqrt(B1(dd,:).^2+B2(dd,:).^2);
    UFU0(dd+1)      = flow.Apkpk(dd)./Ufs;
    meanxamp(dd+1)  = mean(0.5.*(avgbeat{dd,1}.xamp+avgbeat{dd,2}.xamp));
    meanarea(dd+1)  = mean(0.5.*(avgbeat{dd,1}.area+avgbeat{dd,2}.area));
end
for dd=1:datasets+1
    alpha(dd,:)   	= zeta(dd,:)./zeta(1,:);
    avalpha(dd)     = mean(alpha(dd,:));
end

%Plot limit cycles
%(Not useful: no variation visible on visual inspection)
if 0
    figure, hold on, 
    for dd=1:datasets+1
        plot(B1(dd,:),B2(dd,:),'color',cmap(dd,:))
    end
end

%Plot limit cycle amplitude
%(Raw cycle amplitude is not useful: not variations visible with naked eye)
%(Scaled limit cycle is also very hard to link to actual kinematics)
if 0
    figure, hold on,
    for dd=1:datasets+1
        plot(phi0,alpha(dd,:),'color',cmap(dd,:))
    end
    grid on, xlabel('$\phi_C$ [rad]'), ylabel('$\alpha$ [-]')
    set(gca,...%'ylim',[0.7 1.3],'ytick',0.7:0.3:1.3,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
end

%Plot average alpha vs U_F/U_0
%(Useless: pretty much a straight line)
if 0
    figure, plot(UFU0,avalpha,'ko')
    grid on, xlabel('$U_F/U_0$ [-]'), ylabel('$\langle\alpha\rangle$ [-]')
    set(gca,'xlim',[0 25],'ylim',[0 1.5])
end

%Plot average stroke amplitude vs U_F/U_0
%+ Slight increase in stroke amplitude visible with increasing flow
%amplitude
if 0
    figure, plot(UFU0,meanxamp,'ko--','MarkerFaceColor','k')
    grid on, xlabel('$U_F/U_0$ [-]'), ylabel('$\langle \Delta x \rangle / L$ [-]')
    set(gca,'xlim',[0 25],'ylim',[0 1.5])
    saveas(gcf,'Sync_stroke_amplitude_vs_UFU0','epsc')
end

%Plot average stroke area vs U_F/U_0
%+ Slight increase in stroke area visible with increasing flow
%amplitude
if 0
    figure, plot(UFU0,meanarea,'ko--','MarkerFaceColor','k')
    grid on, xlabel('$U_F/U_0$ [-]'), ylabel('$\langle area \rangle$ [-]')
    set(gca,'xlim',[0 25],'ylim',[0 0.006])
end

%Plot crosscorrelations
if 0
%Significant correlation, although this is expected (variables not independent)
figure,plot(meanxamp,meanarea,'ko','MarkerFaceColor','k')
grid on, xlabel('$\langle x_{amp} \rangle$ [-]'),ylabel('$\langle area \rangle$ [-]')
set(gca,'xlim',[0 1.5],'ylim',[0 1.5])

%No significant correlation
figure,plot(avalpha,meanxamp,'ko','MarkerFaceColor','k')
grid on, xlabel('$\langle x_{amp} \rangle$ [-]'),ylabel('$\langle area \rangle$ [-]')
set(gca,'xlim',[0 1.5],'ylim',[0 1.5])

%No significant correlation
figure,plot(avalpha,meanarea,'ko','MarkerFaceColor','k')
grid on, xlabel('$\langle\alpha\rangle$ [-]'),ylabel('$\langle area \rangle$ [-]')
set(gca,'xlim',[0 1.5],'ylim',[0 1.5])
end

%% Kinetics
cmap = parula(datasets+1);
UFU0(1)     = 0;
meanarea(1) = BC426.area;
totalFphi(1,:) = BC426.meanEFtphi;
Wv_cyc(1) = trapz(BC426.meantime,BC426.meanPv);
for dd=1:datasets
    UFU0(dd+1)          = flow.Apkpk(dd)./Ufs;
    totalFphi(dd+1,:)   = 0.5.*(avgbeat{dd,1}.meanEFtphi+avgbeat{dd,2}.meanEFtphi);
    peakforce(dd,:)     = 0.5.*(avgbeat{dd,1}.meanftdenspeak+avgbeat{dd,2}.meanftdenspeak);
    Wv_cyc(dd+1)        = 2.*mean([avgbeat{dd,1}.Wv_cyc(:); avgbeat{dd,2}.Wv_cyc(:);]);
end
for dd=1:datasets+1
    avalpha(dd)     = mean(alpha(dd,:));
    totalFphiscaled(dd,:) = totalFphi(dd,:)./totalFphi(1,:);
    meanEFt(dd)     = mean(totalFphi(dd,:));
end

%Plot total force profiles vs cell angle
if 0
    figure, hold on
    for dd=1:datasets+1
        plot(phi0,totalFphiscaled(dd,:),'color',cmap(dd,:))
    end
    grid on, xlabel('$\phi_C$ [-]'), ylabel('$\langle \sum F \rangle$ [N]')
    set(gca,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
end

%Plot peak force profiles vs cell angle
if 0
    figure, hold on
    for dd=1:datasets
        plot(phi0,smooth(peakforce(dd,:)),'color',cmap(dd+1,:))
    end
    grid on, xlabel('$\phi_C$ [-]'), ylabel('$\langle f_{peak} \rangle$ [N]')
    set(gca,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
end

%Mean total force over cycle vs UFU0

if 1
    figure, plot(UFU0,meanEFt, 'ko--','MarkerFaceColor','k')
    grid on, xlabel('$U_F/U_0$ [-]'),ylabel('$\langle F_t \rangle$ [N]')
    set(gca,'xlim',[0 25],'ylim',[0 6e-8])
    saveas(gcf,'Sync_meanEFt_UFU0','epsc')
end

%Work per cycle vs UFU0
%(Useless: no trend whatsoever)
if 1
    figure, plot(UFU0,Wv_cyc, 'ko--','MarkerFaceColor','k')
    grid on, xlabel('$U_F/U_0$ [-]'),ylabel('$\langle W_{cyc} \rangle$ [J]')
    set(gca,'xlim',[0 25],'ylim',[0 2e-15])
    saveas(gcf,'Sync_meanWccyc_UFU0','epsc')
end

%Work per cycle vs beat amplitude
%(Useless: no trend whatsoever)
if 0
    xmin = 0; xmax = 1.5; ymin = 0; ymax = 2e-15;
    figure, hold on, xdata = []; ydata = [];
    for dd=1:datasets+1
        xdata = [xdata; meanxamp(dd);];
        ydata = [ydata; Wv_cyc(dd);];
        plot(meanxamp(dd),Wv_cyc(dd),'.','MarkerSize',10,'color',cmap(dd,:))
    end
    p = polyfit(xdata,ydata,1);
    plot([xmin xmax],polyval(p,[xmin xmax]),'r--')
    xlabel('$\langle \Delta x \rangle /L$ [-]'),ylabel('$W_{cyc}$ [J]'),grid on
    xlim([xmin xmax]),ylim([ymin ymax]),legend(legstr,'Location','SouthWest')
end
%--------------------------------------------------------------------------
%% Total power profiles
%--------------------------------------------------------------------------
if 0
    fig=figure('name','Overall mean Ptotaldlphi','NumberTitle','off'); hold on
    ax = fig.Children;
    cmap = jet(datasets+1);
    plot(phi0,smooth(BC426.meanPtphidl),'color',cmap(1,:),'LineWidth',0.8);
    legendstr{1} = 'No flow';
    for dd=1:datasets
        plot(phi0,smooth(avgbeat{dd,3}.meanPtphidl),'color',cmap(dd+1,:));
        legendstr{dd+1} = [num2str(round(flow.Apkpk(dd)*1e3,2)) ' mm/s'];
    end
    ymin = -500; ymax = 500; ysize = 0.12*(ymax-ymin); yloc = 420;
    plot_body_flags(ax,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    grid on
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\tilde{\mathcal{P}}$ [-]')
    legend(legendstr,'Location','South');
    set(gca,'ylim',[ymin ymax],'ytick',ymin:250:ymax,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    saveas(gcf,'Sync_total_power_profiles','epsc')
end
%--------------------------------------------------------------------------
%% Plot profiles and susceptibilities of kinematics, kinetics
%--------------------------------------------------------------------------
cmap = jet(datasets+1);
% cmap = interp1(1:1000,parula(1000),linspace(150,1000,datasets+1));
close all, dbclear all
alpha_sync(1,:) = ones(size(BC426.Zphi));
beta_sync(1,:) = ones(size(BC426.meanomegacphi));
Pvdl_sync(1,:) = BC426.meanPvphidl; %Both flagella
Pedl_sync(1,:) = BC426.meanPephidl; %Both flagella
ftdenstip_sync(1,:) = ones(size(BC426.meanftdensphitip)); %One flagellum
totalFphiscaled(1,:) = ones(size(BC426.meanEFtphi));
xdata = [0 flow.Apkpk*1e3];
clear legstr, legstr{1} = 'No flow';
for dd=1:datasets
    alpha_sync(dd+1,:) = 0.5.*(avgbeat{dd,1}.meanZphi+...
        avgbeat{dd,2}.meanZphi)./BC426.Zphi;
    beta_sync(dd+1,:) = 0.5.*(avgbeat{dd,1}.meanomegacphi+...
        avgbeat{dd,2}.meanomegacphi)./BC426.meanomegacphi;
    Pvdl_sync(dd+1,:) = avgbeat{dd,3}.meanPvphidl;
    Pedl_sync(dd+1,:) = avgbeat{dd,3}.meanPephidl;
    ftdenstip_sync(dd+1,:) = avgbeat{dd,1}.meanftdensphitip./BC426.meanftdensphitip;
    totalFphiscaled(dd+1,:) = avgbeat{dd,3}.meanEFtphi./BC426.meanEFtphi;
    legstr{dd+1} = [num2str(round(flow.Apkpk(dd)*1e3,2)) ' mm/s'];
end
x = xdata;
X = [ones(length(x),1) x']; 

%Calculate susceptibility of normalized shape amplitude (alpha)
chi_alpha = zeros(size(phi0));
for pp=1:size(phi0,2)
    alphadata = 1;
    for dd=1:datasets
        alphadata = [alphadata; alpha_sync(dd,pp);];
    end
    b1 = X\alphadata;      y1 = X*b1;
    chi_alpha(pp) = b1(2);
end

if 0
    figure
    hAx1 = axes('Position',[0.15 0.65 0.60 0.325]); 
    hAx2 = axes('Position',[0.15 0.15 0.60 0.325]); 
    hold(hAx1,'on')
    for dd=1:datasets+1
        plot(hAx1,phi0,smooth(alpha_sync(dd,:)),'color',cmap(dd,:))
    end
    xlabel(hAx1,'$\phi_{C}$ [rad]'),ylabel(hAx1,'$\alpha$ [-]'),grid(hAx1,'on')
    ymin = 0.6; ymax = 1.4; ysize = 0.25*(ymax-ymin); yloc = 0.7;
    plot_body_flags(hAx1,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    set(hAx1,'ylim',[ymin ymax],'ytick',ymin:0.4:ymax,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.57 pos(3:4)]);

    plot(hAx2,phi0,smooth(chi_alpha)), grid on, hold on
    set(hAx2,'ylim',[-0.1 0.1],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\chi_{\alpha}$ [$(\mathrm{mm/s})^{-1}$]')
    saveas(gcf,'Synchrony_alpha','epsc')
end

%Calculate susceptibility of beta
chi_beta = zeros(size(phi0));
for pp=1:length(phi0)
    betadata = 1;
    for dd=1:datasets
        betadata = [betadata; beta_sync(dd,pp);];
    end
    b1 = X\betadata;      y1 = X*b1;
    chi_beta(pp) = b1(2);
end

if 0
    figure
    hAx1 = axes('Position',[0.15 0.65 0.60 0.325]); 
    hAx2 = axes('Position',[0.15 0.15 0.60 0.325]); 
    hold(hAx1,'on')
    for dd=1:datasets+1
        plot(hAx1,phi0,smooth(beta_sync(dd,:)),'color',cmap(dd,:))
    end
    xlabel(hAx1,'$\phi_{C}$ [rad]'),ylabel(hAx1,'$\beta$ [-]'),grid(hAx1,'on')
    ymin = 0.5; ymax = 1.25; ysize = 0.22*(ymax-ymin); yloc = 0.7;
    plot_body_flags(hAx1,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    set(hAx1,'ylim',[ymin ymax],'ytick',[0.5 0.75 1 1.25],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.57 pos(3:4)]);

    plot(hAx2,phi0,smooth(chi_beta)), grid on
    set(hAx2,'ylim',[-0.1 0.1],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\chi_{\beta}$ [$(\mathrm{mm/s})^{-1}$]')
    saveas(gcf,'Synchrony_beta','epsc')
end

%Calculate susceptibility of viscous power
chi_Phi = zeros(size(phi0));
for pp=1:length(phi0)
    Phidata = [];
    for dd=1:datasets+1
        Phidata = [Phidata; Pvdl_sync(dd,pp);];
    end
    b1 = X\Phidata;      y1 = X*b1;
    chi_Phi(pp) = b1(2);
end

if 0
    figure
    hAx1 = axes('Position',[0.15 0.65 0.60 0.325]); 
    hAx2 = axes('Position',[0.15 0.15 0.60 0.325]); 
    hold(hAx1,'on')
    for dd=1:datasets+1
        plot(hAx1,phi0,smooth(Pvdl_sync(dd,:)),'color',cmap(dd,:))
    end
    ymin = 0; ymax = 150; ysize = 0.22*(ymax-ymin); yloc = 18;
    plot_body_flags(hAx1,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    xlabel(hAx1,'$\phi_{C}$ [rad]'),ylabel(hAx1,'$\tilde{\Phi}$ [-]'),grid(hAx1,'on')
    set(hAx1,'ylim',[ymin ymax],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.57 pos(3:4)]);

    plot(hAx2,phi0,smooth(chi_Phi)), grid on
    set(hAx2,'ylim',[-20 10],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\chi_{\tilde{\Phi}}$ [$(\mathrm{mm/s})^{-1}$]')
    saveas(gcf,'Synchrony_Pvdl','epsc')
end

%Calculate susceptibility of elastic power
chi_E = zeros(size(phi0));
for pp=1:length(phi0)
    PEdata = [];
    for dd=1:datasets+1
        PEdata = [PEdata; Pedl_sync(dd,pp);];
    end
    b1 = X\PEdata;      y1 = X*b1;
    chi_E(pp) = b1(2);
end

if 1
    figure
    hAx1 = axes('Position',[0.15 0.65 0.60 0.325]); 
    hAx2 = axes('Position',[0.15 0.15 0.60 0.325]); 
    hold(hAx1,'on')
    for dd=1:datasets+1
        plot(hAx1,phi0,smooth(Pedl_sync(dd,:)),'color',cmap(dd,:))
    end
    ymin = -500; ymax = 500; ysize = 0.22*(ymax-ymin); yloc = -150;
    plot_body_flags(hAx1,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    xlabel(hAx1,'$\phi_{C}$ [rad]'),ylabel(hAx1,'$\tilde{\mathcal{E}}$ [-]'),grid(hAx1,'on')
    set(hAx1,'ylim',[ymin ymax],'ytick',ymin:250:ymax,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.57 pos(3:4)]);

    plot(hAx2,phi0,smooth(chi_E)), grid on
    set(hAx2,'ylim',[-50 50],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\chi_{\tilde{\mathcal{E}}}$ [$(\mathrm{mm/s})^{-1}$]')
    saveas(gcf,'Synchrony_Pedl','epsc')
end

%Calculate susceptibility total force
chi_FT = zeros(size(phi0));
for pp=1:length(phi0)
    FTdata = 1;
    for dd=1:datasets
        FTdata = [FTdata; totalFphiscaled(dd,pp);];
    end
    b1 = X\FTdata;      y1 = X*b1;
    chi_FT(pp) = b1(2);
end

if 0
    figure
    hAx1 = axes('Position',[0.15 0.65 0.60 0.325]); 
    hAx2 = axes('Position',[0.15 0.15 0.60 0.325]); 
    hold(hAx1,'on')
    for dd=1:datasets+1
        plot(hAx1,phi0,smooth(totalFphiscaled(dd,:)),'color',cmap(dd,:))
    end
    ymin = 0; ymax = 2; ysize = 0.22*(ymax-ymin); yloc = 0.4;
    plot_body_flags(hAx1,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    xlabel(hAx1,'$\phi_{C}$ [rad]'),ylabel(hAx1,'$\tilde{F_t}$ [-]'),grid(hAx1,'on')
    set(hAx1,'ylim',[ymin ymax],...%'ytick',[0.4 0.7 1 1.3 1.6],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    h=legend(hAx1,legstr); pos=get(h,'position');
    set(h,'position',[0.75 0.57 pos(3:4)]);

    plot(hAx2,phi0,smooth(chi_FT)), grid on
    set(hAx2,...%'ylim',[-0.2 0.1],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\chi_{\tilde{F_t}}$ [$(\mathrm{mm/s})^{-1}$]')
    saveas(gcf,'Synchrony_Ftotal','epsc')
end

% ----------------------------------------------------------------------
%% Plot stroke pattern
% ----------------------------------------------------------------------
exp = 6; %Experiment to analyze

ind(1)      = 1;   %First cycle to analyze
ind(2)      = 5;   %Last cycle to plot

%Calculate cell body perimeter
rmindl  = Rcell(exp,1)*1e6./lflag{exp}; 
rmajdl  = Rcell(exp,2)*1e6./lflag{exp};
theta = linspace(0,2*pi,100);
xcelldl = rmajdl + rmajdl.*cos(theta);
ycelldl = rmindl.*sin(theta);
greyclr = 0.95.*[230 230 240]./255;


ind1 = avgbeat{exp,1}.locs(ind(1));
ind2 = avgbeat{exp,1}.locs(ind(2)+1);
indices = [ind1 ceil(ind1):1:floor(ind2) ind2];

if 1
    figure,hold on
    cmap = plasma(length(phi0));
    cinterp = griddedInterpolant({phi0,1:3},cmap);
    plot(xcelldl,ycelldl,'k','LineWidth',1) %Plot cell body
    for ii=ind(1):ind(2)
    h1=fill(avgbeat{exp,1}.xhull{ii},avgbeat{exp,1}.yhull{ii},greyclr); %Plot swept area
    h2=fill(avgbeat{exp,2}.xhull{ii},avgbeat{exp,2}.yhull{ii},greyclr);
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
    xlabel('$x/L$ [-]'),ylabel('$y/L$ [-]')
    axis equal
    set(gca,'xlim',[-1 1],'xtick',-1:0.5:1,...
        'ylim',[-1 1],'ytick',-1:0.5:1),grid on
    
    saveas(gcf,'Sync_stroke_pattern','epsc')
end
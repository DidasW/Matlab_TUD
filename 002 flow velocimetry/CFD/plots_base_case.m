greyclr = ([230 230 230])./255; %Color of the shaded band between the percentiles
set(0,'defaulttextinterpreter','latex')
set(0,'DefaultAxesFontSize',16)
close all; dbclear all

anglist = 0:pi/2:2*pi;
xloclist = anglist;
xsize = 0.2*pi;
%----------------------------------------------------------------------
%% Overall averages
%----------------------------------------------------------------------
%Viscous power profile
if 0
    fig=figure('name','Overall mean Pvisdlphi','NumberTitle','off'); hold on
    axhandle = fig.Children; ymin = 0; ymax = 140; ysize = (ymax-ymin)/10;
    plot(phi0,ovPvphidlp(1,:),'k--')
    plot(phi0,ovPvphidlp(4,:),'k--')
    fill([phi0,fliplr(phi0)],...
        [ovPvphidlp(2,:),fliplr(ovPvphidlp(3,:))],greyclr,'EdgeColor','none')
    plot(phi0,ovmeanPvphidl,'b')
    plot_body_flags(axhandle,anglist,xloclist,20,xsize,ysize,BC,kappasave,Rcell)
    grid(axhandle,'on'),
    xlabel(axhandle,'$\phi_{C}$ [rad]'),ylabel(axhandle,'$\tilde{\Phi}$ [-]')
    set(axhandle,'ylim',[ymin ymax],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    saveas(fig,'Base_case_mean_Pvdlphi_profile','epsc')
end
%Elastic power profile
if 0
    figure('name','Overall mean Peldlphi','NumberTitle','off'), hold on
    plot(datapts,ovPedlpminn,'k--'),plot(datapts,ovPedlpmaxx,'k--')
    fill([datapts,fliplr(datapts)],[ovPedlpmin,fliplr(ovPedlpmax)],greyclr,'EdgeColor','none')
    plot(datapts,ovmeanPedl,'b')
    grid on, xlabel('$\phi_{C}$ [rad]'),ylabel('$\tilde{P}$ [-]')
    saveas(gcf,'Base_case_mean_Pedlphi_profile.tex','epsc')
end
%Total power profile
if 1
    fig=figure('name','Overall mean Ptotaldlphi','NumberTitle','off'); hold on
    ax = fig.Children;
    p1=plot(phi0,ovmeanPtphidl,'k');
    p2=plot(phi0,ovmeanPvphidl,'b');
    p3=plot(phi0,ovmeanPephidl,'r');
    ymin = -500; ymax = 500; ysize = 0.12*(ymax-ymin); yloc = -200;
    plot_body_flags(ax,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    grid on,xlabel('$\phi_{C}$ [rad]'),ylabel('$\tilde{P}$ [-]')
    h=legend([p1,p2,p3],'$\tilde{\mathcal{P}}$',...
        '$\tilde{\Phi}$','$\tilde{\mathcal{E}}$','Location','best');
    set(h,'Interpreter','latex')
    set(gca,'ylim',[ymin ymax],'ytick',ymin:250:ymax,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    saveas(gcf,'Base_case_mean_Ptdlphi_profile','epsc')
end
%----------------------------------------------------------------------
%% Overall average elastic power and energy
%----------------------------------------------------------------------
if 0
figure('name','Overall mean Pephidl profiles','NumberTitle','off'), 
    ymin = -1000; ymax = 500; ysize = (ymax-ymin)/5;
    yloc = ymin + 0.2*(ymax-ymin);
    axhandle=subplot(2,1,1);hold(axhandle,'on')
    plot(axhandle,phi0,ovPephidlp(1,:),'k--')
    plot(axhandle,phi0,ovPephidlp(4,:),'k--')
    fill([phi0,fliplr(phi0)],...
        [ovPephidlp(2,:),fliplr(ovPephidlp(3,:))],greyclr,'EdgeColor','none')
    plot(axhandle,phi0,ovmeanPephidl,'b')
    plot_body_flags(axhandle,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    grid(axhandle,'on'),ylim([ymin ymax])
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\tilde{\mathcal{E}}$ [-]')%ylabel('$\tilde{P}$ [-]')
    set(axhandle,'ylim',[ymin ymax],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
subplot(2,1,2),hold on
    plot(phi0,ovEephidlp(1,:),'k--')
    plot(phi0,ovEephidlp(4,:),'k--')
    fill([phi0,fliplr(phi0)],...
        [ovEephidlp(2,:),fliplr(ovEephidlp(3,:))],greyclr,'EdgeColor','none')
    plot(phi0,ovmeanEephidl,'b')
    grid on,ylim([0 inf])
    xlabel('$\phi_{C}$ [rad]'),ylabel('$\tilde{\epsilon}$ [-]')%ylabel('$\tilde{P}$ [-]')
    set(gca,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    saveas(gcf,'Base_case_mean_Pedlphi_profile','epsc')
end
% ----------------------------------------------------------------------
%% Overall average flagellar force distribution
% ----------------------------------------------------------------------
if 0
    xdata = phi0;
    ydata = flaginterpgrid;
    zdata = ovft;
    figure,surf(xdata,ydata,zdata','LineStyle','none')
    view([0 90]),colormap inferno;shading interp;colorbar,caxis([0 3e-9]);
    ylabel('$s/L$ [-]'),xlabel('$\phi_C$ [rad]')
    set(gca,...
     'ylim',[0 1],'ytick',0:0.2:1,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    saveas(gcf,'Base_case_mean_ft','epsc')
end
if 1
    xdata = phi0;
    ydata = flaginterpgrid;
    zdata = ovftdens;
    fig=figure; hold on, 
    axhandle = fig.Children; ymin = 0; ymax = 1; ysize = (ymax-ymin)/10; yloc = 0.1;
    surf(xdata,ydata,zdata','LineStyle','none')
    plot_body_flags(axhandle,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    view([0 90]),colormap inferno;colorbar,caxis([0 0.6e-2]);shading interp
    grid on
    ylabel('$s/L$ [-]'),xlabel('$\phi_C$ [rad]')
    set(gca,...
     'ylim',[0 1],'ytick',0:0.2:1,...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
     saveas(gcf,'Base_case_mean_ftdens','png')
end
%Tip force vs cell angle
if 0
    figure, hold on
%     plot(phi0,ovftdens(:,end),'b')
    plot(phi0,ovmeanftdensphitip,'b','LineWidth',0.8)
    set(gca,'ylim',[0 6e-3],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
    xlabel('$\phi_{C}$ [rad]'),ylabel('$f$ [N/m]'), grid on
    saveas(gcf,'Base_case_fdens_tip','epsc')
end


% ----------------------------------------------------------------------
%% Compare with Guasto
% ----------------------------------------------------------------------
if 0
    xloclist = 0:0.25:1; xsize = 1/10;
    anglist = interp1(datapts,ovmeanphic,xloclist);
    ymin = 0; ymax = 120; ysize = (ymax-ymin)/10; yloc = 30;
    fig=figure; hold on, axhandle = fig.Children; 
%     plot(datapts,circshift(ovmeanPvscdl,[0 -13]),'b')
    plot(axhandle,datapts,interp1(phi0,ovmeanPvphidl,ovmeanphic,'linear','extrap'),'b')
    plot(axhandle,Gua.tdldata,Gua.Pdatadl,'rs-','MarkerFaceColor','r')
    plot(axhandle,datapts,Gua.P_unsteadydl,'r--')
    plot_body_flags(axhandle,anglist,xloclist,yloc,xsize,ysize,BC,kappasave,Rcell)
    grid(axhandle,'on'), xlabel(axhandle,'Dimensionless cycle time $t/\tau$ [-]')
    ylabel(axhandle,'$\tilde{\Phi}$ [-]')
    legend(axhandle,'This study','Guasto et al. (2010)','Stokes drag on sphere')
    set(axhandle,'xlim',[0 1],'xtick',xloclist,...
        'ylim',[ymin ymax],'ytick',ymin:20:ymax)
    saveas(fig,'Guasto_comparison','epsc')
end
% ----------------------------------------------------------------------
%% Plot stroke pattern
% ----------------------------------------------------------------------
if 0
exp = 1; %Experiment to analyze

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
axis equal,set(gca,'xlim',[-1 1],'xtick',-1:0.5:1,...
    'ylim',[-1 1],'ytick',-1:0.5:1), grid on
xlabel('$x/L$ [-]'),ylabel('$y/L$ [-]')
    saveas(gcf,'Basecase_stroke_pattern','epsc')
end

% ----------------------------------------------------------------------
%% Plot limit cycle versus cell angle
% ----------------------------------------------------------------------
if 0
    phistep = pi/5;
    angplot = 0:phistep:2*pi-phistep;
    Bplot = zeros(2,nmodeslimit,length(angplot));
    %Get shape scores
    for lr=1:2
        for nn=1:nmodeslimit
            Bplot(lr,nn,:) = BC.BlimitGIP{nn}(angplot);
        end
    end
    %Calculate xy-version of shapes, plot together with cell body
    nsteps = 40; lf = 10; nodes = size(kappasave,3);
    Lgrid = linspace(0,lf,nodes-1);   %Grid to interpolate curvature
    ssc  = linspace(0,lf,nsteps);  %Location of xy-nodes
    rotation = pi/2;
    [xf,yf] = deal(zeros(length(angplot),2,nsteps));
    legendstr = cell(length(angplot),1);
    for aa=1:length(angplot)
        for lr=1:2
            curv = (PCA_store(1,2:end) + squeeze(Bplot(lr,:,aa))*...
                PCA_store(2:nmodeslimit+1,2:end))./lf;
            phi_0 = PCA_store(1,1) + squeeze(Bplot(lr,:,aa))*...
                PCA_store(2:nmodeslimit+1,1);
            if lr == 1;
                GIP = griddedInterpolant(Lgrid,-curv,'linear');
            else
                GIP = griddedInterpolant(Lgrid,curv,'linear');
            end
            kappa = GIP(ssc);
            if lr == 1
                Ytot = curv2xy_quick(kappa,ssc,...
                    (rotation-(thetabase(1,1)-thetabase(1,3))-phi_0),0,0);
            else
                Ytot = curv2xy_quick(kappa,ssc,...
                    (rotation-(thetabase(1,2)-thetabase(1,3))+phi_0),0,0);
            end
            xf(aa,lr,:) = Ytot(:,2);
            yf(aa,lr,:) = Ytot(:,3);
        end
        legendstr{aa} = [num2str(angplot(aa)/pi) '\pi'];
    end
    cc=parula(length(angplot)); %Colormaps
    rmin = Rcell(1,1)*1e6; rmaj = Rcell(1,2)*1e6; %Minor, major cell radius
    thel = linspace(0,2*pi,100);
    xel  = rmin*cos(thel);
    yel  = -rmaj+rmaj*sin(thel);
    figure,hold on
    for ii=1:length(angplot)
        hfig(ii)=plot(squeeze(xf(ii,1,:)),squeeze(yf(ii,1,:)),'color',cc(ii,:));
        plot(squeeze(xf(ii,2,:)),squeeze(yf(ii,2,:)),'color',cc(ii,:))
    end
    plot(xel,yel,'k'),axis equal
    set(gca,'xlim',[-10 10],'xtick',[-10 -5 0 5 10],...
        'ylim',[-10 10],'ytick',[-10 -5 0 5 10])
    grid on,,xlabel('x [$\mu$m]'),ylabel('y [$\mu$m]')
    legend(hfig,legendstr,'Location','EastOutside');
    saveas(gcf,'Waveforms_vs_cell_angle','epsc');
end
% ----------------------------------------------------------------------
%% Plot limit cycle with varying magnitude
% ----------------------------------------------------------------------
if 0   
    clear hfig
    phistep = pi/2;                     %Step in angle to plot
    angplot = 0:phistep:2*pi-phistep;   %Limit cycle angles to plot
    magplot = [0.8 1 1.2];              %Limit cycle magnitudes to plot
    cc = plasma(length(magplot));close(gcf);
    Bplot = zeros(length(magplot),2,nmodeslimit,length(angplot));
    %Get shape scores
    for lr=1:2
        for nn=1:nmodeslimit
            Bplot(2,lr,nn,:) = BC.BlimitGIP{nn}(angplot);
        end
    end
    for mm = [1 3];
        for aa=1:length(angplot)
            Bplot(mm,:,1,aa) = magplot(mm).*Bplot(2,:,1,aa);
            Bplot(mm,:,2,aa) = magplot(mm).*Bplot(2,:,2,aa);
        end
    end
    %Calculate xy-version of shapes, plot together with cell body
    nsteps = 40; lf = 10; nodes = size(kappasave,3);
    Lgrid = linspace(0,lf,nodes-1);   %Grid to interpolate curvature
    ssc  = linspace(0,lf,nsteps);  %Location of xy-nodes
    rotation = pi/2;
    [xf,yf] = deal(zeros(length(magplot),length(angplot),2,nsteps));
    legendstr = cell(length(angplot),1);
    for mm = 1:3
        for aa=1:length(angplot)
            for lr=1:2
                curv = (PCA_store(1,2:end) + squeeze(Bplot(mm,lr,:,aa))'*...
                    PCA_store(2:nmodeslimit+1,2:end))./lf;
                phi_0 = PCA_store(1,1) + squeeze(Bplot(mm,lr,:,aa))'*...
                    PCA_store(2:nmodeslimit+1,1);
                if lr == 1;
                    GIP = griddedInterpolant(Lgrid,-curv,'linear');
                else
                    GIP = griddedInterpolant(Lgrid,curv,'linear');
                end
                kappa = GIP(ssc);
                if lr == 1
                    Ytot = curv2xy_quick(kappa,ssc,...
                        (rotation-(thetabase(1,1)-thetabase(1,3))-phi_0),0,0);
                else
                    Ytot = curv2xy_quick(kappa,ssc,...
                        (rotation-(thetabase(1,2)-thetabase(1,3))+phi_0),0,0);
                end
                xf(mm,aa,lr,:) = Ytot(:,2);
                yf(mm,aa,lr,:) = Ytot(:,3);
            end
            %legendstr{aa} = [num2str(angplot(aa)/pi) '\pi'];
        end
        legendstr{mm}=num2str(magplot(mm));
    end
    rmin = Rcell(1,1)*1e6; rmaj = Rcell(1,2)*1e6; %Minor, major cell radius
    thel = linspace(0,2*pi,100);
    xel  = rmin*cos(thel);
    yel  = -rmaj+rmaj*sin(thel);
        
    figure,
%     hAx1 = axes('Position',[0.125 0.20 0.40 0.40]); 
%     hAx2 = axes('Position',[0.575 0.20 0.40 0.40]); 
    hAx1 = axes('Position',[0.075 0.20 0.50 0.50]); 
    hAx2 = axes('Position',[0.625 0.275 0.35 0.35]); 
    hold(hAx1,'on')
        for ii=1:length(angplot)
            for mm=1:length(magplot)
                %Right
                hfig(ii,mm)=plot(hAx1,squeeze(xf(mm,ii,1,:)),squeeze(yf(mm,ii,1,:)),...
                    'LineWidth',0.8,'color',cc(mm,:));
                %Left
                plot(hAx1,squeeze(xf(mm,ii,2,:)),squeeze(yf(mm,ii,2,:)),...
                    'LineWidth',0.8,'color',cc(mm,:))
            end
        end
        plot(hAx1,xel,yel,'k--')
        grid(hAx1,'on'),xlabel(hAx1,'x [$\mu$m]'),ylabel(hAx1,'y [$\mu$m]')
        axis(hAx1,'equal'),set(hAx1,'xlim',[-10 10],'xtick',[-10 -5 0 5 10],...
            'ylim',[-10 10],'ytick',[-10 -5 0 5 10]);
    hold(hAx2,'on')
        xmin = -30; xmax = 20; ymin = -20; ymax = 20;
        for mm=1:length(magplot)
            plot(hAx2,magplot(mm).*BC.BlimitGIP{1}(phi0),...
                magplot(mm).*BC.BlimitGIP{2}(phi0),'color',cc(mm,:))
        end
%         plot(hAx2,[0 0],[ymin ymax],'k'),plot(hAx2,[xmin xmax],[0 0],'k')
        grid(hAx2,'on'), xlabel(hAx2,'$B_1$ [-]'),ylabel(hAx2,'$B_2$ [-]')
        axis(hAx2,'equal'),set(hAx2,'xlim',[xmin xmax],'xtick',[xmin:10:xmax],...
            'ylim',[ymin ymax],'ytick',[ymin:10:ymax]);
    leg=legend(hfig(1,:),legendstr{1:3},'Orientation','horizontal'); 
    pos=get(leg,'position');set(leg,'position',[0.35 0.025 pos(3:4)]);
    saveas(gcf,'Waveforms_for_various_amplitudes','epsc')
end
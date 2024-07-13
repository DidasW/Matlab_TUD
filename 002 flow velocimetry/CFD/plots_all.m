%----------------------------------------------------------------------
%% Power profiles
%----------------------------------------------------------------------
if 0
    for n=1:datasets
        windowtit = ['Power ' name{n}];
        figure('name',windowtit,'NumberTitle','off'), subplot(3,1,1), hold on
            plot(Pvdl{n,1},'k'),plot(avgbeat{n,1}.locs,GIPPvdl{n,1}(avgbeat{n,1}.locs),'k*');
            grid on, xlabel('Frame \#'),ylabel('$\tilde{P}_{v}$ [-]'),ylim([0 120])
        subplot(3,1,2),hold on
            plot(Pedl{n,1},'k'),plot(avgbeat{n,1}.locs,GIPPedl{n,1}(avgbeat{n,1}.locs),'k*')
            grid on, xlabel('Frame \#'),ylabel('$\tilde{P}_{e}$ [-]'),ylim([-250 250])
        subplot(3,1,3)
            plot(Ptdl{n,1},'k'),grid on
            xlabel('Frame \#'),ylabel('$\tilde{P}_{t}$ [-]')
        set(gcf, 'Position', get(0,'Screensize')); % Maximize figure
    end
end

%----------------------------------------------------------------------
%% Mean power profiles
%----------------------------------------------------------------------
if 0
    for n=1:datasets
        windowtit = ['Mean power profile ' name{n}];
        figure('name',windowtit,'NumberTitle','off'), subplot(3,1,1)
            plot(avgbeat{n,3}.meanPvdl),grid on,ylim([0 inf])
            title('Viscous power - dimensionless'),ylabel('$\tilde{P}$ [-]')
        subplot(3,1,2)
            plot(avgbeat{n,3}.meanPedl),grid on,title('Elastic power - dimensionless')
            ylabel('$\tilde{P}$ [-]')
        subplot(3,1,3)
            plot(avgbeat{n,3}.meanPtdl),grid on,title('Total power - dimensionless')
            xlabel('Frame \#'),ylabel('$\tilde{P}$ [-]')
    end
end

%----------------------------------------------------------------------
%% Elastic energy and power profiles
%----------------------------------------------------------------------
if 0
    for n=1:datasets
        windowtit = ['Elastic energy and power ' name{n}];
        figure('name',windowtit,'NumberTitle','off'), subplot(2,1,1)
            plot(datapts,avgbeat{n,1}.meanPe,'k'),grid on
            title('Elastic power'),ylabel('$P_e$ [W]')
        subplot(2,1,2),hold on
            plot(datapts,avgbeat{n,1}.meanEe,'k')
            grid on,title('Elastic energy')
            xlabel('Frame \#'),ylabel('$E_e$ [J]')
    end
end

%----------------------------------------------------------------------
%% Phase and phase speed profiles
%----------------------------------------------------------------------
if 0 
    for n=1:datasets
        windowtit = ['Phase ' name{n}];
        figure('name',windowtit,'NumberTitle','off'), subplot(2,2,1), hold on
            plot(datapts,avgbeat{n,1}.meanphic./(2*pi),'k')
            grid on,title('Phase - left flagellum'),ylabel('Phase [0-2$\pi$]')
        subplot(2,2,2),hold on
            plot(datapts,avgbeat{n,2}.meanphic./(2*pi),'k')
            grid on,title('Phase - right flagellum'),ylabel('Phase [0-2$\pi$]')
        subplot(2,2,3), hold on
            plot(datapts,avgbeat{n,1}.meanomegac./(2*pi),'k')
            grid on,title('Phase speed - left flagellum')
            xlabel('Dimensionless time $t/\tau$ [-]'),ylabel('Phase speed [Hz]')
        subplot(2,2,4),hold on
            plot(datapts,avgbeat{n,2}.meanomegac./(2*pi),'k')
            grid on,title('Phase speed - right flagellum')
            xlabel('Dimensionless time $t/\tau$ [-]'),ylabel('Phase speed [Hz]')
        subplot(2,2,3), hold on
            plot(datapts,avgbeat{n,1}.meanomegacdl,'k'),plot(datapts,avgbeat{n,1}.meanomegapdl,'r');
            grid on,title('Phase speed - left flagellum')
            xlabel('Dimensionless time $t/\tau$ [-]'),ylabel('Phase speed [-]')
        subplot(2,2,4),hold on
            plot(datapts,avgbeat{n,2}.meanomegacdl,'k'),plot(datapts,avgbeat{n,2}.meanomegapdl,'r');
            grid on,title('Phase speed - right flagellum')
            xlabel('Dimensionless time $t/\tau$ [-]'),ylabel('Phase speed [-]')
    end
end

%----------------------------------------------------------------------
%% Limit cycles
%----------------------------------------------------------------------
if 0
    for n=1:datasets
        windowtit = ['Limit cycles ' name{n}];
        figure('name',windowtit,'NumberTitle','off'), subplot(1,2,1),hold on
            plot(B{n,1}(:,1),B{n,1}(:,2),'k.','MarkerSize',0.2)
            plot(Blimit{n,1}(:,1),Blimit{n,1}(:,2),'r','LineWidth',1)
            grid on,title('Right flagellum'),axis([-30 30 -20 20]),axis equal
            xlabel('Shape score mode 1'),ylabel('Shape score mode 2')
        subplot(1,2,2),hold on
            plot(B{n,2}(:,1),B{n,2}(:,2),'k.','MarkerSize',0.2)
            plot(Blimit{n,2}(:,1),Blimit{n,2}(:,2),'r','LineWidth',1)
            grid on,title('Left flagellum'),axis([-30 30 -20 20]),axis equal
            xlabel('Shape score mode 1'),ylabel('Shape score mode 2')
    end
end

%----------------------------------------------------------------------
%% Compare limit cycles
%----------------------------------------------------------------------
if 0
    windowtit = 'Limit cycles compared';
    cmap = colormap(parula(datasets)); close(gcf);
    figure('name',windowtit,'NumberTitle','off'), subplot(1,2,1),hold on
        for n=1:datasets
           plot(Blimit{n,1}(:,1),Blimit{n,1}(:,2),'color',cmap(n,:))
        end
        grid on,title('Right flagellum'),legend(name)
        xlabel('Shape score mode 1'),ylabel('Shape score mode 2')
    subplot(1,2,2),hold on
        for n=1:datasets
           plot(Blimit{n,2}(:,1),Blimit{n,2}(:,2),'color',cmap(n,:))
        end
        grid on,title('Left flagellum'),legend(name)
        xlabel('Shape score mode 1'),ylabel('Shape score mode 2')
end

%----------------------------------------------------------------------
%% Plot normal/shear force, internal moment profiles
%----------------------------------------------------------------------
if 0
    close all
    for dd=1:datasets
    windowtit = ['NQM ' name{dd}];
    figure('name',windowtit,'NumberTitle','off'), subplot(3,1,1),hold on
        surf(dataind{dd},flaggriddl{dd},Fint_N{dd,1}','LineStyle','none'); 
        colormap jet, title('N [N]'), shading interp 
        colorbar, caxis([-5e-8 0])
    subplot(3,1,2),hold on
        surf(dataind{dd},flaggriddl{dd},Fint_Q{dd,1}','LineStyle','none');
        colormap jet, title('Q [N]'), shading interp
        colorbar, caxis([-5e-8 5e-8])
    subplot(3,1,3),hold on
        surf(dataind{dd},flaggriddl{dd},Mint{dd,1}','LineStyle','none'); 
        colormap jet, title('M [Nm]'), shading interp
        colorbar, caxis([-2e-13 2e-13])
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure
    end
end

%--------------------------------------------------------------------------
%% Plot forces on flagellum
%--------------------------------------------------------------------------
if 0
    close all
    for dd=1:datasets
        xdata = [mod(phicell{dd,1},2*pi); mod(phicell{dd,2},2*pi);];
        [xdata,ind] = sort(xdata);
        ydata = flaggriddl{dd};
        
        windowtit = ['NQM ' name{dd}];
        figure('name',windowtit,'NumberTitle','off')
        for ii=1:3
            switch ii
                case 1, zdata = [Fint_N{dd,1}; Fint_N{dd,2};];
                case 2, zdata = [Fint_Q{dd,1}; Fint_Q{dd,2};];
                case 3, zdata = [Mint{dd,1}; Mint{dd,2};];
            end
            zdata = zdata(ind,:);
            zdata = smooth(zdata(:));
            zdata = reshape(zdata,length(xdata),length(ydata));
            subplot(3,1,ii),surf(xdata,ydata,zdata','LineStyle','none');
            colormap jet, view([0 90]), colorbar, shading interp
            switch ii
                case 1, caxis([-5e-8 2e-8]),    title('N [N]')
                case 2, caxis([-5e-8 5e-8]),    title('Q [N]')
                case 3, caxis([-2e-13 2e-13]),  title('M [Nm]')
            end
            xlabel('$\phi_{cell}$ [rad]'),ylabel('$s/L$ [-]')
            set(gca,...
             'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
             'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'},...
             'ylim',[0 1])
        end
        set(gcf, 'Position', get(0,'Screensize')); % Maximize figure
    end
end






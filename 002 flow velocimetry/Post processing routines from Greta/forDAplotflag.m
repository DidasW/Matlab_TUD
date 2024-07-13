 %% Plot Forces over one beating cycle 
%--------------------------------------------------------------------------
% Create matrix of forces with dimensions [phi0 points in cell phase; nnodes
% in distance;];

    phistep = pi/10;
 angplot = 0:phistep:2*pi;
 
phi0small        = angplot;   %Equally spaced grid req. for DFT
  cc=parula(19); %Colormaps

     %Interpolated total force
     %Interpolated total force

% EFx_interp = cell(datasets,2);       %Interpolated total force
% EFy_interp = cell(datasets,2);       %Interpolated total force
% Pv_interp = cell(datasets,2);       %Interpolated total force
% Pe_interp = cell(datasets,2);       %Interpolated total force
% Pt_interp = cell(datasets,2);       %Interpolated total force


EFt6C1part=EFt6C1(11:203); %index are frames you want  to take
        %Convert ft and phi to equally spaced vectors
        [phisort,ind] = sort(mod(Ph6wr,2*pi));
    
        clear ftsort ftdenssort
          EFt6C1sort = EFt6C1part(ind,:);
        
        %Remove duplicates
        ind = find(diff(phisort) ==  0,1,'first');
        while ~isempty(ind)
            phisort(ind) = [];
            EFt6C1sort(ind+1,:) = (EFt6C1sort(ind,:)+EFt6C1sort(ind+1,:))./2;
            EFt6C1sort(ind,:) = [];
           
            ind = find(diff(phisort) ==  0,1,'first');
            
        end
     
         GIP = griddedInterpolant(phisort, EFt6C1sort );
        

         
         EFt6C1_interp = GIP(phi0small); 
    
     



fig=figure('name','EFt','NumberTitle','off'); hold on
axhandle = fig.Children; 
ymin = 0; ymax = 6;ysize = (ymax-ymin)/10;
plot(phi0small,smooth( EFt6C1_interp,3)./Fst,'k','Linewidth',2.5);
ypos=0.7;
  plot_body_flags_gre
xlabel(axhandle,'$\phi$ [rad]'),ylabel(axhandle,'$\mathcal {F}_{\rm t}$/$\mathcal{F}_0$','Interpreter','latex')
    set(axhandle,'ylim',[ymin ymax],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
t=title(['Total force EFt ']);
 set(gcf,'units','points','position',[50, 50 , 400,300])
box on



fig=figure('name','EFt','NumberTitle','off'); hold on
axhandle = fig.Children; 
ymin = 0; ymax = 80;ysize = (ymax-ymin)/10;
plot(phi0small,smooth( Pv6C1_interp,3),'k','Linewidth',2.5);
hold on, plot(phi0small,smooth( Pv6C3_interp,3),'b','Linewidth',2.5);
ypos=10;
  plot_body_flags_gre
xlabel(axhandle,'$\phi$ [rad]'),ylabel(axhandle,'$\mathcal {P}_{\rm v}$/$\mathcal{P}_0$','Interpreter','latex')
    set(axhandle,'ylim',[ymin ymax],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
t=title(['Total Pv ']); 
set(gcf,'units','points','position',[50, 50 , 400, 300])
box on


fig=figure('name','EFt','NumberTitle','off'); hold on
axhandle = fig.Children; 
ymin = -500; ymax = 250;ysize = (ymax-ymin)/10;
plot(phi0small,smooth( Pe6C1_interp,3),'k','Linewidth',2.5);
hold on, plot(phi0small,smooth( Pe6C3_interp,3),'b','Linewidth',2.5);
ypos=-410;
  plot_body_flags_gre
xlabel(axhandle,'$\phi$ [rad]'),ylabel(axhandle,'$\mathcal {P}_{\rm e}$/$\mathcal{P}_0$','Interpreter','latex')
    set(axhandle,'ylim',[ymin ymax],...
     'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
     'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
t=title(['Total Pe ']); 
set(gcf,'units','points','position',[50, 50 , 400, 300])
box on

% fig=figure('name','EFt','NumberTitle','off'); hold on
% axhandle = fig.Children; 
% ymin = -500; ymax = 250;ysize = (ymax-ymin)/10;
% plot(phi0small,(smooth( Pe6C1_interp,3)+smooth(Pv6C1_interp))./(Pst*10^-3),'k','Linewidth',2.5);
% hold on, plot(phi0small,(smooth( Pe6C3_interp,3)+smooth(Pv6C1_interp))./(Pst*10^-3),'b','Linewidth',2.5);
% ypos=-410;
%   plot_body_flags_gre
% xlabel(axhandle,'$\phi$ [rad]'),ylabel(axhandle,'$\mathcal {F}_t$/$\mathcal{F}_0$','Interpreter','latex')
%     set(axhandle,'ylim',[ymin ymax],...
%      'xlim',[0 2*pi],'xtick',0:pi/2:2*pi,...
%      'xticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
% t=title(['Total Pt ']); 
% set(gcf,'units','points','position',[50, 50 , 400, 300])
% box on
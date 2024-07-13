% Daniel Tam
% June 2014

clear variabclear
close all; clc
% addpath('D:\Final distribution\CFD');
% addpath('D:\Final distribution\CFD\BEM');
% addpath('D:\Final distribution\CFD\distmesh\');

topfld = 'D:\004 FLOW VELOCIMETRY DATA\';
cd(topfld) % so that the pipette file will be saved parallel to the folder 
           % of the full scenario

             
supfld = 'c5l\';
cd(supfld)
 pt = 12;
casefld_fullpath = [topfld,supfld,num2str(pt,'%02d'),'\'];
cd(casefld_fullpath)

% addpath('D:\004 FLOW VELOCIMETRY DATA\c1g\21');
pipettefile        = [topfld,'pipette_20170502_c5l','.mat'];
waveformsfilestruct= dir('lib*.mat'); waveformsfilename = waveformsfilestruct(1).name;
waveformsfile      = [casefld_fullpath,waveformsfilename]; 
% addpath('/Users/Jan/Documents/MEGA/WB/M2/Thesis/Matlab/Flagella tracking/movies/4-26/cal'); %path for the flagella signal
% the lib- files
% For Da's purpose
beadcoords = dlmread('D:\000 RAW DATA FILES\170502 lateral\position\Position c5l_BeforeRot_um.dat');
%


set(0,'defaulttextinterpreter','latex','DefaultAxesFontSize',16);

% pipettefile     = './Data/meshes/pipette_4-26_445_328';
% waveformsfile   = './Data/Shift/4-26 88 2000-2750 corrected'; 
% the path of the lib-file.
% waveformsfile   = 'D:\004 FLOW VELOCIMETRY DATA\c1g\21\lib21_1_55_2017-02-02_1022.mat'; 
% savefilename    = '8-3 25 2000-2750 correcte`d BEMsolution.mat';
% savefilename    = ['BEMsolution_',supfld(1:end-1),'_position',num2str(pt,'%02d'),'.mat'];
savefilename    = ['BEMsolution_',supfld(1:end-1),'_position',...
                    num2str(pt,'%02d'),'.mat'];
flowshift       = 0; %Phase shift for flow (positive=lead,negative=lag) [rad]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
calc = 1;           % 0: Only show sequence of shapes
                    % 1: Do calculations
saveresults = 1;    % Save results?
compute_flow = 3;   % 0: Only solve integral equation
                    % 1: Solve integral equation on velocity on mesh
                    % 2: Solve integral equation and velocity on list of points
                    % 3: Both 1 and 2
makemovie = 1;      % Make movie of flow field?
sepgridquiv = 0;    % Use reduced grid for quiver plot?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%SIMULATION PARAMETERS      %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up Cell + Pipette system == Upload Cell mesh
load(pipettefile);    % File with points on the cell mesh.

xh         = centroids(:,1);                    %x coordinate of centroids of Cell mesh         [micron]
yh         = centroids(:,2);                    %y coordinate of centroids of Cell mesh         [micron]
zh         = centroids(:,3);                    %z coordinate of centroids of Cell mesh         [micron]
ih         = find(abs(zh)<1);
Nh         = size(areas(:),1);                  % # of elements representing the cell + pipette head
theta      = linspace(0,2*pi,100);              %Angle                                          [rad]
a          = 4.29;                              % half major axis of prolate spheroid           [micron]
b          = 4.32;                              % half minor axis of prolate spheroid           [micron]
xhead      = a*cos(theta);                      %x coordinates of head                          [micron]
yhead      = b*sin(theta);                      %y coordinates of head                          [micron]
eta        = 0.9544e-3;                         %Viscosity, 22 degrees Celcius                  [Pa*s]

% Set up Flagella ==  Upload shape file
load(waveformsfile); % File with waveforms
rf         = 0.2 ;                                  % Radius of the flagellum           [micron]
                                                    % Calib. @20170601, 0.20 +/- 0.03
lf         = lf0;                                   % Length of the flagellum           [micron]
Slend      = rf/lf;                                 % Slenderness ratio                 [-]
EI         = 0.9e-21;                               % Bending stiffness                 [Nm2]
kappasave(:,:,2:end) = kappasave(:,:,2:end)./lf;    % Rescale curvature from 1 micron to lf     [1/micron]
Rotmat = @(phi) [cos(phi) sin(phi); -sin(phi) cos(phi);];% Rotation matrix
velx       = velx0.*lf;
vely       = vely0.*lf;
Nf         = size(kappasave,3)-2;                   % # of flagella elements            [-]
ssold      = linspace(0,lf,Nf+1);                   % Define flagella segments          [micron]
smin       = 0.15;%0.06;                                  % Distance in s (0-1) where description of flagellum starts  [-]
indstart   = find(ssold >= smin*lf,1,'first');
ss         = ssold(indstart:end);                      
Nf         = length(ss)-1;                          % # of flagella elements            [-]
ssc        = (ss(2:end)+ss(1:(end-1)))/2;           % Centroids of flagella elements    [micron]
llf        =  ss(2:end)-ss(1:(end-1));              % Length of each flagella segment   [micron]
xbase      = -4.29;                                 % x coord of flagellar base         [micron]
% xbase = -Cell.dist_base; modified to -4.29 as the recognition seemed
% inaccurate.
ybase      = 0  ;                                   % y coord of flagellar base         [micron]
dtime      = 1/fps;                                 % Time step                         [s]

indh       = (1:3*Nh);                              % Index for head
indf1      = (1:3*Nf)+3*Nh;                         % Index for flagellum 1 right
indf2      = (1:3*Nf)+3*(Nh+Nf);                    % Index for flagellum 2 left

M                = zeros(3*Nh+2*3*Nf,3*Nh+2*3*Nf);  % Mobility matrix                   [1e6 m/(N*s)]
M(1:3*Nh,1:3*Nh) = MATRIX;
UU               = zeros(3*Nh+2*3*Nf,1);            % Velocities at each element's boundary     [micron/s]
UU_max           = 40*lf;                      % Maximum velocity for plots        [micron/s]
% UU_max modified from 100*lf to 40*lf, 20170605,Da

beginctr   = 1;                         % First frame to process
endctr     = size(kappasave,1);         % Last frame to process
nframes    = endctr-beginctr+1;         % Number of frames/time steps 
nframestot = size(kappasave,1);         % Total number of frames in data
BEMtime    = dtime.*(0:1:nframestot-1); % Time vector              [s]

% Set up a cartesian Grid in the bulk on which to compute the flow.
if (compute_flow == 1) || (compute_flow == 3)
    Nxg       = 120+1;                                  %Number of nodes in x direction     [-]
    Nyg       = 80+1;                                   %Number of nodes in y direction     [-]
    xmin = -30; xmax = 30; ymin = -20; ymax = 20;       %Limits for velocity grid
    [xg,yg]   = ndgrid(linspace(xmin,xmax,Nxg),linspace(ymin,ymax,Nyg));  %Grid (xy)        [micron]
    zg        = zeros(size(xg));                        %Grid z                             [micron]
    xg = xg(:);  yg = yg(:); zg = zg(:);                %Convert matrices to column vectors
    Ng        = size(xg,1);                             %Number of grid points
    if sepgridquiv == 1
        [xgq,ygq] = ndgrid(linspace(xmin,xmax,(Nxg-1)/4+1),...
            linspace(ymin,ymax,(Nyg-1)/4+1));           %Grid for quiver [micron]
        zgq        = zeros(size(xgq));                  %Grid z                             [micron]
        xgq = xgq(:);  ygq = ygq(:); zgq = zgq(:);      %Convert matrices to column vectors
        Ngq        = size(xgq,1);                       %Number of grid points
        indf2q = zeros(size(xgq));
        for ii=1:length(xgq) %Find indices of full grid corresponding to compact grid
            indx = find(xg == xgq(ii));
            indy = find(yg == ygq(ii));
            [~,ind] = ismember(indx,indy);
            indf2q(ii) = indx(find(ind~=0,1,'first'));
        end
    end
end
if compute_flow >= 2
    %Location of bead
%    xgb = -24.11; ygb = 2.81; zgb = 0;

    %automatically read 
%     beadcoords = dlmread('D:\000 RAW DATA FILES\170130\positions\Position c2r_BeforeRot_um.dat');

    rownum     = find(beadcoords(:,1)==pt);
    % orientation before 20170502
%     xgb        = beadcoords(rownum,2)*-1;
%     ygb        = beadcoords(rownum,3);
    xgb        = beadcoords(rownum,3);
    ygb        = beadcoords(rownum,2)*-1;
    zgb = 0;
    Nb = length(xgb);
end

% %Compute flow matrix for the head
if compute_flow ~= 0
    %To correctly display points near the pipette
    indg      = find(dPipette([xg yg zg],pv) <= 0.1);   %Indices to grid points closer than 0.5 micron to the pipette+cell body
    if (compute_flow == 1) || (compute_flow == 3)
        if exist('M_Flow_head_c5l_120_80_30x_20y.mat','file')
            load('M_Flow_head_c5l_120_80_30x_20y')
        else
            [M_Flow_head,~,~,~,~] = FlowStokes(panels,[xg(:) yg(:) zg(:)],normals,param);
            save('M_Flow_head_c5l_120_80_30x_20y','M_Flow_head')
        end
    end    
    if compute_flow >= 2
        [M_Flow_headb,~,~,~,~] = FlowStokes(panels,[xgb(:) ygb(:) zgb(:)],normals,param);
        [Uflowb,Vflowb,Wflowb] = deal(zeros(nframes,length(xgb)));
    end
end

% Set up External flow
% setup_piezo_flow #####################
% %% scooped from the setup_piezo flow

% 
% velocity of a translating pipette in stationary medium, this corresponds 
% to MINUS the velocity of the flow on a stationary pipette.

[U,W] = deal(zeros(3,nframes));
U(1) = 0; U(2) = 0; U(3) = 0;   % U is the translation velocity of pipette    [micron/s]
W(1) = 0; W(2) = 0; W(3) = 0;   % W is the rotation velocity of pipette       [rad/s]

%Pre-allocating arrays
F(length(BEMtime)) = struct('cdata',[],'colormap',[]); %Frames for movie
Ebend = zeros(nframestot,3);
Pbend = zeros(nframestot,2);
[fx1,fy1,fx2,fy2] = deal(zeros(nframestot,Nf));        
[D1,D2] = deal(zeros(nframestot,2));       
[phi1,phi2,Dtot] = deal(zeros(nframestot,1));   
[r,c]      = size(MATRIX);              %Rows/columns

for kk = beginctr:endctr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Frame %d out of %d \n',kk-beginctr+1,nframes);

% Compute the position vector of the flagellum
% 1 = right, 2 = left in this program, whereas 1 = left, 2 = right in
% detection...
Y1  = flagella_quick(-squeeze(kappasave(kk,2,2:end)),ssold,...
    [pi-(Cell.thetar-Cell.phi_body)-squeeze(kappasave(kk,2,1));xbase;ybase;]);
Y2  = flagella_quick(squeeze(kappasave(kk,1,2:end)),ssold,...
    [pi-(Cell.thetal-Cell.phi_body)+squeeze(kappasave(kk,1,1));xbase;ybase;]);
% Smooth curvature
k1s = smooth(squeeze(kappasave(kk,2,2:end)),3);
k2s = smooth(squeeze(kappasave(kk,1,2:end)),3);
Y1s = flagella_quick(-k1s,ssold,...
    [pi-(Cell.thetar-Cell.phi_body)-squeeze(kappasave(kk,2,1));xbase;ybase;]);
Y2s = flagella_quick(k2s,ssold,...
    [pi-(Cell.thetal-Cell.phi_body)+squeeze(kappasave(kk,1,1));xbase;ybase;]);

%Calculate bending energy
Ebend(kk,1) = 1/2*EI*lf/Nf*sum(k1s.^2)*1e6;     %Bending energy    [J]
Ebend(kk,2) = 1/2*EI*lf/Nf*sum(k2s.^2)*1e6;     %Bending energy    [J]
Ebend(kk,3) = Ebend(kk,1)+Ebend(kk,2);

%Rotate and scale velocity vectors
for lr=1:2
    if lr == 1 %Left flagellum in storage, right in this program
        phi = pi+(Cell.thetal-Cell.phi_body);
    else %Right flagellum in storage, left in this program
        phi = pi-(Cell.thetar-Cell.phi_body);
    end
    vrot = [squeeze(velx(kk,lr,:))';squeeze(vely(kk,lr,:))';];
    vrot = Rotmat(phi)*vrot; 
    velx(kk,lr,:) = vrot(1,:);
    if lr == 1
        vely(kk,lr,:) = vrot(2,:);
    else
        vely(kk,lr,:) = -vrot(2,:);
    end
end

%Cut off everything before the starting point (ensure flagella-body
%separation)
Y1s = Y1s(indstart:end,:);
Y2s = Y2s(indstart:end,:);

xf1     = Y1s(2:end,2);         xf2     = Y2s(2:end,2);             %x coordinate of flagellum      [micron]
yf1     = Y1s(2:end,3);         yf2     = Y2s(2:end,3);             %y coordinate of flagellum      [micron]
zf1     = zeros(size(xf1));     zf2     = zeros(size(xf2));        %z coordinate of flagellum      [micron]
thf1    = Y1s(2:end,1);         thf2    = Y2s(2:end,1);             %Tangent angle of flagellum     [rad]
%Include background flow velocity here 
vxf1    = squeeze(velx(kk,2,indstart+1:end)) + U(1,kk);
vxf2    = squeeze(velx(kk,1,indstart+1:end)) + U(1,kk);
vyf1    = squeeze(vely(kk,2,indstart+1:end)) + U(2,kk);
vyf2    = squeeze(vely(kk,1,indstart+1:end)) + U(2,kk);
vzf1    = zeros(size(vxf1))+ U(3,kk);
vzf2    = zeros(size(vxf1))+ U(3,kk);

if calc == 0
    % Check waveforms and velocity vectors
    figure(1),clf,hold on;
    plot(xhead,yhead,'k','LineWidth',1); hold on;
%     plot(Y1(indstart+1:end,2),Y1(indstart+1:end,3),'g--')
%     plot(Y2(indstart+1:end,2),Y2(indstart+1:end,3),'r--')
    plot(Y1s(2:end,2),Y1s(2:end,3),'g','LineWidth',0.8)
    plot(Y2s(2:end,2),Y2s(2:end,3),'r','LineWidth',0.8)
    if compute_flow >= 2
       plot(xgb,ygb,'bo') 
    end
%     quiver(xf1,yf1,vxf1,vyf1)
%     quiver(xf2,yf2,vxf2,vyf2)
    xlabel('x [$\mathrm{\mu}$m]'),ylabel('y [$\mathrm{\mu}$m]')
    grid on,axis equal,axis([-15 10 -10 10]);
    set(gca, 'xtick', [-10 -5 0 5 10], 'ytick', [-10 -5 0 5 10])
%     figure(2),clf
%     subplot(2,1,1), hold on
%         plot(squeeze(kappasave(kk,2,2:end)),'g');
%         plot(k1s,'g--')
%     subplot(2,1,2), hold on
%         plot(squeeze(kappasave(kk,1,2:end)),'r');
%         plot(k2s,'r--')
    pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if calc
    % Assemble RHS
    [U_t,U_r]       = U_colloc(U(:,kk),W(:,kk),centroids,r/3);      %Translation/rotational velocity vectors    [micron/s]
    RHS             = (U_t+U_r);                                    %Right hand side (velocity)                 [micron/s]

    % Put together the Mobility matrix
    % Head
    M(indh,indh) = MATRIX;   

    % Flagella 
    % Current flagella_mobility uses cylindrical shape to simulate the 
    % flagellum. The shape was once simulated by a parabolic balloon.
    % Date of the note: 2017-07-18
    Mf1 = flagella_mobility(Slend,rf,llf',Nf,xf1,yf1,zf1,thf1,ssc');
    Mf2 = flagella_mobility(Slend,rf,llf',Nf,xf2,yf2,zf2,thf2,ssc');

    M(indf1,indf1) = Mf1;
    M(indf2,indf2) = Mf2;

    % Flagella interaction
    Mf12 = flagella_interaction(xf1,yf1,zf1,xf2,yf2,zf2,Nf,Nf,rf);
    Mf21 = flagella_interaction(xf2,yf2,zf2,xf1,yf1,zf1,Nf,Nf,rf); 
    Mf1h = flagella_interaction(xf1,yf1,zf1,xh,yh,zh,Nf,Nh,rf); 
    Mf2h = flagella_interaction(xf2,yf2,zf2,xh,yh,zh,Nf,Nh,rf); 
    M(indf2,indf1) = Mf12;
    M(indh,indf1)  = Mf1h;
    M(indf1,indf2) = Mf21;
    M(indh,indf2)  = Mf2h;

    % Head Interaction
    [MATRIX_h1,~,~,~,~] = FlowStokes(panels,[xf1 yf1 zf1],normals,param);
    [MATRIX_h2,~,~,~,~] = FlowStokes(panels,[xf2 yf2 zf2],normals,param);
    M(indf1,indh) = MATRIX_h1;
    M(indf2,indh) = MATRIX_h2;

    % Put together the Velocity matrix : VELOCITY AT SURFACE OF HEAD AND PIPETTE REMAINS ZERO!!!
    % Part of RHS that corresponds to the head and the flagellum
    uu1 = [vxf1 vyf1 vzf1]';       uu2 = [vxf2 vyf2 vzf2]';
    UU(indf1)  = uu1(:); 
    UU(indf2)  = uu2(:); 
    UU(indh)   = RHS(:);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute the singularity distribution
    phi        = M\UU;

    % f          = MATRIX\RHS(:); 
    fh         = phi(indh);         %Point forces for the head          [1e-12 N]
    f1         = phi(indf1);        %Point forces for right flagellum   [1e-12 N]
    f2         = phi(indf2);        %Point forces for left flagellum    [1e-12 N]

    % Compute Total rate of work & Drag force on each flagellum
    fx1(kk,:)  = f1(1:3:end); fy1(kk,:) = f1(2:3:end);
    fx2(kk,:)  = f2(1:3:end); fy2(kk,:) = f2(2:3:end);

    phi1(kk) = fx1(kk,:)*(vxf1-U(1,kk))+fy1(kk,:)*(vyf1-U(2,kk));     %Rate of work, right flagellum    [1e-18 W]
    phi2(kk) = fx2(kk,:)*(vxf2-U(1,kk))+fy2(kk,:)*(vyf2-U(2,kk));     %Rate of work, left flagellum     [1e-18 W]
    D1(kk,:) = [sum(fx1(kk,:)) ; sum(fy1(kk,:))]; %Drag for right flagellum         [1e-18 N] 
    D2(kk,:) = [sum(fx2(kk,:)) ; sum(fy2(kk,:))]; %Drag for left flagellum          [1e-18 N]
    Dtot(kk) = D1(1)*U(1) + D1(2)*U(2); %Total rate of work

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute the Flow on the cartesian grid: xg,yg,zg grid
    if compute_flow ~=0
        if (compute_flow == 1) || (compute_flow == 3)
            M_Flow_f1  = flagella_interaction(xf1,yf1,zf1,xg,yg,zg,Nf,Ng,rf);   %Flow matrix for right flagellum
            M_Flow_f2  = flagella_interaction(xf2,yf2,zf2,xg,yg,zg,Nf,Ng,rf);   %Flow matrix for left flagellum
            UF         = M_Flow_head*fh(:)+M_Flow_f1*f1(:)+M_Flow_f2*f2(:);     %Velocity field                     [micron/s]
            %Subtract background flow from result to correct for boundary condition
            u_flow     = UF(1:3:end)-U(1,kk);   u_flow(indg) = 0;  %x velocity     [micron/s]
            v_flow     = UF(2:3:end)-U(2,kk);   v_flow(indg) = 0;  %y velocity     [micron/s]
            w_flow     = UF(3:3:end)-U(3,kk);   w_flow(indg) = 0;  %z velocity     [micron/s]
        end

        if compute_flow >= 2
            M_Flow_f1b   = flagella_interaction(xf1,yf1,zf1,xgb,ygb,zgb,Nf,Nb,rf);   %Flow matrix for right flagellum
            M_Flow_f2b   = flagella_interaction(xf2,yf2,zf2,xgb,ygb,zgb,Nf,Nb,rf);   %Flow matrix for left flagellum
            UFb          = M_Flow_headb*fh(:)+M_Flow_f1b*f1(:)+M_Flow_f2b*f2(:);     %Velocity field                     [micron/s]
            Uflowb(kk,:) = UFb(1:3:end)-U(1,kk);   %x velocity     [micron/s]
            Vflowb(kk,:) = UFb(2:3:end)-U(2,kk);   %y velocity     [micron/s]
            Wflowb(kk,:) = UFb(3:3:end)-U(3,kk);   %z velocity     [micron/s]
        end

        if (compute_flow == 1) || (compute_flow == 3)
            figure(1);clf;
            UU_flow = sqrt(u_flow.^2+v_flow.^2)/UU_max; 
            UU_flow(indg) = 0.1;
            UU_flow_rscl = min(UU_flow,1);
            u_flow = u_flow.*UU_flow_rscl./UU_flow; v_flow = v_flow.*UU_flow_rscl./UU_flow;
            pcolor(reshape(xg,Nxg,Nyg),reshape(yg,Nxg,Nyg),reshape(UU_flow,Nxg,Nyg)); hold on;
            shading interp; colormap parula; caxis([0 0.5]);
            plot(xhead,yhead,'k','LineWidth',5); hold on;
            axis equal;
            plot(xf1,yf1,'k','LineWidth',5);    %Plot right flagellum
            plot(xf2,yf2,'k','LineWidth',5);    %Plot left flagellum
            plot(xh(ih),yh(ih),'r.');           %Plot body + pipette points
            if compute_flow == 3
               plot(xgb,ygb,'k.','Markersize',25); 
               set(gca,'ylim',[-100,20]) % Da added on 20170606
            end
            if sepgridquiv
                quiver(xgq,ygq,u_flow(indf2q),v_flow(indf2q)); 
            else
                quiver(xg,yg,u_flow,v_flow); 
            end
            title(sprintf('t = %4.3f ms',1000*BEMtime(kk)))
            pause(eps);
            F(kk) = getframe;   %Write frame to movie variable
        end
    end
end
clc
end

% filename = 'Point7_74_BEMsolution';
% filename = ['FlowSpeed_',supfld(1:end-1),'_',num2str(pt,'%02d'),'.mat'];
% filename = ['rf=',num2str(rf),'_','FlowSpeed_',supfld(1:end-1),'_',num2str(pt,'%02d'),'.mat'];
filename = ['rf=',num2str(rf),'_','FlowSpeed_',supfld(1:end-1),'_',num2str(pt,'%02d'),'_ModifyMobilityFile','.mat'];
if compute_flow >= 2
    Uflowb = - Uflowb;
    Vflowb = - Vflowb;
    save(filename,'Uflowb','Vflowb','xgb','ygb','fps','BEMtime','fx1','fx2','phi1','phi2')
else
    save(filename,'Uflowb','Vflowb','fps','BEMtime','fx1','fx2','phi1','phi2')
end
    
%% SAVE RESULTS
if saveresults
    clear areas centroids normals panels
    clear COLN_R COLN_S LINE_R LINE_S phi RHS
    clear M MATRIX MATRIX_h1 MATRIX_h2 Mf1 Mf12 Mf1h Mf2 Mf21 Mf2h
    save(savefilename)
end

%% MAKING MOVIE
if makemovie ~= 0
%     filename = 'BEM_Position7_74';
    moviefilename = [filename(1:end-4),'.mp4'];
    v = VideoWriter(moviefilename,'MPEG-4');
    v.FrameRate = 5;
    open(v)
    writeVideo(v,F(2:end))
    close(v)
end
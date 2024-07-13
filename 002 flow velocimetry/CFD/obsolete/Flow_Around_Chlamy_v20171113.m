%% DOC %%
% Update Log of Flow_Around_Chlamy... . m (FAC*.m)
% Date: 2014-06.      Created.     by Daniel Tam
% Date: 2017-07-18.   Organized.   Wei Da
%     Some organization is called for after several users has worked
%     with sults.
%         User dependent. One may edit directly the FAC_004_SaveResults.m
%         file in the switchthis program. The organization of the code is as follows:
%      
%     001. Add paths to include functions and necessary files. 
%         As this code will be used on different computers, this part is
%         fully user dependent. Please modify the FAC_001_AddPath.m such
%         that your own filepaths are included in the switch structure
%     002. Set the operational mode of the code, load or creat necessary
%         parameters for the following simulation.
%         The structure of this part is not user dependent. In case that  
%         some values such as flag stiffness, flag radius need to be
%         changed, user should notify others or simply do it in one's local
%         version
%     003. Compute the flow field around a chlamy cell. 
%         FAC_003_CalcImgSequence_CORE.m
%         This part should not be modified as it directly affects the 
%         validity of the computation. Any change must be annouced to
%         all the users of this code and updating this DOC at the same time. 
%     004. Save simulation re structure.
%
% Date: 2017-11-13.   FAC_003_CORE updated by Daniel. 
%     1. Redundant calculation of Y1 and Y2 were deleted (it was Y1(2)s
%     that were used.
%     2. Flagella shape coordiantes were calculated now using
%     curv2xy_quick.m, instead of flagella_quick.m. The former is the one
%     how the clicked coordinates got into curvature in the first place.

%% Add paths  
% User dependent, can modify without noticing others.
Flow_Around_Chlamy_001_AddPath

%% %%%%%%%%%%%%%%%%%%%%%%%%  Operational modes   %%%%%%%%%%%%%%%%%%%%%%%%%%
% User dependent, can modify without noticing others.

calc = 1;           % 0: Only show sequence of shapes
                    % 1: Do calculations
saveresults  = 1;   % Save BEM results?
compute_flow = 3;   % 0: Only solve integral equation
                    % 1: Solve integral equation on velocity on mesh
                    % 2: Solve integral equation and velocity on list of points
                    % 3: Both 1 and 2
flowshift   = 0;    % Phase shift for flow (positive=lead,negative=lag) [rad] 

makemovie   = 1;    % Make movie of flow field?
sepgridquiv = 1;    % Use reduced grid for quiver plot?

RemoveFlag1 = 0;    % Removing a flag will place it infinitely far away
RemoveFlag2 = 0;    % from the cell. 1 = Remove. Flag1: right
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        


%% %%%%%%%%%%%%%%%%%%%  Simulation parameters    %%%%%%%%%%%%%%%%%%%%%%%%%%
% User independent, modify with noticing others
%% Set up Cell + Pipette system == Upload Cell mesh
load(pipettefile);    % File with points on the cell mesh.

xh         = centroids(:,1);                    %x coordinate of centroids of Cell mesh         [micron]
yh         = centroids(:,2);                    %y coordinate of centroids of Cell mesh         [micron]
zh         = centroids(:,3);                    %z coordinate of centroids of Cell mesh         [micron]
ih         = find(abs(zh)<1);
Nh         = size(areas(:),1);                  % # of elements representing the cell + pipette head
theta      = linspace(0,2*pi,100);              % Angle                                          [rad]
% a,b,d size parameters of the cell and the pipette
% they are stored in the pipettefile.mat
xhead      = a*cos(theta);                      %x coordinates of head                          [micron]
yhead      = b*sin(theta);                      %y coordinates of head                          [micron]
eta        = 0.9544e-3;                         %Viscosity, 22 degrees Celcius                  [Pa*s]

%% Set up Flagella ==  Upload shape file                   
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
smin       = 0.15;                                  % Distance in s (0-1) where description of flagellum starts  [-]
% Rationale behind: to avoid collision between points on flagella 
% and points on cell body. 

indstart   = find(ssold >= smin*lf,1,'first');
ss         = ssold(indstart:end);                      
Nf         = length(ss)-1;                          % # of flagella elements            [-]
ssc        = (ss(2:end)+ss(1:(end-1)))/2;           % Centroids of flagella elements    [micron]
llf        =  ss(2:end)-ss(1:(end-1));              % Length of each flagella segment   [micron]

% %%%%%%%%%%%%%%%%%%%%%%%%%
xbase      = -Cell.dist_base;
ybase      = 0  ;                                   % y coord of flagellar base         [micron]
dtime      = 1/fps;                                 % Time step                         [s]

indh       = (1:3*Nh);                              % Index for head
indf1      = (1:3*Nf)+3*Nh;                         % Index for flagellum 1 right
indf2      = (1:3*Nf)+3*(Nh+Nf);                    % Index for flagellum 2 left

M                = zeros(3*Nh+2*3*Nf,3*Nh+2*3*Nf);  % Mobility matrix                   [1e6 m/(N*s)]
M(1:3*Nh,1:3*Nh) = MATRIX;

UU               = zeros(3*Nh+2*3*Nf,1);            % Velocities at each element's boundary     [micron/s]
UU_max           = 100*lf;                           % Maximum velocity for plots        [micron/s]

beginctr   = 1;                         % First frame to process
endctr     = size(kappasave,1);         % Last frame to process

nframes    = endctr-beginctr+1;         % Number of frames/time steps 
nframestot = size(kappasave,1);         % Total number of frames in data
BEMtime    = dtime.*(0:1:nframestot-1); % Time vector              [s]

%% Set up a cartesian Grid in the bulk on which to compute the flow.
if(compute_flow == 1) || (compute_flow == 3)
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
    [xgb,ygb]  = BeadCoordsFromFile(beadcoords_pth,pt,experiment);    
%     xgb = [18:2:125]*-1;%-5*ones(size(ygb));
%     ygb = zeros(size(xgb)); %[18:2:125]*-1;%;

    zgb = zeros(size(ygb));
    Nb = length(xgb);
end

%% Compute flow matrix for the head
if compute_flow ~= 0
    % To correctly display points near the pipette
    % Indices to grid points closer than XXX micron to the 
    % pipette+cell body. indg will be used to set parts of flowfield to 0
    indg      = find(dPipette([xg yg zg],pv) <= 0.1);  
    if ~exist('xmax','var'); xmax=1;ymax=1;Nxg=1;Nyg=1; end    
    [~,ParentDir,~]   = fileparts(fileparts(pwd));
    flowheadfile      = ['M_Flow_head_',ParentDir,sprintf('_%d_%d_%dx_%dy.mat',...
                         Nxg,Nyg,xmax,ymax)];
    flowheadfullpath  = [fileparts(pwd),'\',flowheadfile];
    MFlowHeadExist    = exist(flowheadfullpath,'file');
    if (compute_flow == 1) || (compute_flow == 3)
        if MFlowHeadExist
            load(flowheadfullpath)
        else
            [M_Flow_head,~,~,~,~] = FlowStokes(panels,[xg(:) yg(:) zg(:)],...
                                               normals,param);
            save(flowheadfullpath,'M_Flow_head')
        end
    end    
    if compute_flow >= 2
        [M_Flow_headb,~,~,~,~] = FlowStokes(panels,[xgb(:) ygb(:) zgb(:)],...
                                            normals,param);
        [Uflowb,Vflowb,Wflowb] = deal(zeros(nframes,length(xgb)));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Calculation
% User independent, MODIFICATION MUST BE ANNOUCED.
Flow_Around_Chlamy_003_ComputeForceAndFlow_CORE
% Flow_Around_Chlamy_003_CalcImgSequence_CORE

%% Save results. 
% User dependent, can modify without noticing others.
Flow_Around_Chlamy_004_SaveResults

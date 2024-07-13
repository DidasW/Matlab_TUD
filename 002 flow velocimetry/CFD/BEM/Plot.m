% Daniel Tam
% June 2011

clear all;
close all;
addpath(genpath('./swimum_Chlam'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('./Fit_Fourier.out');
load('./chlam_00.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set simulation Parameters
%  Set up Cell + Pipette system == Upload Cell mesh
load('./pipette_24.mat');                          % File with points on the cell mesh.
xh         = centroids(:,1);
yh         = centroids(:,2);
zh         = centroids(:,3);
Nh         = size(areas(:),1);                      % # of elements representing the cell + pipette head
theta      = linspace(0,2*pi,100);
xhead      = 5*cos(theta);
yhead      = 4*sin(theta);

% Set up Flagella
rf         = 0.20;                                  % Radius of the flagellum
lf         = 12;                                    % Length of the flagellum
Slend      = rf/lf;
Nf         = 40;                                    % # of flagella elements
ss         = linspace(0,lf,Nf+1);                   % Define flagella segments
ssc        = (ss(2:end)+ss(1:(end-1)))/2;           % Centroids of flagella elements
llf        =  ss(2:end)-ss(1:(end-1));              % Length of each flagella segment
Xof        = [-5.5 ; -5.5];                           % X coord of anchoring point of flagella (here 2 flag)
Yof        = [ 0.75; -0.75];                         % Y coord of anchoring point of flagella (here 2 flag)
time       = 0.35;
indh       = (1:3*Nh);                              % Index for head
indf1      = (1:3*Nf)+3*Nh;                         % 
indf2      = (1:3*Nf)+3*(Nh+Nf);

M                = zeros(3*Nh+2*3*Nf,3*Nh+2*3*Nf);
M(1:3*Nh,1:3*Nh) = MATRIX;
UU               = zeros(3*Nh+2*3*Nf,1);

% Set up a cartesian Grid in the bulk on which to compute the flow.
Nxg       = 120;
Nyg       = 90;
[xg,yg]   = ndgrid(linspace(-20,20,Nxg),linspace(-15,15,Nyg));
zg        = zeros(size(xg));
xg = xg(:);  yg = yg(:); zg = zg(:);
Ng        = size(xg,1);
indg      = find(dPipette([xg yg zg],pv) <= 0.0);

% Compute flow matrix for the head
[M_Flow_head,LINE_S,LINE_R,COLN_S,COLN_R] = FlowStokes(panels,[xg(:) yg(:) zg(:)],[],XS);


for time = 0.0:0.05:1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute the position vector of the flagellum
%flagellum 1
func1   = @(s,Y) flagella(s,Y,time,a_f,b_f,MaxTerm,lf);
func2   = @(s,Y) flagella(s,Y,time,-a_f,-b_f,MaxTerm,lf);
[s1,Y1]  = ode45(func1,[0 ssc lf],[pi;Xof(1);Yof(1);0;0;0]);
[s2,Y2]  = ode45(func2,[0 ssc lf],[pi;Xof(2);Yof(2);0;0;0]);
xf1     = Y1(2:(Nf+1),2);           xf2     = Y2(2:(Nf+1),2);
yf1     = Y1(2:(Nf+1),3);           yf2     = Y2(2:(Nf+1),3);
zf1     = zeros(size(xf1));         zf2     = zeros(size(xf2));
thf1    = Y1(2:(Nf+1),1);           thf2    = Y2(2:(Nf+1),1);
vxf1    = Y1(2:(Nf+1),5);           vxf2    = Y2(2:(Nf+1),5);
vyf1    = Y1(2:(Nf+1),6);           vyf2    = Y2(2:(Nf+1),6);
vzf1    = zeros(size(vxf1));        vzf2    = zeros(size(vxf2));
dthf1   = Y1(2:(Nf+1),4);           dthf2   = Y2(2:(Nf+1),4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Put together the Mobility matrix
% Head
M(indh,indh) = MATRIX;   

% Flagella
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
[MATRIX_h1,LINE_S,LINE_R,COLN_S,COLN_R] = FlowStokes(panels,[xf1 yf1 zf1],[],XS);
[MATRIX_h2,LINE_S,LINE_R,COLN_S,COLN_R] = FlowStokes(panels,[xf2 yf2 zf2],[],XS);
M(indf1,indh) = MATRIX_h1;
M(indf2,indh) = MATRIX_h2;

% Put together the Velocity matrix : VELOCITY AT SURFACE OF HEAD AND PIPETTE REMAINS ZERO!!!
uu1 = [vxf1 vyf1 vzf1]';       uu2 = [vxf2 vyf2 vzf2]';
UU(indf1)  = uu1(:); 
UU(indf2)  = uu2(:); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the singularity distribution
phi        = M\UU;
fh         = phi(indh);
f1         = phi(indf1);
f2         = phi(indf2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the Flow on the cartesian grid: xg,yg,zg grid
M_Flow_f1  = flagella_interaction(xf1,yf1,zf1,xg,yg,zg,Nf,Ng,rf); 
M_Flow_f2  = flagella_interaction(xf2,yf2,zf2,xg,yg,zg,Nf,Ng,rf); 
UF         = M_Flow_head*fh(:)+M_Flow_f1*f1(:)+M_Flow_f2*f2(:);

u_flow     = UF(1:3:end);   u_flow(indg) = 0;
v_flow     = UF(2:3:end);   v_flow(indg) = 0;
w_flow     = UF(3:3:end);   w_flow(indg) = 0;


figure;
UU_max = max(sqrt(vxf1(:).^2+vyf1(:).^2)); UU_flow = sqrt(u_flow.^2+v_flow.^2)/UU_max; UU_flow(indg) = 0.5; 
pcolor(reshape(xg,Nxg,Nyg),reshape(yg,Nxg,Nyg),reshape(UU_flow,Nxg,Nyg)); hold on;
shading interp; colormap parula; caxis([0 1]);
plot(xhead,yhead,'k','LineWidth',5); hold on;
% plot(pv(:,1),pv(:,2),'k-'); axis equal; hold on;
axis([-20 20 -15 15]); axis equal;
plot(xf1,yf1,'k','LineWidth',5);
plot(xf2,yf2,'k','LineWidth',5);
quiver(xg,yg,u_flow,v_flow); 
pause;

end






















% figure;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%% Analyse Computed stroke %%%%%%%%%%%%%%%%%%%%%%% 
% swim_chlam(link,N,Nc,Cell,l,MaxTerm,Opt_param,lubric,impose,Tol,1,aa)

















% a_f = 10/11.5*a_f;
% b_f = 10/11.5*b_f;
% 
% 
% 
% save('chlam_00.mat','a_f','b_f','-append')


% a_four=zeros(Ccell.MaxTerm+1  ,Ccell.Nc);    % [a1 a2 ... aMaxTerm a0] 
% b_four=zeros(Ccell.MaxTerm    ,Ccell.Nc);    % [b1 b2 ... bMaxTerm]
% for p=2:(Ccell.Nc+1)/2
% j = (  p-2)*(2*Ccell.MaxTerm+1);  
% a_four(1:Ccell.MaxTerm+1,p)     = Ccell.aa((j        +1):(j+  Ccell.MaxTerm+1))';
% b_four(1:Ccell.MaxTerm  ,p)     =-Ccell.aa((j+Ccell.MaxTerm+2):(j+2*Ccell.MaxTerm+1))';
% 
% a_four(1:Ccell.MaxTerm+1,Ccell.Nc+2-p) =Ccell.aa((j        +1):(j+  Ccell.MaxTerm+1))';    % Construct a_four for other half of swimmer
% b_four(1:Ccell.MaxTerm  ,Ccell.Nc+2-p) =-Ccell.aa((j+Ccell.MaxTerm+2):(j+2*Ccell.MaxTerm+1))';    % by symmetry (CHLAMY is symmetric!!!)
% end  
% 
% 
% Tip = (Ccell.Nc-1)/2;

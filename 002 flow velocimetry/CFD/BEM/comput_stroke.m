% Low Reynolds Swimmer
% June 2007
% Daniel TAM
%
% Function computing :
%   INPUT:
%   - link   row vector (3 elements) for link geometry: radius/half
%            length/slenderness
%   - N      number of links
%   - Cell   Link number where the head is. If 0, there is none.  
%   - l      matrix of the length of the links: l(i) is the half length (in 
%            terms of L) of the ith link
%            *Therefore: 2*(Sum of l(i)) = L
%   - x0     row vector (3 elements) containing initial X,Y,Theta, of first
%            link of the chain
%   - MOVIE  =0 no movie
%   -        =1 movie
%   - Ang    Matrix containing the different the path through the shape
%            space
%   OUTPUT:
%   - Efficiency
%   - Travel distance
%   - Work

function [Dist,Work_ext,Eff] = comput_stroke(link,N,Nc,Cell,l,MOVIE,a_four,b_four,MaxTerm ...
                                                                ,Opt_param,lubric,tol) 

%============================== Define fixed parameters ===================================%

N_quad = 5;                        % Number of quadrature points used for numerical integration  
[X_quad,W_quad]=lgwt(N_quad,-1,1); % Compute weights and evaluation points for gaussian quad.

%============== Define Runge Kutta parameters for time integration=========================% 

Nrk = 6;
ark = [   0         1/15    3/10        3/5          1         7/8];
brk = [   0         0       0           0            0         0     
          1/5       0       0           0            0         0
          3/40      9/40    0           0            0         0
          3/10     -9/10    6/5         0            0         0
        -11/54      5/2   -70/27       35/27         0         0
       1631/55296 175/512 575/13824 44275/110592  253/4096     0]; 
crk = [  37/378     0     250/621      125/594       0       512/1771];
drk = [-277/64512   0    6925/370944 -6925/202752 -277/14336 277/7084];

pow_rk   = 1/5;

%=========================== PreAllocate and declare variables ============================% 

F      = 0.0;
h      = 0.0;
if Cell~=0
  head = 1; 
else 
  head = 0; 
end
Lsto   = [1:2:(2*(Cell)),(2*Cell+1+head):2:(2*N+head)];
Lst1   = [2:2:(2*(Cell)),(2*Cell+2+head):2:(2*N+head)];

x_rk     = zeros(N,Nrk);
y_rk     = zeros(N,Nrk);
theta_rk = zeros(N,Nrk);
fs_rk    = zeros(2*N+head,Nrk);
F_rk     = zeros(1,Nrk);

%=============================== Define time parameter ====================================% 

t_init  = 0.0;
t_final = 1.0;
tau     = t_final-t_init;
time    = t_init;
Time    = time;
tol     = 10^(-4);
dt=0.04;
dt_min=10^(-8);
dt_accept=true;

%============================ Define geometry of swimmer ==================================%

Slend     = link(1);                   % Characteristic slenderness
rad       = link(2);                   % radius of flagellum
l_tot     = link(3);                   % Characteristic flagl. length
lcell     = link(4);                   % Characteristic length of cell
ARhead    = link(6);                   % Aspect Ratio of the head
Volume    = link(7);                   % Volume of the head
shape     = link(8);                   % shape of the head (alpha)
delta     = 5;                         % Thickness of ring around cell body (1 micron ~= diffusion dist over 1 storke)

Frequency = 50;                        % Beat frequency in Herz
Diff      = 5*10^2;                    % Diffusivity in: micrometers^2 second^-1
Pe        = Frequency*lcell*Diff;      % Peclet number ~sort of pre factor

%========================== Define Resistance coefficients ================================%

areg = -4*pi/(   log(1/Slend)+log(2)-3/2);
breg = -8*pi/(   log(1/Slend)+log(2)-1/2);
dreg = -8*pi/(3*(log(1/Slend)+log(2)-11/6));
if Cell ~= 0
[acell,bcell,dcell,l] = head_carac(ARhead,shape,l,Cell,link);
else
acell = 0; bcell = 0; dcell = 0;   
end


af = areg*l;
if Cell ~= 0
h=l(Cell)/(ARhead*tan(link(5)));
af(Cell)=acell*lcell;
end

%============ INITIALIZE GEOMERTY / MOTION PATH / BOUNDARY CONDITIONS AT JOINT ============%
% Initial geometry of the solver of the swimmer 
%  -'x'     matrix of the abscissa of the center of the ith link
%  -'y'     matrix of the ordinate of the center of the ith link
%  -'theta' matrix of the angle of the ith link

x(1,1)      = 0.0;    % Enter the coordinates of first link, rest is computed from conf.
y(1,1)      = 0.0;    % Enter the coordinates of first link, rest is computed from conf.
theta(1,1)  = 0.0;    % Enter the coordinates of first link, rest is computed from conf.

Ang(1:N,1)  = Init_shape(Cell,link,a_four,b_four,l_tot,N,Nc);

q=1;
for i=1:N
   if i > 1
   theta(i,1)=theta(i-1,1)+Ang(i,1); 
   x(i,1)=x(i-1,1)+cos(theta(i-1))*l(i-1)+cos(theta(i))*l(i);
   y(i,1)=y(i-1,1)+sin(theta(i-1))*l(i-1)+sin(theta(i))*l(i);
   end
   XXp(2*i-1,q)= x(i)-cos(theta(i))*l(i);
   XXp(2*i,q)  = x(i)+cos(theta(i))*l(i);
   YYp(2*i-1,q)= y(i)-sin(theta(i))*l(i);
   YYp(2*i,q)  = y(i)+sin(theta(i))*l(i); 
end
X     = x;
Y     = y;
Theta = theta;
Fs    = [];

%==========================================================================================%
%==================BEGIN TIME INTEGRATION/ 5th order Runge Kutta ==========================%
%==========================================================================================%

q=1;
while (time <= t_final && dt_accept)
   for rk=1:Nrk
   x_t        = x    +x_rk*brk(rk,:)';
   y_t        = y    +y_rk*brk(rk,:)';
   theta_t    = theta+theta_rk*brk(rk,:)'; 
   [M,Mo]     = Assemble_M(Slend,rad,lcell,ARhead,Cell,h,l,N,x_t,y_t,theta_t,acell,bcell,dcell,N_quad,X_quad,W_quad,lubric);
   [R,W]      = Assemble_R( Cell,a_four,b_four,x_t,y_t,theta_t,l,l_tot,N,Nc,time+dt*ark(rk));
   [LM,UM]    = lu(M);
   Um         = UM\(LM\(-R));        
   
   U2  = Mo*Um(1:3,1)+R(4:end,1);               % Find velocities at center of each LINK
   W2  = W+Um(3,1);                             % Find rot veloct at center of each LINK
   fs  = Um(4:end);
   
   Uu          = zeros(3*N,1);
   Uu(1:3:end) = U2(Lsto);
   Uu(2:3:end) = U2(Lst1);
   Uu(3:3:end) = W2(1:1:end);  
   Phi         = sqrt(abs(U2'*Um(4:end)));

   %Time integration (RK 4th order)
   x_rk(:,rk)     = dt*Uu(1:3:end);
   y_rk(:,rk)     = dt*Uu(2:3:end);
   theta_rk(:,rk) = dt*Uu(3:3:end); 
   fs_rk(:,rk)    = fs;
   F_rk(1,rk)     = dt*Phi;
   end
   
   % Estimate error
   
   error = norm([x_rk*drk' y_rk*drk' theta_rk*drk']);   
   
   % Integrate solution
   if error < tol
   x     = x    +    x_rk*crk';
   y     = y    +    y_rk*crk';
   fs    =          fs_rk*crk';
   theta = theta+theta_rk*crk';
   F     = F    +    F_rk*crk'; 
   X     = [X     x    ];                      % x coordinate of each link
   Y     = [Y     y    ];                      % y coordinate of each link
   Theta = [Theta theta];                      % angle of each link
   Fs    = [Fs    fs   ];                      % Hydrodynamics forces on each link
   
   %Increment time
   time  = time+dt;   
   Time  = [Time time];
   q     = q+1;
   end
   
   dt = dt*abs(tol/error)^pow_rk*9/10;
   if   dt<dt_min
   disp('WARNING: Time Step very small');
   dt_accept=false;
   end    
   if time+dt>t_final
       dt=t_final+eps-time;
   end   
end
T_end = q;

%=================== COMPUTE EFFICIENCY / VELOCITY / DISTANCE =============================%

if dt_accept
    
Work_ext =  F^2/tau;                                     % Work = twice that of a half period
if Opt_param == 0    
   AA  = abs(sum(af));
   if Cell ~= 0
   AA   = abs(af(Cell));
   if Volume~=0
   AA   = 6*pi*(3*Volume/(4*pi))^(1/3);    
   end
   end
   if      t_final == 1                                % t_final==1, complete period
   Dist = -sqrt((X(1,1)-X(1,end))^2+(Y(1,1)-Y(1,end))^2);   
   cor  =  1 - 100*sum(abs(Theta(:,end)-Theta(:,1)))/N;  % Correction for rotating swimmers (if waveform not symetrical)
   elseif  t_final == 0.5
   dT   =  (Theta(1,end)+Theta(1,1))/2;
   Dist = -abs( cos(dT)*(X(1,1)-X(1,end))+ sin(dT)*(Y(1,1)-Y(1,end))); %translation = twice that of half period
   cor  = 1;                                                           % no Correction for rotating swimmers (for symetrical waveform)
   else
   Dist = 0;
   display('ERROR IN DEFINING T_final')
   end

Eff      = -AA*Dist^2/(tau*Work_ext);
Eff      =  Eff*cor;
fprintf('%3.15f : %3.15f : %3.15f  \n',Eff,Dist,Work_ext);
end

else
Work_ext = 0;
Eff      = 0;
Dist     = 0;
end

%==========================================================================================%
%============================= POST TREATMENT / MAKE   MOVIE ==============================%
%==========================================================================================%

if MOVIE~=0
Ni=3;   % # of additional periods

%=============================== Add additional periods ===================================%
Fs     = [Fs Fs(:,1)];                % Fit the size of Fs (one timestep less than XX,YY)
XXp    = [];
YYp    = [];
for p=1:T_end
xx(1:2:2*N,1) = X(:,p)-cos(Theta(:,p)).*l;
xx(2:2:2*N,1) = X(:,p)+cos(Theta(:,p)).*l;
yy(1:2:2*N,1) = Y(:,p)-sin(Theta(:,p)).*l;
yy(2:2:2*N,1) = Y(:,p)+sin(Theta(:,p)).*l;
XXp    = [XXp xx];
YYp    = [YYp yy];
end  
Np=size(XXp,2);

for i=1:Ni
for p=2:T_end
XXp    = [XXp XXp(:,p)+i*(XXp(2,T_end)-XXp(2,1))];
YYp    = [YYp YYp(:,p)+i*(YYp(2,T_end)-YYp(2,1))];
Theta  = [Theta Theta(:,p)];
Fs     = [Fs Fs(:,p)];
X      = [X X(:,p)+i*(XXp(2,T_end)-XXp(2,1))];
Y      = [Y Y(:,p)+i*(YYp(2,T_end)-YYp(2,1))];
Time   = [Time i+Time(p)];
end
end

%============================ Rotate the plot (horizontal) ================================%

DX = X(1,1)-X(1,end);
DY = Y(1,1)-Y(1,end);
DD = sqrt( DX^2 + DY^2 ); 
if DD <= 10^-10
    DD = 1; DX = 1; DY = 0;
end
XX         = DX/DD*XXp           + DY/DD*YYp;
YY         =-DY/DD*XXp           + DX/DD*YYp;
Ftemp      = Fs;
Fs(Lsto,:) = DX/DD*Ftemp(Lsto,:) + DY/DD*Ftemp(Lst1,:);
Fs(Lst1,:) =-DY/DD*Ftemp(Lsto,:) + DX/DD*Ftemp(Lst1,:);
Xtemp      = X;
Ytemp      = Y;
X          = DX/DD*Xtemp         + DY/DD*Ytemp;
Y          =-DY/DD*Xtemp         + DX/DD*Ytemp; 
YY         = YY- mean(Y(:,1));
Y          = Y - mean(Y(:,1));
Theta      = Theta - atan2(DY,DX);

%======================= Make MOVIE SWIMMER!!! ===========================%

col  = (0:1/(2*T_end):1)';
cmap = -col.*(col-2) ;
cmap = [cmap cmap cmap];
cmap = [cmap ; ones(size(cmap)) ; ones(size(cmap)) ];
cmap = flipud(cmap);

ss  = 2*cumsum(l(:))-l(1);                        % Curvilinear abscisse
circle = 40;
ind    = 2*pi*(1:circle)/(circle-1);

if MOVIE ==1

mov = VideoWriter('Temp.avi');
open(mov);

for p=1:1:(Ni)*T_end
    HH = figure(1);      
    % PLOT SWIMMER    
    if     Cell==0
    plot(XX(1:end,p),YY(1:end,p),'k','LineWidth',2);
    % Plot Head
    elseif Cell~=0     
    X_trajet(p)=(XX(2*Cell,p)+XX(2*Cell-1,p))/2;
    Y_trajet(p)=(YY(2*Cell,p)+YY(2*Cell-1,p))/2;
    DX         =(XX(2*Cell,p)-XX(2*Cell-1,p));
    DY         =(YY(2*Cell,p)-YY(2*Cell-1,p));
    DD         =sqrt(DX^2+DY^2);
    
    shape = 0;
    xcell=X_trajet(p)-DY*h/DD+DX/DD*lcell*ARhead*cos(ind)+DY/DD*lcell*sin(ind).*(shape*cos(ind)+1);
    ycell=Y_trajet(p)+DX*h/DD+DY/DD*lcell*ARhead*cos(ind)-DX/DD*lcell*sin(ind).*(shape*cos(ind)+1);  
    
    XXcell=X_trajet(p)-DY*h/DD;
    YYcell=Y_trajet(p)+DX*h/DD;
           
    plot(-XX(1:(2*Cell-1),p),YY(1:(2*Cell-1),p),'k',-XX((2*Cell):end,p),YY((2*Cell):end,p),'k','LineWidth',4);
    hold on;   
    plot(-xcell,ycell,'k','LineWidth',4)
    hold off;
    end

xmean = mean(-X(Cell,:));
ymean = mean(Y(Cell,:));
axis([xmean-20  xmean+20  ymean-15.66   ymean+15.66  ]);
F = getframe(HH);
writeVideo(mov,F);
end
close(mov);
fprintf('%3.15f : %3.15f : %3.15f  \n',Eff,Work_ext,Dist);
hold off
end

%=================================== PLOT Curvature ! ===========================%

if MOVIE==4
    for i = 1 : 2*T_end
    cosus_f =  cos(2*pi*(1:MaxTerm)'*(Time(i))); 
    sinus_f =  sin(2*pi*(1:MaxTerm)'*(Time(i)));
    ss_c    = ( 0:(1/(Nc-2)):1 )' ;
    ss      = ( 0:(1/(N -2)):1 )' ;

    Curv_f  = a_four(MaxTerm+1,:)' + a_four(1:MaxTerm,:)'* cosus_f + b_four(1:MaxTerm,:)'* sinus_f;
    curv_f  = interp1(ss_c,Curv_f(2:end),ss,'spline');

    list    = (floor(N/2)+2):(size(ss(:),1)-1);
    s       = (ss(list)-ss(list(1)))/(ss(list(end))-ss(list(1)));
    plot(s,-curv_f(list)+Time(i)*7)
    hold on
    end
end
end   % end MOVIE
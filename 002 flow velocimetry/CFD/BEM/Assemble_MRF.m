function [M,Mo] = Assemble_MRF(Slend,rad,lcell,ARhead,Cell,h,l,N,x,y,theta,acell,bcell,dcell,N_quad,X_quad,W_quad,lubric) 

% Output:
%   - M  Assembled matrix  M*U=R of the linear system
% Input:
%   - af,bf,df:    Coeff of mobility matrix
%   - l:           Vector of link length
%   - l_tot,Slend: Geometric parameter / total length / Slenderness
%   - N:           # of links
%   - x,y,theta:   Vector of link coordinate
%   - N,X,W_quad:  Parameter for gaussian quad # quad pt / abscisse / coeff
%   - comput_AA:   true=comput AA matrix / false=do not comput AA

%============================== Define Parameters =========================================%

if Cell~=0
  head = 1; 
  ref  = Cell;                        % ref: link where to express TORQUE equilibrium
  DX   = cos(theta(Cell));            % DX:  Vector defining orientation of ref link
  DY   = sin(theta(Cell));            % DY:  
else 
  head = 0; 
  ref  = 1;
  DX   = 0.0;
  DY   = 0.0;
end
xo     = x(ref) - DY*h;                                 % Abscissa of reference point (center of head)
yo     = y(ref) + DX*h;                                 % Ordinate of reference point (center of head)
cst    = log(Slend^2);                                   
Lst    = [1:(2*(Cell-1)),(2*Cell+1):2*N];
Lsto   = [1:(2*(Cell-1)),(2*Cell+1+head):(2*N+head)];
Lst1   = [1:(2*(Cell  )),(2*Cell+1+head):(2*N+head)];

% plot(x,y,'b')
% hold on
% plot(xo,yo,'ro')
% hold off
% axis([-30 30 -12.0 30.0]); 
% pause
%=========================== PreAllocate and declare variables ============================% 
M      = zeros(2*N+3+head,2*N+3+head); 
K      = zeros(2*N,2*N);
L      = zeros(2*N,2);
H      = zeros(2*N,2);
R      = zeros(3,2*N);
K_quad = zeros(2*N,3); 
H_quad = zeros(2*N,3);
L_quad = zeros(3,3);

one    = ones(1,N);
one_q  = ones(1,N_quad);
Id     = eye(N);


%====================== (I) COMPUTE ASSEMBLE MATRIX FOR FLAGELLUM =========================%
%=========================Compute Values for evaluation of Integrals=======================%
Xo     = x-xo;
Yo     = y-yo;
Ro     = sqrt(Xo.^2+Yo.^2);
Xi     = x*one;
Yi     = y*one;
Li     = l*one;
cosus  = cos(theta)*one; 
sinus  = sin(theta)*one;
Si     = [ 0 ; cumsum(l(1:end-1,1)+l(2:end,1))]*one;
Lij    = Li'./Li;
Xij    = Xi-Xi';
Yij    = Yi-Yi';
Rij    = sqrt( Xij.^2 + Yij.^2 )   + 10^20*Id   ;

Rij(1:Cell-1,Cell+1:end) = Rij(1:Cell-1,Cell+1:end) + 5*rad; %10^20 ;  % Avoid strong interaction between 
Rij(Cell+1:end,1:Cell-1) = Rij(Cell+1:end,1:Cell-1) + 5*rad; %10^20 ;  % flagellas of same swimmer (Chlamy)

Xij    = Xij./Rij; 
Yij    = Yij./Rij;
Sij    = abs(Si-Si')  + 10^20*Id;

if Cell ~=0
Sij(1:Cell,Cell:end) = Sij(1:Cell,Cell:end) + 10^20;  % Consider Two separate flagella for 
Sij(Cell:end,1:Cell) = Sij(Cell:end,1:Cell) + 10^20;  % Chlamy (interaction through stokeslets)

% Sij(1:Cell-1,Cell+1:end) = Sij(1:Cell-1,Cell+1:end) + 10^20; % OLD Consider Two separate flagella for 
% Sij(Cell+1:end,1:Cell-1) = Sij(Cell+1:end,1:Cell-1) + 10^20; % OLD Chlamy (interaction through stokeslets)
end


% Sij = 10^20*ones(size(Sij));
% Rij = 10^20*ones(size(Rij));
%======================== action flagellum on flagellum =================================%
% K(1:2:2*N,1:2:2*N) = (1 + Xij.^2)./Rij; 
% K(1:2:2*N,2:2:2*N) =   (Xij.*Yij)./Rij;
% K(2:2:2*N,1:2:2*N) =   (Xij.*Yij)./Rij;
% K(2:2:2*N,2:2:2*N) = (1 + Yij.^2)./Rij;
% 
% L(1:2:2*N,1)       = sum((1 +   cosus.^2).*Lij./Sij,2);
% L(1:2:2*N,2)       = sum((  cosus.*sinus).*Lij./Sij,2);
% L(2:2:2*N,1)       = sum((  cosus.*sinus).*Lij./Sij,2);
% L(2:2:2*N,2)       = sum((1 +   sinus.^2).*Lij./Sij,2);


Fac                = 2*(log(2/Slend)-3/2)/(log(2/Slend)-1/2)-1;
Fac                = 1;

% Cox Coefficients
at                 =  4*(log(1/Slend)+log(2)-3/2);
an                 =  2*(log(1/Slend)+log(2)-1/2);

% Coefficients from lighthill
% at                 =  4*(log(0.18*80));
% an                 =  2*(log(0.18*80)+0.5);
% return

H(1:2:2*N,1)       =  (an*( sinus(:,1).^2          )   +  at *(cosus(:,1).^2)         )./(2*l);
H(1:2:2*N,2)       =  (an*(-cosus(:,1).*sinus(:,1) )   +  at *(cosus(:,1).*sinus(:,1)))./(2*l);
H(2:2:2*N,1)       =  (an*(-cosus(:,1).*sinus(:,1) )   +  at *(cosus(:,1).*sinus(:,1)))./(2*l);
H(2:2:2*N,2)       =  (an*( cosus(:,1).^2          )   +  at *(sinus(:,1).^2)         )./(2*l);
% H(1:2:2*N,1)       = (-cst-1-Fac*(cst+1)*cosus(:,1).^2)         ./(2*l);
% H(1:2:2*N,2)       = (      -Fac*(cst+1)*cosus(:,1).*sinus(:,1))./(2*l);
% H(2:2:2*N,1)       = (      -Fac*(cst+1)*cosus(:,1).*sinus(:,1))./(2*l);
% H(2:2:2*N,2)       = (-cst-1-Fac*(cst+1)*sinus(:,1).^2)         ./(2*l);

K(1:2:2*N,1:2:2*N) = 1/(8*pi)*(K(1:2:2*N,1:2:2*N) + diag(H(1:2:2*N,1)-L(1:2:2*N,1)));
K(1:2:2*N,2:2:2*N) = 1/(8*pi)*(K(1:2:2*N,2:2:2*N) + diag(H(1:2:2*N,2)-L(1:2:2*N,2))); 
K(2:2:2*N,1:2:2*N) = 1/(8*pi)*(K(2:2:2*N,1:2:2*N) + diag(H(2:2:2*N,1)-L(2:2:2*N,1)));
K(2:2:2*N,2:2:2*N) = 1/(8*pi)*(K(2:2:2*N,2:2:2*N) + diag(H(2:2:2*N,2)-L(2:2:2*N,2)));

R(1,1:2:2*N)       = 1;
R(2,2:2:2*N)       = 1;
R(3,1:2:2*N)       =-Yo;
R(3,2:2:2*N)       = Xo;

% if lubric == 1
% %======================== Compute LUBRICATION INTERACTION =================================%
% Cor                = ones(size(Rij))*10^(-20) + triu(ones(size(Rij)),3)*10^(20) + tril(ones(size(Rij)),-3)*(10^(20));
% Rij                = Rij + 1./Cor;
% Lub                = (-sinus.*Xij+cosus.*Yij).^2 .* (-sinus'.*Xij+cosus'.*Yij).^2;
% Lub                = 4/(pi*sqrt(2))*(3*rad./abs(Rij - 3*rad )).^(3/2).*Lub;
% K(1:2:2*N,1:2:2*N) = K(1:2:2*N,1:2:2*N) - Lub + diag(sum(Lub,2));
% K(2:2:2*N,2:2:2*N) = K(2:2:2*N,2:2:2*N) - Lub + diag(sum(Lub,2));
% end

%======================Compute Assembled matrix: FLAGELLUM=================================%
M(1:3,Lsto+3)      = R(:,Lst) ;
M(Lsto+3,1:3)      = R(:,Lst)';
M(Lsto+3,Lsto+3)   = K(Lst,Lst);  



if Cell ~= 0
%===================== (II) COMPUTE ASSEMBLE MATRIX FOR HEAD ==============================%
%=========================Compute Values for evaluation of Integrals=======================%
% lcell = lcell*3/4;

% !!!!!! CHLAMY ONLY !!!!!!!!!!! 
% PRINCIPLE AXIS ARE pi/2 Rotated
DX   =-sin(theta(Cell));            % DX:  Vector defining orientation of ref link
DY   = cos(theta(Cell));            % DY:  

a    = lcell;                                   % Semi major axis
b    = lcell*ARhead;                            % Semi minor axis
e    = sqrt(1-ARhead^2);                        % Excentricity
c    = a*e;                                     % Focal length
eta1 =    e^2 /(2-e^2);
eta2 = (1-e^2)/(2-e^2);

% s_q  = one'*X_quad';                            % abscissa between focal points of the head 
% Xo_q = Xo*one_q + c*s_q*DX;                     % Vector: Center of head -> point along flagellum 
% Yo_q = Yo*one_q + c*s_q*DY;                     %
% Ro_q = sqrt(Xo_q.^2+Yo_q.^2);                   % Length: Center of head -> point along flagellum
% 
% Xo   = Xo./Ro;                                  % Unit Vector: Center head -> point along flaglum
% Yo   = Yo./Ro;                                  %
% Xo_q = Xo_q./Ro_q;                              % Unit Vector: Integration points along head -> point along flaglum
% Yo_q = Yo_q./Ro_q;                              %
% 
% xo   = Xo  *DX + Yo  *DY;                       % (xo,yo) same as (Xo,Yo) but in rotated frame
% yo   =-Xo  *DY + Yo  *DX;                       % xo / yo : component along major / minor axis of head
% xo_q = Xo_q*DX + Yo_q*DY;                       % (xo_q,yo_q) same as (Xo_q,Yo_q) but in rotated frame
% yo_q =-Xo_q*DY + Yo_q*DX;                       % xo_q / yo_q: component along major / minor axis of head
                                                                                               
%====================== Interaction on flagellum due to Head ==============================%

% K_quad(1:2:2*N,1)  = ( (1 + Xo_q.^2)./Ro_q + 0.5*b^2*(1-s_q.^2).*( 1 - 3*Xo_q.^2)./Ro_q.^3 )*W_quad ;
% K_quad(1:2:2*N,2)  = (  (Xo_q.*Yo_q)./Ro_q + 0.5*b^2*(1-s_q.^2).*( -3*Xo_q.*Yo_q)./Ro_q.^3 )*W_quad ;
% K_quad(2:2:2*N,1)  = (  (Xo_q.*Yo_q)./Ro_q + 0.5*b^2*(1-s_q.^2).*( -3*Xo_q.*Yo_q)./Ro_q.^3 )*W_quad ;
% K_quad(2:2:2*N,2)  = ( (1 + Yo_q.^2)./Ro_q + 0.5*b^2*(1-s_q.^2).*( 1 - 3*Yo_q.^2)./Ro_q.^3 )*W_quad ;
% K_quad(1:2:2*N,3)  = 1.5*( (1-s_q.^2).*( (3*eta1*xo_q.*yo_q.*Xo_q - Yo_q)./Ro_q.^2 + 0.25*eta2*c^2*(1-s_q.^2).*(3*(-xo_q*DY + yo_q*DX) -15*xo_q.*yo_q.*Xo_q)./Ro_q.^4 ) )*W_quad ;
% K_quad(2:2:2*N,3)  = 1.5*( (1-s_q.^2).*( (3*eta1*xo_q.*yo_q.*Yo_q + Xo_q)./Ro_q.^2 + 0.25*eta2*c^2*(1-s_q.^2).*(3*( xo_q*DX + yo_q*DY) -15*xo_q.*yo_q.*Yo_q)./Ro_q.^4 ) )*W_quad ;

%====================== Interaction on head due to Flagellum ==============================%

% H_quad(1:2:2*N,1)  = (1 + Xo.^2)./Ro + 1/6*( 2*b^2*(1 -3*Xo.^2) + c^2*(-1 + 3*xo.^2 +2* DX^2 - 6*xo    .*(2*DX*Xo) + (-3+15*xo.^2).* (Xo.^2) ) )./Ro.^3;
% H_quad(1:2:2*N,2)  = (   Xo.*Yo)./Ro + 1/6*( 2*b^2*( -3*Xo.*Yo) + c^2*(              2*DX*DY - 6*xo.*(DY*Xo+DX*Yo) + (-3+15*xo.^2).*(Xo.*Yo) ) )./Ro.^3;
% H_quad(2:2:2*N,1)  = (   Xo.*Yo)./Ro + 1/6*( 2*b^2*( -3*Xo.*Yo) + c^2*(              2*DX*DY - 6*xo.*(DY*Xo+DX*Yo) + (-3+15*xo.^2).*(Xo.*Yo) ) )./Ro.^3;
% H_quad(2:2:2*N,2)  = (1 + Yo.^2)./Ro + 1/6*( 2*b^2*(1 -3*Yo.^2) + c^2*(-1 + 3*xo.^2 +2* DY^2 - 6*xo    .*(2*DY*Yo) + (-3+15*xo.^2).* (Yo.^2) ) )./Ro.^3;
% H_quad(1:2:2*N,3)  = 1/(a^2*(2-e^2))*( (a^2+b^2)*Yo - 3*(a^2-b^2)*xo.*yo.*Xo )./Ro.^2;
% H_quad(2:2:2*N,3)  = 1/(a^2*(2-e^2))*(-(a^2+b^2)*Xo - 3*(a^2-b^2)*xo.*yo.*Yo )./Ro.^2;

%============================== Action Head on Head =======================================%  
Coe                = 1.0;
acell = acell*Coe;
bcell = bcell*Coe;


L_quad(1,1)        = (1/acell*DX^2+1/bcell*DY^2)/lcell; 
L_quad(1,2)        = (1/acell-1/bcell)*DX*DY    /lcell;
L_quad(2,1)        = (1/acell-1/bcell)*DX*DY    /lcell;
L_quad(2,2)        = (1/acell*DY^2+1/bcell*DX^2)/lcell;
L_quad(3,3)        = 1/dcell/lcell^3;

%======================= Compute Assembled matrix: HEAD ===================================%

M(1:3,2*Cell+1+(1:3))            = eye(3) ;       % Because center of head is reference point       
M(2*Cell+1+(1:3),1:3)            = eye(3) ;       % Because center of head is reference point      

M(2*Cell+1+(1:3),2*Cell+1+(1:3)) = L_quad(1:3,1:3);

M(Lsto+3,2*Cell+1+(1:3))         = 1/(16*pi)*K_quad(Lst,1:3) ;
M(2*Cell+1+(1:3),Lsto+3)         = 1/( 8*pi)*H_quad(Lst,1:3)';
end

Mo(Lst1,1:3)                     = R';            % Ref point is CENTER of cell BUT: when integrat vel to find x: look for Center of LINKS

if head == 1
   Mo(2*Cell+head,3)             = 1 ;
end

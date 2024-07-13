function [M,Mo] = Assemble_M(Slend,rad,Cell,l,N,x,y,theta,SS) 

% Output:
%   - M  Assembled matrix  M*U=R of the linear system
% Input:
%   - l:           Vector of link length
%   - l_tot,Slend: Geometric parameter / total length / Slenderness
%   - N:           # of links
%   - x,y,theta:   Vector of link coordinate

%============================== Define Parameters =========================================%

cst    = log(Slend^2);                                   

%=========================== PreAllocate and declare variables ============================% 
K      = zeros(2*N,2*N);
L      = zeros(2*N,2);
H      = zeros(2*N,2);
one    = ones(1,N);
Id     = eye(N);

%====================== (I) COMPUTE ASSEMBLE MATRIX FOR FLAGELLUM =========================%
%=========================Compute Values for evaluation of Integrals=======================%
Xi     = x*one;
Yi     = y*one;
Li     = l*one;
cosus  = cos(theta)*one; 
sinus  = sin(theta)*one;
Si     = SS*one;
Lij    = Li'./Li;
Xij    = Xi-Xi';
Yij    = Yi-Yi';
Rij    = sqrt( Xij.^2 + Yij.^2 )   + 10^20*Id   ;

Rij(1:Cell-1,Cell+1:end) = Rij(1:Cell-1,Cell+1:end) + 5*rad; %10^20 ;  % Avoid strong interaction between 
Rij(Cell+1:end,1:Cell-1) = Rij(Cell+1:end,1:Cell-1) + 5*rad; %10^20 ;  % flagellas of same swimmer (Chlamy)

Xij    = Xij./Rij; 
Yij    = Yij./Rij;
Sij    = abs(Si-Si')  + 10^20*Id;

%======================== action flagellum on flagellum =================================%
K(1:2:2*N,1:2:2*N) = (1 + Xij.^2)./Rij; 
K(1:2:2*N,2:2:2*N) =   (Xij.*Yij)./Rij;
K(2:2:2*N,1:2:2*N) =   (Xij.*Yij)./Rij;
K(2:2:2*N,2:2:2*N) = (1 + Yij.^2)./Rij;

L(1:2:2*N,1)       = sum((1 +   cosus.^2).*Lij./Sij,2);
L(1:2:2*N,2)       = sum((  cosus.*sinus).*Lij./Sij,2);
L(2:2:2*N,1)       = sum((  cosus.*sinus).*Lij./Sij,2);
L(2:2:2*N,2)       = sum((1 +   sinus.^2).*Lij./Sij,2);

H(1:2:2*N,1)       = (-cst+1-(cst+3)*cosus(:,1).^2)         ./(2*l);
H(1:2:2*N,2)       = (      -(cst+3)*cosus(:,1).*sinus(:,1))./(2*l);
H(2:2:2*N,1)       = (      -(cst+3)*cosus(:,1).*sinus(:,1))./(2*l);
H(2:2:2*N,2)       = (-cst+1-(cst+3)*sinus(:,1).^2)         ./(2*l);

K(1:2:2*N,1:2:2*N) = 1/(8*pi)*(K(1:2:2*N,1:2:2*N) + diag(H(1:2:2*N,1)-L(1:2:2*N,1)));
K(1:2:2*N,2:2:2*N) = 1/(8*pi)*(K(1:2:2*N,2:2:2*N) + diag(H(1:2:2*N,2)-L(1:2:2*N,2))); 
K(2:2:2*N,1:2:2*N) = 1/(8*pi)*(K(2:2:2*N,1:2:2*N) + diag(H(2:2:2*N,1)-L(2:2:2*N,1)));
K(2:2:2*N,2:2:2*N) = 1/(8*pi)*(K(2:2:2*N,2:2:2*N) + diag(H(2:2:2*N,2)-L(2:2:2*N,2)));

%======================Compute Assembled matrix: FLAGELLUM=================================%
M = K;  






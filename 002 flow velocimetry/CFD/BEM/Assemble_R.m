function [R,W] = Assemble_R(Cell,a,b,x,y,theta,l,l_tot,N,Nc,time) 

% Output:
%   - B  Assembled vector of constraint A*U=B of the linear system
%
% Input:
%   - Cell:        Position of the head / Cell= 0 means no head
%   - a:           Fourier coeff in COS [a1 a2 a3 a4 ... aMaxTerm a0]
%   - b:           Fourier coeff in SIN [b1 b2 b3 b4 ... bMaxTerm]
%   - N:           # of links
%   - Nc:          # of points in the discrtization of curvature
%   - time:        time (stroke parameterize with time)

%============================== Define Parameters =========================================%

if Cell~=0
  head = 1; 
  ref  = Cell;                        % ref: link where to express TORQUE equilibrium
else 
  head = 0; 
  ref  = 1;
end
Lst    = [1:(2*(Cell-1)),(2*Cell+1):2*N];
Lsto   = [1:(2*(Cell-1)),(2*Cell+1+head):(2*N+head)];
Lk     = l_tot/(N-head);                                 % half Length of one link
dt     = 10^-6;

%=========================== PreAllocate and declare variables ============================% 

one     = ones(1,N);
R       = zeros(2*N+3+head,1);
U       = zeros(2*N,1);
MaxTerm = size(b,1);

%========================= Compute Values for evaluation of 2nd member ====================%

cosus_f =                    cos(2*pi*(1:MaxTerm)'*(time+dt)); 
sinus_f =                    sin(2*pi*(1:MaxTerm)'*(time+dt));
cosus_b =                    cos(2*pi*(1:MaxTerm)'*(time-dt)); 
sinus_b =                    sin(2*pi*(1:MaxTerm)'*(time-dt));

Xi      = x*one; 
Yi      = y*one;
cosine  = cos(theta); 
sine    = sin(theta);
Xio     = (l.*cosine)*one; 
Yio     = (l.*  sine)*one;
Xij     = zeros(size(Xi));
Yij     = zeros(size(Yi));

lst0  = 1:(ref-1);
lst1  = (ref+1):size(Xij,2);
Xij(lst0,lst0+1) = triu( Xi(lst0,lst0)'-Xi(lst0,lst0) +Xio(lst0,lst0)' );
Yij(lst0,lst0+1) = triu( Yi(lst0,lst0)'-Yi(lst0,lst0) +Yio(lst0,lst0)' );
Xij(lst1,lst1)   = tril( Xi(lst1,lst1) -Xi(lst1,lst1)'+Xio(lst1,lst1)' );
Yij(lst1,lst1)   = tril( Yi(lst1,lst1) -Yi(lst1,lst1)'+Yio(lst1,lst1)' );

%==================== Compute Curvatures and interpolate at junctions ======================%

ss_c    = ( 0:(1/(Nc-2)):1 )' ;
ss      = ( 0:(1/(N -2)):1 )' ;

Curv_f  = a(MaxTerm+1,:)' + a(1:MaxTerm,:)'* cosus_f + b(1:MaxTerm,:)'* sinus_f;
Curv_b  = a(MaxTerm+1,:)' + a(1:MaxTerm,:)'* cosus_b + b(1:MaxTerm,:)'* sinus_b;
curv_f                 = interp1(ss_c,Curv_f(2:end),ss,'spline');
curv_b                 = interp1(ss_c,Curv_b(2:end),ss,'spline');
% curv_f                 = interp1(ss_c,Curv_f(2:end),ss,'pchip');
% curv_b                 = interp1(ss_c,Curv_b(2:end),ss,'pchip');
% curv_f                 = interp1(ss_c,Curv_f(2:end),ss,'linear');
% curv_b                 = interp1(ss_c,Curv_b(2:end),ss,'linear');

%========================== Compute angular velocities at junctions ========================%

Ang_f   = 2*atan( Lk*curv_f );
Ang_b   = 2*atan( Lk*curv_b );

Omega   = 0.5*(Ang_f-Ang_b)/dt;
                      
Omega   = [0 ; Omega];
Omega   = Omega*one;

U(1:2:end,1) = -Yij*Omega(:,1) ;
U(2:2:end,1) =  Xij*Omega(:,1) ;

R(Lsto+3,1)  = U(Lst,1);

%========================== Compute Omega_deformation ======================================%

W          = cumsum(Omega(:,1),1);
W          = W - W(ref,1);                   % W  deformation (W  deformation = 0 for ref link)












% plot(ss,curv_f,'b',ss,curv_b,'r');
% axis([0 1 -2 2])
% pause

% %============================== Define Parameters =========================================%
% 
% if Cell~=0
%   head = 1; 
%   ref  = Cell;                        % ref: link where to express TORQUE equilibrium
% else 
%   head = 0; 
%   ref  = 1;
% end
% Lst    = [1:(2*(Cell-1)),(2*Cell+1):2*N];
% Lsto   = [1:(2*(Cell-1)),(2*Cell+1+head):(2*N+head)];
% Lk     = l_tot/(N-head);                                 % half Length of one link
% dt     = 10^-6;
% 
% %=========================== PreAllocate and declare variables ============================% 
% 
% one     = ones(1,N);
% R       = zeros(2*N+3+head,1);
% U       = zeros(2*N,1);
% MaxTerm = size(b,1);
% 
% %========================= Compute Values for evaluation of 2nd member ====================%
% 
% cosus_f =                    cos(2*pi*(1:MaxTerm)'*(time+dt)); 
% sinus_f =                    sin(2*pi*(1:MaxTerm)'*(time+dt));
% cosus_b =                    cos(2*pi*(1:MaxTerm)'*(time-dt)); 
% sinus_b =                    sin(2*pi*(1:MaxTerm)'*(time-dt));
% 
% Xi      = x*one; 
% Yi      = y*one;
% cosine  = cos(theta); 
% sine    = sin(theta);
% Xio     = (l.*cosine)*one; 
% Yio     = (l.*  sine)*one;
% 
% % Xij     = tril( Xi-(Xi-Xio)' ,-1);
% % Yij     = tril( Yi-(Yi-Yio)' ,-1);
% Xij     = tril( Xi-(Xi-Xio)' );
% Yij     = tril( Yi-(Yi-Yio)' );
% 
% %==================== Compute Curvatures and interpolate at junctions ======================%
% 
% ss_c    = ( 0:(1/(Nc-2)):1 )' ;
% ss      = ( 0:(1/(N -2)):1 )' ;
% 
% Curv_f  = a(MaxTerm+1,:)' + a(1:MaxTerm,:)'* cosus_f + b(1:MaxTerm,:)'* sinus_f;
% Curv_b  = a(MaxTerm+1,:)' + a(1:MaxTerm,:)'* cosus_b + b(1:MaxTerm,:)'* sinus_b;
% curv_f  = spline(ss_c,Curv_f(2:end),ss);
% curv_b  = spline(ss_c,Curv_b(2:end),ss);
% 
% %========================== Compute angular velocities at junctions ========================%
% 
% Ang_f   = 2*atan( Lk*curv_f );
% Ang_b   = 2*atan( Lk*curv_b );
% 
% Omega   = 0.5*(Ang_f-Ang_b)/dt;
%                       
% Omega   = [0 ; Omega];
% Omega   = Omega*one;
% 
% U(1:2:end,1) = -Yij*Omega(:,1) ;
% U(2:2:end,1) =  Xij*Omega(:,1) ;
% 
% % U(1:2:end,1) = -Yij*Omega(:,1) - Yio(:,1).*Omega(:,1);
% % U(2:2:end,1) =  Xij*Omega(:,1) + Xio(:,1).*Omega(:,1);
% 
% % U(1:2:end,1) = U(1:2:end,1) - U(2*ref-1,1);  % Ux deformation (Ux deformation = 0 for ref link)
% % U(2:2:end,1) = U(2:2:end,1) - U(2*ref  ,1);  % Uy deformation (Uy deformation = 0 for ref link)
% 
% R(Lsto+3,1)  = U(Lst,1);
% 
% %========================== Compute Omega_deformation ======================================%
% 
% W          = cumsum(Omega(:,1),1);
% % W          = W - W(ref,1);                   % W  deformation (W  deformation = 0 for ref link)



































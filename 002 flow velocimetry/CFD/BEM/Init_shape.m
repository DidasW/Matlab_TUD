function [Ang] = Init_shape(Cell,link,a,b,l_tot,N,Nc) 

% Output:
%   - Ang          Vector of angles at t=0
%
% Input:
%   - Cell:        Position of the head / Cell= 0 means no head
%   - a:           Fourier coeff in COS [a1 a2 a3 a4 ... aMaxTerm a0]
%   - b:           Fourier coeff in SIN [b1 b2 b3 b4 ... bMaxTerm]
%   - N:           # of links
%   - Nc:          # of points in the discrtization of curvature

%============================== Define Parameters ==========================================%

if Cell~=0
  head = 1; 
else 
  head = 0; 
end
Lk     = l_tot/(N-head);                                 % half Length of one link

%=========================== PreAllocate and declare variables =============================% 

MaxTerm = size(b,1);

%========================= Compute Values for evaluation of 2nd member =====================%

cosus   = ones(MaxTerm,1);       % At t=0 cosine = 1, and sine = 0 

%==================================== Compute Curvatures ===================================%

Curv       = a(MaxTerm+1,:)' + a(1:MaxTerm,:)'* cosus ;

% Curv       = [ Curv ; 0];            

%========================== Fit Curvature to Junction between links ========================%

ss_c                 = ( 0:(1/(Nc-2)):1 )' ;
ss                   = ( 0:(1/(N -2)):1 )' ;
curv                 = interp1(ss_c,Curv(2:end),ss,'spline');
% curv                 = interp1(ss_c,Curv(2:end),ss,'pchip');
% curv                 = interp1(ss_c,Curv(2:end),ss,'linear');
Ang                  = 2*atan( Lk*curv);


% plot(1:(N-1),Ang)
% axis([1 N-1 -pi/6 pi/6])
% pause

Ang                  = [0 ; Ang];


%===================== Angular correction (flagel normal to cell surface) ==================%

if Cell ~= 0
if Cell == N
   disp('WARNING: head cannot be at the end!!!');
   return
end

if link(5) >= 0
   cor = -pi/2+link(5);
else
   cor =  pi/2+link(5);
end

Ang(Cell)   = Ang(Cell)   + cor;
Ang(Cell+1) = Ang(Cell+1) + cor;
end
















































% nl     = N  - 1;
% nc     = Nc - 1;
% ic         = floor((1:nl)'*nc/nl) + 1;
% Lambda     = (1:nl)'*nc/nl - ic   + 1; 
% Ang        = 2*atan(Lk*((1-Lambda).*Curv(ic)+Lambda.*Curv(ic+1)));
% 
% 
% Ang        = Lk*((1-Lambda).*Curv(ic)+Lambda.*Curv(ic+1));
% Ang        = [0 ; Ang];
% 
% plot(1:N,Ang,1:N,Ang1)
% pause
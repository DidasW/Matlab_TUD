function [C, Ceq] = constraint_fcn_minimization_PCA(B,scale,x0,y0,theta0,lf0,xperim,yperim,phi_body,lr,nmodes,princpts,ssc)
%% FUNCTION constraint_legendre_PCA_whole
% Constraint function for minimize_legendre_PCA_whole. Flagellum cannot
% intersect cell body, flagellum is limited in max curvature and allowable
% tangent angles.
%% INPUTS
%B          Manipulation variable (shape scores)
%scale      Scale of pictures in [px/micron]
%x0         Starting point of integration in x
%y0         Starting point of integration in y
%theta0     Starting point of integration in theta
%lf         Length of flagellum
%xperim     x coordinates of cell rim
%yperim     y coordinates of cell rim
%lr         Left/right flagellum
%index      Last correctly detected point
%nmodes     Number of PCA modes
%princpts   Principal components (shape modes)
%ssc        Interpolation grid
%debugfmc   Debug variable
%% OUTPUTS
%C      Constraint: C(X) =< X
%Ceq    Constraint: Ceq(X) = 0

if lr == 1
    curv = -princpts(1,2:end)' - princpts(2:nmodes+1,2:end)'*B; %Curvature profile
   	theta0 = theta0 - princpts(1,1) - princpts(2:nmodes+1,1)'*B; %Initial tangent angle
else
    curv = princpts(1,2:end)' + princpts(2:nmodes+1,2:end)'*B; %Curvature profile
    theta0 = theta0 + princpts(1,1) + princpts(2:nmodes+1,1)'*B; %Initial tangent angle
end
Ytot = curv2xy_quick(curv,ssc,theta0,x0,y0); %Integrate curvature to yield xy

%Determine whether flagellum is inside cell body
indmax = ceil(0.5*size(Ytot,1));
isinbody = sum(inpolygon(Ytot(indmax:end,2),Ytot(indmax:end,3),xperim,yperim));

%Put limit on allowable curvature
rhomin = 1/50; %Minimum radius of curvature for flagellum of 1 micron.
curvmax = 1/rhomin/scale/lf0; %Maximum allowable curvature for actual flagellum
if max(abs(curv)) > curvmax
    curv2big = 1;
else
    curv2big = 0;
end

%Put limit on allowable tangent angle
if lr == 1
    thetamin = pi/6 + phi_body;
    thetamax = 3*pi/4 + phi_body;
else
    thetamin = -3*pi/4 + phi_body;
    thetamax = -pi/6 + phi_body;
end
wrongangle = 0;
for ii=1:size(Ytot,1)
   if Ytot(ii,1) > thetamin & Ytot(ii,1) < thetamax
       wrongangle = wrongangle + 1;
   end
end

C   = [];
Ceq = isinbody + curv2big + wrongangle;

% if debugfmc ~=0
%     formatSpec = 'isinbody %2u, curv2big %2u, wrongangle %2u, \n';
%     fprintf(formatSpec,isinbody,curv2big,wrongangle);
% end
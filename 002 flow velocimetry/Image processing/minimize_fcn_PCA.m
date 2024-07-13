function Dmin=minimize_fcn_PCA(B,xlim,ylim,lf0,scale,x0,y0,theta0,xperim,yperim,phi_body,lr,nmodes,princpts,ssc,FGinterp,debugfmc)
%% FUNCTION miminize_fcn_PCA
% Minimizes the cost of a curve on an image. The cost function consists of
% the average intensity value at the interpolation nodes plus a cost for
% bending of the curve and the fit to already detected points.
%% INPUTS
%B          Manipulation variable (shape scores) (>0 for lr == 2, <0 for lr == 1)
%xflag      x of already detected points
%yflag      y of already detected points
%xlim       Max x (size of image)
%ylim       Max y (size of image)
%lf0        Length of flagellum [micron]
%scale      Scale in [px/micron]
%x0         Starting point of integration in x
%y0         Starting point of integration in x
%theta0     Starting point of integration in theta
%lr         Left/right flagellum
%index      Last correctly detected point
%nmodes     Number of PCA modes to take into account
%princpts   Principal components (shape modes)
%ssc        Interpolation grid
%FGinterp   Griddedinterpolant of foreground image
%debugfmc   Debug variable
%% OUTPUTS
%Dmin   Value of cost function

if lr == 1
    curv = -princpts(1,2:end)' - princpts(2:nmodes+1,2:end)'*B;
   	theta0 = theta0 - princpts(1,1) - princpts(2:nmodes+1,1)'*B;
else
    curv = princpts(1,2:end)' + princpts(2:nmodes+1,2:end)'*B;
    theta0 = theta0 + princpts(1,1) + princpts(2:nmodes+1,1)'*B;
end
Ytot = curv2xy_quick(curv,ssc,theta0,x0,y0);

% figure(5),clf,hold on,plot(Ytot(:,3),Ytot(:,2),'r','LineWidth',2)
% plot(yflag,xflag,'bo'),axis equal;pause(eps)

%Image cost
ind = find(Ytot(:,2) > 0 & Ytot(:,2) < xlim & Ytot(:,3) > 0 & Ytot(:,3) < ylim);
intens = FGinterp(Ytot(ind,3),Ytot(ind,2));    %Intensity at [x,y]
Eim = sum(intens)/length(ind);  %Measure of fit to foreground image 

%Track development of shape for debugging purposes
if debugfmc == 3
    figure(5),clf, imshow(FGinterp.Values),hold on
    plot(Ytot(:,2),Ytot(:,3),'r','LineWidth',2); 
end

% Compute bending cost
curv = curv.*scale.*lf0;
Eb   = (ssc(2)-ssc(1))/lf0/scale*sum(curv(1:end-1).^2+(curv(2:end).^2-curv(1:end-1).^2)); %Equivalent to Eb=trapz(ssc,curv.^2), but faster

%% CONSTRAINTS
%Determine whether flagellum is inside cell body
indmax = ceil(0.5*size(Ytot,1));
isinbody = sum(inpolygon(Ytot(indmax:end,2),Ytot(indmax:end,3),xperim,yperim));

%Put limit on allowable curvature (curvature is already in 1/micron!)
rhomin = 1/50;      %Minimum radius of curvature [micron]
curvmax = 1/rhomin; %Maximum allowable curvature for actual flagellum   [1/micron]
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
   if (Ytot(ii,1) > thetamin) && (Ytot(ii,1) < thetamax)
       wrongangle = wrongangle + 1;
   end
end

Ceq = isinbody + curv2big + wrongangle;

%% ALL TOGETHER
wgt = [1 2e-3 1000];%[2.5 1 2e-3];
Dmin = sum(wgt.*[Eim Eb Ceq]);
if debugfmc ~=0
    formatSpec = 'Eim %3.7f, Eb %3.7f, body %3.7f, curv %3.7f, angle %3.7f, Dmin %3.7f \n';
    fprintf(formatSpec,Eim*wgt(1),Eb*wgt(2),wgt(3)*isinbody,wgt(3)*curv2big,wgt(3)*wrongangle,Dmin);
end

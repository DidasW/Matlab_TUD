function Dmin=xy2PCA(B,xflag,yflag,lf0,scale,x0,y0,theta0,lr,nmodes,princpts,ssc,debugfmc)
%% FUNCTION xy2PCA
% Converts xy-coordinates to PCA shape scores
%% INPUTS
%B          Manipulation variable (shape scores) (>0 for lr == 2, <0 for lr == 1)
%xflag      x of already detected points
%yflag      y of already detected points
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

%Cost of fit to already detected points
%wgt = 1-0.5*linspace(0,1,length(xflag))';
Ed = sum(sqrt((Ytot(:,2)-xflag).^2+(Ytot(:,3)-yflag).^2))./scale./lf0;         %Measure of fit to points already detected

%Track development of shape for debugging purposes
if debugfmc == 3
    figure(5),clf, hold on,plot(Ytot(:,2),Ytot(:,3),'r','LineWidth',2); 
    plot(xflag(:),yflag(:),'bo'); pause(eps);
end

% Compute bending cost
curv = curv.*scale.*lf0;
Eb   = (ssc(2)-ssc(1))/lf0/scale*sum(curv(1:end-1).^2+(curv(2:end).^2-curv(1:end-1).^2)); %Equivalent to Eb=trapz(ssc,curv.^2), but faster
wgt = [1 1e-5];
Dmin = sum(wgt.*[Ed Eb]);
if debugfmc ~=0
    formatSpec = 'Ed %3.15f, Eb %3.15f, Dmin %3.15f \n';
    fprintf(formatSpec,Ed*wgt(1),Eb*wgt(2),Dmin);
end
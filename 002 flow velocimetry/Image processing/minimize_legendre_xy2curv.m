function Dmin=minimize_legendre_xy2curv(X,x,y,ssc,x0,y0,theta0)
%% FUNCTION miminize_legendre
% Minimizes the cost of a curve on an image. The cost function consists of
% the average intensity value at the interpolation nodes plus a cost for
% bending of the curve.
%% INPUTS
%X      Manipulation variable (list of curvatures)
%x0     starting point of integration in x
%y0     starting point of integration in x
%theta0 starting point of integration in theta
%Lgrid  Grid in s corresponding to curvature nodes
%% OUTPUTS
%Dmin   Value of cost function

Ytot = curv2xy_quick(X,ssc,theta0,x0,y0);
 
%Cost of fit to data points
Ed = sum(sqrt((x(:)-Ytot(:,2)).^2+(y(:)-Ytot(:,3)).^2))./length(x);

%Cost of bending
Eb   = (ssc(2)-ssc(1))*sum(X(1:end-1).^2+(X(2:end).^2-X(1:end-1).^2)); %Equivalent to Eb=trapz(ssc,curv.^2), but faster

wgt = [1 1e-5];%1e-3
Dmin = sum(wgt.*[Ed Eb]);
% figure(7), clf, hold on, plot(y,x,'k')
% plot(Ytot(:,3),Ytot(:,2),'r'), axis equal, pause(eps)
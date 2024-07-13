function [curv,theta0] = xy2curv(x,y,ssc,optsfmc)
%% FUNCTION XY2CURV Converts xy-curves to curvature profiles
%   Conversion from xy to curvature for rescaled data of length 1
%% INPUTS
%x          x coordinates
%y          y coordinates
%ssc        Grid where you want to know the curvature values
%optsfmc    Options for fmincon
%% OUTPUTS
%curv       Curvature values corresponding to the nodes of ssc
%theta0     Initial tangent angle

theta0  = atan2(y(2)-y(1),x(2)-x(1));
x0     = x(1);
y0     = y(1);

%Make finite differences approximation of curvature to generate a close
%initial condition
[dxds,dyds,dx2ds2,dy2ds2,X0] = deal(zeros(size(ssc)));
ds = ssc(2)-ssc(1);
dxds(2:end) = (x(2:end)-x(1:end-1))./ds;
dyds(2:end) = (y(2:end)-y(1:end-1))./ds;
dx2ds2(3:end) = (x(1:end-2)-2.*x(2:end-1)+x(3:end))./ds^2;
dy2ds2(3:end) = (y(1:end-2)-2.*y(2:end-1)+y(3:end))./ds^2;
X0(3:end) = (dxds(3:end).*dy2ds2(3:end)-dyds(3:end).*dx2ds2(3:end))./...
    (dxds(3:end).^2+dyds(3:end).^2).^1.5;

%Plot initial condition, reverse x and y to compensate for image coordinates
% Ytot = curv2xy_quick(X0,ssc,theta0,x0,y0);
% figure(8),clf,subplot(2,1,1),hold on, plot(y,x,'k'),title('Initial condition')
% plot(Ytot(:,3),Ytot(:,2),'r'), axis equal

%Generate upper and lower bounds
rho_min = 1/100; %Minimum radius of curvature for flagellum of 1 micron
LB = ones(size(X0));
LB = LB.*-1/rho_min;
UB = -LB;
[curv,~,~] = fmincon(@(X) minimize_legendre_xy2curv(X,x,y,ssc,x0,y0,theta0),...
        X0,[],[],[],[],LB,UB,[],optsfmc);
    
%Plot improved fit, reverse x and y to compensate for image coordinates
% Ytot = curv2xy_quick(curv,ssc,theta0,x0,y0);
% figure(8), subplot(2,1,2),plot(y,x,'k'), hold on, title('Improved fit')
% plot(Ytot(:,3),Ytot(:,2),'r'), axis equal
end


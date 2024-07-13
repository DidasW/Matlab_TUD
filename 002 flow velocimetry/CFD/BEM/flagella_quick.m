function [Y] = flagella_quick(curv,ssc,X0)
%% FUNCTION CURV2XY_QUICK 
%Generates xy coordinates from a curvature profile
%% INPUTS
%curv       Curvature profile at points ssc
%ssc        Grid of points where output is desired
%theta0     Starting tangent angle [rad]
%x0         Starting x [px]
%y0         Starting y [px]
%% OUTPUTS
%Ytot       Matrix with tangent angle, x and y vectors
%Y(1)       Tangent angle                       [rad]
%Y(2)       x coordinate                        [micron]
%Y(3)       y coordinate                        [micron]
%Y(4)       Time derivative of tangent angle    [rad/s]
%Y(5)       x velocity                          [micron/s]
%Y(6)       y velocity                          [micron/s]
    ds = ssc(2)-ssc(1);
    Y(1,:) = X0;
    for ii=2:length(ssc)
        Y(ii,1) = Y(ii-1,1) + ds*curv(ii);
        Y(ii,2) = Y(ii-1,2) + ds*cos(Y(ii,1));
        Y(ii,3) = Y(ii-1,3) + ds*sin(Y(ii,1));
    end
end
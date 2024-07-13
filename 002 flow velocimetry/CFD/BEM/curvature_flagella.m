function [curv,dcurv] = curvature_flagella(s,t,a_f,b_f,MaxTerm,l)
%% FUNCTION CURVATURE_FLAGELLA
% Generates curvature and time derivative of curvature from
% time-discretized curvature profiles at a limited number of nodes.
%
% Curvature is defined in terms of Fourier coefficients for each node. The
% reconstructed waveforms give the curvature of a certain node over time.
% The frequencies are (1,2,3...MaxTerm) Hz.
%% INPUTS
%s              Grid of flagellum                   [micron]
%t              Time                                [s]
%a_f            Fourier coefficients for sines   	[micron]
%b_f            Fourier coefficients for cosines    [micron]
%MaxTerm        Number of harmonics                 [-]
%l              Length of flagellum                 [micron]
%% OUTPUTS
%curv           Curvature                           [1/micron]
%dcurv          Time derivative of curvature        [1/micron/s]

%Reconstruct curvature profiles
cosus = cos(2*pi*(1:MaxTerm)'*(t));
sinus = sin(2*pi*(1:MaxTerm)'*(t));

dcosus = -2*pi*(1:MaxTerm)'.*sin(2*pi*(1:MaxTerm)'*(t));
dsinus =  2*pi*(1:MaxTerm)'.*cos(2*pi*(1:MaxTerm)'*(t));

Curv_f  = a_f(MaxTerm+1,:)' + a_f(1:MaxTerm,:)'* cosus + b_f(1:MaxTerm,:)'* sinus;
dCurv_f = a_f(1:MaxTerm,:)'*dcosus + b_f(1:MaxTerm,:)'*dsinus;

%Interpolate to get curvature on actual grid
N     = size(a_f,2);            %Number of grid points  [-]
ss_c    = ( 0:l/(N-1):l )' ;    %Grid of curvature nodes   [micron]

curv    = interp1(ss_c,Curv_f,s,'spline');  %Curvature                      [1/micron]
dcurv   = interp1(ss_c,dCurv_f,s,'spline'); %Time derivative of curvature   [1/micron/s]        

curv = curv/2;
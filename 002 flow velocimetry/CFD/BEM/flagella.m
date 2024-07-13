function F = flagella(s,Y,time,a_f,b_f,MaxTerm,l)
%% FUNCTION CURVATURE_FLAGELLA
% Generates derivatives for integration by ode45
%% INPUTS
%s              Grid                                [micron]
%Y              Previous integration value          [#various]
%time           Time?                               [s]
%a_f            Fourier coefficients for sines   	[micron]
%b_f            Fourier coefficients for cossines   [micron]
%MaxTerm        Number of harmonics                 [-]
%l              Length of flagellum                 [micron]
%% OUTPUTS
%F              Vector of derivatives               [#various]

F    = zeros(6,1);
[curv,dcurv] = curvature_flagella(s,time,a_f,b_f,MaxTerm,l);

F(1) = curv;                    %Curvature          [1/micron]
F(2) = cos(Y(1));               %dx/ds              [-]
F(3) = sin(Y(1));               %dy/ds              [-]
F(4) = dcurv;                   %dkappa/dt          [1/micron/s]     
F(5) =-Y(4).*sin(Y(1));         %-dtheta/dt*dy/ds   [rad/s]
F(6) = Y(4).*cos(Y(1));         %dtheta/dt*dx/ds    [rad/s]

%Y(1)       Tangent angle                       [rad]
%Y(2)       x coordinate                        [micron]
%Y(3)       y coordinate                        [micron]
%Y(4)       Time derivative of tangent angle    [rad/s]
%Y(5)       ?
%Y(6)       ?
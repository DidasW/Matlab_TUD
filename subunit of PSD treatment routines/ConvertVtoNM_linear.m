%% Doc
%{
The documented AODtonmx(y) values are already used in converting the
Voltage coordinates into Position(nm) coordinates. Therefore, here calx and
caly are different in unit from those used in ConvertVtoNM.m
%}

%%
function nm=ConvertVtoNM_linear(Vx,Vy,CalFile_Linear_path)

% AODtonmx=1278.4; %[nm/MHz]
% AODtonmy=1286.0; %[nm/MHz]

% Load Calibration Parameters
cal=load(CalFile_Linear_path); %V to AOD Space Calibration Parameters
calx=cal(:,1);
caly=cal(:,2);

nm(:,1) = calx(2)*Vx + calx(3)*Vy + calx(1);
nm(:,2) = caly(2)*Vx + caly(3)*Vy + caly(1);
    




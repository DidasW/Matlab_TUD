function nm=ConvertVtoNM(Vx,Vy,CalFile_path)



AODtonmx=1278.4; %[nm/MHz]
AODtonmy=1286.0; %[nm/MHz]


% Load Calibration Parameters
cal=load(CalFile_path); %V to AOD Space Calibration Parameters
calx=cal(:,1);
caly=cal(:,2);

nm(:,1)=AODtonmx*(calx(1)+calx(2)*Vx+calx(3)*Vy+calx(4)*Vx.^2+calx(5)*Vy.^2+calx(6)*Vx.^3+calx(7)*Vy.^3+calx(8)*Vx.^4+calx(9)*Vy.^4+calx(10)*Vx.^5+calx(11)*Vy.^5+calx(12)*Vx.*Vy+calx(13)*Vx.^2.*Vy+calx(14)*Vx.*Vy.^2+calx(15)*Vx.^3.*Vy+calx(16)*Vx.^2.*Vy.^2+calx(17)*Vx.*Vy.^3+calx(18)*Vx.^4.*Vy+calx(19)*Vx.^3.*Vy.^2+calx(20)*Vx.^2.*Vy.^3+calx(21)*Vx.*Vy.^4-26);
nm(:,2)=AODtonmy*(caly(1)+caly(2)*Vx+caly(3)*Vy+caly(4)*Vx.^2+caly(5)*Vy.^2+caly(6)*Vx.^3+caly(7)*Vy.^3+caly(8)*Vx.^4+caly(9)*Vy.^4+caly(10)*Vx.^5+caly(11)*Vy.^5+caly(12)*Vx.*Vy+caly(13)*Vx.^2.*Vy+caly(14)*Vx.*Vy.^2+caly(15)*Vx.^3.*Vy+caly(16)*Vx.^2.*Vy.^2+caly(17)*Vx.*Vy.^3+caly(18)*Vx.^4.*Vy+caly(19)*Vx.^3.*Vy.^2+caly(20)*Vx.^2.*Vy.^3+caly(21)*Vx.*Vy.^4-26);





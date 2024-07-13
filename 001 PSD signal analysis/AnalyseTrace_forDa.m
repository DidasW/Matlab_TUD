clear all
close all 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%include right path in the line below to save time :)
[dfn,dpn]=uigetfile(['C:\','/*.*'],'Select Data File');
[cfn1,cpn1]=uigetfile([dpn,'/*.*'],'Position Calibration 1');
sfn1=[cfn1(1:(length(cfn1)-4)),'stiff1'];

rawDat=dlmread([dpn,dfn]);

rawnmdata=ConvertVtoNM(rawDat(:,1),rawDat(:,2),[cpn1,cfn1]);
%This comes out in AOD coordinates, must convert to PSD Coords
rawnmdata(:,1:2)=rotateCoords(rawnmdata(:,1:2),-45);
%Now in PSD Coordinates
% 
figure
plot(rawnmdata(:,1))
figure
plot(rawnmdata(:,2))




stiffvals=dlmread([cpn1,sfn1]);
xstiff=stiffvals(1);
ystiff=stiffvals(2);
fdat(:,1)=rawnmdata(:,1)*xstiff;
fdat(:,2)=rawnmdata(:,2)*ystiff;




time=(rawDat(:,5)-rawDat(2,5))./1000;


%Plot distance vs time
figure
plot(time,rawnmdata(:,1),'k',time,rawnmdata(:,2),'b');
xlabel('time (s)')
ylabel('nm')
grid on;




%Plot force vs time
figure
plot(time,fdat(:,1),'k',time,fdat(:,2),'b')
xlabel('time (s)')
ylabel('pN')
grid on



%Save data
[fn pn]=uiputfile(['C:\','/*.txt'],'Save file name');
dlmwrite([pn, fn],[time,rawnmdata(:,1),rawnmdata(:,2)]);


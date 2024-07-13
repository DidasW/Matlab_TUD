clear all
close all 
addpath('D:\002 MATLAB codes\000 Routine\subunit of PSD treatment routines');
folder='D:\000 RAW DATA FILES\170104 Flash light cutter, a function\003 1230 c2b2\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%include right path in the line below to save time :)
[dfn,dpn]=uigetfile  ([folder,'\AF_1230_c2b2\','*.dat'],'Select Data File');           % data file path

% [cfn1,cpn1]=uigetfile([folder,'*.*'],'Position Calibration 1');   % 5th order polynomial coefficient filepath
cpn1 = 'D:\000 RAW DATA FILES\170104 Flash light cutter, a function\003 1230 c2b2\';
cfn1 = 'b3coef.txt';
spn1 = 'D:\000 RAW DATA FILES\170104 Flash light cutter, a function\003 1230 c2b2\';
sfn1 = 'stiff1.txt';
% [sfn1,spn1]=uigetfile([folder,'*.*'],'Stiffness record');         % stiffness file path

rawDat=dlmread([dpn,dfn]);
% test_zero=find(rawDat(:,5)==0);
% rawDat(test_zero,:) = [];
substrate = dlmread('D:\000 RAW DATA FILES\170104 Flash light cutter, a function\003 1230 c2b2\loc\b3loc.dat');
rawDat(:,1) = rawDat(:,1) - mean(substrate(:,1));
rawDat(:,2) = rawDat(:,2) - mean(substrate(:,2));


rawnmdata=ConvertVtoNM(rawDat(:,1),rawDat(:,2),[cpn1,cfn1]);
%This comes out in AOD coordinates, must convert to PSD Coords
% rawnmdata(:,1:2)=rotate_mirror_Coords(rawnmdata(:,1:2),35);
%Now in PSD Coordinates
% 
% figure
% plot(rawnmdata(:,1))
% figure
% plot(rawnmdata(:,2))




stiffvals=dlmread([spn1,sfn1]);
xstiff=stiffvals(1);
ystiff=stiffvals(2);
fdat(:,1)=rawnmdata(:,1)*xstiff;
fdat(:,2)=rawnmdata(:,2)*ystiff;



time = (1:length(rawDat))/50;
% time=(rawDat(:,5)-rawDat(2,5))./1000;

% 
% %Plot distance vs time
% fig1 = figure('Name','Raw nm data','NumberTitle','off');
% plot(time,smooth(rawnmdata(:,1),99),'k.',time,smooth(rawnmdata(:,2),99),'b.','MarkerSize',4);
% xlim([0,140]);
% xlabel('time (ms)');
% ylabel('nm');
% grid on;
% title(sprintf('%s',['Displacement@pos-',dfn(4:end-4)]));
% 




%Plot force vs time
fig2 = figure('Name','Force data','NumberTitle','off');

plot(time,smooth(fdat(:,1),99),'r',time,smooth(fdat(:,2),99),'b','Linewidth',2);
legend('y','x');
xlim([0,200]);
ylim([-2,4]);
xlabel('Time (ms)','FontSize',18,'FontWeight','bold');
ylabel('Force (pN)','FontSize',18,'FontWeight','bold');
title(sprintf('%s',['Force@pos-',dfn(4:end-4)]));
grid on


% saveas(fig1 , [folder,'AF force figs2_no rot\','Displacement_at_',dfn(4:end-4),'.png'],  'png');
saveas(fig2 , [folder,'AF force figs2_no rot\','Force_at_',dfn(4:end-4),'.png'],  'png');
% %Save data
% [fn,pn]=uiputfile(['C:\','/*.txt'],'Save file name');
% dlmwrite([pn, fn],[time,rawnmdata(:,1),rawnmdata(:,2)]);


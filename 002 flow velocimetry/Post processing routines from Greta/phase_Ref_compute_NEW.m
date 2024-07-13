close all
clear all 
clc
%compute specrtogram and hist


%USE this routine if you want to crop a different mask in the images in the
%folder try/
%highlight flagella with region growing,compute frequency on small parts of
%signal, smoothing every image, replace adapthisteq with  imadjust  
addpath('F:\functions\')
%-----------------------------------
% PARAMETERS TO INITIALIZE
path2=('F:/5-12/cell2/'); %path for the flagella signal
path3=('F:/5-12/calpulse/'); %path for the bead signal
cd(path2)
pts2=[5];%exp

ppt=13;%cal
load(['piezo point ',num2str(pts2),'.mat'])

load(['point',num2str(pts2),'.mat'])

FsFlag=Fs;
figure;

p1=plot(f(nd),t,'k','linewidth',2);
hold on, 
p2=plot(f2(nd2),t2,'linewidth',2);


 F=f(nd);
F(:)=f_imp;
hold on, 
p3=plot(F,t,'r','linewidth',2);
xlim([45 60])

v=legend([p1 p2],{'Flagella 1 freq','Flagella 2 freq'});
set(v,'fontsize',12)
legend('boxoff')
xlabel('Frequency (Hz)','FontSize',24,'Fontweight','bold')
ylabel('Time [s]','FontSize',24,'Fontweight','bold')
title(['Flagella frequency point ',num2str(pt)])

pause 
% Ph1=Ph2;
%choose best flagellum

% colormap bone
load([path3,'point',num2str(ppt),'.mat'],'Tot_disp','I_bk_tot','Fmax1');
Fmax1 %check that I loaded the right point frequency of piezo signal during tracking of bead
f_imp %frequency of piezo during experiment on flagella
%find peak of the light pulse signal from both the experiment and the
%calibration test and align the 2 so that you can overlap the piezo signal
%from calibration with the experiment

% 1. calibration test
M1=mean(I_bk_tot)
I_bk_tot=abs(I_bk_tot-M1);
p1=find(I_bk_tot>0.06,1) %point where there is first pulse
figure,plot(I_bk_tot)
%2. Experiment
M2=mean(Bkg_tot)
Bkg_tot=abs(Bkg_tot-M2);
figure,plot(Bkg_tot)
p2=find(Bkg_tot>0.06,1) %point where there is first pulse

if isempty(p1)
    return
elseif isempty(p2)
    return
end
sh=p2-p1; % the shift I have to impose on the calibration signal
piezost=circshift(Tot_disp,[0,sh]);
I_bk_tot=circshift(I_bk_tot,[0 sh]);

figure, plot(piezost)
hold on,plot(Bkg_tot.*100,'r')
figure, plot(piezost)
hold on,plot(Ph1,'r')
hold on,plot(Bkg_tot.*100+10,'c')
hold on,plot(I_bk_tot.*100+20,'g')
legend('piezo','flagella','flash calibration','flash experiment')
xlim([1800 3000])
pause
[x1,y1]=ginput(2);
x1=round(x1);
dpie=diff(piezost);
figure,plot(dpie)
%  figure,plot(dpie)
hold on, plot((piezost/3-40),'r')
legend('dx(t)/dt','x(t)')


%detects initial phase difference over 10 periods
piezo_p=piezost(x1(1):x1(2));
figure,plot(piezost)
peaksP=[];
for ll=2:(length(piezo_p)-1)
    
if(piezo_p(ll)>piezo_p(ll-1)&& piezo_p(ll+1)<piezo_p(ll)) %pueaks are the points where the value is larger than the neighbours
 peaksP(end+1)=x1(1)+ll-1; %I make a list with frames numbers where it is minimum
 
end
end
Z=zeros(size(peaksP));
hold on,plot(peaksP,piezost(peaksP),'or')
title('piezo signal')

Hp=hilbert(dpie); % take the Hilbert transform to compute the phase at the end
PhP=atan2(imag(Hp),real(Hp));
figure,plot(PhP)
hold on,plot(peaksP,PhP(peaksP),'or') %at the peaks of piezo signal the phase is max or min, now I want that the flagella phase is also , max /min when flagella are straight
title('Diff(piezo)')
PrefP=mean(PhP(peaksP)) 


cd(num2str(pts2))
 D = dir('*.tif'); %check how many images there are
 list =1: length(D(not([D.isdir])));
 if list(end)<10000
     format=('%4.4d');
 else
     format=('%6.6d');
 end
%  pause
close all
% break
% save(['../frames point ',num2str(pts2)],'figs')

load(['../frames point ',num2str(pts2)])

%check that I selected the right ones:

peaksF=figs;
for kk=1:length(figs)
      n=num2str((figs(kk)),format);
      n
       file=([num2str(pts2),'_',n,'.tif']);
        [I]=imread(file);
        I=im2double(I);
           
    figure, imshow(I),

end
% pause
PrefF=mean(Ph1(peaksF))
PhPunw=unwrap_phase(PhP);

Ph1unw=unwrap_phase(Ph1);
figure,plot(PhPunw)
hold on,plot(Ph1unw,'r')

figure,
subplot(2,1,1),plot(PhPunw)
hold on,plot(peaksP,PhPunw(peaksP),'or') %at the peaks of piezo signal the phase is max or min,
title('\Phi_{piezo}-\Phi_{ref}')
subplot(2,1,2),plot(Ph1)
hold on,plot(peaksF,Ph1(peaksF),'or') %at the peaks of piezo signal the phase is max or min,
title('\Phi_{flag}-\Phi_{ref}')
%    save(['../frames point ',num2str(pts2),'.mat'],'figs')
Ph1unwRef=Ph1unw-PrefF;

PhPunwRef=PhPunw-PrefP;

PhPunwRef=PhPunwRef';
Lp=length(PhPunwRef);
Lf=length(Ph1unwRef);
if FsFlag==Fs
    if Lp>Lf
        PhaseNew=Ph1unwRef-PhPunwRef(1:Lf);
    else
        PhaseNew=Ph1unwRef(1:Lp)-PhPunwRef;
    end
end

TimeNew=(1:length(PhaseNew))/Fs;
PhaseNew=PhaseNew/(2*pi);
PhaseNew=smooth(PhaseNew,15);



figure,plot(PhaseNew)
pause
dial=inputdlg({'x values to compute phase? (Enter space separated numbers)'},'Inter',[1 50]); %insert the frames where phase is flat, then it will compute phase difference
Inter=str2num(dial{:});
ph_tot=[];
std_t=[];
 for tt=1:2:length(Inter)
     ph_mean=mean(PhaseNew(Inter(tt):Inter(tt+1)));
     stD=std(PhaseNew(Inter(tt):Inter(tt+1)));
    ph_meanR=ph_mean-round(ph_mean) 
  ph_tot=[ph_tot ph_meanR]; %calculate the intervals of time in which is synchronous
  std_t=[std_t stD];% st dev of all phase values  in the intervals where is flat					

 end
%  ph_tot 

 std_t=mean(std_t);
 
 
Med2=mean(ph_tot); 
 disp(['mean phase=',num2str(Med2)])
%  disp(['st1=',num2str(std_t)])
% Med2=Med2-round(Med2)
stDT=std(ph_tot);% stdev of mean phase in different intervals	
disp(['st 2 =',num2str(stD)])


 save(['../phase reference point ',num2str(pts2),'.mat'],'TimeNew','PhaseNew','PrefF','PrefP','Med2','stD')

dPh=PhaseNew-round(PhaseNew);

pulse=p2/Fs
 

T=1:length(Bkg_tot);

T=T/Fs;

figure,plot(dPh)
[x2,y2]=ginput(2);
x2=round(x2);
Med=mean((dPh(x2(1):x2(2))))
figure,plot(TimeNew,dPh)
hold on,plot(T,Bkg_tot+0.5,'r')
hold on,plot(pulse,0.5,'sm','Markersize',10)  

% save(['../2REFpoint ',num2str(pts2),'.mat'],'TimeNew','PhaseNew','pulse','Fs','f_imp','Ph1unwRef','PhPunwRef')
% k=pts2;
% cd ../
% Fx=strcat('Phase3-8.xlsx');
% cell1=strcat('A',num2str(k));
% [status msg]=xlswrite(Fx,k,'Foglio1',cell1);
% cell2=strcat('B',num2str(k));
% [status msg]=xlswrite(Fx,Med2,'Foglio1',cell2);
% cell3=strcat('C',num2str(k));
% [status msg]=xlswrite(Fx,stD,'Foglio1',cell3);

%%

% fitting for far points

close all
clear all 
clc
%compute specrtogram and hist


%USE this routine if you want to crop a different mask in the images in the
%folder try/
%highlight flagella with region growing,compute frequency on small parts of
%signal, smoothing every image, replace adapthisteq with  imadjust  
addpath('P:\functions\')
%-----------------------------------
% PARAMETERS TO INITIALIZE
path2=('F:/3-8/'); %path for the flagella signal
cd(path2)
pts2=8;
load(['REFpoint ',num2str(pts2),'.mat'])

%crop part of signal for fitting

figure,plot(PhaseNew)
pause

[px,py]=ginput(2)

Phasepart=PhaseNew(px(1):px(2));

Timepart=TimeNew(px(1):px(2));

figure,plot(Phasepart)
[px1,py1]=ginput(4);


Phaseint1=Phasepart(px1(1):px1(2));
timeint1=Timepart(px1(1):px1(2))
X0=[3; -300];
[X1, resnorm]=lsqcurvefit(@lin_fit1,X0,timeint1,Phaseint1') %fit the decay before synchrony
Y1=X1(1)*Timepart+X1(2);

% 


Phaseint2=Phasepart(px1(3):px1(4));
timeint2=Timepart(px1(3):px1(4));
X0=[3; -300];
[X2, resnorm]=lsqcurvefit(@lin_fit1,X0,timeint2,Phaseint2') %fit the flat part

Y2=X2(1)*Timepart+X2(2);
figure, plot(Timepart,Phasepart,'.')
   hold on,plot(Timepart,Y1,'r')
   hold on,plot(Timepart,Y2,'r')
save('Point ',num2str(pts2),'expintersect.mat')


%%
% %%
%case fake piezo

close all
clear all 
clc
%compute specrtogram and hist


%USE this routine if you want to crop a different mask in the images in the
%folder try/
%highlight flagella with region growing,compute frequency on small parts of
%signal, smoothing every image, replace adapthisteq with  imadjust  
addpath('P:\functions\')
%-----------------------------------
% PARAMETERS TO INITIALIZE
path2=('F:/11-18'); %path for the flagella signal
cd(path2)
pts2=[1:100];

for ii=1:length(pts2)
    Pt=pts2(ii);
    if exist(['point',num2str(Pt),'.mat'],'file')
load(['point',num2str(Pt),'.mat'])

% H1=hilbert(dFlag1);
% Ph1=atan2(imag(H1),real(H1));
% H2=hilbert(dFlag2);
% Ph2=atan2(imag(H2),real(H2));


figure,plot(phase1)
hold on,plot(phase2,'r')
title(['point',num2str(Pt)])
% % pause
% Ph1=Ph2;

Ph1unw=unwrap_phase(Ph1);

fake_p=0:Fs/f_imp:length(Ph1);
phaseF_p=(0:(length(fake_p)-1));
Time_i=0:length(Ph1)-1;
PhaseF_pi=interp1(fake_p,phaseF_p,Time_i);

phaseNew=Ph1unw/(2*pi)-PhaseF_pi';
% figure,plot(Time_i,PhaseF_pi)
% hold on,plot(Ph1unw,'r')
% hold on,plot(time1,phase1)
% figure,plot(Time_i/Fs,phaseNew)

TimeNew=Time_i/Fs;
PhaseNew=phaseNew;

save(['REFpoint ',num2str(Pt),'.mat'],'TimeNew','PhaseNew','Fs','f_imp')
    end
end

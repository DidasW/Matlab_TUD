addpath('F:\functions\')
% % 
% % 
% % Subtract REF phase to flagella phase so that the extended flagella are at
% % phase 0
% 
% %point6
% 
% PhF=-phishape(:,2); %select the best one which is flag 2in the image processing (trans)
% 
% % figure,plot(beginimg:endimg,-phishape(:,1),'b'),
% % hold on, plot(beginimg:endimg,-phishape(:,2),'r'),
% framesREF=[5559,5573,5601,5628,5642,5656,5683,5697,5724,5738,5752];
% frInd=framesREF-beginimg+1;
% PrefF=mean(PhF(frInd))-0.13
% 
% figure,plot(beginimg:endimg,PhF)
% hold on,plot(framesREF,PhF(frInd),'o')
% 
% PhFunw=unwrap_phase(PhF);
% 
% 
% PhFunwRef=PhFunw-PrefF;
% PhFunwRefSM=smooth(PhFunwRef,5);
% figure, plot(PhFunwRefSM)
% hold on,plot(PhFunwRef)
% %wrap phase again
% % PhFwrSM=wrap_phase(PhFunwRefSM);
% % PhFwr=wrap_phase(PhFunwRef)
% 
% figure,plot(PhFwrSM)
% % hold on,plot(PhFwr)
% % legend('smoothed phase','non smoothed phase')
% temp=PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi;
% 
% figure,plot(beginimg:endimg,temp)
% hold on,plot(framesREF,temp(frInd),'o')
% 
% load('P:/5-12/cell2/PieREFcrop pt6.mat');
% 
% %
% pieunwREF=unwrap_phase(PhPwrRef);
% figure,plot(pieunwREF)
% 
% Deltaphi=PhFunwRefSM-pieunwREF';
% Deltaphi=Deltaphi./(2*pi);
% figure,plot(beginimg:endimg,Deltaphi,'linewidth',2)
% 
% figure,plot(beginimg:endimg,PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi)
% 
% 
% % pause
% save('PhaseREFpt6.mat','Deltaphi','PhFwrSM','PhFunwRefSM')
% % 
% 






% %Subtract REF phase to flagella phase so that the extended flagella are at
% %phase 0
% 
% %point5
% 
% PhF=-phishape(:,2); %select the best one which is flag 2in the image processing (trans)
% 
% figure,plot(beginimg:endimg,-phishape(:,2),'b'),
% % hold on, plot(beginimg:endimg,-phishape(:,2),'r'),
% % framesREF=[4947,4976,4990,5005,5019,5063,5080,5098,5112,5141];
% framesREF=[5063,5080,5098]; %select frames during antiphase cause I want to plot the 
% 
% frInd=framesREF-beginimg+1;
% hold on,plot(framesREF,PhF(frInd),'o')
% PrefF=mean(PhF(frInd))-0.35;
% 
% 
% PhFunw=unwrap_phase(PhF);
% figure,plot(beginimg:endimg,PhFunw)
% 
% PhFunwRef=PhFunw-PrefF;
% 
% PhFunwRefSM=smooth(PhFunwRef,10);
% temp=PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi;
% figure,plot(beginimg:endimg,PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi)
% hold on,plot(framesREF,temp(frInd),'o')
% 
% 
% figure, plot(beginimg:endimg,PhFunwRefSM)
% % hold on,plot(PhFunwRef)
% %wrap phase again
% PhFwrSM=wrap_phase(PhFunwRefSM);
% % PhFwr=wrap_phase(PhFunwRef)
% 
% figure,plot(PhFwrSM)
% % hold on,plot(PhFwr)
% % legend('smoothed phase','non smoothed phase')
% 
% load('P:/5-12/cell2/PieREFcrop pt5.mat');
% 
% %
% pieunwREF=unwrap_phase(PhPwrRef);
% figure,plot(pieunwREF)
% 
% Deltaphi=PhFunwRefSM-pieunwREF;
% Deltaphi=Deltaphi./(2*pi);
% Deltaphi=smooth(Deltaphi,20);
% figure,plot(beginimg:endimg,Deltaphi,'linewidth',2)
% 
% 
% 
% save('PhaseREFpt5.mat','Deltaphi','PhFwrSM','PhFunwRefSM')




%case no flow


PhF=-phishape(:,2); %select the best one which is flag 2in the image processing (trans)

figure,plot(beginimg:endimg,phishape(:,2),'b'),
% hold on, plot(beginimg:endimg,-phishape(:,2),'r'),
% framesREF=[4947,4976,4990,5005,5019,5063,5080,5098,5112,5141];
framesREF=[29,75,135,165]; %select frames during antiphase cause I want to plot the 

frInd=framesREF-beginimg+1;
hold on,plot(framesREF,PhF(frInd),'o')
PrefF=mean(PhF(frInd));


PhFunw=unwrap_phase(PhF);
figure,plot(beginimg:endimg,PhFunw)

PhFunwRef=PhFunw-PrefF;

PhFunwRefSM=smooth(PhFunwRef,10);
temp=PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi;
figure,plot(beginimg:endimg,PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi)
hold on,plot(framesREF,temp(frInd),'o')


figure, plot(beginimg:endimg,PhFunwRefSM)
% hold on,plot(PhFunwRef)
%wrap phase again
PhFwrSM=wrap_phase(PhFunwRefSM);
% PhFwr=wrap_phase(PhFunwRef)

figure,plot(PhFwrSM)
% hold on,plot(PhFwr)
% legend('smoothed phase','non smoothed phase')



save('PhaseREFpt0Chris.mat','PhFwrSM','PhFunwRefSM')




% %case ptx no flow cis
% 
% 
% PhF=-phishape(:,1); %select the best one which is flag 2in the image processing (trans)
% 
% % figure,plot(beginimg:endimg,-phishape(:,1),'b'),
% % hold on, plot(beginimg:endimg,-phishape(:,2),'r'),
% % framesREF=[4947,4976,4990,5005,5019,5063,5080,5098,5112,5141];
% framesREF=[1570,1581,1591]; %select frames during antiphase cause I want to plot the 
% 
% frInd=framesREF-beginimg+1;
% hold on,plot(framesREF,PhF(frInd),'o')
% PrefF=mean(PhF(frInd));
% 
% 
% PhFunw=unwrap_phase(PhF);
% figure,plot(beginimg:endimg,PhFunw)
% 
% PhFunwRef=PhFunw-PrefF;
% 
% PhFunwRefSM=smooth(PhFunwRef,5);
% temp=PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi;
% figure,plot(beginimg:endimg,PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi)
% hold on,plot(framesREF,temp(frInd),'o')
% 
% 
% figure, plot(beginimg:endimg,PhFunwRefSM)
% % hold on,plot(PhFunwRef)
% %wrap phase again
% PhFwrSM=wrap_phase(PhFunwRefSM);
% % PhFwr=wrap_phase(PhFunwRef)
% 
% figure,plot(PhFwrSM)
% % hold on,plot(PhFwr)
% % legend('smoothed phase','non smoothed phase')
% 
% 
% 
% save('PhaseREFptx1Nofl-cis.mat','PhFwrSM','PhFunwRefSM')
% 
% 
% 
% %case ptx no flow trans
% 
% 
% PhF=-phishape(:,2); %select the best one which is flag 2in the image processing (trans)
% 
% figure,plot(beginimg:endimg,-phishape(:,1),'b'),
% % hold on, plot(beginimg:endimg,-phishape(:,2),'r'),
% % framesREF=[4947,4976,4990,5005,5019,5063,5080,5098,5112,5141];
% framesREF=[1584,1596,1606,1616]; %select frames during antiphase cause I want to plot the 
% 
% frInd=framesREF-beginimg+1;
% hold on,plot(framesREF,PhF(frInd),'o')
% PrefF=mean(PhF(frInd));
% 
% 
% PhFunw=unwrap_phase(PhF);
% figure,plot(beginimg:endimg,PhFunw)
% 
% PhFunwRef=PhFunw-PrefF;
% 
% PhFunwRefSM=smooth(PhFunwRef,5);
% temp=PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi;
% figure,plot(beginimg:endimg,PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi)
% hold on,plot(framesREF,temp(frInd),'o')
% 
% 
% figure, plot(beginimg:endimg,PhFunwRefSM)
% % hold on,plot(PhFunwRef)
% %wrap phase again
% PhFwrSM=wrap_phase(PhFunwRefSM);
% % PhFwr=wrap_phase(PhFunwRef)
% 
% figure,plot(PhFwrSM)
% % hold on,plot(PhFwr)
% % legend('smoothed phase','non smoothed phase')
% 
% 
% 
% save('PhaseREFptx1Nofl-trans.mat','PhFwrSM','PhFunwRefSM')
% 
% 
% 


%case ptx FLOW cis
% 
% 
% PhF=-phishape(:,1); %select the best one which is flag 2in the image processing (trans)
% 
% figure,plot(beginimg:endimg,-phishape(:,1),'b'),
% % hold on, plot(beginimg:endimg,-phishape(:,2),'r'),
% % framesREF=[4947,4976,4990,5005,5019,5063,5080,5098,5112,5141];
% framesREF=[554,566,620]; %select frames during antiphase cause I want to plot the 
% 
% frInd=framesREF-beginimg+1;
% hold on,plot(framesREF,PhF(frInd),'o')
% PrefF=mean(PhF(frInd));
% 
% 
% PhFunw=unwrap_phase(PhF);
% figure,plot(beginimg:endimg,PhFunw)
% 
% PhFunwRef=PhFunw-PrefF+0.3;
% 
% PhFunwRefSM=smooth(PhFunwRef,5);
% temp=PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi;
% figure,plot(beginimg:endimg,PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi)
% hold on,plot(framesREF,temp(frInd),'o')
% 
% 
% figure, plot(beginimg:endimg,PhFunwRefSM)
% % hold on,plot(PhFunwRef)
% %wrap phase again
% PhFwrSM=wrap_phase(PhFunwRefSM);
% % PhFwr=wrap_phase(PhFunwRef)
% 
% figure,plot(PhFwrSM)
% % hold on,plot(PhFwr)
% % legend('smoothed phase','non smoothed phase')
% 
% 
% 
% save('PhaseREFptx1Flow-cis.mat','PhFwrSM','PhFunwRefSM')
% 
% 
% 
% %case ptx FLOW trans
% 
% 
% PhF=-phishape(:,2); %select the best one which is flag 2in the image processing (trans)
% 
% figure,plot(beginimg:endimg,-phishape(:,1),'b'),
% % hold on, plot(beginimg:endimg,-phishape(:,2),'r'),
% % framesREF=[4947,4976,4990,5005,5019,5063,5080,5098,5112,5141];
% framesREF=[549,560,570,603]; %select frames during antiphase cause I want to plot the 
% 
% frInd=framesREF-beginimg+1;
% hold on,plot(framesREF,PhF(frInd),'o')
% PrefF=mean(PhF(frInd));
% 
% 
% PhFunw=unwrap_phase(PhF);
% figure,plot(beginimg:endimg,PhFunw)
% 
% PhFunwRef=PhFunw-PrefF+0.1;
% 
% PhFunwRefSM=smooth(PhFunwRef,5);
% temp=PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi;
% figure,plot(beginimg:endimg,PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi)
% hold on,plot(framesREF,temp(frInd),'o')
% 
% 
% figure, plot(beginimg:endimg,PhFunwRefSM)
% % hold on,plot(PhFunwRef)
% %wrap phase again
% PhFwrSM=wrap_phase(PhFunwRefSM);
% % PhFwr=wrap_phase(PhFunwRef)
% 
% figure,plot(PhFwrSM)
% % hold on,plot(PhFwr)
% % legend('smoothed phase','non smoothed phase')
% 
% 
% 
% save('PhaseREFptx1Flow-trans.mat','PhFwrSM','PhFunwRefSM')
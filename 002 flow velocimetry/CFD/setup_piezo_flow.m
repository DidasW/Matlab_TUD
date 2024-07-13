%{
the old setup_piezo_flow.m is renamed as 
setup_piezo_flow_LastReceivedFromGreta_backup.m
%}

load('Piezo 47 cis.mat') % put in the CFD folder for reference
% This is a file recording the piezo motion that generates an angular flow
% at 47 Hz

% Fmax1 %check that I loaded the right point frequency of piezo signal during tracking of bead
% f_imp %frequency of piezo during experiment on flagella
%find peak of the light pulse signal from both the experiment and the
%calibration test and align the two so that you can overlap the piezo signal
%from calibration with the experiment

piezocorrX = - X_s; %subtract mean, correct so that initial position moves towards cell
piezocorrY = - Y_s;
% piezocorr = - piezost/scale;
%  figure,hold on,plot(piezocorr), title('Piezo position'),xlabel('Frame no.'), ylabel('Position [micron]')

%CALCULATE PIEZO FLOW GRETA

% Hp=hilbert(piezocorrX); % take the Hilbert transform to compute the phase at the end
% PhP=atan2(imag(Hp),real(Hp));
PhP = calcHilbertPhase(piezocorrX);
phipiezo=unwrap(PhP);

% %% CALCULATE PIEZO PHASE
% %(PIEZO PHASE IS ZERO WHEN IN MAXIMUM FORWARD POSITION!)
% p1c         = p1+sh;    %Corrected index of start of piezo motion
% p12c        = p12+sh;   %Corrected index of end of piezo motion
% piezoinv    = -piezocorr(p1c:p12c);             %Inverted piezo position        [micron]
% minpk       = 2;                                %Minimum peak height [micron]
% [~,locs]    = findpeaks(piezoinv,'MinPeakHeight',minpk);
% locs        = [locs+p1c-1];     
% 
% phipiezo    = zeros(size(piezocorr));   %Phase of piezo     [rad]
% loc1        = find(piezocorr(p1c:locs(1)) == max(piezocorr(p1c:locs(1)))); %Find very first peak
% loc1        = loc1+p1c-1;
% phipiezo(1:p1c)             = pi/2; %Phase is constant before first point
% phipiezo(p1c+1:loc1)        = interp1([p1c loc1],[pi/2 pi],p1c+1:loc1);
% phipiezo(loc1+1:locs(1))    = interp1([loc1 locs(1)],[pi 2*pi],loc1+1:locs(1));
% %Phase linearly increases with 2*pi between each two peaks
% for kk=1:length(locs)-1 
%     phipiezo(locs(kk)+1:locs(kk+1)) = interp1([locs(kk) locs(kk+1)],...
%         [kk*2*pi (kk+1)*2*pi],locs(kk)+1:locs(kk+1));
% end
% loc2        = find(piezocorr(locs(end):p12c) == max(piezocorr(locs(end):p12c))); %Find stopping poitn
% loc2        = loc2+locs(end)-1;
% phipiezo(locs(end)+1:loc2) = interp1([locs(end) loc2],...
%     [phipiezo(locs(end)) phipiezo(locs(end))+pi/2],locs(end)+1:loc2);
% phipiezo(loc2+1:end) = phipiezo(loc2);  %Phase is constant after last point
% 
% % figure,hold on,plot(piezocorr),plot(locs,piezocorr(locs),'k*')
% title('Piezo position'),xlabel('Frame no.'), ylabel('Position [micron]')

%% SHIFT BACKGROUND FLOW
framesshift = 0; %Number of frames to shift
posind      = 1:1:length(piezocorrX);
posGIP      = griddedInterpolant(posind,piezocorrX,'spline','nearest');
piezocorrshX = posGIP(posind+framesshift);
posGIP      = griddedInterpolant(posind,piezocorrY,'spline','nearest');
piezocorrshY = posGIP(posind+framesshift);

% figure,hold on,plot(piezocorr,'k'),plot(piezocorrsh,'r')
% phipiezo    = phipiezo + flowshift;

%% CALCULATE VELOCITY
%5PT SAVITSKY-GOLAY
velbgX = zeros(size(piezocorrshX));
velbgY = zeros(size(piezocorrshY));

%Use forward differences for first two frames
velbgX(1:2) = (piezocorrshX(2:3)-piezocorrshX(1:2)).*fps;
velbgY(1:2) = (piezocorrshY(2:3)-piezocorrshY(1:2)).*fps;

%Use savitsky-golay for middle frames
velbgX(3:end-2) = (piezocorrshX(4:end-1)-piezocorrshX(2:end-3)+...
    2.*(piezocorrshX(5:end)-piezocorrshX(1:end-4)))./10.*fps;
%Use backward differences for last two frames
velbgX(end-1:end) = (piezocorrshX(end-1:end)-piezocorrshX(end-2:end-1)).*fps;
%Use savitsky-golay for middle frames
velbgY(3:end-2) = (piezocorrshY(4:end-1)-piezocorrshY(2:end-3)+...
    2.*(piezocorrshY(5:end)-piezocorrshY(1:end-4)))./10.*fps;
%Use backward differences for last two frames
velbgY(end-1:end) = (piezocorrshY(end-1:end)-piezocorrshY(end-2:end-1)).*fps;

[U,W] = deal(zeros(3,nframes));
beginframe = beginimg+beginctr-1;   %First frame processed in BEM
endframe = beginimg+endctr-1;       %Last frame processed in BEM
U(1,:) = -velbgX(beginframe:endframe); %NOTE THE MINUS SIGN! BEM code uses 
U(2,:) = -velbgY(beginframe:endframe); %NOTE THE MINUS SIGN! BEM code uses 

%velocity of a translating pipette in stationary medium, this corresponds 
%to MINUS the velocity of the flow on a stationary pipette.

% figure,plot(velbgX),hold on,plot(beginframe:endframe,U(1,:))
% figure,plot(velbgY),hold on,plot(beginframe:endframe,U(2,:))
% U(1,:) = vel(startframe:startframe+nframes-1);
% figure,plot(vel), title('Piezo velocity'),xlabel('Frame no.'), ylabel('Velocity [micron/s]')

%% Plot position and velocity vs piezo phase
% figure,subplot(2,1,1),hold on
%     x   = 0:1:length(phipiezo)-1;
%     y1  = piezocorr;
%     y2  = mod(phipiezo,2*pi);
%     [H,~,~]=plotyy(x,y1,x',y2');grid on
%     x1= loc1-20; x2=x1+50;
%     set(H(1),'xlim',[x1 x2]),set(H(2),'xlim',[x1 x2],'ylim',[0 2*pi],...
%         'ytick',0:pi/2:2*pi,'yticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
% subplot(2,1,2),hold on
%     y1  = velbg;
%     [H,~,~]=plotyy(x,y1,x',y2');grid on
%     x1= loc1-20; x2=x1+50;
%     set(H(1),'xlim',[x1 x2]),set(H(2),'xlim',[x1 x2],'ylim',[0 2*pi],...
%         'ytick',0:pi/2:2*pi,'yticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'})
%----------------------------------------------------------------------
% AVERAGE CYCLES - interpolate values throughout beat cycle, then average
% over all cycles
%----------------------------------------------------------------------
peakw = round(12e-3*fps);        %Minimum number of samples between detected peaks
phasejump = -pi;
%Detect periods by locating exact location of downgoing zero crossings
%by linear interpolation
for lr=1:2
   indbefore    = diff(mod(phicell{dd,lr},2*pi));   %Index before zero crossing
   indbefore    = find(indbefore < phasejump);
   while ~isempty(find(diff(indbefore)<peakw,1))
       ind1 = find(diff(indbefore)<peakw,1,'first');
       indbefore(ind1+1) = [];
   end
   indafter     = indbefore+1;                  %Index after zero crossing
   phival       = 2*pi:2*pi:(length(indbefore)-1+1)*2*pi;
   phibefore    = phicell{dd,lr}(indbefore);
   phiafter     = phicell{dd,lr}(indafter);
   avgbeat{dd,lr}.locs  = indbefore + (phival'-phibefore).*...
       (indafter-indbefore)./(phiafter-phibefore); %Interpolate
end

%Plot detected periods
% figure, subplot(2,2,1),hold on
%     plot(mod(phicell{dd,2},2*pi),'b'),
%     plot(avgbeat{dd,2}.locs,ones(length(avgbeat{dd,2}.locs)).*pi,'b*'), 
%     title('Left flagellum'),ylabel('Phase mod 2$\pi$ [rad]')
%     xlabel('Data point'), grid on
% subplot(2,2,2),hold on
%     plot(mod(phicell{dd,1},2*pi),'r'),
%     plot(avgbeat{dd,1}.locs,ones(length(avgbeat{dd,1}.locs)).*pi,'r*')
%     title('Right flagellum'),ylabel('Phase mod 2$\pi$ [rad]'),grid on
% subplot(2,2,3),hold on
%     plot(Pedl{dd,2},'k')
%     plot(avgbeat{dd,1}.locs,GIPPedl{dd,2}(avgbeat{dd,2}.locs),'k*')
% subplot(2,2,4),hold on
%     plot(Pedl{dd,1},'k')
%     plot(avgbeat{dd,1}.locs,GIPPedl{dd,1}(avgbeat{dd,1}.locs),'k*')        

datapts = 0:0.01:1;             %Dimensionless timescale of mean beat cycle
phipts = datapts.*(2*pi);
for lr=1:2
    avgbeat{dd,lr}.nperiods =  length(avgbeat{dd,lr}.locs)-1;    %Number of beat cycles
    %For each flagellum, calculate the mean beat cycle by making the
    %timescale dimensionless and interpolating on the fine non-dimensional
    %timescale
    for k=1:avgbeat{dd,lr}.nperiods
        xg  = [avgbeat{dd,lr}.locs(k),...
            ceil(avgbeat{dd,lr}.locs(k)):1:floor(avgbeat{dd,lr}.locs(k+1)),...
            avgbeat{dd,lr}.locs(k+1)];     %Grid points
        xgsc= (xg-xg(1))./(xg(end)-xg(1)); %Scaled grid [0-1]
        dataPv      = GIPPv{dd,lr}(xg);    %Viscous power
        dataEe      = GIPEe{dd,lr}(xg);    %Elastic energy
        dataPe      = GIPPe{dd,lr}(xg);    %Elastic power
        dataEFx     = GIPEFx{dd,lr}(xg);   %Summed force in x-direction    [N]
        dataEFy     = GIPEFy{dd,lr}(xg);   %Summed force in y-direction    [N]
        dataEFt     = GIPEFt{dd,lr}(xg);   %Total summed force             [N]
        dataftdens  = GIPftdens{dd,lr}({xg,flagcentroids{dd}});
        dataftdenspeak = max(dataftdens,[],2); %Maximum force density of each time step [N/m]
        dataftdenstip  = GIPftdenstip{dd,lr}(xg); %Force density                [N/m]
        dataphic    = GIPphic{dd,lr}(xg);
        dataomegac  = GIPomegac{dd,lr}(xg);
        dataZ       = sqrt(GIPB{dd,lr,1}(xg).^2 + GIPB{dd,lr,2}(xg).^2);
        %As a function of dimensionless cycle time
        GIPPvcyc    = griddedInterpolant(xgsc,dataPv,'linear');  %Interpolant objects
        GIPEecyc    = griddedInterpolant(xgsc,dataEe,'linear');
        GIPPecyc    = griddedInterpolant(xgsc,dataPe,'linear');
        GIPphiccyc  = griddedInterpolant(xgsc,dataphic,'linear');
        avgbeat{dd,lr}.Pvsc(k,:)   = GIPPvcyc(datapts); %Interpolate on fine grid
        avgbeat{dd,lr}.Eesc(k,:)   = GIPEecyc(datapts);
        avgbeat{dd,lr}.Pesc(k,:)   = GIPPecyc(datapts);
        avgbeat{dd,lr}.Ptsc(k,:)   = avgbeat{dd,lr}.Pvsc(k,:)+avgbeat{dd,lr}.Pesc(k,:);
        %As a function of phase angle
        dataphic    = dataphic-dataphic(1);
        avgbeat{dd,lr}.Pvphi(k,:)   = interp1(dataphic,dataPv,phi0,'linear','extrap'); %Interpolate on fine grid
        avgbeat{dd,lr}.Eephi(k,:)   = interp1(dataphic,dataEe,phi0,'linear','extrap');
        avgbeat{dd,lr}.Pephi(k,:)   = interp1(dataphic,dataPe,phi0,'linear','extrap');
        avgbeat{dd,lr}.Ptphi(k,:)   = avgbeat{dd,lr}.Pvphi(k,:) + avgbeat{dd,lr}.Pephi(k,:);
        avgbeat{dd,lr}.ftdenspeak(k,:) = interp1(dataphic,dataftdenspeak,phi0,'linear','extrap');
        avgbeat{dd,lr}.ftdensphitip(k,:) = interp1(dataphic,dataftdenstip,phi0,'linear','extrap');
        avgbeat{dd,lr}.EFxphi(k,:)  = interp1(dataphic,dataEFx,phi0,'linear','extrap');
        avgbeat{dd,lr}.EFyphi(k,:)  = interp1(dataphic,dataEFy,phi0,'linear','extrap');
        avgbeat{dd,lr}.EFtphi(k,:)  = interp1(dataphic,dataEFt,phi0,'linear','extrap');
        avgbeat{dd,lr}.omegacphi(k,:) = interp1(dataphic,dataomegac,phi0,'linear','extrap');
        avgbeat{dd,lr}.Zphi(k,:)    = interp1(dataphic,dataZ,phi0,'linear','extrap');
        %Other
        avgbeat{dd,lr}.duration(k) = (xg(end)-xg(1))./fps; %Duration of cycle [s]
        avgbeat{dd,lr}.phic(k,:)   = GIPphiccyc(datapts)-GIPphiccyc(0);
        avgbeat{dd,lr}.omegac(k,:) = sg5der(avgbeat{dd,lr}.phic(k,:)',...
            avgbeat{dd,lr}.duration(k)/(length(datapts)));
        avgbeat{dd,lr}.err_Pbend(k) = trapz(datapts.*avgbeat{dd,lr}.duration(k),...
            avgbeat{dd,lr}.Pesc(k,:));
        %Per cycle
        cycleinterp = linspace(avgbeat{dd,lr}.locs(k),avgbeat{dd,lr}.locs(k+1),50);
        xcycle = GIPxdl{dd,lr}({cycleinterp,flagcentroidsdl{dd}});
        ycycle = GIPydl{dd,lr}({cycleinterp,flagcentroidsdl{dd}});
        
        avgbeat{dd,lr}.Wv_cyc(k) = trapz(avgbeat{dd,lr}.duration(k).*datapts,...
            avgbeat{dd,lr}.Pvsc(k,:)); %Total work per cycle [J]
        avgbeat{dd,lr}.Z_area_cyc(k) = polyarea(...
            GIPB{dd,lr,1}(cycleinterp),GIPB{dd,lr,2}(cycleinterp));
        avgbeat{dd,lr}.meanEFt_cyc(k) = mean(avgbeat{dd,lr}.EFtphi(k,:));
        avgbeat{dd,lr}.f_cyc(k) = mean(interp1(dataind{dd},omegacell{dd,lr},...
            cycleinterp))/(2*pi);
        avgbeat{dd,lr}.Pvdl_cyc(k) = rms(GIPPvdl{dd,lr}(cycleinterp));
        avgbeat{dd,lr}.Pedl_cyc(k) = rms(GIPPedl{dd,lr}(cycleinterp));
        avgbeat{dd,lr}.Ptdl_cyc(k) = rms(GIPPtdl{dd,lr}(cycleinterp));
        [avgbeat{dd,lr}.xhull{k},avgbeat{dd,lr}.yhull{k},avgbeat{dd,lr}.area(k)] = ...
            areafromxy(xcycle,ycycle);
        avgbeat{dd,lr}.area(k) = avgbeat{dd,lr}.area(k);
        avgbeat{dd,lr}.xamp(k) = max(max(xcycle))-min(min(xcycle));
        
    end
    %Overall average
    avgbeat{dd,lr}.fcell = (GIPphic{dd,lr}(avgbeat{dd,lr}.locs(end))-...
        GIPphic{dd,lr}(avgbeat{dd,lr}.locs(1)))/...
        (avgbeat{dd,lr}.locs(end)-avgbeat{dd,lr}.locs(1))*fps/(2*pi); %Beat frequency
    avgbeat{dd,lr}.meanarea = median(avgbeat{dd,lr}.area);
    %Power of mean cycle
    avgbeat{dd,lr}.meanPv  = median(avgbeat{dd,lr}.Pvsc,1);   
    avgbeat{dd,lr}.meanEe  = median(avgbeat{dd,lr}.Eesc,1);
    avgbeat{dd,lr}.meanPe  = median(avgbeat{dd,lr}.Pesc,1);
    avgbeat{dd,lr}.meanPt  = avgbeat{dd,lr}.meanPv + avgbeat{dd,lr}.meanPe;
    avgbeat{dd,lr}.meanPvphi    = median(avgbeat{dd,lr}.Pvphi,1);   
    avgbeat{dd,lr}.meanEephi    = median(avgbeat{dd,lr}.Eephi,1);
    avgbeat{dd,lr}.meanPephi    = median(avgbeat{dd,lr}.Pephi,1);
    avgbeat{dd,lr}.meanPtphi    = avgbeat{dd,lr}.meanPvphi + avgbeat{dd,lr}.meanPephi;
    avgbeat{dd,lr}.meanftdenspeak = median(avgbeat{dd,lr}.ftdenspeak,1);
    avgbeat{dd,lr}.meanftdensphitip= median(avgbeat{dd,lr}.ftdensphitip,1);
    avgbeat{dd,lr}.meanEFxphi   = median(avgbeat{dd,lr}.EFxphi,1);
    avgbeat{dd,lr}.meanEFyphi   = median(avgbeat{dd,lr}.EFyphi,1);
    avgbeat{dd,lr}.meanEFtphi   = median(avgbeat{dd,lr}.EFtphi,1);
    %RMS power of mean cycle
    avgbeat{dd,lr}.PvRMS   = rms(avgbeat{dd,lr}.meanPv);
    avgbeat{dd,lr}.PeRMS   = rms(avgbeat{dd,lr}.meanPe);
    avgbeat{dd,lr}.PtRMS   = rms(avgbeat{dd,lr}.meanPt);
    avgbeat{dd,lr}.meantime= linspace(0,mean(avgbeat{dd,lr}.duration),length(datapts)); %Duration of mean cycle
    %Mean phase profiles
    avgbeat{dd,lr}.meanphic= median(avgbeat{dd,lr}.phic,1);
    avgbeat{dd,lr}.meanomegac = sg5der(avgbeat{dd,lr}.meanphic,...
            mean(avgbeat{dd,lr}.duration)/(length(datapts)));
    avgbeat{dd,lr}.meanomegacphi = median(avgbeat{dd,lr}.omegacphi,1);
    avgbeat{dd,lr}.meanomegacdl = sg5der(avgbeat{dd,lr}.meanphic./(2*pi),...
            1/(length(datapts)));
    avgbeat{dd,lr}.meanerr_Pbend = mean(avgbeat{dd,lr}.err_Pbend);
    avgbeat{dd,lr}.meanZphi = median(avgbeat{dd,lr}.Zphi,1);
end
%Calculate total powers
avgbeat{dd,3}.meanPv       = avgbeat{dd,1}.meanPv +avgbeat{dd,2}.meanPv; %Viscous power of average cycle         [W]
avgbeat{dd,3}.meanEe       = avgbeat{dd,1}.meanEe +avgbeat{dd,2}.meanEe; %Elastic energy of average cycle        [W]    
avgbeat{dd,3}.meanPe       = avgbeat{dd,1}.meanPe +avgbeat{dd,2}.meanPe; %Elastic power of average cycle         [W]    
avgbeat{dd,3}.meanPt       = avgbeat{dd,1}.meanPt +avgbeat{dd,2}.meanPt; %Total power of average cycle           [W]
avgbeat{dd,3}.meanPvphi    = avgbeat{dd,1}.meanPvphi +avgbeat{dd,2}.meanPvphi; %Viscous power of average cycle   [W]
avgbeat{dd,3}.meanEephi    = avgbeat{dd,1}.meanEephi +avgbeat{dd,2}.meanEephi; %Elastic energy of average cycle  [W]    
avgbeat{dd,3}.meanPephi    = avgbeat{dd,1}.meanPephi +avgbeat{dd,2}.meanPephi; %Elastic power of average cycle   [W]    
avgbeat{dd,3}.meanPtphi    = avgbeat{dd,1}.meanPtphi +avgbeat{dd,2}.meanPtphi; %Total power of average cycle     [W]
avgbeat{dd,3}.meanftdensphitip= median([avgbeat{dd,1}.ftdensphitip; avgbeat{dd,2}.ftdensphitip;],1);
avgbeat{dd,3}.meanEFxphi   = avgbeat{dd,1}.meanEFxphi+avgbeat{dd,2}.meanEFxphi;%Summed force in x-direction      [N]
avgbeat{dd,3}.meanEFyphi   = avgbeat{dd,1}.meanEFyphi+avgbeat{dd,2}.meanEFyphi;%Summed force in y-direction      [N]
avgbeat{dd,3}.meanEFtphi   = avgbeat{dd,1}.meanEFtphi+avgbeat{dd,2}.meanEFtphi;%Total summed force               [N]
avgbeat{dd,3}.PvRMS        = avgbeat{dd,1}.PvRMS  +avgbeat{dd,2}.PvRMS;  %Viscous RMS power of average cycle     [W]
avgbeat{dd,3}.PeRMS        = avgbeat{dd,1}.PeRMS  +avgbeat{dd,2}.PeRMS;  %Elastic RMS power of average cycle     [W]
avgbeat{dd,3}.PtRMS        = avgbeat{dd,1}.PtRMS  +avgbeat{dd,2}.PtRMS;  %Total RMS power of average cycle       [W]
avgbeat{dd,3}.meantime     = (avgbeat{dd,1}.meantime + avgbeat{dd,2}.meantime)/2;%Average time of average cycle  [s]
avgbeat{dd,3}.meanphic     = (avgbeat{dd,1}.meanphic + avgbeat{dd,2}.meanphic)/2;%Average phase of average cycle  [s]
avgbeat{dd,3}.meanomegac   = (avgbeat{dd,1}.meanomegac + avgbeat{dd,2}.meanomegac)/2;%Average phase speed of average cycle[s]
% avgbeat{dd,3}.Wv_cyc       = avgbeat{dd,1}.Wv_cyc + avgbeat{dd,2}.Wv_cyc; %Not possible, # of cycles need not be the same

%Dimensionless powers
for kk=1:3
   avgbeat{dd,kk}.meanPvdl = avgbeat{dd,kk}.meanPv.*facdlP(dd);    %Dimensionless average viscous power cycle  [-]
   avgbeat{dd,kk}.meanEedl = avgbeat{dd,kk}.meanEe.*facdlE(dd);    %Dimensionless average elastic energy cycle [-]
   avgbeat{dd,kk}.meanPedl = avgbeat{dd,kk}.meanPe.*facdlP(dd);    %Dimensionless average elastic power cycle  [-]
   avgbeat{dd,kk}.meanPtdl = avgbeat{dd,kk}.meanPt.*facdlP(dd);    %Dimensionless average total power cycle    [-]
   avgbeat{dd,kk}.meanPvphidl = avgbeat{dd,kk}.meanPvphi.*facdlP(dd);    %Dimensionless average viscous power cycle  [-]
   avgbeat{dd,kk}.meanEephidl = avgbeat{dd,kk}.meanEephi.*facdlE(dd);    %Dimensionless average elastic energy cycle [-]
   avgbeat{dd,kk}.meanPephidl = avgbeat{dd,kk}.meanPephi.*facdlP(dd);    %Dimensionless average elastic power cycle  [-]
   avgbeat{dd,kk}.meanPtphidl = avgbeat{dd,kk}.meanPtphi.*facdlP(dd);    %Dimensionless average total power cycle    [-]
   avgbeat{dd,kk}.meanEFxphidl = avgbeat{dd,kk}.meanEFxphi.*facdlF(dd);
   avgbeat{dd,kk}.meanEFyphidl = avgbeat{dd,kk}.meanEFyphi.*facdlF(dd);
   avgbeat{dd,kk}.meanEFtphidl = avgbeat{dd,kk}.meanEFtphi.*facdlF(dd);
   avgbeat{dd,kk}.PvRMSdl  = avgbeat{dd,kk}.PvRMS.*facdlP(dd);     %Dimensionless RMS viscous power        [-]
   avgbeat{dd,kk}.PeRMSdl  = avgbeat{dd,kk}.PeRMS.*facdlP(dd);     %Dimensionless RMS elastic power        [-]
   avgbeat{dd,kk}.PtRMSdl  = avgbeat{dd,kk}.PtRMS.*facdlP(dd);     %Dimensionless RMS total power          [-]
end
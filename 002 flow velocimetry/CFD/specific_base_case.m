%--------------------------------------------------------------------------
%% Weighed average over multiple datasets
%--------------------------------------------------------------------------
cyclestotal = 0;        %Total number of cycles
for dd=1:datasets; cyclestotal = cyclestotal+avgbeat{dd,1}.nperiods; end
for dd=1:datasets; w(dd) = avgbeat{dd,1}.nperiods/cyclestotal; end
ovmeantime = zeros(1,length(datapts));
[ovPvRMS, ovPeRMS, ovPtRMS, ovPvRMSdl, ovPeRMSdl, ovPtRMSdl] = deal(0);
[ovft_interpmat,ovftdens_interpmat] = deal(...
    zeros(length(phi0),length(flaginterpgrid),2*datasets));
for dd=1:datasets
    %Dimensional variables
    ovmeantime  = ovmeantime   +w(dd).*avgbeat{dd,3}.meantime; %Overall average cycle time                 [s]
    ovPvRMS     = ovPvRMS      +w(dd).*avgbeat{dd,3}.PvRMS;    %Overall viscous RMS power                  [W]
    ovPeRMS     = ovPeRMS      +w(dd).*avgbeat{dd,3}.PeRMS;    %Overall elastic RMS power                  [W]
    ovPtRMS     = ovPtRMS      +w(dd).*avgbeat{dd,3}.PtRMS;    %Overall total RMS power                    [W]
    %Dimensionless variables
    ovPvRMSdl   = ovPvRMSdl    +w(dd).*avgbeat{dd,3}.PvRMSdl;  %Overall dimensionless viscous RMS power    [-]
    ovPeRMSdl   = ovPeRMSdl    +w(dd).*avgbeat{dd,3}.PeRMSdl;  %Overall dimensionless elastic RMS power    [-]
    ovPtRMSdl   = ovPtRMSdl    +w(dd).*avgbeat{dd,3}.PtRMSdl;  %Overall dimensionless total RMS power      [-]
    for lr=1:2
        ovft_interpmat(:,:,dd+lr-1) = ft_interp{dd,lr}; 
        ovftdens_interpmat(:,:,dd+lr-1) = ftdens_interp{dd,lr}; 
    end
end
ovft     = median(ovft_interpmat,3);
ovftdens = median(ovftdens_interpmat,3);

%Calculation of percentiles
[phiscdata,Pvscdata,Eescdata,Pescdata,Ptscdata,err_Pbenddata] = deal([]);
[Pvscdldata,Eescdldata,Pescdldata,Ptscdldata,durtotal,err_Pbenddldata] = deal([]);
[Pvphidata,Eephidata,Pephidata,Ptphidata,ftdensphidata] = deal([]);
[Pvphidldata,Eephidldata,Pephidldata,Ptphidldata] = deal([]);
for dd=1:datasets
    %As a function of dimensionless cycle time
    phiscdata   = [phiscdata;   avgbeat{dd,1}.meanphic; avgbeat{dd,2}.meanphic;];
    Pvscdata    = [Pvscdata;    avgbeat{dd,1}.Pvsc;     avgbeat{dd,2}.Pvsc; ];
    Eescdata    = [Eescdata;    avgbeat{dd,1}.Eesc;     avgbeat{dd,2}.Eesc; ];
    Pescdata    = [Pescdata;    avgbeat{dd,1}.Pesc;     avgbeat{dd,2}.Pesc; ];
    Ptscdata    = [Ptscdata;    avgbeat{dd,1}.Ptsc;     avgbeat{dd,2}.Ptsc; ];
    Pvscdldata  = [Pvscdldata;  avgbeat{dd,1}.Pvsc.*facdlP(dd);     avgbeat{dd,2}.Pvsc.*facdlP(dd);  ];
    Eescdldata  = [Eescdldata;  avgbeat{dd,1}.Eesc.*facdlE(dd);     avgbeat{dd,2}.Eesc.*facdlE(dd);   ];
    Pescdldata  = [Pescdldata;  avgbeat{dd,1}.Pesc.*facdlP(dd);     avgbeat{dd,2}.Pesc.*facdlP(dd);   ];
    Ptscdldata  = [Ptscdldata;  avgbeat{dd,1}.Ptsc.*facdlP(dd);     avgbeat{dd,2}.Ptsc.*facdlP(dd);];
    durtotal    = [durtotal;    avgbeat{dd,1}.duration';        avgbeat{dd,2}.duration';];
    err_Pbenddata   = [err_Pbenddata;   avgbeat{dd,1}.err_Pbend';       avgbeat{dd,2}.err_Pbend';];
    %As a function of phase angle
    Pvphidata     = [Pvphidata;     avgbeat{dd,1}.Pvphi;      avgbeat{dd,2}.Pvphi; ];
    Eephidata     = [Eephidata;     avgbeat{dd,1}.Eephi;      avgbeat{dd,2}.Eephi; ];
    Pephidata     = [Pephidata;     avgbeat{dd,1}.Pephi;      avgbeat{dd,2}.Pephi; ];
    Ptphidata     = [Ptphidata;     avgbeat{dd,1}.Ptphi;      avgbeat{dd,2}.Ptphi; ];
    ftdensphidata = [ftdensphidata; avgbeat{dd,1}.ftdensphitip;     avgbeat{dd,2}.ftdensphitip;];
    Pvphidldata   = [Pvphidldata;   avgbeat{dd,1}.Pvphi.*facdlP(dd);      avgbeat{dd,2}.Pvphi.*facdlP(dd);  ];
    Eephidldata   = [Eephidldata;   avgbeat{dd,1}.Eephi.*facdlE(dd);      avgbeat{dd,2}.Eephi.*facdlE(dd);   ];
    Pephidldata   = [Pephidldata;   avgbeat{dd,1}.Pephi.*facdlP(dd);      avgbeat{dd,2}.Pephi.*facdlP(dd);   ];
    Ptphidldata   = [Ptphidldata;   avgbeat{dd,1}.Ptphi.*facdlP(dd);      avgbeat{dd,2}.Ptphi.*facdlP(dd);];
    err_Pbenddldata = [err_Pbenddldata;   avgbeat{dd,1}.err_Pbend'.*facdlE(dd);   avgbeat{dd,2}.err_Pbend'.*facdlE(dd);];
end
%As a function of dimensionless cycle time
ovmeanphic  = median(phiscdata,1);      %Overall cell angle                         [rad]
ovmeanPvsc  = 2.*median(Pvscdata,1);    %Overall viscous power cycle                [W]
ovmeanEesc  = 2.*median(Eescdata,1);    %Overall elastic energy cycle               [J]
ovmeanPesc  = 2.*median(Pescdata,1);    %Overall elastic power cycle                [W]
ovmeanPtsc  = 2.*median(Ptscdata,1);    %Overall total power cycle                  [W]
ovmeanPvscdl= 2.*median(Pvscdldata,1);  %Overall dimensionless viscous power cycle  [-]
ovmeanEescdl= 2.*median(Eescdldata,1);  %Overall dimensionless elastic energy cycle [-]
ovmeanPescdl= 2.*median(Pescdldata,1);  %Overall dimensionless elastic power cycle  [-]
ovmeanPtscdl= 2.*median(Ptscdldata,1);  %Overall dimensionless total power cycle    [-]
ovmeanerrPbend = 2.*mean(err_Pbenddata,1);
%As a function of phase angle
ovmeanPvphi     = 2.*median(Pvphidata,1);    %Overall viscous power cycle                [W]
ovmeanEephi     = 2.*median(Eephidata,1);    %Overall elastic energy cycle               [J]
ovmeanPephi     = 2.*median(Pephidata,1);    %Overall elastic power cycle                [W]
ovmeanPtphi     = 2.*median(Ptphidata,1);    %Overall total power cycle                  [W]
ovmeanftdensphitip = median(ftdensphidata,1);%Overall tip force density                  [N/m]   
ovmeanPvphidl   = 2.*median(Pvphidldata,1);  %Overall dimensionless viscous power cycle  [-]
ovmeanEephidl   = 2.*median(Eephidldata,1);  %Overall dimensionless elastic energy cycle [-]
ovmeanPephidl   = 2.*median(Pephidldata,1);  %Overall dimensionless elastic power cycle  [-]
ovmeanPtphidl   = 2.*median(Ptphidldata,1);  %Overall dimensionless total power cycle    [-]
ovmeanerrPbenddl = 2.*mean(err_Pbenddldata,1);

prctilevec = [10 25 75 90];
for k=1:length(datapts)
    %Percentiles
    ovPvp(:,k)      = prctile(2.*Pvscdata(:,k),prctilevec);
    ovEep(:,k)      = prctile(2.*Eescdata(:,k),prctilevec);
    ovPep(:,k)      = prctile(2.*Pescdata(:,k),prctilevec);
    ovPtp(:,k)      = prctile(2.*Ptscdata(:,k),prctilevec);
    ovPvdlp(:,k)    = prctile(2.*Pvscdldata(:,k),prctilevec);
    ovEedlp(:,k)    = prctile(2.*Eescdldata(:,k),prctilevec);
    ovPedlp(:,k)    = prctile(2.*Pescdldata(:,k),prctilevec);
    ovPtdlp(:,k)    = prctile(2.*Ptscdldata(:,k),prctilevec);
end
for k=1:length(phi0)
    ovPvphip(:,k)   = prctile(2.*Pvphidata(:,k),prctilevec);
    ovEephip(:,k)   = prctile(2.*Eephidata(:,k),prctilevec);
    ovPephip(:,k)   = prctile(2.*Pephidata(:,k),prctilevec);
    ovPtphip(:,k)   = prctile(2.*Ptphidata(:,k),prctilevec);
    ovPvphidlp(:,k) = prctile(2.*Pvphidldata(:,k),prctilevec);
    ovEephidlp(:,k) = prctile(2.*Eephidldata(:,k),prctilevec);
    ovPephidlp(:,k) = prctile(2.*Pephidldata(:,k),prctilevec);
    ovPtphidlp(:,k) = prctile(2.*Ptphidldata(:,k),prctilevec);
end

%Display table of RMS values
[PvisRMS,PelRMS,PtotalRMS] = deal([]);
for dd=1:datasets
    PvisRMS     = [PvisRMS;     avgbeat{dd,3}.PvRMS;     ];
    PelRMS      = [PelRMS;      avgbeat{dd,3}.PeRMS;      ];
    PtotalRMS   = [PtotalRMS;   avgbeat{dd,3}.PtRMS;   ];
end
PvisRMS     = [PvisRMS;     ovPvRMS;  ovPvRMS-min(PvisRMS); ...
    max(PvisRMS)-ovPvRMS];
PelRMS      = [PelRMS;      ovPeRMS;  ovPeRMS-min(PelRMS); ...
    max(PelRMS)-ovPeRMS];
PtotalRMS   = [PtotalRMS;   ovPtRMS;  ovPtRMS-min(PtotalRMS); ...
    max(PtotalRMS)-ovPtRMS];

TRMS = table(PvisRMS,PelRMS,PtotalRMS,...
    'RowNames',{name{1};name{2};name{3};name{4};'Overall';'Upper dev';'Lower dev'})
%Display table of dimensionless RMS values
[PvisRMSdl,PelRMSdl,PtotalRMSdl] = deal([]);
for dd=1:datasets
    PvisRMSdl   = [PvisRMSdl;   avgbeat{dd,3}.PvRMSdl;   ];
    PelRMSdl    = [PelRMSdl;    avgbeat{dd,3}.PeRMSdl;    ];
    PtotalRMSdl = [PtotalRMSdl; avgbeat{dd,3}.PtRMSdl; ];
end
PvisRMSdl   = [PvisRMSdl;   ovPvRMSdl;    ovPvRMSdl-min(PvisRMSdl); ...
    max(PvisRMSdl)-ovPvRMSdl];
PelRMSdl    = [PelRMSdl;    ovPeRMSdl;     ovPeRMSdl-min(PelRMSdl); ...
    max(PelRMSdl)-ovPeRMSdl];
PtotalRMSdl = [PtotalRMSdl; ovPtRMSdl;  ovPtRMSdl-min(PtotalRMSdl); ...
    max(PtotalRMSdl)-ovPtRMSdl];

TRMSdl = table(PvisRMSdl,PelRMSdl,PtotalRMSdl,...
    'RowNames',{name{1};name{2};name{3};name{4};'Overall';'Upper dev';'Lower dev'})
%Average avgbeat frequency
        f_avg = 1/mean(durtotal);
        
%--------------------------------------------------------------------------
%% Compare with Guasto
%--------------------------------------------------------------------------
Gua.U_avg       = 134e-6;               %Mean velocity          [m/s]
Gua.R           = 3.5e-6;               %Cell body radius       [m]
Gua.facdl       = 6*pi*eta*Gua.R*Gua.U_avg^2;
Gua.f           = 53;                   %Beat frequency         [Hz]
Gua.omega       = 2*pi*Gua.f;           %Angular frequency      [rad/s]
Gua.delta       = 339e-6;               %Velocity amplitude     [m/s]
Gua.t           = datapts./Gua.f;       %Time vector            [s]
Gua.tdldata     = [0.025    0.091   0.1575  0.225   0.295   0.36    0.43...
    0.495   0.56    0.625   0.695   0.755   0.825   0.89    0.96];
Gua.Pdata       = [0.5      3.3     8.3     12.5    14.6    11.8    7.2...
    2.6     0.5     0.6     1.4     1.9     1.95    1.25    0.55].*1e-15;
Gua.Pdatadl     = Gua.Pdata./Gua.facdl;
Gua.U_steady    = Gua.U_avg.*Gua.t.^0;
Gua.U_unsteady  = Gua.U_steady + Gua.delta.*sin(Gua.omega.*Gua.t);
Gua.P_steady    = 6*pi*eta*Gua.R.*Gua.U_steady.^2;
Gua.P_unsteady  = 6*pi*eta*Gua.R.*Gua.U_unsteady.^2;
Gua.P_unsteadydl= Gua.P_unsteady./Gua.facdl;

%--------------------------------------------------------------------------
%% Calculate overall limit cycle, store base case variables
%--------------------------------------------------------------------------
BC.Blimit = zeros(nmodeslimit,nlimit);
BC.BlimitGIP = cell(nmodeslimit,1);
for ii=1:nmodeslimit
    Btemp = zeros(size(phi0));
    for dd=1:datasets
       Btemp = Btemp + 0.5.*BlimitGIP{dd,1,ii}(phi0) + ...
           0.5.*BlimitGIP{dd,2,ii}(phi0); 
    end
    Btemp = Btemp./datasets;
    BC.Blimit(ii,:) = Btemp;
    BC.BlimitGIP{ii} = griddedInterpolant(phi0,Btemp,'linear');
end
BC.ovmeantime = ovmeantime;
BC.ovPvRMS = ovPvRMS;
BC.ovPeRMS = ovPeRMS;
BC.ovPtRMS = ovPtRMS;
BC.ovPvRMSdl = ovPvRMSdl;
BC.ovPeRMSdl = ovPeRMSdl;
BC.ovPtRMSdl = ovPtRMSdl;
BC.ovmeanPv = ovmeanPvsc; 
BC.ovmeanEe = ovmeanEesc;
BC.ovmeanPe = ovmeanPesc;
BC.ovmeanPt = ovmeanPtsc;
BC.ovmeanPvdl = ovmeanPvscdl;
BC.ovmeanEedl = ovmeanEescdl;
BC.ovmeanPedl = ovmeanPescdl;
BC.ovmeanPtdl = ovmeanPtscdl;
BC.ovmeanPvphi   = ovmeanPvphi;  
BC.ovmeanEephi   = ovmeanEephi;
BC.ovmeanPephi   = ovmeanPephi;
BC.ovmeanPtphi   = ovmeanPtphi;
BC.ovmeanPvphidl   = ovmeanPvphidl;
BC.ovmeanEephidl   = ovmeanEephidl;
BC.ovmeanPephidl   = ovmeanPephidl;
BC.ovmeanPtphidl   = ovmeanPtphidl;
for dd=1:datasets
    BC.fcell(dd) = mean([avgbeat{dd,1}.fcell;avgbeat{dd,2}.fcell]); 
end
BC.PCA_store = PCA_store;
BC.thetabase = thetabase(1,:);
%Also save base case data for 4-26 cell, which we use all the time
BC426.Blimit = (Blimit{1,1}+Blimit{1,2})./2;
for ii=1:nmodeslimit
    BC426.BlimitGIP{ii} = BlimitGIPavg{1,ii};
end
BC426.ZlimitGIP = griddedInterpolant(phi0,BC426.BlimitGIP{1}(phi0) + ...
    1i.*BC426.BlimitGIP{2}(phi0),GIPmethod);
[phisort,ind] = sort(mod([phicell{1,1}; phicell{1,2};],2*pi));
omegasort = [omegacell{1,1}; omegacell{1,2};];
omegasort = omegasort(ind);
BC426.omegaGIP = griddedInterpolant(phisort,omegasort,GIPmethod);
BC426.PvRMS = avgbeat{1,3}.PvRMS;
BC426.PeRMS = avgbeat{1,3}.PeRMS;
BC426.PtRMS = avgbeat{1,3}.PtRMS;
BC426.PvRMSdl = avgbeat{1,3}.PvRMSdl;
BC426.PeRMSdl = avgbeat{1,3}.PeRMSdl;
BC426.meanEFtphi = avgbeat{1,3}.meanEFtphi;
BC426.PtRMSdl = avgbeat{1,3}.PtRMSdl;
BC426.meanPv = avgbeat{1,3}.meanPv;
BC426.meanEe = avgbeat{1,3}.meanEe;
BC426.meanPe = avgbeat{1,3}.meanPe;
BC426.meanPt = avgbeat{1,3}.meanPt;
BC426.meanPvdl = avgbeat{1,3}.meanPvdl;
BC426.meanEedl = avgbeat{1,3}.meanEedl;
BC426.meanPedl = avgbeat{1,3}.meanPedl;
BC426.meanPtdl = avgbeat{1,3}.meanPtdl;
BC426.meanPvphi = avgbeat{1,3}.meanPvphi;
BC426.meanEephi = avgbeat{1,3}.meanEephi;
BC426.meanPephi = avgbeat{1,3}.meanPephi;
BC426.meanPtphi = avgbeat{1,3}.meanPtphi;
BC426.meanPvphidl = avgbeat{1,3}.meanPvphidl;
BC426.meanEephidl = avgbeat{1,3}.meanEephidl;
BC426.meanPephidl = avgbeat{1,3}.meanPephidl;
BC426.meanPtphidl = avgbeat{1,3}.meanPtphidl;
BC426.meanphic = 0.5.*(avgbeat{1,1}.meanphic+avgbeat{1,2}.meanphic);
BC426.meanomegac = 0.5.*(avgbeat{1,1}.meanomegac+avgbeat{1,2}.meanomegac); 
BC426.meanomegacphi = 0.5.*(avgbeat{1,1}.meanomegacphi+avgbeat{1,2}.meanomegacphi);
BC426.meanEFt_cyc = mean([avgbeat{1,1}.meanEFt_cyc(:); avgbeat{1,2}.meanEFt_cyc(:);]);
BC426.fcell = 0.5.*(avgbeat{1,1}.fcell+avgbeat{1,2}.fcell); 
BC426.Zphi = 0.5.*(avgbeat{1,1}.meanZphi+avgbeat{1,2}.meanZphi); 
BC426.area = 0.5.*(avgbeat{1,1}.meanarea+avgbeat{1,2}.meanarea);
BC426.xamp = mean([avgbeat{1,1}.xamp(:); avgbeat{1,2}.xamp(:);]);
BC426.meantime = mean([avgbeat{1,1}.meantime; avgbeat{1,2}.meantime;],1);
BC426.meanftdensphitip = mean([avgbeat{1,1}.meanftdensphitip;...
    avgbeat{1,2}.meanftdensphitip;],1);

save('Base_case_vars.mat','BC','BC426')

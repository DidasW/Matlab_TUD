%Save variables from experiments to cell variables, so all datasets can be
%compared easily. Indexing is done like "variable{dd,lr}" where dd relates
%to the data set and lr=1 indicates the right flagellum and lr=2 the left.

dataind{dd}         = 1:1:length(BEMtime);  %Indices of samples     [#]
datatime{dd}        = BEMtime;              %Time grid              [s]
begimg(dd)          = beginimg;
enimg(dd)           = endimg;

%Various grids for location of nodes
integrationgrid{dd} = ssold;  %Location of nodes
redind{dd}          = fliplr(size(kappasave,3)-(1:1:length(ssc)+1)); %Indices of nodes on reduced grid (with gap between flagella)
flagcentroids{dd}   = ssc;
flaggrid{dd}        = [ssc-0.5*(ssc(2)-ssc(1)) ssc(end)+0.5*(ssc(2)-ssc(1))].*1e-6;
flaggridstep(dd)    = (ssc(2)-ssc(1)).*1e-6;
lflag{dd}           = lf;
flaggriddl{dd}      = flaggrid{dd}./1e-6./lflag{dd};
flagcentroidsdl{dd} = ssc./lf;                          
flaggridsurf{dd}    = ssc+0.5.*(ssc(end)-ssc(end-1));   %Grid for matlab 'surf' function
flaggridsurfdl{dd}  = flaggridsurf{dd}./lf;
nflagnodes{dd}      = length(ssc);
EI(dd)              = EI;       %Bending stiffness [Nm2]

%Cell size
Rcell(dd,1) = min(Cell.minor_rad,Cell.major_rad)*1e-6; %Minor cell radius [m]
Rcell(dd,2) = max(Cell.minor_rad,Cell.major_rad)*1e-6; %Major cell radius [m]
Rcell(dd,3) = sqrt(Cell.minor_rad*Cell.major_rad)*1e-6;%Geometric mean radius [m]
thetabase(dd,1) = thetar;           %Initial angle of right flagellum
thetabase(dd,2) = thetal;           %Initial angle of left flagellum
thetabase(dd,3) = Cell.phi_body;    %Cell body rotation angle

%----------------------------------------------------------------------
% POWER PROFILES
%----------------------------------------------------------------------
%Point forces [N]
fx{dd,1} = 1e-12.*fx1; 
fx{dd,2} = 1e-12.*fx2;
fx{dd,3} = fx{dd,1}+fx{dd,2};
fy{dd,1} = 1e-12.*fy1;
fy{dd,2} = 1e-12.*fy2;
fy{dd,3} = fy{dd,1}+fy{dd,2};
ft{dd,1} = sqrt(fx{dd,1}.^2+fy{dd,1}.^2); 
ft{dd,2} = sqrt(fx{dd,2}.^2+fy{dd,2}.^2);
ft{dd,3} = ft{dd,1}+ft{dd,2};
%Total forces
for lr=1:3
    EFx{dd,lr}   = sum(fx{dd,lr},2);    %Summed force in x-direction    [N]
    EFy{dd,lr}   = sum(fy{dd,lr},2);    %Summed force in y-direction    [N]
    EFt{dd,lr}   = sqrt(EFx{dd,lr}.^2+EFy{dd,lr}.^2);    %Total summed force [N]
end

%Force densities [N/m]
for kk=1:3
   fxdens{dd,kk}    = fx{dd,kk}./flaggridstep(dd); 
   fydens{dd,kk}    = fy{dd,kk}./flaggridstep(dd);
   ftdens{dd,kk}    = ft{dd,kk}./flaggridstep(dd);
end

% Viscous power [W]
Pv{dd,1} = smooth(eta*phi1*1e-18,'sgolay');
Pv{dd,2} = smooth(eta*phi2*1e-18,'sgolay');
Pv{dd,3} = Pv{dd,1}+Pv{dd,2};

% Elastic energy [J]
Ee{dd,1} = Ebend(:,1);
Ee{dd,2} = Ebend(:,2);
Ee{dd,3} = Ebend(:,3);

% Elastic power [W]
Pe{dd,1} = sg5der(Ebend(:,1),dtime);
Pe{dd,2} = sg5der(Ebend(:,2),dtime);
Pe{dd,3} = Pe{dd,1}+Pe{dd,2};

%Non-dimensionalize
facdlF(dd) = 1/(6*pi*eta*Rcell(dd,3)*Ufs);
facdlP(dd) = 1/(6*pi*eta*Rcell(dd,3)*Ufs^2);
if strcmp(scenario,'Base case')==1
    fcell(dd) = BC.fcell(dd); 
else
    fcell(dd) = BC426.fcell;
end
facdlE(dd) = 1/(6*pi*eta*Rcell(dd,3)*Ufs^2/fcell(dd));

%Interpolant objects of data
for kk=1:3; 
    Pt{dd,kk}       = Pv{dd,kk} + Pe{dd,kk}; 
    Pvdl{dd,kk}     = Pv{dd,kk}.*facdlP(dd);    %Dimensionless viscous power profile    [-]
    Eedl{dd,kk}     = Ee{dd,kk}.*facdlE(dd);    %Dimensionless elastic energy profile   [-]
    Pedl{dd,kk}     = Pe{dd,kk}.*facdlP(dd);    %Dimensionless elastic power profile    [-]
    Ptdl{dd,kk}     = Pt{dd,kk}.*facdlP(dd);    %Dimensionless total power profile      [-]
    fxdl{dd,kk}     = fx{dd,kk}.*facdlF(dd);
    fydl{dd,kk}     = fy{dd,kk}.*facdlF(dd);
    ftdl{dd,kk}     = ft{dd,kk}.*facdlF(dd);
    EFxdl{dd,kk}    = EFx{dd,kk}.*facdlF(dd);
    EFydl{dd,kk}    = EFy{dd,kk}.*facdlF(dd);
    EFtdl{dd,kk}    = EFt{dd,kk}.*facdlF(dd);
    GIPPv{dd,kk}    = griddedInterpolant(dataind{dd},Pv{dd,kk},'linear');
    GIPEe{dd,kk}    = griddedInterpolant(dataind{dd},Ee{dd,kk},'linear');
    GIPPe{dd,kk}    = griddedInterpolant(dataind{dd},Pe{dd,kk},'linear');
    GIPPt{dd,kk}    = griddedInterpolant(dataind{dd},Pt{dd,kk},'linear');
    GIPEFx{dd,kk}   = griddedInterpolant(dataind{dd},EFx{dd,kk},'linear');
    GIPEFy{dd,kk}   = griddedInterpolant(dataind{dd},EFy{dd,kk},'linear');
    GIPEFt{dd,kk}   = griddedInterpolant(dataind{dd},EFt{dd,kk},'linear');
    GIPPvdl{dd,kk}  = griddedInterpolant(dataind{dd},Pvdl{dd,kk},'linear');
    GIPEedl{dd,kk}  = griddedInterpolant(dataind{dd},Eedl{dd,kk},'linear');
    GIPPedl{dd,kk}  = griddedInterpolant(dataind{dd},Pedl{dd,kk},'linear');
    GIPPtdl{dd,kk}  = griddedInterpolant(dataind{dd},Ptdl{dd,kk},'linear');
    GIPEFxdl{dd,kk} = griddedInterpolant(dataind{dd},EFxdl{dd,kk},'linear');
    GIPEFydl{dd,kk} = griddedInterpolant(dataind{dd},EFydl{dd,kk},'linear');
    GIPEFtdl{dd,kk} = griddedInterpolant(dataind{dd},EFtdl{dd,kk},'linear');
end

for kk=1:2
%     GIPfx{dd,kk}    = griddedInterpolant(dataind{dd},fx{dd,kk}(:,end),'linear');
%     GIPfy{dd,kk}    = griddedInterpolant(dataind{dd},fy{dd,kk}(:,end),'linear');
%     GIPft{dd,kk}    = griddedInterpolant(dataind{dd},ft{dd,kk}(:,end),'linear');
    GIPfxdenstip{dd,kk}= griddedInterpolant(dataind{dd},fxdens{dd,kk}(:,end),'linear');
    GIPfydenstip{dd,kk}= griddedInterpolant(dataind{dd},fydens{dd,kk}(:,end),'linear');
    GIPftdenstip{dd,kk}= griddedInterpolant(dataind{dd},ftdens{dd,kk}(:,end),'linear'); 
    GIPftdens{dd,kk} = griddedInterpolant({dataind{dd},flagcentroids{dd}},...
        ftdens{dd,kk},'linear');
end

%Calculate normal force, shear force and internal moment in flagella (beta-
%not used anywhere)
ds = flaggridstep(dd);
for lr=1:2
    for kk=1:length(dataind{dd})
        %Convert curvature values to curvature of flagellum of 1 micron
        if lr==1
            phistart = pi-(Cell.thetar-Cell.phi_body)-squeeze(kappasave(kk,2,1));
            kappa = -smooth(squeeze(kappasave(kk,2,2:end)),3).*lflag{dd}; 
        else 
            phistart = pi-(Cell.thetal-Cell.phi_body)+squeeze(kappasave(kk,1,1));
            kappa = smooth(squeeze(kappasave(kk,1,2:end)),3).*lflag{dd}; 
        end
        Y = flagella_quick(kappa,integrationgrid{dd}./lflag{dd},[phistart;0;0;]);
        xflagellumdl{dd,lr}(kk,:) = Y(redind{dd},2);
        yflagellumdl{dd,lr}(kk,:) = Y(redind{dd},3);
        %------------------------------------------------------------------
        %Calculate internal forces
        %------------------------------------------------------------------
        %Calculate tangential, normal vector
        kappavec = kappa(redind{dd});               %Curvature at nodes         [micron]
        thetavec = Y(redind{dd},1);                 %Tangent angle of nodes     [micron]
        xvec = Y(redind{dd},2).*lflag{dd}.*1e-6;    %x-coordinate of nodes      [micron]
        yvec = Y(redind{dd},3).*lflag{dd}.*1e-6;    %y-coordinate of nodes      [micron]
        kappanode = kappa.*1e6;                     %Curvature at nodes         [1/m]
        thetatangcent = 0.5.*(thetavec(2:end)+thetavec(1:end-1));   %Tangent angle of centroids [rad]
        if lr == 1
            kappanode = -kappanode;
            thetanormcent = thetatangcent+pi/2;          %Normal of angle centroids  [rad]
        else
            thetanormcent = thetatangcent-pi/2;          %Normal of angle centroids  [rad]
        end
        tangvec = [cos(thetatangcent) sin(thetatangcent)];    %Unit tangent vector [-]
        normvec = [cos(thetanormcent) sin(thetanormcent)];    %Unit normal vector  [-]
        xcent = 0.5*(xvec(2:end)+xvec(1:end-1));    %x-coordinate of centroids  [micron]        
        ycent = 0.5*(yvec(2:end)+yvec(1:end-1));    %y-coordinate of centroids  [micron]
%         %Plot tangent,normal vectors
%         figure(1),clf,hold on,plot(xvec,yvec,'ko-')
%         quiver(xcent,ycent,5e-7.*tangvec(:,1),5e-7.*tangvec(:,2),0,'b');
%         quiver(xcent,ycent,5e-7.*normvec(:,1),5e-7.*normvec(:,2),0,'r');
%         quiver(0,0,1e-6,0,'g'),quiver(0,0,0,1e-6,'r')%x and y-axis
%         axis equal, grid on, hold off
        
        %Calculate normal force, shear force, internal moment
        [N,Q,M] = deal(zeros(size(flaggrid{dd}))); %Normal/shear force [N], internal moment [Nm]
        fnorm  = dot([fx{dd,lr}(kk,:)' fy{dd,lr}(kk,:)'],normvec,2);
        ftang  = dot([fx{dd,lr}(kk,:)' fy{dd,lr}(kk,:)'],tangvec,2);
        N(end) = 0; Q(end) = 0; M(end) = 0; %Forces/moment zero at free end
        for nn=length(flaggrid{dd})-1:-1:1 %Loop backwards through nodes
            N(nn) = N(nn+1) + ftang(nn);
            Q(nn) = Q(nn+1) - fnorm(nn);
            M(nn) = M(nn+1) - Q(nn)*ds - fnorm(nn)*ds/2 + EI(dd)*(kappanode(nn)-kappanode(nn+1));
        end
        Fint_N{dd,lr}(kk,:) = N;
        Fint_Q{dd,lr}(kk,:) = Q;
        Fint_R{dd,lr}(kk,:) = sqrt(N.^2+Q.^2);
        Mint{dd,lr}(kk,:)   = M;
%         %Plot N,Q,M
%         figure(2),clf,hold on
%         [AX,L1,L2]=plotyy([flaggrid{dd}' flaggrid{dd}'],[N'*1e9 Q'*1e9],...
%             flaggrid{dd},M*1e15);
%         set(AX(1),'xlim',[0 lflag{dd}*1e-6]), set(AX(2),'xlim',[0 lflag{dd}*1e-6])
%         ylabel(AX(1),'Force [$\mu$N]'),ylabel(AX(2),'Moment [fNm]')
%         legend('N','Q','M'),grid on, hold off
    end
    GIPxdl{dd,lr} = griddedInterpolant({dataind{dd},flaggriddl{dd}},...
        xflagellumdl{dd,lr},'linear');
    GIPydl{dd,lr} = griddedInterpolant({dataind{dd},flaggriddl{dd}},...
        yflagellumdl{dd,lr},'linear');
end

%Flow stats -- adjust this if
if strcmp(scenario,'Base case') == 0
    flow.vel(dd,:)  = sqrt(U(1,:).^2 + U(2,:).^2 + U(3,:).^2); %Flow velocity [micron/s]
    flow.Apkpk(dd)  = 0.5*(max(flow.vel(dd,:))-min(flow.vel(dd,:)))*1e-6;   %Flow amplitude (peak-peak) [m/s]
    flow.f(dd)      = Fmax1;                                %Flow frequency         [Hz]
    if exist('flowshift','var') == 1
        if strcmp(scenario,'Shift') == 1
            flow.phidiff(dd) = flowshift + pi;
        else
            flow.phidiff(dd) = flowshift;
        end
    else
        flow.phidiff(dd) = 0;
    end

    if exist('phipiezo','var') == 1
        flow.phi{dd}    = phipiezo;             %Piezo angle            [rad]
    else
        flow.phi{dd}    = zeros(size(piezocorr));
    end
end
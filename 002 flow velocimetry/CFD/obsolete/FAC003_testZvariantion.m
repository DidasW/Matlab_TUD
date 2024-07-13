% Set up External flow
% setup_piezo_flow #####################
% %% scooped from the setup_piezo flow

% 
% velocity of a translating pipette in stationary medium, this corresponds 
% to MINUS the velocity of the flow on a stationary pipette.
[U,W] = deal(zeros(3,nframes));
U(1) = 0; U(2) = 0; U(3) = 0;   % U is the translation velocity of pipette    [micron/s]
W(1) = 0; W(2) = 0; W(3) = 0;   % W is the rotation velocity of pipette       [rad/s]


%Pre-allocating arrays
F(length(BEMtime)) = struct('cdata',[],'colormap',[]); %Frames for movie
Ebend = zeros(nframestot,3);
Pbend = zeros(nframestot,2);
[fx1,fy1,fx2,fy2] = deal(zeros(nframestot,Nf));        
[D1,D2] = deal(zeros(nframestot,2));       
[phi1,phi2,Dtot] = deal(zeros(nframestot,1));   
[r,c]      = size(MATRIX);              %Rows/columns

for kk = beginctr:endctr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Frame %d out of %d \n',kk-beginctr+1,nframes);

% Compute the position vector of the flagellum
% 1 = right, 2 = left in this program, whereas 1 = left, 2 = right in
% detection...
Y1  = flagella_quick(-squeeze(kappasave(kk,2,2:end)),ssold,...
    [pi-(Cell.thetar-Cell.phi_body)-squeeze(kappasave(kk,2,1));xbase;ybase;]);
Y2  = flagella_quick(squeeze(kappasave(kk,1,2:end)),ssold,...
    [pi-(Cell.thetal-Cell.phi_body)+squeeze(kappasave(kk,1,1));xbase;ybase;]);
% Smooth curvature
k1s = smooth(squeeze(kappasave(kk,2,2:end)),3);
k2s = smooth(squeeze(kappasave(kk,1,2:end)),3);
Y1s = flagella_quick(-k1s,ssold,...
    [pi-(Cell.thetar-Cell.phi_body)-squeeze(kappasave(kk,2,1));xbase;ybase;]);
Y2s = flagella_quick(k2s,ssold,...
    [pi-(Cell.thetal-Cell.phi_body)+squeeze(kappasave(kk,1,1));xbase;ybase;]);

%Calculate bending energy
Ebend(kk,1) = 1/2*EI*lf/Nf*sum(k1s.^2)*1e6;     %Bending energy    [J]
Ebend(kk,2) = 1/2*EI*lf/Nf*sum(k2s.^2)*1e6;     %Bending energy    [J]
Ebend(kk,3) = Ebend(kk,1)+Ebend(kk,2);

%Rotate and scale velocity vectors
for lr=1:2
    if lr == 1 %Left flagellum in storage, right in this program
        phi = pi+(Cell.thetal-Cell.phi_body);
    else %Right flagellum in storage, left in this program
        phi = pi-(Cell.thetar-Cell.phi_body);
    end
    vrot = [squeeze(velx(kk,lr,:))';squeeze(vely(kk,lr,:))';];
    vrot = Rotmat(phi)*vrot; 
    velx(kk,lr,:) = vrot(1,:);
    if lr == 1
        vely(kk,lr,:) = vrot(2,:);
    else
        vely(kk,lr,:) = -vrot(2,:);
    end
end

%Cut off everything before the starting point (ensure flagella-body
%separation)
Y1s = Y1s(indstart:end,:);
Y2s = Y2s(indstart:end,:);

%x coordinate of flagellum      [micron]
xf1     = Y1s(2:end,2) + RemoveFlag1*lf*10^9;   
xf2     = Y2s(2:end,2) + RemoveFlag2*lf*10^9;             

%y coordinate of flagellum      [micron]
yf1     = Y1s(2:end,3) + RemoveFlag1*lf*10^9;     
yf2     = Y2s(2:end,3) + RemoveFlag2*lf*10^9;        

%z coordinate of flagellum      [micron]
zf1     = zeros(size(xf1));   
zf2     = zeros(size(xf2));     

%Tangent angle of flagellum     [rad]
thf1    = Y1s(2:end,1);     
thf2    = Y2s(2:end,1);        


%Include background flow velocity here 
vxf1    = squeeze(velx(kk,2,indstart+1:end)) + U(1,kk);
vxf2    = squeeze(velx(kk,1,indstart+1:end)) + U(1,kk);
vyf1    = squeeze(vely(kk,2,indstart+1:end)) + U(2,kk);
vyf2    = squeeze(vely(kk,1,indstart+1:end)) + U(2,kk);
vzf1    = zeros(size(vxf1))+ U(3,kk);
vzf2    = zeros(size(vxf1))+ U(3,kk);

if calc == 0
    % Check waveforms and velocity vectors
    figure(1),clf,hold on;
    plot(xhead,yhead,'k','LineWidth',1); hold on;
%     plot(Y1(indstart+1:end,2),Y1(indstart+1:end,3),'g--')
%     plot(Y2(indstart+1:end,2),Y2(indstart+1:end,3),'r--')
    plot(Y1s(2:end,2),Y1s(2:end,3),'g','LineWidth',0.8)
    plot(Y2s(2:end,2),Y2s(2:end,3),'r','LineWidth',0.8)
    if compute_flow >= 2
       plot(xgb,ygb,'bo') 
    end
%     quiver(xf1,yf1,vxf1,vyf1)
%     quiver(xf2,yf2,vxf2,vyf2)
    xlabel('x [$\mathrm{\mu}$m]'),ylabel('y [$\mathrm{\mu}$m]')
    grid on,axis equal,axis([-15 10 -10 10]);
    set(gca, 'xtick', [-10 -5 0 5 10], 'ytick', [-10 -5 0 5 10])
%     figure(2),clf
%     subplot(2,1,1), hold on
%         plot(squeeze(kappasave(kk,2,2:end)),'g');
%         plot(k1s,'g--')
%     subplot(2,1,2), hold on
%         plot(squeeze(kappasave(kk,1,2:end)),'r');
%         plot(k2s,'r--')
    pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if calc
    % Assemble RHS
    [U_t,U_r]       = U_colloc(U(:,kk),W(:,kk),centroids,r/3);      %Translation/rotational velocity vectors    [micron/s]
    RHS             = (U_t+U_r);                                    %Right hand side (velocity)                 [micron/s]

    % Put together the Mobility matrix
    % Head
    M(indh,indh) = MATRIX;   

    % Flagella 
    % Current flagella_mobility uses cylindrical shape to simulate the 
    % flagellum. The shape was once simulated by a parabolic balloon.
    % Date of the note: 2017-07-18
    Mf1 = flagella_mobility(Slend,rf,llf',Nf,xf1,yf1,zf1,thf1,ssc');
    Mf2 = flagella_mobility(Slend,rf,llf',Nf,xf2,yf2,zf2,thf2,ssc');

    M(indf1,indf1) = Mf1;
    M(indf2,indf2) = Mf2;

    % Flagella interaction
    Mf12 = flagella_interaction(xf1,yf1,zf1,xf2,yf2,zf2,Nf,Nf,rf);
    Mf21 = flagella_interaction(xf2,yf2,zf2,xf1,yf1,zf1,Nf,Nf,rf); 
    Mf1h = flagella_interaction(xf1,yf1,zf1,xh,yh,zh,Nf,Nh,rf); 
    Mf2h = flagella_interaction(xf2,yf2,zf2,xh,yh,zh,Nf,Nh,rf); 
    M(indf2,indf1) = Mf12;
    M(indh,indf1)  = Mf1h;
    M(indf1,indf2) = Mf21;
    M(indh,indf2)  = Mf2h;

    % Head Interaction
    [MATRIX_h1,~,~,~,~] = FlowStokes(panels,[xf1 yf1 zf1],normals,param);
    [MATRIX_h2,~,~,~,~] = FlowStokes(panels,[xf2 yf2 zf2],normals,param);
    M(indf1,indh) = MATRIX_h1;
    M(indf2,indh) = MATRIX_h2;

    % Put together the Velocity matrix : VELOCITY AT SURFACE OF HEAD AND PIPETTE REMAINS ZERO!!!
    % Part of RHS that corresponds to the head and the flagellum
    uu1 = [vxf1 vyf1 vzf1]';       uu2 = [vxf2 vyf2 vzf2]';
    UU(indf1)  = uu1(:); 
    UU(indf2)  = uu2(:); 
    UU(indh)   = RHS(:);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute the singularity distribution
    phi        = M\UU;

    % f          = MATRIX\RHS(:); 
    fh         = phi(indh);         %Point forces for the head          [1e-12 N]
    f1         = phi(indf1);        %Point forces for right flagellum   [1e-12 N]
    f2         = phi(indf2);        %Point forces for left flagellum    [1e-12 N]

    % Compute Total rate of work & Drag force on each flagellum
    fx1(kk,:)  = f1(1:3:end); fy1(kk,:) = f1(2:3:end);
    fx2(kk,:)  = f2(1:3:end); fy2(kk,:) = f2(2:3:end);

    phi1(kk) = fx1(kk,:)*(vxf1-U(1,kk))+fy1(kk,:)*(vyf1-U(2,kk));     %Rate of work, right flagellum    [1e-18 W]
    phi2(kk) = fx2(kk,:)*(vxf2-U(1,kk))+fy2(kk,:)*(vyf2-U(2,kk));     %Rate of work, left flagellum     [1e-18 W]
    D1(kk,:) = [sum(fx1(kk,:)) ; sum(fy1(kk,:))]; %Drag for right flagellum         [1e-18 N] 
    D2(kk,:) = [sum(fx2(kk,:)) ; sum(fy2(kk,:))]; %Drag for left flagellum          [1e-18 N]
    Dtot(kk) = D1(1)*U(1) + D1(2)*U(2); %Total rate of work

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute the Flow on the cartesian grid: xg,yg,zg grid
    if compute_flow ~=0
        if (compute_flow == 1) || (compute_flow == 3)
            M_Flow_f1  = flagella_interaction(xf1,yf1,zf1,xg,yg,zg,Nf,Ng,rf);   %Flow matrix for right flagellum
            M_Flow_f2  = flagella_interaction(xf2,yf2,zf2,xg,yg,zg,Nf,Ng,rf);   %Flow matrix for left flagellum
            UF         = M_Flow_head*fh(:)+M_Flow_f1*f1(:)+M_Flow_f2*f2(:);     %Velocity field                     [micron/s]
            %Subtract background flow from result to correct for boundary condition
            u_flow     = UF(1:3:end)-U(1,kk);   u_flow(indg) = 0;  %x velocity     [micron/s]
            v_flow     = UF(2:3:end)-U(2,kk);   v_flow(indg) = 0;  %y velocity     [micron/s]
            w_flow     = UF(3:3:end)-U(3,kk);   w_flow(indg) = 0;  %z velocity     [micron/s]
        end

        if compute_flow >= 2
            M_Flow_f1b   = flagella_interaction(xf1,yf1,zf1,xgb,ygb,zgb,Nf,Nb,rf);   %Flow matrix for right flagellum
            M_Flow_f2b   = flagella_interaction(xf2,yf2,zf2,xgb,ygb,zgb,Nf,Nb,rf);   %Flow matrix for left flagellum
            UFb          = M_Flow_headb*fh(:)+M_Flow_f1b*f1(:)+M_Flow_f2b*f2(:);     %Velocity field                     [micron/s]
            Uflowb(kk,:) = UFb(1:3:end)-U(1,kk);   %x velocity     [micron/s]
            Vflowb(kk,:) = UFb(2:3:end)-U(2,kk);   %y velocity     [micron/s]
            Wflowb(kk,:) = UFb(3:3:end)-U(3,kk);   %z velocity     [micron/s]
        end

        if (compute_flow == 1) || (compute_flow == 3)
            figure(1);clf;
%             set(1,'ToolBar','none','MenuBar','none','Resize','off',...
%                 'Unit','pixels','InnerPosition',[25,116,560,420]);

% vv = sqrt(vxf1.^2+vyf1.^2+vzf1.^2);
% UU_max = max(vv(:));

            UU_flow = sqrt(u_flow.^2+v_flow.^2); 
            UU_flow(indg) = 0.1;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            UU_flow_rscl = min(UU_flow,UU_max);% 50 was UUmax before 0825
            u_flow = u_flow.*UU_flow_rscl./UU_flow;
            v_flow = v_flow.*UU_flow_rscl./UU_flow;
%              u_flow = u_flow.*UU_flow_rscl./UU_flow;
%              v_flow = v_flow.*UU_flow_rscl./UU_flow;
            
            
%            pcolor(reshape(xg,Nxg,Nyg),    reshape(yg,Nxg,Nyg),...
%                   reshape(UU_flow_rscl,Nxg,Nyg)); hold on;
%             pcolor(reshape(xg,Nxg,Nyg),    reshape(yg,Nxg,Nyg),...
%                    abs(reshape(u_flow,Nxg,Nyg))); hold on;
            pcolor(-reshape(zg,Nxg,Nyg),reshape(xg,Nxg,Nyg),    ...
                   min(abs(reshape(u_flow,Nxg,Nyg)),100)); hold on;
            shading interp; colormap parula; %caxis([0 0.5]);
            plot(-yhead,xhead,'k','LineWidth',3); hold on;
            axis equal; 
            plot(-yf1,xf1,'k','LineWidth',3);    %Plot right flagellum
            plot(-yf2,xf2,'k','LineWidth',3);    %Plot left flagellum
            plot(-yh(ih),xh(ih),'r.');           %Plot body + pipette points
 
            quiver(-zgq,xgq,-v_flow(indf2q),u_flow(indf2q)); 
        
%             shading interp; colormap parula; %caxis([0 0.5]);
%             plot(xhead,yhead,'k','LineWidth',3); hold on;
%             axis equal; 
%             plot(xf1,yf1,'k','LineWidth',3);    %Plot right flagellum
%             plot(xf2,yf2,'k','LineWidth',3);    %Plot left flagellum
%             plot(xh(ih),yh(ih),'r.');           %Plot body + pipette points


%             if compute_flow == 3
% %                plot(xgb,ygb,'k.','Markersize',15); 
%                plot(-ygb,xgb,'k.','Markersize',15); 
               set(gca,'ylim',[-45,15],'xlim',[-40,40]) % Da added on 20170606
%             end
%             if sepgridquiv
%                 quiver(xgq,ygq,u_flow(indf2q),v_flow(indf2q)); 
%             else
%                 quiver(xg,yg,u_flow,v_flow); 
%             end
%             title(sprintf('t = %4.3f ms',1000*BEMtime(kk)))
%             pause(eps);
% pause;
            F(kk) = getframe(gcf);   %Write frame to movie variable
        end
    end
end
clc
end
%%%%
% save('workspace.mat','-regexp','^(?!(M_Flow_head)$).');
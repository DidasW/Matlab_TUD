%% ==========================VELOCITY CORRECTION==========================%
%----------------------------CALCULATE VELOCITIES-------------------------%
%Calculate x,y and absolute velocity in [micron/s]
[velx,vely] = deal(zeros(nframes,2,nsteps+1));
dt = 1/fps;                     %Time step [s]
%5PT SAVITSKY-GOLAY
%Use forward differences for first two frames
velx(1:2,:,:) = (xflag(2:3,:,:)-xflag(1:2,:,:))./scale./dt;
vely(1:2,:,:) = (yflag(2:3,:,:)-yflag(1:2,:,:))./scale./dt;
%Use savitsky-golay for middle frames
velx(3:end-2,:,:) = (xflag(4:end-1,:,:)-xflag(2:end-3,:,:)+...
    2.*(xflag(5:end,:,:)-xflag(1:end-4,:,:)))./scale./10./dt;
vely(3:end-2,:,:) = (yflag(4:end-1,:,:)-yflag(2:end-3,:,:)+...
    2.*(yflag(5:end,:,:)-yflag(1:end-4,:,:)))./scale./10./dt;
%Use backward differences for last two frames
velx(end-1:end,:,:) = (xflag(end-1:end,:,:)-xflag(end-2:end-1,:,:))./scale./dt;
vely(end-1:end,:,:) = (yflag(end-1:end,:,:)-yflag(end-2:end-1,:,:))./scale./dt;
%Calculate absolute velocity
velabs = sqrt(velx.^2+vely.^2);

%Plot velocities
if postplots ~= 0
    figure(6), clf, cmap = colormap(jet(nsteps+1));    
    subplot(1,2,1), hold on; colormap(jet(nframes));
        for ii=1:nsteps+1
            plot(squeeze(velabs(:,1,ii)),'color',cmap(ii,:))
        end
        title('Left flagellum')
        xlabel('Frame number')
        ylabel('Velocity [micron/s]'),grid on
    subplot(1,2,2), hold on
        for ii=1:nsteps+1
            plot(squeeze(velabs(:,2,ii)),'color',cmap(ii,:))
        end
        title('Right flagellum')
        xlabel('Frame number')
        ylabel('Velocity [micron/s]'),grid on
end


%Rotate and non-dimensionalize velocities
%Velocities, like the shapes themselves, are stored in left flagellum form
velx0 = velx./lf0;
vely0 = vely./lf0;
velabs0 = velabs./lf0;
for image=1:nframes
    for lr=1:2
        vrot = [squeeze(velx0(image,lr,:))';squeeze(vely0(image,lr,:))';];
        if lr == 1
            vrot(2,:) = -vrot(2,:);
            vrot = R(-thetal)*vrot; 
        else
            vrot = R(thetar)*vrot; 
        end
        velx0(image,lr,:) = vrot(1,:);
        vely0(image,lr,:) = vrot(2,:);
    end
end

%=======SAVE SHAPES=======================================================%
if saveshapes %Save waveforms of shapes/entire workspace
    filename = strcat('lib',num2str(pt,'%02d'),'_',num2str(beginimg),'_',...
        num2str(endimg),'_',datestr(datetime('now'),'yyyy-mm-dd_HHMM'));
    save(filename,'Cell','kappasave','xflag','yflag','Bshape','phishape',...
        'phase','princpts','nmodes','velx0','vely0','lf0','scale','fps',...
        'thetal','thetar','phi_body','beginimg','endimg','list','nframes',...
        'xperim_el','yperim_el','optsfmc','R','screenmagnif',...
        'fileformatstr','fold','xbase','ybase','ssc','Im','supfld','pt')
end

% %% Check result
% figure(7), clf, hold on
% lr = 2;
% for image=1:nframes
% Ytot = curv2xy_quick(kappasave(image,lr,:),ssc./lf0./scale,kappasave(image,lr,1),0,0); 
% plot(Ytot(:,2),Ytot(:,3))
% quiver(Ytot(:,2),Ytot(:,3),squeeze(velx(image,lr,:)),squeeze(vely(image,lr,:)));
% pause(1)
% end
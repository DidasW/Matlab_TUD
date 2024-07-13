%Calculate total/unwrapped phase

phase = zeros(nframes,2);
for lr=1:2
    phase(:,lr) = unwrap(phishape(:,lr));
end

%% Correct frames based on phase
%Find frames with a peak in phase
minphasediff = 0.1*2*pi;        %Minimum peak height

phi_approx = zeros(size(phishape));
phi_approx(2:end-1,:) = (phishape(1:end-2,:)+phishape(3:end,:))./2;
E_phi = sqrt((phishape-phi_approx).^2);
[~,locs1] = findpeaks(E_phi(:,1),'Threshold',minphasediff);
[~,locs2] = findpeaks(E_phi(:,2),'Threshold',minphasediff);

%Plot error
figure(1), subplot(2,2,1),hold on
    plot(E_phi(:,1)./(2*pi),'r'), hold on, grid on
    plot(locs1,E_phi(locs1,1)./(2*pi),'r*')
    title('RMS prediction error'),xlabel('Frame #'),ylabel('Error [2$\pi$ rad]')
    legend('Left'),hold off
subplot(2,2,2),hold on
    plot(E_phi(:,2)./(2*pi),'b'), hold on, grid on
    plot(locs2,E_phi(locs2,2)./(2*pi),'b*')
    title('RMS prediction error'),xlabel('Frame #'),ylabel('Error [2$\pi$ rad]')
    legend('Right'),hold off
subplot(2,2,3),hold on
    plot(phishape(:,1)./(2*pi),'r'), grid on
    plot(locs1,phishape(locs1,1)./(2*pi),'r*')
    title('Raw phase atan2(B_2/B_1)'),xlabel('Frame #'),ylabel('Phase [2$\pi$ rad]')
    legend('Left'),hold off
subplot(2,2,4),hold on
    plot(phishape(:,2)./(2*pi),'b'), grid on
    plot(locs2,phishape(locs2,2)./(2*pi),'b*')
    title('Raw phase atan2(B_2/B_1)'),xlabel('Frame #'),ylabel('Phase [2$\pi$ rad]')
    legend('Right'),hold off
%Interpolate shape scores
for lr=1:2
    if lr==1
        indices = locs1;
    else
        indices = locs2;
    end
    if ~isempty(indices)
        for kk=1:length(indices)
            loc = indices(kk);
            image = beginimg+loc-1;
            %Interpolate shape
            Bshape(loc,lr,:) = (Bshape(loc-1,lr,:)+Bshape(loc+1,lr,:))./2;
            %Recalculate curvature, shape in xy
            Bf = squeeze(Bshape(loc,lr,:));
            if lr == 1
                curv = -princpts(1,2:end)' - princpts(2:nmodes+1,2:end)'*Bf;
                phi0 = thetal  - princpts(1,1) - princpts(2:nmodes+1,1)'*Bf;
            else
                curv = princpts(1,2:end)' + princpts(2:nmodes+1,2:end)'*Bf;
                phi0 = thetar  + princpts(1,1) + princpts(2:nmodes+1,1)'*Bf;
            end
            Ytot = curv2xy_quick(curv,ssc,phi0,xbase,ybase); 
            xtemp = Ytot(:,2); ytemp = Ytot(:,3); stage=1;

%             %Plot result
%             if postplots ~= 0 
%                 n = num2str(list(image),fileformatstr);       %Generate image string
%                 file = (['1_',n,'.tif']);           %First image
%                 Im = mat2gray(imread(file));            %Grayscale version of image
%                 [Im,~] = wiener2(Im);                   %Apply Wiener filter for Gaussian noise removal
%                 figure(6),clf,imshow(Im,'InitialMagnification',screenmagnif),hold on
%                 plot(squeeze(xflag(loc-2,lr,:)),squeeze(yflag(loc-2,lr,:)),'k--')
%                 plot(squeeze(xflag(loc-1,lr,:)),squeeze(yflag(loc-1,lr,:)),'b--')
%                 plot(squeeze(xflag(loc,lr,:)),squeeze(yflag(loc,lr,:)),'ro')
%                 if loc < nframes
%                     plot(squeeze(xflag(loc+1,lr,:)),squeeze(yflag(loc+1,lr,:)),'b+')
%                     if loc < nframes-1
%                         plot(squeeze(xflag(loc+2,lr,:)),squeeze(yflag(loc+2,lr,:)),'k+')
%                     end
%                 end            
%                 plot(xtemp,ytemp,'b','LineWidth',1.5), pause(eps), hold off
%             end

            post_processing            
        end
    end
end

%Recalculate phases
for lr=1:2
    phase(:,lr) = unwrap(phishape(:,lr));
end

if postplots ~= 0
    %Plot phase
    figure(8),clf, 
    subplot(3,1,1),hold on
        plot(phishape(:,1)./(2*pi),'r'),plot(phishape(:,2)./(2*pi),'b'), grid on
        title('Raw phase atan2(B_2/B_1)'),xlabel('Frame #'),ylabel('Phase [2$\pi$ rad]')
        legend('Left','Right'),hold off
    subplot(3,1,2),hold on
        plot(phase(:,1)./(2*pi),'r'),plot(phase(:,2)./(2*pi),'b'),grid on
        title('Unwrapped phase'),xlabel('Frame #'),ylabel('Phase [2$\pi$ rad]')
        legend('Left','Right'),hold off
    subplot(3,1,3)
        plot((phase(:,1)-phase(:,2))./(2*pi),'k'),grid on, hold off
        title('Relative phase (left-right)'),xlabel('Frame #'),ylabel('Phase [2$\pi$ rad]')

    %Plot limit cycle
    figure(9),clf
    subplot(2,1,1)
        plot(Bshape(:,1,1),Bshape(:,1,2),'r-o'),grid on,title('Limit cycle left')
        xlabel('Shape mode 1 [-]'),ylabel('Shape mode 2 [-]')
    subplot(2,1,2)
        plot(Bshape(:,2,1),Bshape(:,2,2),'b-o'),grid on,title('Limit cycle right')
        xlabel('Shape mode 1 [-]'),ylabel('Shape mode 2 [-]')
end
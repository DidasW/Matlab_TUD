%% %%%%%%%%%%%%%%%%%%%%%POST PROCESSING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%------TRANSFORM SHAPES---------------------------------------------------%
%Shapes are stored in right flagella form, rescaled to 1
%micron and rotated to have 0 initial tangent angle
xndim = (xtemp-xtemp(1))./lf0./scale; %Rescale flagellum to 1 micron
yndim = (ytemp-ytemp(1))./lf0./scale; %Rescale flagellum to 1 micron
xrot = [xndim'; yndim';];

% figure(9),clf, subplot(3,1,1)
% plot(xndim,yndim)
% axis equal, pause(eps)

%Save shapes in left flagellum form (flip left shape instead of right
%because of image coordinates)
if lr == 1 
    xrot(2,:) = -xrot(2,:);
end

% figure(9),subplot(3,1,2)
% plot(xrot(1,:),xrot(2,:))
% axis equal, pause(eps)

if lr == 1
    xrot = R(-thetal)*xrot; 
else
    xrot = R(thetar)*xrot; 
end
xndim = xrot(1,:);
yndim = xrot(2,:);

% figure(9),subplot(3,1,3)
% plot(xrot(1,:),xrot(2,:))
% axis equal, pause(eps)

%------CALCULATE CURVATURE, SHAPE SCORES AND PHASE ANGLE------------------%
%Curvature profiles are stored as for a left flagellum, but shape scores
%are negative for left flagellum and positive for right flagellum.
%Shape scores are stored so as to get the shape of a flagellum of 1 micron
%back, using the 1 micron principal components.

if stage == 0
    [curv,phi0] = xy2curv(xndim,yndim,ssc./lf0./scale,optsfmc);
    kappasave(image-firstimg+1,lr,:) = [phi0; curv'];
else
    curv = (princpts(1,2:end)' + princpts(2:nmodes+1,2:end)'*Bf).*lf0.*scale;
    phi0 = princpts(1,1) + princpts(2:nmodes+1,1)'*Bf;
    kappasave(image-firstimg+1,lr,:) = [phi0; curv];
end
   
% %Plot results
% if lr == 1
%     phi0 = thetal-phi0;
%     curv = -curv;
% else
%     phi0 = thetar+phi0;
% end
% Ytot = curv2xy_quick(curv./lf0./scale,ssc,phi0,xbase,ybase); 
% figure(7), clf, imshow(Im,'InitialMagnification',400), hold on
% plot(xtemp,ytemp,'k*-')
% plot(Ytot(:,2),Ytot(:,3),'r','LineWidth',1.5), hold off; pause(eps)

%Store result
xflag(image-firstimg+1,lr,:) = xtemp;
yflag(image-firstimg+1,lr,:) = ytemp;
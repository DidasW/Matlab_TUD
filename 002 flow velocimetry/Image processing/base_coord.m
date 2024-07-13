%%%%%%%%%%%%%%%%%%%%%%%%%%PERIMETER DETECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Locate the perimeter by scanning with radial lines from clicked point.
%Brightest point on each scanning line corresponds to perimeter. Only first
%image is processed.
n = num2str(list(1),fileformatstr); %Generate image string
file = (['1_',n,'.tif']);           %First image
Im     = mat2gray(imread(file));    %Grayscale version of image
[Im,~] = wiener2(Im);
 
[ylim,xlim] = size(Im);                 %Columns, rows
[xx,yy] = meshgrid(1:xlim,1:ylim);      %xgrid, ygrid
[xnd,ynd] = ndgrid(1:ylim,1:xlim);      %xgrid, ygrid

if userclick == 0
    switch supfld
    case '4-26/'
        switch pt
        case {9,17,27}
                xi = 131.3750; yi=39.1250;
            case {68,83}
                xi = 162.3750; yi=46.8750;
        end
    case ''
        switch pt
        otherwise
            error('First supply points to be clicked to file basecoord.m before setting userclick = 0')
        end
        otherwise
        error('First supply points to be clicked to file basecoord.m before setting userclick = 0')
    end
else
    figure(1), imshow(Im,'InitialMagnification',screenmagnif)
    title('Click 1 point, middle of cell body (LMB)')
    [xi,yi,~] = ginput(1);                   %xy coordinates of clicked point
end

%Search parameters
theta=linspace(0,2*pi,180);                 %All angles to be scanned [rad]
rmin = 2.5;                                 %Min search radius [micron]
rmax = 5.5;                                 %Max search radius [micron]
rres = 0.1;                                 %Search resolution [micron]
rsearch = rmin:rres:rmax;                   %Search radius vector [micron]
[xperim, yperim] = deal(zeros(length(theta),1)); %xy coordinates of perimeter

% figure, imshow(Im), hold on
% plot(xi+rmin.*scale.*cos(theta),yi+rmin.*scale.*sin(theta),'r')
% plot(xi+rmax.*scale.*cos(theta),yi+rmax.*scale.*sin(theta),'g')
% pause

%Scan radially
F = griddedInterpolant(xnd,ynd,Im,'linear');  %Interpolation grid
for i=1:length(theta)
    xline = xi+rsearch.*scale.*cos(theta(i)); %Coordinates of search line points [px]
    yline = yi+rsearch.*scale.*sin(theta(i));
    %When parts of line are outside image, disregard this scan line
    ind = find(xline > 0 & xline < xlim & yline > 0 & yline < ylim);
    if length(ind) == length(rsearch)
        insty = F(yline,xline);    %Intensity at [xline,yline]
        if colorb
            ind = find(insty == max(insty),1,'last');
        else
            ind = find(insty == min(insty),1,'last');
        end
        xperim(i) = xline(ind);
        yperim(i) = yline(ind);
    end
%     %Plot results
%     figure(1),clf
%     subplot(2,1,1)
%         subimage(Im), hold on
%         plot(xline,yline,'rx')
%         plot(xperim(i),yperim(i),'g*')
%     subplot(2,1,2)
%         plot(insty)
%     pause(eps)
end

xperim(xperim == 0) = [];
yperim(yperim == 0) = [];

% % Plot results
% figure(1),clf, imshow(Im,'InitialMagnification',screenmagnif), hold on
% plot(xperim,yperim,'g*'), pause(1)

%%%%%%%%%%%%%%%%%DETERMINE CELL ROTATION, FLAGELLAR BASE%%%%%%%%%%%%%%%%%%%
%An ellipse is fitted to the detected cell body rim. The rotation of this 
%fitted ellipse is used as an estimation for the rotation of the cell body.
%The user is prompted to accept this guess or click a point himself.

el = fit_ellipse(xperim,yperim);    %Fit ellipse
Cell.major_rad = el.a/scale;
Cell.minor_rad = el.b/scale;
R = @(phi) [cos(phi) sin(phi); -sin(phi) cos(phi);]; %Rotation matrix

if userclick
    %Accept starting coordinates?
    figure(1), clf, imshow(Im,'InitialMagnification',screenmagnif), hold on
    qstr = 'Accept starting coordinates?';
    astr1 = 'Yes';
    astr2 = 'No, let my try again';
    basecomplete = 0;
    while ~basecomplete
        figure(1), clf, imshow(Im,'InitialMagnification',screenmagnif), hold on
        title('Click 2 points at the cell body edge, one for each flagellum, left flagellum first (LMB)')
        for click = 1:2
            [xi(click),yi(click),~] = ginput(1);   %xy coordinates of clicked point
            plot(xi(click),yi(click),'b+')
        end
        hold on
            plot(xi,yi,'b+')
        hold off
        button2 = questdlg(qstr,qstr,astr1,astr2,astr1);
        switch button2
            case astr1 %User accepts clicked points
                %Accept coordinates
                xbclick(1,1) = xi(1);
                xbclick(1,2) = yi(1);
                xbclick(2,1) = xi(2);
                xbclick(2,2) = yi(2);
                basecomplete = 1;
            case astr2 %User wants to click again
                %Do nothing, let loop run again
        end
    end
else
    switch supfld
    case '4-26/'
        xbclick = [134.3750 60.6250; 128.1250 60.1250;];     
    end
    switch pt
    case 0
        xbclick = [130.9994 65.5335; 130.7379 75.0217;]; 
    case 1
        xbclick = [107.1250 61.6250; 108.3750 70.8750;];    
    case 3
        xbclick =[106.3750 57.1250; 105.8750 67.3750;];
    case 4
        xbclick = [94.625 55.125; 95.125 64.125;]; 
    case 6
        xbclick = [185.625 43.875; 179.625 43.875;];
    case 23
        xbclick = [63.3750 65.8750; 63.1250 74.8750;];
    case {53,65}
        xbclick = [139.125 79.125; 131.375 80.125;];
    case {83,84,88,91}
        xbclick = [165.3750 66.8750; 157.6250 66.8750;];
    end  
end

%Construct polygon of ellipse fit for cell body description
theta_r         = linspace(0,2*pi,25);
ellipse_x_r     = el.X0 + el.a*cos( theta_r );
ellipse_y_r     = el.Y0 + el.b*sin( theta_r );
rotated_ellipse = R(el.phi) * [ellipse_x_r;ellipse_y_r];
xperim_el = rotated_ellipse(1,:);
yperim_el = rotated_ellipse(2,:);
[xc,yc,~] = centroid(xperim_el,yperim_el);

% %Create mask with 1 inside ellipse and 0 outside
% bodymask = poly2mask(round(xperim_el),round(yperim_el),size(Im,1),size(Im,2));
% bodymask = double(bodymask);
% GIPbody = griddedInterpolant(xnd,ynd,bodymask,'linear');

%Display results
figure
subplot(2,1,1)
    subimage(Im) 
    hold on
        plot(xperim,yperim,'g*')
        plot(xc,yc,'g+')
    hold off
subplot(2,1,2)
    subimage(Im)  
    hold on
        plot(xi,yi,'rx')
        plot(xbclick(1,1),xbclick(1,2),'b+')
        plot(xbclick(2,1),xbclick(2,2),'b+')
        plot_ellipse(el,gca,1)%Rotated ellipse
    hold off
pause(1)

figure
imshow(Im),hold on
plot(xperim,yperim,'g*')
plot_ellipse(el,gca,1)%Rotated ellipse

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%REFINE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In order to have a meaningful description of the flagellum, the starting
% point has to be the same for each set of images. The procedure is as
% follows: 
% 1) The user clicks two points, one on each flagellum
% 2) For a number of frames, one scanning step is taken per flagellum. The
% point of minimum/maximum intensity is stored.
% 3) The two points per flagellum define a line. The flagellar base is
% defined to be where these two lines cross. 
% 4) The orientation angle of the body is determined from the angle between
% the centroid (determined in base_coord) and the flagellar base
% Note: both the flagellar base location and the body angle are determined
% from the average over a number of frames.

sotf = 1;                               %Start of training frames
ntf = 10;                               %Number of training frames
eotf = sotf+ntf;                        %End of training frames

xbase_guess = zeros(2,ntf);             %Estimates of flagellar base location
[xscan,yscan] = deal(zeros(ntf,2));     %The darkest/brightest point in the scan fan
thetal = -pi/4-orientation;
thetar = pi/4-orientation;

for ll=1:ntf
    n=num2str(list(ll-1+sotf),fileformatstr);
    file=(['1_',n,'.tif']);
    Im = imread(file);
    Im = mat2gray((Im));
    Im = wiener2(Im);               %Apply Wiener filter to remove Gaussian noise
    Im = imadjust(Im,contradj);
    F  = griddedInterpolant(xnd,ynd,Im,'linear');  %Interpolation grid
    
    for lr=1:2 %Scan each flagellum
        if lr == 1 %left flagellum
            theta = 2.5*theta0 + thetal;      %Start search (45+body tilt) degrees to left
        else
            theta = 2.5*theta0 + thetar;      %Start search (45-body tilt) degrees to right
        end
        xline = xbclick(lr,1)+3*ds0.*cos(theta);    %Fan of points to search
        yline = xbclick(lr,2)+3*ds0.*sin(theta);
%         figure(1),clf, imshow(Im,'InitialMagnification',screenmagnif),hold on 
%         plot(xbclick(lr,1),xbclick(lr,2),'r+'),plot(xline,yline,'g*'),pause%(eps)
        insty = F(yline,xline);   %Returns image intensity values @ scan locations
        mintens = min(insty);   %Minimum intensity
        maxtens = max(insty);   %Maximum intensity
        dintensrel = (maxtens - mintens)/ds0/scale/abs(theta(1)-theta(end)); %Relative intensity difference
        if  dintensrel < dintensrelmin %Difference in intensity among scanned positions insufficient to determine darkest/brightest point
            xscan(ll,lr) = 0;
            yscan(ll,lr) = 0;
        else
            if colorf(lr) == 1 %Flagellum bright against dark background
                ind = find(insty == max(insty),1,'first');
            else %Flagellum dark against bright background
                ind = find(insty == min(insty),1,'first');
            end
            xscan(ll,lr) = xline(ind);
            yscan(ll,lr) = yline(ind);
        end
    end
       
%     figure(1), clf, imshow(Im,'InitialMagnification',screenmagnif), hold on
%     plot(xscan(ll,1),yscan(ll,1),'r+'),plot(xscan(ll,2),yscan(ll,2),'g+'),pause(eps)
end

%Flagellar base is mean of detected locations in training frames
xscanm1 = mean(nonzeros(xscan(:,1)));
xscanm2 = mean(nonzeros(xscan(:,2)));
yscanm1 = mean(nonzeros(yscan(:,1)));
yscanm2 = mean(nonzeros(yscan(:,2)));

% figure(1), clf, imshow(Im,'InitialMagnification',screenmagnif), hold on
% plot(xscanm1,yscanm1,'r+'),plot(xscanm2,yscanm2,'r+')
% plot(xbclick(1,1),xbclick(1,2),'bo'),pause(eps)
% plot(xbclick(2,1),xbclick(2,2),'bo'),pause(eps)

a1 = (yscanm1-xbclick(1,2))/(xscanm1-xbclick(1,1));     %Slope of left flagellum line
a2 = (yscanm2-xbclick(2,2))/(xscanm2-xbclick(2,1));     %Slope of right flagellum line
b1 = yscanm1 - a1*xscanm1;                              %Starting point of left flagellum line
b2 = yscanm2 - a2*xscanm2;                              %Starting point of right flagellum line
xbase = (b2-b1)/(a1-a2);                                %x coordinate of line crossing point
ybase = a1*xbase+b1;                                    %y coordinate of line crossing point
phi_body = atan2(ybase-yc,xbase-xc);                    %Cell body angle
thetal = atan2(yscanm1-ybase,xscanm1-xbase);    %Initial tangent angle for left flagellum
thetar = atan2(yscanm2-ybase,xscanm2-xbase);    %Initial tangent angle for right flagellum
Cell.thetal = thetal; Cell.thetar = thetar; Cell.phi_body = phi_body;
Cell.dist_base = sqrt((ybase-yc)^2+(xbase-xc)^2)/scale;

if userclick 
    %Display result to user and allow to correct
    clickcomplete = 0;
    qstr = 'Accept current base?';
    astr1 = 'Yes';
    astr2 = 'No, let me click myself';
    while ~clickcomplete
        figure(1),clf,imshow(Im,'InitialMagnification',screenmagnif), hold on
        plot(xbase,ybase,'b+')
        plot([xbase xbase+5*cos(thetal)],[ybase ybase+5*sin(thetal)],'b+-','LineWidth',5),
        plot([xbase xbase+5*cos(thetar)],[ybase ybase+5*sin(thetar)],'b+-','LineWidth',5), pause(eps)

        button = questdlg(qstr,qstr,astr1,astr2,astr1);
        switch button
            case astr1 %Accept base
                %Do nothing
                clickcomplete = 1;
            case astr2 %Let user click
                figure(1), clf, imshow(Im,'InitialMagnification',screenmagnif), hold on
                title('Click the flagellar base (LMB)')
                [xbase, ybase, ~] = ginput(1);
                plot(xbase,ybase,'bo')
                title('Click the point where the LEFT flagellum crosses the cell body edge (LMB)')
                [xscanm1, yscanm1, ~] = ginput(1);
                plot(xscanm1,yscanm1,'b+')
                title('Click the point where the RIGHT flagellum crosses the cell body edge (LMB)')
                [xscanm2, yscanm2, ~] = ginput(1);
                plot(xscanm2,yscanm2,'b+')
                phi_body = atan2(ybase-yc,xbase-xc);                    %Cell body angle
                thetal = atan2(yscanm1-ybase,xscanm1-xbase);    %Initial tangent angle for left flagellum
                thetar = atan2(yscanm2-ybase,xscanm2-xbase);    %Initial tangent angle for right flagellum
                Cell.thetal = thetal; Cell.thetar = thetar; Cell.phi_body = phi_body;
                Cell.dist_base = sqrt((ybase-yc)^2+(xbase-xc)^2)/scale;
        end
    end
else
    figure(1),clf,imshow(Im,'InitialMagnification',screenmagnif), hold on
    plot(xbase,ybase,'b+')
    plot([xbase xbase+5*cos(thetal)],[ybase ybase+5*sin(thetal)],'b+-','LineWidth',5),
    plot([xbase xbase+5*cos(thetar)],[ybase ybase+5*sin(thetar)],'b+-','LineWidth',5), pause(eps)
    pause(0.5)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CLEAN UP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear a1 a2 astr1 astr2 b1 b2 basecomplete button button2 click phi_body_guess
clear qstr rmax rmin rotated_ellipse rres rsearch
clear xc xi xscanm1 xscanm2 yc yi yscanm1 yscanm2

clickcomplete = 0;
while ~clickcomplete
    %Show image
    figure(4), clf, imshow(Im,'InitialMagnification',screenmagnif), hold on
    plot(xbase,ybase,'b+')
    %Let user click points
    if lr == 1
        title('Click points on left flagellum with LMB, end with RMB, exclude first point')
    else
        title('Click points on right flagellum with LMB, end with RMB, exclude first point')
    end
    click = 2;                      %Index variable
    button = 1;                     %Button clicked (1/2/3=left/middle/right)
    clear xi yi clickgrd
    xi(1) = xbase; yi(1) = ybase;
    while button == 1
        [xi(click),yi(click),button] = ginput(1);   %xy coordinates of clicked point
        plot(xi(click),yi(click),'b+')
        click = click + 1;
    end
    %Process shape into continuous curvature shape
    npts = length(xi);  
    si = sqrt((xi(2:end)-xi(1:end-1)).^2+(yi(2:end)-yi(1:end-1)).^2);   %Distance betweence adjacent points [px]
    clickgrd(1) = 0;
    for ii=2:npts
        clickgrd(ii) = clickgrd(ii-1)+si(ii-1);     %Grid of arc length [px]
    end
    %Interpolate clicked points before converting to curvature
    clickinterpx = griddedInterpolant(clickgrd,xi,'spline');
    clickinterpy = griddedInterpolant(clickgrd,yi,'spline');
    xinterp = clickinterpx(ssc);    %Interpolated x values
    yinterp = clickinterpy(ssc);    %Interpolated y values
    [curv,phi0] = xy2curv(xinterp,yinterp,ssc,optsfmc);
    Ytot = curv2xy_quick(curv,ssc,phi0,xbase,ybase);
    %Plot results, let user decide
    plot(Ytot(:,2),Ytot(:,3),'r','LineWidth',1.5)
    button2 = questdlg(qstr,qstr,astr1,astr3,astr1);
    switch button2
        case astr1 %User accepts clicked points
            %Accept coordinates
            xtemp = Ytot(:,2); ytemp = Ytot(:,3);
            post_processing_initial
            clickcomplete = 1;
        case astr3 %User wants to click again
            %Do nothing, let loop run again
    end
end
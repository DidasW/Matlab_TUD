function [] = plot_body_flags(axhandle,anglist,xloclist,yloc,...
    xsize,ysize,BC,kappasave,Rcell)
%% PLOT_BODY_FLAGS 
%Plots cell body and flagella for multiple cell angles in the axes
%specified by axhandle
%% INPUT
%axhandle       handle to plot axes
%anglist        list of cell angles to plot
%xloclist       x locations for plots of cell body + flagella
%yloc           y location for plots
%xsize          size of cell in x-direction (recommend 1/10th of plot range)
%ysize          size of cell in y-direction (recommend 1/10th of plot range)
%BC             BC (base case) object with limit cycle info
%kappasave      Curvature values of experiment
%thetabase      Initial angles for left/right flagella
%Rcell          Cell minor/major radii

%% NOTE
%PCA_store,BC,kappasave,thetabase and Rcell already exist in workspace so 
%supply these variables directly

%   Detailed explanation goes here
    nmodes = 2;
    Bplot = zeros(nmodes,length(anglist));
    %Get shape scores
    for nn=1:nmodes
        Bplot(nn,:) = BC.BlimitGIP{nn}(anglist);
    end
    %Calculate xy-version of shapes, plot together with cell body
    nsteps = 40; nodes = size(kappasave,3);
    Lgrid = linspace(0,1,nodes-1);   %Grid to interpolate curvature
    ssc  = linspace(0,1,nsteps);  %Location of xy-nodes
    rotation = pi/2;
    [xf,yf] = deal(zeros(length(anglist),2,nsteps));
    for aa=1:length(anglist)
        for lr=1:2
            curv = (BC.PCA_store(1,2:end) + Bplot(:,aa)'*BC.PCA_store(2:nmodes+1,2:end));
            phi_0 = BC.PCA_store(1,1) + Bplot(:,aa)'*BC.PCA_store(2:nmodes+1,1);
            if lr == 1;
                GIP = griddedInterpolant(Lgrid,-curv,'linear');
            else
                GIP = griddedInterpolant(Lgrid,curv,'linear');
            end
            kappa = GIP(ssc);
            if lr == 1
                Ytot = curv2xy_quick(kappa,ssc,...
                    (rotation-(BC.thetabase(1,1)-BC.thetabase(1,3))-phi_0),0,0);
            else
                Ytot = curv2xy_quick(kappa,ssc,...
                    (rotation-(BC.thetabase(1,2)-BC.thetabase(1,3))+phi_0),0,0);
            end
            xf(aa,lr,:) = Ytot(:,2);
            yf(aa,lr,:) = Ytot(:,3);
        end
    end
    rmin = Rcell(1,1)*1e6/10; rmaj = Rcell(1,2)*1e6/10; %Minor, major cell radius
    thel = linspace(0,2*pi,100);
    xel  = xsize*rmin*cos(thel);
    yel  = -ysize*rmaj+ysize*rmaj*sin(thel);
    for ii=1:length(anglist)
        plot(axhandle,xloclist(ii)+xsize.*squeeze(xf(ii,1,:)),...
            yloc+ysize.*squeeze(yf(ii,1,:)),'r')
        plot(axhandle,xloclist(ii)+xsize.*squeeze(xf(ii,2,:)),...
            yloc+ysize.*squeeze(yf(ii,2,:)),'r')
        plot(axhandle,xloclist(ii)+xel,yloc+yel,'k');
    end
end


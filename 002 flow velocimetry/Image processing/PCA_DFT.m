%--------------------------------------------------------------------------
% principal_component_analysis_curvature
%--------------------------------------------------------------------------
%Performs a principal component analysis on the curvature values from
%shape_library.mat

%% Preliminaries
close all
clc

savelimit = 0;          %Save limit cycle data?
PCAplots = 1;           %Extra plots?
movie = 0;              %Make and show movie of limit cycle?
n=9;                    %Only n first modes relevant

curv = [squeeze(kappasave(:,1,:)); squeeze(kappasave(:,2,:));]; %[starting angle; (Curvatures)]
samples = size(curv,1);     %Number of measurements
nodes = size(curv,2);

%% Principle value decomposition
close all
curv0 = repmat(mean(curv,1),[samples,1]);   %Mean of all samples
Cov = (curv-curv0)'*(curv-curv0);           %Covariance matrix
%figure, imshow(imadjust(Cov),'InitialMagnification',5e3,'Colormap',jet(100))  %Plot covariance matrix
[eigvecs,eigvals] = eig(Cov);               %eigvals is diagonal matrix with eig vals, 
                                            %eigvecs matrix with eig vecs as collumns
eigvals = real(diag(eigvals));              %Discard tiny imaginary part
eigvecs = real(eigvecs);                    %Discard tiny imaginary part

%Sort shape modes in descending order
[eigvals, index] = sort(eigvals,'descend'); %Index gives the old indices of the sorted vector
eigvecs = eigvecs(:,index);

if PCAplots
    %Plot magnitude of eigenvalues
    figure, semilogy(eigvals/eigvals(1),'o-k'), grid on                 
    xlabel('Shape mode nr'), ylabel('Relative magnitude of eigenvalue')
    title('Relative magnitude of eigenvalues')
    %Plot first n shape modes
    figure, legendstr = cell(n,1); hold on
    plot(curv0(1,:)), legendstr{1} = '0';
    for i=1:n                               
        plot(eigvecs(:,i))
        legendstr{i+1} = num2str(i);
    end
    hold off, xlabel('Node number'), ylabel('Shape mode curvature')
    title('Shape modes'),legend(legendstr,'Location','South')
end

%% Fit principal components to data
%Calculate shape scores using linear least squares
C = real(eigvecs);                          %Shape modes
d = curv-curv0;                             %Tangent angle minus mean
Bdata = zeros(samples,nodes);               %Shape scores
curv_tilde = zeros(size(curv));             %Approximate curvatures
for ii=1:samples
    Bdata(ii,:) = lsqlin(C,d(ii,:),[],[]);
    curv_tilde(ii,:) = curv0(1,:) + (C*Bdata(ii,:)')';
end
Bdata = real(Bdata);

% %Plots of reconstructed vs actual shapes
% for i=1:10:samples
%     figure
%     subplot(2,1,1)
%     %Exact and approximated shapes
%     hold on
%         plot(curv(i,:))
%         plot(curv_tilde(i,:))
%         legend(strcat('\kappa_{',num2str(i),'}'),'\kappa_{PCA}')
%         xlabel('Node number')
%         ylabel('Shape mode curvature')
%     hold off
%     subplot(2,1,2)
%     %Shape scores
%         plot(abs(B(i,:)))
%         xlabel('Shape mode')
%         ylabel('Absolute shape score')
%     pause(1e-4)
% end

% %% Calculate xy version of shape modes
% onlyshape = 0; %Plot only shape modes (1) or shape mode + mean shape (0)
% nsteps = 40;
% lf = 15;
% Lgrid = linspace(0,lf,nodes-1);   %Grid to interpolate curvature
% ssc  = linspace(0,lf,nsteps);  %Location of xy-nodes
% [xflag,yflag] = deal(zeros(nsteps,n+1));
% for i=1:n+1
%     if onlyshape
%         if i == 1 %Mean shape
%             curv_PCA = curv0(1,2:end)'./lf;
%             phi0_PCA = curv0(1,1);
%         else %Higher modes
%             curv_PCA = C(2:end,i-1)./lf;
%             phi0_PCA = C(1,i-1);
%         end
%     else
%         coeff = 5;
%         if i == 1 %Mean shape
%             curv_PCA = curv0(1,2:end)'./lf;
%             phi0_PCA = curv0(1,1);
%         else %Higher modes
%             curv_PCA = (curv0(1,2:end)'+coeff.*C(2:end,i-1))./lf;
%             phi0_PCA = curv0(1,1) + coeff*C(1,i-1);
%         end
%     end
%     GIP = griddedInterpolant(Lgrid,curv_PCA,'linear');
%     kappa = GIP(ssc);
%     Ytot = curv2xy_quick(kappa,ssc,phi0_PCA,0,0);
%     xflag(:,i) = Ytot(:,2);
%     yflag(:,i) = Ytot(:,3);
%     legendstr{i} = strcat('Shape mode ',num2str(i-1));
% end
% 
% % %Plot shape modes in xy
% % figure, hold on
% % for i=1:length(legendstr)
% %     if i == 1 %Mean shape
% %         plot(xflag(:,i),yflag(:,i),'--');
% %     else
% %         plot(xflag(:,i),yflag(:,i));
% %     end
% % end
% % title('Shape modes in xy coordinates')
% % xlabel('x [\mu m]')
% % ylabel('y [\mu m]')
% % legend(legendstr)

%% Reconstruct limit cycle
if n>1
    phi = -unwrap(atan2(Bdata(:,2),Bdata(:,1)))+2.16;
    %Convert B and phi to equally spaced vectors
    [phisort,ind] = sort(mod(phi,2*pi)); 
    Bsort = Bdata(ind,:);
    %Check for double values of phi
    diffphisort = phisort(2:end)-phisort(1:end-1);
    ind = find(diffphisort == 0);
    if ~isempty(ind) %Double values found
        ind = ind+1;
        phisort(ind) = [];
        Bsort(ind,:) = [];
    end
    phieq = linspace(min(phisort),max(phisort),500);   %Equally spaced grid req. for DFT
    [Y,Beq,P2] = deal(zeros(length(phieq),nodes));
    for ii=1:nodes
        GIP = griddedInterpolant(phisort,Bsort(:,ii),'linear');
        Beq(:,ii) = GIP(phieq);                 %Shape scores on equally spaced grid
    end
    N = length(phieq);              %Number of samples
    T = (phisort(end)-phisort(1))/N;%Sample time    [s]
    k = 0:N-1;                      %Sample index
    Fs = 1/T;                       %Sampling frequency [Hz]
    f = k.*Fs./N;                   %Recovered frequencies
    %Do the DFT
    P1 = zeros(N/2+1,nodes);
    for ii=1:nodes
        Y(:,ii) = fft(Beq(:,ii));
        %Convert two-sided transform to one-sided transform
        P2(:,ii) = Y(:,ii)/N;
        P1(:,ii) = P2(1:N/2+1,ii);
        P1(2:end-1,ii) = 2*P1(2:end-1,ii);
    end
    nlimit = 400;                   %Number of steps in limit cycle
    phi0 = pi*(2:-2/(nlimit-1):0);
    Blimit = zeros(nlimit,nodes);
    %Inverse DFT with limited number of frequencies
    nharm = 5;                     %Number of harmonics to take into account
    for ii=1:nodes
        for k=1:nharm
            Blimit(:,ii) = Blimit(:,ii) + real(P1(k,ii)).*cos(2*pi*f(k).*phi0') + ...
                imag(P1(k,ii)).*sin(2*pi*f(k).*phi0'); 
        end
    end
    %Blimit = Blimit(end:-1:1,:);
    if PCAplots
        %Plot approximated limit cycle
        a = ceil(sqrt(n+1));
        b = ceil((n+1)/a);
        figure
        for ii=1:n
           subplot(a,b,ii), hold on, scatter(phieq./(2*pi),Beq(:,ii),2,'k.')
           plot(phi0./(2*pi),Blimit(end:-1:1,ii),'r','LineWidth',2)
           title(strcat('Mode',{' '},num2str(ii)))
    %        if ii == 1
               ylabel('Shape score')
    %        end
           xlabel('Relative phase')
    %        switch ii
    %            case 1
    %                axis([0 1 -25 20])
    %            case 2
    %                axis([0 1 -15 20])
    %            case 3
    %                axis([0 1 -5 10])
    %        end
        end
        subplot(a,b,n+1), hold on, scatter(0.5,0.5,'k.')
        plot([0 1],[1 1],'r','LineWidth',2),title('Legend')
        axis([0 1 0 1])
        legend('Shape scores of points','Fitted limit cycle')
    end
end

%Store limit cycle
PCA_store(1,:) = mean(curv,1);
PCA_store(2:size(eigvecs,1)+1,:) = eigvecs';
if savelimit
    filename = strcat('Blimit_curv');
    save(filename,'Bdata','Blimit','kappasave','PCA_store');
end
        
if PCAplots
    %Plot limit cycle
    switch n
        case 1
            figure, plot(Bdata(:,1))
            title('Shape scores'),xlabel('Sample'),ylabel('Mode 1')
        case 2
            figure, hold on, scatter(Blimit(:,1),Blimit(:,2),100,hsv2rgb([mod(phi0'/(2*pi),1) ones(length(phi0),2)]),'.');
            scatter(Bdata(:,1),Bdata(:,2),100,hsv2rgb([mod(-phi/(2*pi),1) ones(samples,2)]),'.');
            title('Shape scores'),xlabel('Mode 1'),ylabel('Mode 2'), grid on
        otherwise
            figure, hold on, scatter3(Blimit(:,1),Blimit(:,2),Blimit(:,3),100,hsv2rgb([mod(phi0'/(2*pi),1) ones(length(phi0),2)]),'.')
            scatter3(Bdata(:,1),Bdata(:,2),Bdata(:,3),100,hsv2rgb([mod(-phi/(2*pi),1) ones(samples,2)]),'.')
            title('Shape scores'),xlabel('Mode 1'),ylabel('Mode 2'),zlabel('Mode 3'),grid on
    end
end

%% Make movie of reconstructed limit cycle
if movie
    nstepsm = 40;                           %Number of nodes
    lf = 15;                                %Length of flagellum
    Lgrid = linspace(0,lf,nodes-1);         %Grid to interpolate curvature
    sscm  = linspace(0,lf,nstepsm);         %Location of xy-nodes
    [xflag,yflag] = deal(zeros(nstepsm));   %x/y coordinates
    Frames(size(Blimit,1)) = struct('cdata',[],'colormap',[]);
    if n>1
        for ii=1:size(Blimit,1)
            curv_PCA = (curv0(1,2:end)'+C(2:end,1:n)*Blimit(ii,1:n)')./lf;
            phi0_PCA = curv0(1,1) + C(1,1:n)*Blimit(ii,1:n)';
            
            GIP = griddedInterpolant(Lgrid,curv_PCA,'linear'); %Interpolate curvature
            kappa = GIP(sscm);
            Ytot = curv2xy_quick(kappa,sscm,phi0_PCA,0,0);
            xflag = Ytot(:,2);
            yflag = Ytot(:,3);
            figure(3), clf
            plot(xflag,yflag), axis([-lf lf -lf lf]), pause(eps)
            drawnow
            Frames(ii) = getframe;
        end
%         if savelimit
            filename = strcat('Limit_cycle_new_',num2str(n),'_modes');
            v = VideoWriter(filename,'MPEG-4');
            f = 0.1;
            v.FrameRate = round(length(phi0)*f);
            open(v)
                writeVideo(v,Frames)
            close(v)
%         end
    end
end
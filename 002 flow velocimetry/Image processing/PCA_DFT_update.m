%--------------------------------------------------------------------------
% PCA_DFT_update
%--------------------------------------------------------------------------
%Performs a principal component analysis on the curvature values from
%shape_library.mat

%% Preliminaries
close all
clc

savelimit = 0;          %Save limit cycle data?

curv = [squeeze(kappasave(:,1,:)); squeeze(kappasave(:,2,:));]; %[starting angle; (Curvatures)]
samples = size(curv,1);     %Number of measurements
nodes = size(curv,2);

%% Principle value decomposition
close all
curv0 = repmat(mean(curv,1),[samples,1]);   %Mean of all samples
Cov = (curv-curv0)'*(curv-curv0);           %Covariance matrix
[eigvecs,eigvals] = eig(Cov);               %eigvals is diagonal matrix with eig vals, 
                                            %eigvecs matrix with eig vecs as collumns
eigvals = real(diag(eigvals));              %Discard tiny imaginary part
eigvecs = real(eigvecs);                    %Discard tiny imaginary part

%Sort shape modes in descending order
[eigvals, index] = sort(eigvals,'descend'); %Index gives the old indices of the sorted vector
eigvecs = eigvecs(:,index);

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

%% Reconstruct limit cycle
if n>1
    phi = unwrap(atan2(Bdata(:,2),Bdata(:,1)));
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
end

%Store limit cycle
PCA_store(1,:) = mean(curv,1);
PCA_store(2:size(eigvecs,1)+1,:) = eigvecs';
if savelimit
    filename = strcat('Blimit_curv');
    save(filename,'Bdata','Blimit','kappasave','PCA_store');
end

%Load limit cycle shapes
princpts0 = PCA_store; 
princpts0(:,2:end) = princpts0(:,2:end)./lf0./scale; %Curvature values are for flagellum of 1 micron, convert to values for pixels

%Make principal components use same grid as xy-shapes
ncurvnodes = size(Blimit,2)-1;          %Number of curvature nodes in library shapes    
Lgrid = linspace(0,lf,ncurvnodes);      %Grid to interpolate curvature
princpts = zeros(size(princpts0,1),nsteps+2);
for k=1:size(princpts0,1)%Loop over all modes
   GIP = griddedInterpolant(Lgrid,princpts0(k,2:end),'spline');
   princpts(k,1) = princpts0(k,1);
   princpts(k,2:end) = GIP(ssc);
end

%Optimization options
LB = -10*max(abs(Blimit),[],1);     %Lower bound (shape scores limited to 10 times limit cycle max)
LB = LB(1:nmodes);
UB = -LB;                           %Upper bound

if minimalgorithm == 1
    %Generate xy version of shapes from data
%     nmodes = min(size(Bdata,2),ncurvnodes-2);   %Number of PCA modes to take into account
    nmodes = min(size(Bdata,2),ncurvnodes);     %Number of PCA modes to take into account
    samples = size(Bdata,1);                    %Number of samples for limit cycle
    curvlimit = repmat(princpts(1,:),samples,1) + ...
        Bdata(:,1:end)*princpts(2:end,:); %Curvature values of each point on limit cycle
elseif minimalgorithm == 2
    %Generate xy version of limit cycle from curvature values
    nmodes = min(size(Blimit,2),ncurvnodes-2);  %Number of PCA modes to take into account
    samples = size(Blimit,1);                   %Number of samples for limit cycle
    curvlimit = repmat(princpts(1,:),samples,1) + ...
        Blimit(:,1:end)*princpts(2:end,:); %Curvature values of each point on limit cycle
end
if minimalgorithm ~= 0
%     cmap = colormap(jet(samples+1)); 
    [xlimit,ylimit] = deal(zeros(samples,nsteps+1));
    for k=1:samples
        Ytot = curv2xy_quick(curvlimit(k,2:end),ssc,curvlimit(k,1),0,0); %Also vary base angle of shapes
        xlimit(k,:) = Ytot(:,2)';       %x-coordinate angle of limit cycle shape
        ylimit(k,:) = Ytot(:,3)';       %y-coordinate of limit cycle shape
    end
end

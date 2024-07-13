%--------------------------------------------------------------------------
% Principal_component_analysis_curvature
%--------------------------------------------------------------------------
%Performs a principal component analysis on the curvature values from
%shape_library.mat

%% Preliminaries
clear all
close all
clc

addpath(genpath('./'))
addpath(genpath('./src'));
addpath(genpath('./distmesh'));
set(0,'defaulttextinterpreter','latex')

savelimit = 0;          %Save limit cycle data?
texfigs = 1;            %Save figures as .tex file?
n=3;                    %Only n first modes relevant

datasets        = 4;                    %Number of datasets
filenames       = cell(datasets);       %File names
filenames{1}    = 'Data/Base case/4-26 9 1-750 corrected.mat';
filenames{2}    = 'Data/Base case/4-25 cell1 1-750 corrected.mat';
filenames{3}    = 'Data/Base case/4-25 cell2 1-750 corrected.mat';
filenames{4}    = 'Data/Base case/4-25 cell3 1-750 corrected.mat';

curv = []; 
for dd=1:datasets
   templ = []; tempr = [];
   load(filenames{dd}) 
   for kk=1:size(kappasave,1)
        templk = [squeeze(kappasave(kk,1,1)); smooth(squeeze(kappasave(kk,1,2:end)),3)];
        temprk = [squeeze(kappasave(kk,2,1)); smooth(squeeze(kappasave(kk,2,2:end)),3)];
        templ = [templ; templk';];
        tempr = [tempr; temprk';];
   end
   curv = [curv; templ; tempr;];
end
% curv = [squeeze(kappasave(:,1,:)); squeeze(kappasave(:,2,:));]; %[starting angle; (Curvatures)]
samples = size(curv,1);     %Number of measurements
nodes = size(curv,2);

%% Principle value decomposition
close all
curv0 = repmat(mean(curv,1),[samples,1]);   %Mean of all samples
Cov = (curv-curv0)'*(curv-curv0);           %Covariance matrix
% figure, imshow(imadjust(Cov),'InitialMagnification',5e3,'Colormap',jet(100))  %Plot covariance matrix
[eigvecs,eigvals] = eig(Cov);               %eigvals is diagonal matrix with eig vals, 
                                            %eigvecs matrix with eig vecs as collumns
eigvals = real(diag(eigvals));              %Discard tiny imaginary part
eigvecs = real(eigvecs);                    %Discard tiny imaginary part

%Sort shape modes in descending order
[eigvals, index] = sort(eigvals,'descend'); %Index gives the old indices of the sorted vector
eigvecs = eigvecs(:,index);

%% Plot shapes
close all

nsteps = 40;
lf = 10;
Lgrid = linspace(0,lf,nodes-1);   %Grid to interpolate curvature
ssc  = linspace(0,lf,nsteps);  %Location of xy-nodes
Lgriddl = Lgrid./lf;
sscdl = ssc./lf;
%--------------------------------------------------------------------------
% Magnitude of eigenvalues
%--------------------------------------------------------------------------
figure, semilogy(eigvals/eigvals(1),'o-k'), grid on,ylim([1e-7 Inf]),xlim([1 nodes])              
xlabel('Shape mode \#'), ylabel('Relative magnitude of eigenvalue [-]')
if texfigs
    cleanfigure; matlab2tikz('PCA_mode_magnitude.tex','extraAxisOptions',...
            'scale=\figurescale','showInfo', false);
end

%--------------------------------------------------------------------------
% Shape modes - curvature
%--------------------------------------------------------------------------
figure, legendstr = cell(n,1); hold on
plot(Lgriddl,curv0(1,2:end)), legendstr{1} = '0';
for ii=1:n                               
    plot(Lgriddl,eigvecs(2:end,ii))
    legendstr{ii+1} = num2str(ii);
end
grid on,xlabel('$s/L$ [-]'), ylabel('$\kappa$ [1/$\mu$m]')
legend(legendstr,'Location','NorthEast');
if texfigs
    cleanfigure; matlab2tikz('PCA_modes_curvature.tex','extraAxisOptions',...
            'scale=\figurescale','showInfo', false);
end

%--------------------------------------------------------------------------
% Shape modes - tangent angle
%--------------------------------------------------------------------------
[tangang] = deal(zeros(nsteps,n+1));
for ii=1:n+1
    coeff = 5;
    if ii == 1 %Mean shape
        curv_PCA = curv0(1,2:end)'./lf;
        phi0_PCA = curv0(1,1);
    else %Higher modes
        curv_PCA = coeff.*C(2:end,ii-1)./lf;
        phi0_PCA = coeff*C(1,ii-1);
    end
    for lr=1
        if lr == 1;
            GIP = griddedInterpolant(Lgrid,curv_PCA,'linear');
        else
            GIP = griddedInterpolant(Lgrid,-curv_PCA,'linear');
        end
        kappa = GIP(ssc);
        if lr == 1
            Ytot = curv2xy_quick(kappa,ssc,phi0_PCA,0,0);
        else
            Ytot = curv2xy_quick(kappa,ssc,-phi0_PCA-pi,0,0);
        end
        tangang(:,ii) = Ytot(:,1);
    end
    legendstr{ii} = strcat(num2str(ii-1));
end
cc=lines(n+1); %Colormaps
figure,hold on
for ii=1:n+1
    plot(sscdl,tangang(:,ii),'color',cc(ii,:));
end
grid on,xlabel('$s/L$ [-]'),ylabel('$\phi$ [rad]'),xlim([0 1])
legend(legendstr,'Location','East');
if texfigs
    cleanfigure; matlab2tikz('PCA_modes_tangang.tex','extraAxisOptions',...
            'scale=\figurescale','showInfo', false);
end

%--------------------------------------------------------------------------
% Shape modes - xy (+cell body)
%--------------------------------------------------------------------------
[xf,yf] = deal(zeros(nsteps,n+1,2));
for ii=1:n+1
    coeff = 5;
    rotation = pi;
    if ii == 1 %Mean shape
        curv_PCA = curv0(1,2:end)'./lf;
        phi0_PCA = curv0(1,1);
    else %Higher modes
        curv_PCA = (curv0(1,2:end)'+coeff.*C(2:end,ii-1))./lf;
        phi0_PCA = curv0(1,1) + coeff*C(1,ii-1);
    end
    for lr=1:2
        if lr == 1;
            GIP = griddedInterpolant(Lgrid,curv_PCA,'linear');
        else
            GIP = griddedInterpolant(Lgrid,-curv_PCA,'linear');
        end
        kappa = GIP(ssc);
        if lr == 1
            Ytot = curv2xy_quick(kappa,ssc,phi0_PCA+rotation,0,0);
        else
            Ytot = curv2xy_quick(kappa,ssc,-phi0_PCA-pi+rotation,0,0);
        end
        xf(:,ii,lr) = Ytot(:,2);
        yf(:,ii,lr) = Ytot(:,3);
    end
    legendstr{ii} = strcat(num2str(ii-1));
end
cc=lines(n+1); %Colormaps
rmin = 3.4; rmaj = 4.3; %Minor, major cell radius
thel = linspace(0,2*pi,100);
xel  = rmin*cos(thel);
yel  = -rmaj+rmaj*sin(thel);
figure,hold on
for ii=1:n+1
    h(ii)=plot(squeeze(xf(:,ii,1)),squeeze(yf(:,ii,1)),'color',cc(ii,:));
    plot(squeeze(xf(:,ii,2)),squeeze(yf(:,ii,2)),'color',cc(ii,:))
end
plot(xel,yel,'k--')
grid on,axis equal,xlabel('x [$\mu$m]'),ylabel('y [$\mu$m]')
legend(h,legendstr,'Location','South');
if texfigs
    cleanfigure; matlab2tikz('PCA_modes_xy.tex','extraAxisOptions',...
            'scale=\figurescale','showInfo', false);
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
% for i=1:1000:samples
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
%         plot(abs(Bdata(i,:)))
%         xlabel('Shape mode')
%         ylabel('Absolute shape score')
%     pause(1e-4)
% end

%% Store new shape base
%Store limit cycle
if savelimit
    PCA_store(1,:) = mean(curv,1);
    PCA_store(2:size(eigvecs,1)+1,:) = eigvecs';
    curv0 = curv0(1,:);
    Infostr = 'Rows are eigenvectors, columns are nodes. First row is mean shape.';
    filename = strcat('Blimit_general.mat');
    save(filename,'PCA_store','C','curv0','Infostr');
end
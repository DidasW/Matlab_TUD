% clear all;
close all; clc
% dbstop if error

%% Add paths
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%USER INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Add relevant folders
user = 'Da';
switch user
    case 'Da'
        cd('D:\004 FLOW VELOCIMETRY DATA\')
        run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')
        % will add all the pathes needed
    case 'Daniel'
    case 'other'
        %Please fill in the relevant folders here
end
experiment= '180903c22a1'; 
AA05_experiment_based_parameter_setting;

%Image location and image numbers to process
supfld = [uni_name,'\'];                %Folder immediately below main folder
pt     = 99;                             %Selected image folder
fold   = (num2str(pt,'%02d'));          %Folder name   
screenmagnif = 100;                     %Show images at n% of original size
cd(strcat(supfld,fold));                %Change current folder

load([supfld,num2str(pt,'%02d'),'\Blimit_27_final.mat']);

list     = 1:30;     %Image numbers in folder, now defined in AA05_...
beginimg = 1;          %First image to process (n-th item of 'list')
endimg   = list(end);         %Last image to process (n-th item of 'list')

princpts0 = PCA_store; 
princpts0(:,2:end) = princpts0(:,2:end)./lf0./scale; %Curvature values are for flagellum of 1 micron, convert to values for pixels
                                
%% Debugging switches
userclick  = 1;         %Click flagellar base detection starting point?
plotshapes = 1;         %Plots detected shapes?
saveshapes = 1;         %Save xy shapes and curvature profiles?
debugfmc   = 0;         %0 = No extra info about optimization
                        %1 = Show initial and final condition for fmincon, info per step 
                        %2 = also display initial fitting of limit cycle shapes
                        %3 = also show motion of shape during optimization (=SLOW!)
makemovie = 1;          %Make and store movie of detected shapes?
                        %0 = No movie
                        %1 = Movie with shapes only
                        %2 = Movie with velocity vectors
minimalgorithm = 1;     %1 = Run with raw shapes as initial guess
                        %2 = Run with limit cycle shapes as initial guess
postplots = 1;          %Show plots from post-processing?



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%FLAGELLA DETECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This algorithm generates a best-fitting waveform using shapes
%based on Principal Component Analysis. The best fit is determined by a
%cost function with terms for the fit to the points from the scanning
%algorithm, total curvature and fit to a foreground image (flagellum black,
%rest white). Limit cycle shapes are used as initial guess for the
%optimization.

%% %%%%%%%%%%%%%%%%%%%%%OTHER PRELIMINARY ACTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%
lf = lf0*scale;                         %Length of flagellum [px]
%Control parameters
nsteps = 25;                            %Number of steps
ssc  = linspace(0,lf,nsteps+1);         %Location of xy-nodes in terms of arc length
thetastep = 2/180*pi;                   %Step angle [rad]
rho_min = 4*scale;                      %Minimal radius of curvature [px]
%Check parameters
dintensrelmin = 1.5e-3;                 %Threshold on (relative) intensity difference for breaking off initial search algorithm

%Derived parameters
Nnodes = 4*nsteps;                      %Number of interpolation points for PCA
ds0 = lf/nsteps;                        %Scan step [px] 
dtheta = 2*ds0/rho_min;                 %Half the search angle [rad]
theta0 = linspace(-dtheta,dtheta,round(2*dtheta/thetastep));  %Scan angles, one step per degree

cycleframes = ceil(fps/f0);             %Number of frames per beatcycle

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
if minimalgorithm == 1
    %Generate xy version of shapes from data
    nmodes = min(size(Bdata,1)-1,ncurvnodes);   %Number of PCA modes to take into account
    samples = size(Bdata,1);                    %Number of samples for limit cycle
    curvlimit = repmat(princpts(1,:),samples,1) + ...
        Bdata(:,1:end)*princpts(2:end,:); %Curvature values of each point on limit cycle
elseif minimalgorithm == 2
    %Generate xy version of limit cycle from curvature values
    nmodes = min(size(Blimit,2),ncurvnodes);  %Number of PCA modes to take into account
    samples = size(Blimit,1);                   %Number of samples for limit cycle
    curvlimit = repmat(princpts(1,:),samples,1) + ...
        Blimit(:,1:end)*princpts(2:end,:); %Curvature values of each point on limit cycle
end
if minimalgorithm ~= 0
    cmap = colormap(jet(samples+1)); 
    [philimit,xlimit,ylimit] = deal(zeros(samples,nsteps+1));
    for k=1:samples
        Ytot = curv2xy_quick(curvlimit(k,2:end),ssc,curvlimit(k,1),0,0); %Also vary base angle of shapes
        philimit(k,:) = Ytot(:,1)';     %Tangent angle of limit cycle shape
        xlimit(k,:) = Ytot(:,2)';       %x-coordinate angle of limit cycle shape
        ylimit(k,:) = Ytot(:,3)';       %y-coordinate of limit cycle shape
    end
    %Optimization options
    LB = -10*max(abs(Blimit),[],1);     %Lower bound (shape scores limited to 10 times limit cycle max)
    LB = LB(1:nmodes);
    UB = -LB;                           %Upper bound
end

optsfmc = optimoptions(@fmincon,'Display','none','TolX',10^(-3)); %Options for fmincon

%% %%%%%%%%%%%%%%%%%%BACKGROUND ESTIMATION INITIALIZATION%%%%%%%%%%%%%%%%%%
%Gaussian background detection keeps track of a Gaussian distribution of
%pixel intensity for each pixel. Distributions are updated each new frame.
%Pixel intensities that fall outside {mean-k*standard dev,mean+k*standard
%dev} are flagged as foreground, rest is background.

sotf = list(1);                         %Start of training frames
ntf  = 2*cycleframes;                   %Number of training frames (2 cycles)
eotf = sotf+ntf;                        %End of training frames
n    = num2str(list(1),fileformatstr); 
file = (['1_',n,'.tif']); Im=imread(file);
SB   = zeros(size(Im,1),size(Im,2),ntf);%Sliding background matrix

%Determine contrast adjustment
contrastlim = zeros(2,ntf);             %Limits for contrast adjustment with 1%/99% saturation limits    
for ll=1:ntf
    n=num2str(list(1),fileformatstr); 
    file=(['1_',n,'.tif']);
    Im=imread(file);
    Im= mat2gray((Im));
    Im = wiener2(Im);
    contrastlim(:,ll) = stretchlim(Im); 
end
contradj = mean(contrastlim,2);

%Initialize Gaussian background model
for ll=1:ntf
    n=num2str(list(ll),fileformatstr); 
    file=(['1_',n,'.tif']);
    Im=imread(file);
    Im= mat2gray((Im));
    Im = wiener2(Im);               %Apply Wiener filter to remove Gaussian noise (noise level from other analysis)
    Im = imadjust(Im,contradj);
    SB(:,:,ll)=Im;
end
meanSB = mean(SB,3);                    %Mean of the same pixel of each image
varSB = var(SB,0,3);                    %Variance of the same pixel of each image
rho = 0.05;                             %Learning rate of background detection
d = zeros(size(Im));                    %Distance from mean for each pixel
[ylim,xlim] = size(Im);                 %Columns, rows
[xx,yy] = meshgrid(1:xlim,1:ylim);      %xgrid, ygrid
[xnd,ynd] = ndgrid(1:ylim,1:xlim);      %xgrid, ygrid

%% %%%%%%%%%%%%%%%%%%%%%%STARTING POINT DETECTION%%%%%%%%%%%%%%%%%%%%%%%%%%
base_coord

%% %%%%%%%%%%%%%%%%%%%%%%%%%%START DETECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic, close all;
nframes = endimg+1-beginimg;
[phase,phishape] = deal(zeros(nframes,2));   %Total and reduced (0-2*pi) phase angle of detected shapes
Bshape = zeros(nframes,2,nmodes);  %Shape scores of detected shapes
[xflag,yflag] = deal(zeros(nframes,2,nsteps+1));
kappasave = zeros(nframes,2,nsteps+2);
stage = 1;

for image=beginimg:endimg
    disp(strcat('Processing image',{' '},num2str(image-beginimg),{' '},...
        'out of',{' '},num2str(nframes)));  %Indicate progess in console
    %Open image
    n = num2str(list(image),fileformatstr); %Generate image string
    file = (['1_',n,'.tif']);           %First image
    Im = mat2gray(imread(file));            %Grayscale version of image
    Im = imadjust(Im,contradj);
    [Im,~] = wiener2(Im);                   %Apply Wiener filter for Gaussian noise removal
    F = griddedInterpolant(xnd,ynd,Im,'linear');  %Interpolation grid
    
    %Update standard gaussian background model
    calc_bg
        
    for lr=1:2 %left/right flagellum
        minimization_PCA
        post_processing 
    end
    
    %=======PLOT RESULT=======================================================%
    if plotshapes  %Plot results
        figure(4),clf
        imshow(Im,'InitialMagnification',screenmagnif), hold on
        plot(xbase,ybase,'b+') %Flagellar base
        plot(squeeze(xflag(image-beginimg+1,1,2:end)),squeeze(yflag(image-beginimg+1,1,2:end)),'r*','markersize',3) %Left flagellum
        plot(squeeze(xflag(image-beginimg+1,2,2:end)),squeeze(yflag(image-beginimg+1,2,2:end)),'g*','markersize',3) %Right flagellum
        title(strcat('Image ',num2str(image))), hold off; pause(eps)
    end
    if debugfmc == 0
        clc
    end
end
cputime=toc;
fprintf('Elapsed time: %4.1f s',cputime)
fprintf('Time per frame: %4.1f ms',cputime/nframes*1000)
%% ========================OVERALL POSTPROCESSING=========================%
%=======SAVE SHAPES=======================================================%
phase_stats
velocity

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MAKE MOVIE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Make a movie of the detected shapes, if desired
movieflagellum

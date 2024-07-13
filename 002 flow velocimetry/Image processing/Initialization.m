%% Add relevant folders, used in Image processing package for flow velocimetry
switch user
    case 'Daniel'
    case 'Da'
        cd('D:\004 FLOW VELOCIMETRY DATA\')
        run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')
        % will add all the pathes needed
    case 'other'
        %Please fill in the relevant folders here
end%Image location and image numbers to process

fold         = (num2str(pt,'%02d'));  % Folder name   
screenmagnif = 100;
cd(strcat(supfld,fold));              % Change current folder


%% %%%%%%%%%%%%%%%%%%%%%%%%%%SEARCH OPTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
ds0    = lf/nsteps;                     %Scan step [px] 
dtheta = 2*ds0/rho_min;                 %Half the search angle [rad]
theta0 = linspace(-dtheta,dtheta,round(2*dtheta/thetastep));  %Scan angles, one step per degree

%Optimization options
optsfmc = optimoptions(@fmincon,'Display','none','TolX',10^(-4)); %Options for fmincon

%Determine contrast adjustment
ntf = 30; %Number of training frames
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
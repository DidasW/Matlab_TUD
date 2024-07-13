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
    nmodes = min(size(Bdata,2),ncurvnodes-2);   %Number of PCA modes to take into account
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
    cmap = colormap(jet(samples+1)); 
    [philimit,xlimit,ylimit] = deal(zeros(samples,nsteps+1));
    for k=1:samples
        Ytot = curv2xy_quick(curvlimit(k,2:end),ssc,curvlimit(k,1),0,0); %Also vary base angle of shapes
        philimit(k,:) = Ytot(:,1)';     %Tangent angle of limit cycle shape
        xlimit(k,:) = Ytot(:,2)';       %x-coordinate angle of limit cycle shape
        ylimit(k,:) = Ytot(:,3)';       %y-coordinate of limit cycle shape
    end
end

%Optimization options
LB = -10*max(abs(Blimit),[],1);     %Lower bound (shape scores limited to 10 times limit cycle max)
LB = LB(1:nmodes);
UB = -LB;                           %Upper bound

%Declare variables
% Bshape = zeros(totalframes,2,nmodes);  %Shape scores of detected shapes
% [phase,phishape] = deal(zeros(totalframes,2));   %Total and reduced (0-2*pi) phase angle of detected shapes
% [xflag,yflag] = deal(zeros(totalframes,2,nsteps+1));    %x/y coordinates of flagellum
% kappasave = zeros(totalframes,2,nsteps+2);
%% %%%%%%%%%%%%%%%%%%BACKGROUND ESTIMATION INITIALIZATION%%%%%%%%%%%%%%%%%%
%Gaussian background detection keeps track of a Gaussian distribution of
%pixel intensity for each pixel. Distributions are updated each new frame.
%Pixel intensities that fall outside {mean-k*standard dev,mean+k*standard
%dev} are flagged as foreground, rest is background.

n=num2str(list(1),fileformatstr); 
file=(['1_',n,'.tif']); Im=imread(file);
SB=zeros(size(Im,1),size(Im,2),ntf);    %Sliding background matrix

%Initialize Gaussian background model
for ll=1:ntf;
    n=num2str(list(ll),fileformatstr); 
    file=(['1_',n,'.tif']);
    Im=imread(file);
    Im= mat2gray((Im));
    Im = imadjust(Im,contradj);
    [Im,~] = wiener2(Im);               %Apply Wiener filter to remove Gaussian noise (noise level from other analysis)
    SB(:,:,ll)=Im;
end
meanSB = mean(SB,3);                    %Mean of the same pixel of each image
varSB = var(SB,0,3);                    %Variance of the same pixel of each image
rho = 0.01;                             %Learning rate of background detection
d = zeros(size(Im));                    %Distance from mean for each pixel
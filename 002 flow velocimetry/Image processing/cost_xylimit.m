function Dmin=cost_xylimit(B,xy,scale,lf0,xlim,ylim,nmodes,princpts,ssc,FGinterp,xperim,yperim,debugfmc)
%% FUNCTION miminize_legendre_xylimit
% Calculates the cost of limit cycle shapes
%% INPUTS
%B          Shape scores of limit cycle shape
%xy         xy version of limit cycle shape
%xflag      x of detected points
%yflag      y of detected points
%index      Last correctly detected point
%nmodes     Number of PCA modes
%princpts   Principal components (shape modes)
%ssc    	Grid
%FGinterp   Griddedinterpolant of image
%xperim     x coordinates of cell body rim
%yperim     y coordinates of cell body rim
%debugfmc   Debug variable
%% OUTPUTS
%Dmin   Value of cost function

%% COST FACTORS
%Calculate curvature profile: left/right minus sign is irrelevant since
%this is only used for calculating the magnitude of the overall curvature
curv = princpts(1,2:end)' + princpts(2:nmodes+1,2:end)'*B;
curv = curv.*scale.*lf0;

% Compute bending cost
Eb   = (ssc(2)-ssc(1))/lf0/scale*sum(curv(1:end-1).^2+(curv(2:end).^2-curv(1:end-1).^2)); 
%Equivalent to Eb=trapz(ssc,curv.^2), but much faster

%Image cost
ind = find(xy(1,:) > 0 & xy(1,:) < xlim & xy(2,:) > 0 & xy(2,:) < ylim);
intens = FGinterp(xy(2,ind),xy(1,ind));    %Intensity at [x,y]
Eim = sum(intens)/length(ind);      %Measure of fit to foreground image 

%% CONSTRAINTS
% %Compute whether shape is inside cell body
indmax = ceil(0.5*size(xy,2));
isinbody = 1000*sum(inpolygon(xy(1,indmax:end),xy(2,indmax:end),xperim,yperim));

Ceq = isinbody;

%% ALL TOGETHER

%Total cost
wgt = [1 0 1000];
Dmin = sum(wgt.*[Eim Eb Ceq]);

if debugfmc ~= 0
    formatSpec = 'Eim %3.10f, Eb %3.10f, Ceq %3.10f, Dmin %3.10f \n';
    fprintf(formatSpec,Eim*wgt(1),Eb*wgt(2),Ceq.*wgt(3),Dmin);
end
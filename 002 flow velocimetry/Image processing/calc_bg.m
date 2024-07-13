%=========================================================================%
%-------------------------------CALC_BG-----------------------------------% 
%=========================================================================%
% Calculates a foreground picture according to Gaussian background
% modelling. An interpolated version is calculated for cost calculation.

Ifg = abs(Im-meanSB)./sqrt(varSB);      %Relative deviation from the mean
k=1.5;
indbg = find(abs(Ifg)<k);               %Background pixels

%(Selectively) update background model 
d               = abs(Im-meanSB);                               %Distance from mean for each pixel
meanSB(indbg)   = rho.*Im(indbg) + (1-rho).*meanSB(indbg);      %New mean
varSB           = d.^2.*rho + (1-rho)*varSB;                    %New variance

%Construct foreground picture
d = d.*10; d(d>1) = 1;
fg = medfilt2(imcomplement(d));

FGinterp = griddedInterpolant(xnd,ynd,fg,'linear');


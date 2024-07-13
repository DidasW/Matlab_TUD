%----------------------------------------------------------------------
% PHASES - (calculate cell phase from PCA analysis)
%----------------------------------------------------------------------
unwrph = unwrap(phigen(:,1)); %unwrapped phase
if unwrph(end) > unwrph(1) %Phase increases
    phiPCA{dd,1} = unwrap(phigen(:,1));
    phiPCA{dd,2} = unwrap(phigen(:,2));
else
    %Phase decreases
    %Minus sign insures that phase increases in time rather than decreases
    phiPCA{dd,1} = -unwrap(phigen(:,1));
    phiPCA{dd,2} = -unwrap(phigen(:,2));
end
clear unwrph

%Shift cell phase to ensure phase=0 corresponds to maximum forward position
%of flagella
% phicell{dd,1}   = unwrap(phiPCA{dd,1})-cellshift;
% phicell{dd,2}   = unwrap(phiPCA{dd,2})-cellshift;
phicell{dd,1}   = phFwrap;
phicell{dd,2}   = phFwrap;
for lr = 1:2
    %Interpolant of cell phase
    GIPphic{dd,lr} = griddedInterpolant(dataind{dd},unwrap(phicell{dd,lr}),'linear'); 
    omegacell{dd,lr} = sg5der(unwrap(phicell{dd,lr}),dtime); %Phase speed [rad/s]
    %Interpolant of phase speed
    GIPomegac{dd,lr} = griddedInterpolant(dataind{dd},omegacell{dd,lr},'linear');
end
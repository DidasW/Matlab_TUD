%----------------------------------------------------------------------
% PHASES - (calculate cell phase from PCA analysis)
%----------------------------------------------------------------------
%Minus sign insures that phase increases in time rather than decreases
phiPCA{dd,1} = -unwrap(phigen(:,1));
phiPCA{dd,2} = -unwrap(phigen(:,2));

%Shift cell phase to ensure phase=0 corresponds to maximum forward position
%of flagella
phicell{dd,1}   = unwrap(phiPCA{dd,1})-cellshift;
phicell{dd,2}   = unwrap(phiPCA{dd,2})-cellshift;
for lr = 1:2
    %Interpolant of cell phase
    GIPphic{dd,lr} = griddedInterpolant(dataind{dd},unwrap(phicell{dd,lr}),'linear'); 
    omegacell{dd,lr} = sg5der(unwrap(phicell{dd,lr}),dtime); %Phase speed [rad/s]
    %Interpolant of phase speed
    GIPomegac{dd,lr} = griddedInterpolant(dataind{dd},omegacell{dd,lr},'linear');
end
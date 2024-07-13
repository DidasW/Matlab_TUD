[PvRMS,PeRMS,PtRMS,PvRMSdl,PeRMSdl,PtRMSdl] = deal(zeros(datasets,1));
for dd=1:datasets
    PvRMS(dd)   = avgbeat{dd,3}.PvRMS;
    PeRMS(dd)   = avgbeat{dd,3}.PeRMS;
    PtRMS(dd)   = avgbeat{dd,3}.PtRMS;
    PvRMSdl(dd) = avgbeat{dd,3}.PvRMSdl;
    PeRMSdl(dd) = avgbeat{dd,3}.PeRMSdl;
    PtRMSdl(dd) = avgbeat{dd,3}.PtRMSdl;
end
%Calculate phase speed relative to no flow case
[beta,GIPmeanomegac] = deal(cell(datasets,1));
BC426.GIPphiomega = griddedInterpolant(BC426.meanphic,BC426.meanomegac);
for dd=1:datasets
    GIPmeanomegac{dd} = griddedInterpolant(avgbeat{dd,3}.meanphic,...
        avgbeat{dd,3}.meanomegac);
    beta{dd} = GIPmeanomegac{dd}(phi0)./BC426.GIPphiomega(phi0);
end

%Calculate value of synchronization parameter
fC_fF = 2.076;
omegaC_omegaF = 2*pi*fC_fF;
epsilonguess = omegaC_omegaF./sin(WrapToPi(meanphasediff_act));

epsilon = mean(epsilonguess);
phasediff_guess = asin(omegaC_omegaF/epsilon);

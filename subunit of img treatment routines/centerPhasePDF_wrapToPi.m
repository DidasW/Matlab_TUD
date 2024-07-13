%% Doc
% Center the Probability Distribution Function (PDF) of phase-locking/
% attraction between two osicllators around 0


%%
function [PhasePDF_shifted] = centerPhasePDF_wrapToPi(PhasePDF,BinEdges_pi)
    [~,idx_max]    = max(PhasePDF);
    [~,idx_phase0] = min(abs(BinEdges_pi)); % closest element around 0 
    PhasePDF_shifted = circshift(PhasePDF,idx_phase0-idx_max);
end
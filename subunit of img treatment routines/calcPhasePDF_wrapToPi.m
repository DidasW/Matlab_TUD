%% Doc
% Calculate the probability distribution of phase difference between 
% two oscillators in bins between [-pi, pi]


%%
function [PhasePDF,BinCenters] = calcPhasePDF_wrapToPi(...
                                 phase1,phase2,N_bins)
    d_Ph = phase1 - phase2;
    BinEdges    = linspace(-pi,pi,N_bins+1);
    BinCenters  = (BinEdges(1:end-1) + BinEdges(2:end))/2;
    d_Ph_wrapped = wrapToPi(d_Ph);
    [PhasePDF,~] = histcounts(d_Ph_wrapped,BinEdges,...
                   'Normalization', 'probability');
end
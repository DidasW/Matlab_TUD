%% Doc
%{
Compute the crosscorrelation of two signal by defined time window
%}
%% Function
function [corr_sig] = signalCrossCorrByTimeIntervals(sig1, sig2, Fs, tWin)

    segSize  = tWin*Fs;        
    segSize  = round(segSize/2)*2; % even number
    N_sig    = length(sig1);
    NoSeg    = floor(N_sig/segSize)-1;
    
    corr_sig = zeros(NoSeg, 1);
    t = make_time_series(corr_sig, 1/tWin, 's') + tWin;
    for i_seg = 1:NoSeg
        idx = segSize/2 +[(i_seg-1)*segSize+1  : i_seg*segSize];
        sample_up = sig1(idx);
        sample_down = sig2(idx);
        corr_sig(i_seg) = corr(sample_up, sample_down);
    end

end

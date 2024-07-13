% This function scan the input signal, whose sampling frequency is Fs_Hz,  
% sequentially with a window whose span is t_window_s (sec). The window
% with phase slips in it will be discarded, and the rest will be stiched
% together. Meanwhile, each scanned window will be subtracted by its mean,
% so that there will be no jumps.
% 

function [phase_after,varargout] = getRidOfPhaseSlip(phase_before,Fs_Hz,t_window_s)
    winSize = ceil(t_window_s*Fs_Hz);
    NoWindow = floor(numel(phase_before)/winSize);
    
    %% standardize to row vector
    if size(phase_before,1) ~= 1 
        phase_before = phase_before';
    end
    
    %% scaning with the window
    idx_after   = [];
    phase_after = [];
    for i_seg = 1:NoWindow
        idx = [     (i_seg-1)*NoWindow+1  : ...
                min([i_seg   *NoWindow, numel(phase_before)])];
        sample = phase_before(idx);
        sample_smth = smooth(sample,ceil(0.01*Fs_Hz)); % 10 ms MWA
        if max(sample_smth)-min(sample_smth) < 0.7
            sample      = sample - mean(sample);
            phase_after = [phase_after,sample];
            idx_after   = [idx_after,idx];
        end
    end
    
    if nargout == 2
        varargout{1} = idx_after;
    end
end
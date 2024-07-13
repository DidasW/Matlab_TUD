%% Doc
% this function recognizes a spike in signal based on comparing the raw
% signal and the one treated with median filter. Unless the difference
% exceeds the given threshold value, the signal will be kept raw, otherwise
% it will be replaced with the filted value at that point.
%%
function sig_no_spike = get_rid_of_spike(signal,threshold)
    if nargin<2
        threshold = 50;
    end
    
    sig_no_spike= signal*0;
    sig_medfilt = medfilt1(signal,5);
    residue     = abs(signal - sig_medfilt);
    spike_idx   = find(residue>threshold);
    for i = 1:length(signal)
        if ismember(i,spike_idx)
            sig_no_spike(i) = sig_medfilt(i);
        else
            sig_no_spike(i) = signal(i);
        end 
    end
end
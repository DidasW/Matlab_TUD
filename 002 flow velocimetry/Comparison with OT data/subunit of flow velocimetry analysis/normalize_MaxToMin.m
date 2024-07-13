function signal_norm = normalize_MaxToMin(signal,varargin)
    gamma = 1;
    temp = strcmp(varargin,'Gamma');
    if ~isempty(varargin)
        if any(temp)
            gamma = varargin{find(temp)+1};
        end
    end

    sz1 = size(signal,1);
    sz2 = size(signal,2);
    
    if sz1 == 1 || sz2 == 1 
        signal_norm = (signal-min(signal))/(max(signal)-min(signal));
    else
        max_sig     = max(signal(:));
        min_sig     = min(signal(:));
        signal_norm = (signal - min_sig) ./ (max_sig-min_sig);
    end
    
    signal_norm = signal_norm.^gamma;
end
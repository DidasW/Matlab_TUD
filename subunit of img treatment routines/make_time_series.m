%% To generate a time series according to an input array and given sampling frequency

function t = make_time_series(signal,Fs,unit)
    % Fs should be in unit of Hz.
    N = length(signal);
    switch unit
        case 's'
            t = (0:(N-1))/Fs;  
        case 'ms'
            t = (0:(N-1))/Fs*1000.0;  
        otherwise
            t = (0:(N-1))/Fs*1000.0;  
    end   
end
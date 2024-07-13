%% Doc
% The signal input should contain two flashes, each of 10.326 ms
% Input:
% signal: any signal (1D array) that contains two flashes
% Fs    : the sampling frequency at which the signal is taken
%         No interpolation will be done to the input signal
% Output:
% signal_cut: signal cut from the END of the first flash to the START of
%             the second flash. Notice that such arrangement is not the
%             most natural however it will be compatible with previous
%             treatments.
% indices   : six indices, start/center/end of flash1/flash2.

function [signal_cut,...
          idx_F1_start,idx_F1_cent,idx_F1_end,...
          idx_F2_start,idx_F2_cent,idx_F2_end] = ...
         determine2flashes_PSD(signal,Fs,method) 

switch method
    case 'convolution'
        meth = 0;
    case 'differential'
        meth = 1;
end
     
N           = length(signal);
t           = (0:(N-1))/Fs*1000;                       
F_dura      = 10.326;                       % Calibrated 2017-05-10, std 0.029    
F_winspan   = 2*round((F_dura*Fs/1000)/2);  % must be even number                                           
                                            % F_: Flash; winspan: window span
search_F    = zeros(N,1);


%% create a sweeping window of exactly the size of a flash span
% essenstially it is doing convolution

if meth == 0
    MinProminence   = 0.8;
    for i_search    = (1+F_winspan/2):(N-F_winspan/2)
        search_F(i_search) = sum(signal((i_search-F_winspan/2):(i_search+F_winspan/2-1)));
    end
    
    % Determine whether it's a peak or a valley
    sig_med         = median(search_F);
    sig_max         = max(search_F);
    sig_min         = min(search_F);
    dist_min2med    = abs(sig_min-sig_med);
    dist_max2med    = abs(sig_max-sig_med);
    if dist_min2med > dist_max2med % type: valley
        search_F    = -search_F;
        search_F    = (search_F - min(search_F)) / (max(search_F)-min(search_F));
    else                           % type: peak
        search_F    = (search_F - min(search_F)) / (max(search_F)-min(search_F));
    end
    
    % Now search_F must have a PEAK at the flash
    % make sure that there are two and only two flashes
    
    [~,locs_cents]= findpeaks(search_F,'MinPeakProminence',MinProminence,...
                              'MinPeakDistance',0.1*Fs); % flash must be 0.1s away 
    
    while (length(locs_cents) ~= 2)
        if length(locs_cents)<2
            MinProminence = MinProminence - 0.01;
        elseif length(locs_cents)>2
            MinProminence = MinProminence + 0.01;
        end
        [~,locs_cents]= findpeaks(search_F,'MinPeakProminence',MinProminence,...
                                  'MinPeakDistance',0.1*Fs); 
    end
    
    idx_F1_start = locs_cents(1)-F_winspan/2;
    idx_F1_end   = locs_cents(1)+F_winspan/2;
    idx_F1_cent  = locs_cents(1); 
    idx_F2_start = locs_cents(2)-F_winspan/2;
    idx_F2_end   = locs_cents(2)+F_winspan/2;
    idx_F2_cent  = locs_cents(2);      

    t_F1_rising = t(idx_F1_start);
    t_F2_rising = t(idx_F2_start);
    t_F1_falling= t(idx_F1_end);
    t_F2_falling= t(idx_F2_end);
    sprintf(['1st flash: %.2f ms to %.2f ms, span %.2f ms\n',...
             '2nd flash: %.2f ms to %.2f ms, span %.2f ms\n'],...
            t_F1_rising,t_F1_falling,t_F1_falling-t_F1_rising,...
            t_F2_rising,t_F2_falling,t_F2_falling-t_F2_rising)
 end


if meth == 1
    MinProminence = 0.4; 
    search_F(2:end)   = diff(signal);            % maintain the same length
    search_F          = (search_F - min(search_F)) / (max(search_F)-min(search_F));

    % find the rising and falling edges of the flashes.
    [~,locs_pks]   = findpeaks(search_F,'MinPeakProminence',MinProminence,...
                               'MinPeakDistance',0.1*Fs);
    [~,locs_vals] = findpeaks(-search_F,'MinPeakProminence',MinProminence,...
                               'MinPeakDistance',0.1*Fs);
                          
    % make sure that there are only two flashes
    while (length(locs_pks) ~= 2)
        if length(locs_pks)<2
            MinProminence = MinProminence - 0.01;
        elseif length(locs_pks)>2
            MinProminence = MinProminence + 0.01;
        end
        [~,locs_pks]= findpeaks(search_F,'MinPeakProminence',MinProminence,...
                                'MinPeakDistance',0.1*Fs); 
    end
    
    while (length(locs_vals) ~= 2)
        if length(locs_vals)<2
            MinProminence = MinProminence - 0.01;
        elseif length(locs_vals)>2
            MinProminence = MinProminence + 0.01;
        end
        [~,locs_vals]= findpeaks(-search_F,'MinPeakProminence',MinProminence,...
                                'MinPeakDistance',0.1*Fs); 
    end
    
    idx_F1_start = min(locs_pks(1),locs_vals(1));
    idx_F1_end   = max(locs_pks(1),locs_vals(1));
    idx_F1_cent  = idx_F1_start + F_winspan/2;  
    idx_F2_start = min(locs_pks(2),locs_vals(2));
    idx_F2_end   = max(locs_pks(2),locs_vals(2));
    idx_F2_cent  = idx_F2_start + F_winspan/2;   
    
    t_F1_rising = t(idx_F1_start);
    t_F2_rising = t(idx_F2_start);
    t_F1_falling= t(idx_F1_end);
    t_F2_falling= t(idx_F2_end);
    sprintf(['1st flash: %.2f ms to %.2f ms, span %.2f ms\n',...
             '2nd flash: %.2f ms to %.2f ms, span %.2f ms\n'],...
            t_F1_rising,t_F1_falling,t_F1_falling-t_F1_rising,...
            t_F2_rising,t_F2_falling,t_F2_falling-t_F2_rising)


end

signal_cut   = signal(idx_F1_end:idx_F2_start);   

end
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
function [signal_cut,idx_F1_start,...
          idx_F1_cent,idx_F1_end] = determine1flash_PSD(signal,Fs,method) 

switch method
    case 'convolution'
        meth = 0;
    case 'differential'
        meth = 1;
end
     
N           = length(signal);
t           = (0:(N-1))/Fs*1000;                       
F_dura      = 10.326;                             % Calibrated 2017-05-10, std 0.029    
F_winspan   = 2*round((F_dura*Fs/1000)/2);        % must be even number                                           
                                                  % F_: Flash; winspan: window span
search_F    = zeros(N,1);

%% create a sweeping window of exactly the size of a flash span
% essenstially it is doing convolution
if meth == 0
    MinProminence   = 0.8;
    for i_search    = (1+F_winspan/2):(N-F_winspan/2)
        search_F(i_search) = sum(signal((i_search-F_winspan/2):(i_search+F_winspan/2-1)));
    end
        
    % Determine whether it's a peak or a valley and normalization
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
   
    %%%%Suppose the flash induces peak%%%%
    [~,locs_cent]= findpeaks(search_F,'MinPeakProminence',MinProminence,...
                             'MinPeakDistance',0.1*Fs);  
    N_Loop = 0 ;
    while (length(locs_cent) ~= 1&&N_Loop<100)
        if length(locs_cent)<1
            MinProminence = MinProminence - 0.01;
        elseif length(locs_cent)>1
            MinProminence = MinProminence + 0.01;
        end
        [~,locs_cent]= findpeaks(search_F,'MinPeakProminence',MinProminence,...
                                 'MinPeakDistance',0.1*Fs); 
        N_Loop = N_Loop + 1 ;
    end
    
    if isempty(locs_cent)
        locs_cent = 1;
        disp('failed to find flash')
    end
    idx_F1_start = locs_cent(1)-F_winspan/2;
    idx_F1_end   = locs_cent(1)+F_winspan/2;
    idx_F1_cent  = locs_cent(1);     
    t_F1_rising = t(idx_F1_start);
    t_F1_falling= t(idx_F1_end);
    fprintf('1st flash: %.2f ms to %.2f ms, span %.2f ms\n',...
            t_F1_rising,t_F1_falling,t_F1_falling-t_F1_rising);
end


if meth == 1
    MinProminence   = 0.8;
    search_F(2:end) = diff(signal);              % maintain the same length
    search_F        = (search_F - min(search_F)) / (max(search_F)-min(search_F));

    % find the 1 and only 1 rising edge.
    [~,locs_pks]   = findpeaks(search_F,'MinPeakProminence',MinProminence,...
                               'MinPeakDistance',0.1*Fs); 
    N_Loop = 0 ;
    while (length(locs_pks) ~= 1&&N_Loop<100)
        if length(locs_pks)<1
            MinProminence = MinProminence - 0.01;
        elseif length(locs_pks)>1
            MinProminence = MinProminence + 0.01;
        end
        [~,locs_pks]= findpeaks(search_F,'MinPeakProminence',MinProminence,...
                                'MinPeakDistance',0.1*Fs); 
        N_Loop = N_Loop + 1; 
    end
    if isempty(locs_pks)
        disp('failed to find rising edge')
    end

    % find the 1 and only 1 falling edge.
    [~,locs_vals] = findpeaks(-search_F,'MinPeakProminence',MinProminence,...
                             'MinPeakDistance',0.1*Fs);
    N_Loop = 0 ;
    while (length(locs_vals) ~= 1&&N_Loop<100)
        if length(locs_vals)<1
            MinProminence = MinProminence - 0.01;
        elseif length(locs_vals)>1
            MinProminence = MinProminence + 0.01;
        end
        [~,locs_vals]= findpeaks(-search_F,'MinPeakProminence',MinProminence,...
                                'MinPeakDistance',0.1*Fs); 
        N_Loop = N_Loop + 1; 
    end
    if isempty(locs_vals)
        disp('failed to find falling edge')
    end


            
    if ~isempty(locs_pks) && ~isempty(locs_vals)
        idx_F1_start = min(locs_pks(1),locs_vals(1));
        idx_F1_end   = max(locs_pks(1),locs_vals(1));
        idx_F1_cent  = idx_F1_start + F_winspan/2;  
        t_F1_rising = t(idx_F1_start);
        t_F1_falling= t(idx_F1_end);
        fprintf('1st flash: %.2f ms to %.2f ms, span %.2f ms\n',...
            t_F1_rising,t_F1_falling,t_F1_falling-t_F1_rising);
        signal_cut   = signal(idx_F1_end:end);   
    else
        idx_F1_start = NaN;
        idx_F1_end   = NaN;
        idx_F1_cent  = NaN;
        disp('failed to recognize the whole flash')
        signal_cut   = [];   
    end  
end



end
function t_shift = get_time_shift_by_correlation(sig0,sig1,t_sig1,Fs,t_ref)
    % Fs:     sampling frequency of signal 0, unit: Hz
    % sig0:   reference signal
    % sig1:   matching signal
    % t_sig1: time span, unit: ms
    % t_ref:  the reference time point in sig0,e.g. the start time of image
    %         sequence.
    
    t_sig1_interp = min(t_sig1): 1/Fs*1000  :max(t_sig1);
    sig1_interp   = interp1(t_sig1,sig1,t_sig1_interp);
    [C,lag]       = xcorr(sig0,sig1_interp);        
    [~,locs]      = findpeaks(C,lag/Fs*1000);
    locs((locs-t_ref)<-1.0) = [];
    t_shift       = locs(1)-t_ref;

    figure()
    plot  (lag/Fs*1000,C,'o','markersize',4);
    hold   on
    plot  ([t_ref,t_ref],[-3*max(C),3*max(C)],'--','linewidth',2); 
    xlim  ([-15,15]);
    ylim  ([-2*max(C),2*max(C)])
    xlabel('lag (ms)')
    ylabel('correlation')
%     NOTE: If t_shift > 0, then SIG1 will need to be shift toward
%           the right side (t+) to match SIG0
end

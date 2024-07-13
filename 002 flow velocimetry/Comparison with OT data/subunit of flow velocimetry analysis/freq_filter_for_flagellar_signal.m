%% Doc
% This function is a tailered band pass filter for exposing the desired
% fraction of flow probe signal. Low-pass frequency is designed to keep the
% highest harmonic intact and high-pass frequency the fundamental peak.
% If no peak was detected, a BPF of [30,60]Hz of order 6, will be applied 
% 
% signal:   the one to apply filter to
% Fs    :   sampling frequency of signal, Hz
% 
% number of outputs may vary. Following the order of:
%           signal_filt, pks, locs, w, p, pow, f
% signal_filt   : signal been handled. Mandatory, others all optional
% pks,locs,w,p  : peak heights, peak locations and widths (in Hz), peak
%                 prominence. Same as in findpeaks() function
% pow, f        : Positive branch of the Fourier Spectrum of signal. pow is
%                 the power spectrum unsmoothed.


%%
function [signal_filt, varargout]= freq_filter_for_flagellar_signal(signal,Fs)
    NoArgOutExtra = nargout - 1;
   
    %% Parameter settings
    % f_ stands for 'frequency (of)'
    f_smooth_range = 12; % Hz
    t_total        = length(signal)/Fs;
    f_resolution   = 1/t_total;
    NoP_smooth     = round(f_smooth_range/f_resolution);
    % Num. of points to smooth the Fourier spec
    ROI_freq   = [25,200];    % Hz, ROI: range of interest
    ROI_low    = ROI_freq(1);     
    ROI_high   = ROI_freq(2);         
    min_f_flag    = 20;       % minimum possible flagellar swimming freq.
    max_f_flag    = 75;
    
    strong_sig_p      = 0.8;
    max_pkwidth_strong= 20;   % Hz strong signal contains harmonics
    max_pkwidth_weak  = 5 ;   % Hz weak signal is just a fundamental peak
    
    min_p_factor  = 0.07;     % Fine search for harmonics . Min. prominence 
                              % for a peak to be recognized, in unit of the
                              % fundamental peak prominence 
    min_p2pks     = 0.6;     % prominence of the peak / peak heigh, it
                              % resembles the conspicuousness of the peak
    min_p         = 0.20;     % The smallest prominence to qualify peak
    
    % Default BPF, H/LP for High/Low Pass, 0 for default
    HPf0   = 45; 
    LPf0   = 65;
    order0 = 3;
    [bbp0,abp0] = butter(order0,[HPf0,LPf0]/Fs*2,'bandpass');
    
    %% Fourier transformation
    [f,pow]    =  fft_mag(signal,Fs);
    pow_smooth =  smooth(pow,NoP_smooth);
    
    %% Find the fundamental peak
    %% coarse search
    % if the fundamental peak is not conspicuous, use default BPF instead
    % of further auto-recognition
    [pks,locs,w,p] = findpeaks(pow_smooth,f,'MinPeakDistance',min_f_flag);
    idx_rough      = cat(2,find(locs<ROI_low),find(locs>ROI_high));
    idx      = idx_rough;          % an intermediate to save space
    pks(idx) = [];  w(idx)    = []; 
    p(idx)   = [];  locs(idx) = [];
    
    [~,arg_Hpk] = max(pks);        % Hpk stands for highest peak
    
    %% select
    % C for criterion
    % fundamental peak should be in [min_freq,max_freq] ~ [20Hz,75Hz]
    C1 = (locs(arg_Hpk)<min_f_flag || locs(arg_Hpk)>max_f_flag);       
 
    % fundamental peak should have an absolute prominence of min_fund_p
    C2 = (p(arg_Hpk)<min_p);
   
    % fundamental peak shoule be conspicuous that p2pk > min_p2pk
    C3 = (p(arg_Hpk)/pks(arg_Hpk)<min_p2pks);
    
    if C1 || C2 || C3
        pks = [];  w    = [];      % if fund_peak is out of possible range
        p   = [];  locs = [];
    end
    
    %% Find harmonics
    if ~isempty(locs)
%         fund_pk = pks(arg_Hpk);
%         fund_f  = locs(arg_Hpk);
%         fund_w  = w(arg_Hpk); 
        fund_p  = p(arg_Hpk);
%         fund_p2pk = fund_p/fund_pk ; 
        % Automatically recognize peaks
        
        if fund_p > strong_sig_p
        [pks,locs,w,p] = findpeaks(pow_smooth,f,...
                        'MinPeakDistance',  min_f_flag,...
                        'MinPeakProminence',min_p,...
                        'MaxPeakWidth',     max_pkwidth_strong);
        else
        [pks,locs,w,p] = findpeaks(pow_smooth,f,...
                        'MinPeakDistance',  min_f_flag,...
                        'MinPeakProminence',min_p,...
                        'MaxPeakWidth',     max_pkwidth_weak);
        end
        % should be in the range of interest
        idx_fine = cat(2,find(locs<ROI_low),find(locs>ROI_high));
        idx      = idx_fine;             
        pks(idx) = [];  w(idx)    = []; 
        p(idx)   = [];  locs(idx) = [];
        % should qualify minimun p2pk ratio
        idx = find(p./pks<min_p2pks);
        pks(idx) = []; w(idx)   = [];
        p(idx)   = []; locs(idx)= [];
        
        % Apply filter
        NoPeak   = length(pks);
        switch NoPeak
            case 0 % no peak
                signal_filt = filtfilt(bbp0,abp0,signal);
            otherwise
                HPf    = locs(1)  -2*w(1); 
                LPf    = locs(end)+3*w(end);
                order = 2;
                [bbp,abp] = butter(order,[HPf,LPf]/Fs*2,'bandpass');
                signal_filt = filtfilt(bbp,abp,signal);
        end
    else % no peak even exist when the search is crude.
        signal_filt = filtfilt(bbp0,abp0,signal);
    end
        
    
    
    switch NoArgOutExtra
        case 1 ; varargout{1} = pks;
        case 2 ; varargout{1} = pks; varargout{2} = locs;
        case 3 ; varargout{1} = pks; varargout{2} = locs;
                 varargout{3} = w;
        case 4 ; varargout{1} = pks; varargout{2} = locs;
                 varargout{3} = w;   varargout{4} = p;
        case 5 ; varargout{1} = pks; varargout{2} = locs;
                 varargout{3} = w;   varargout{4} = p;
                 varargout{5} = pow;
        case 6 ; varargout{1} = pks; varargout{2} = locs;
                 varargout{3} = w;   varargout{4} = p;
                 varargout{5} = pow; varargout{6} = f;
    end
    %% Nested function
    function [freq_sequence,magitude]=fft_mag(signal,fs)
    %fs is sampling frequency
    %signal is a 1D array
        L=length(signal);
        nfft = 2^nextpow2(2*L); % Next power of 2 from length of 2*y 
        %2*L is used for the zeropadding
        Y = fft(signal,nfft)/L;
        magitude=2*abs(Y(1:nfft/2+1)); % Magnitude of FFT
        % take only the positive frequency
        freq_sequence = fs/2*linspace(0,1,nfft/2+1);
    end

end
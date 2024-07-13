%% Doc
% Originally named as "freq_filter_for flagellar_signal.m"
% This function is a tailered band pass filter for exposing the desired
% fraction of flow probe signal. Low-pass frequency is designed to keep the
% highest harmonic intact and high-pass frequency the fundamental peak.
% If no peak was detected, a BPF of [30,60]Hz of order 6, will be applied 
% 
% signal:   the one to apply filter to
% Fs    :   sampling frequency of signal, Hz
% varargin: must be two variables to successfully set the default passband,
%           ...,HPF0,LPF0). Else the function uses 40-70 Hz as the passband

% number of outputs may vary. Following the order of:
%           signal_filt, pks, locs, w, p, pow, f
% signal_filt   : signal been handled. Mandatory, others all optional
% pks,locs,w,p  : peak heights, peak locations and widths (in Hz), peak
%                 prominence. Same as in findpeaks() function
% pow, f        : Positive branch of the Fourier Spectrum of signal. pow is
%                 the power spectrum unsmoothed.
% Update 2017-12-04
% Use log-signal isstead linear. Decrease the number of user defined filters.
% In this light, the signal input has to be real.
% Update 2017-12-14
% Two extra optional input were added so that the default passband can be
% defined externally.
% Update 2019-01-08
% Including DogTeeth: multiple stop bands that allow further reduction of
% the noise between the harmonics.






%%
function [signal_filt, varargout]= AutoBPF_FlagSig_v2(signal,Fs,varargin)
    NoArgOutExtra = nargout - 1;
    NoArgInExtra  = nargin  - 2;
    if NoArgInExtra == 2
        HPf0   = varargin{1}; 
        LPf0   = varargin{2};
        order0 = 2;
        [bbp0,abp0] = butter(order0,[HPf0,LPf0]/Fs*2,'bandpass');
    else
        % Default BPF, H/LP for High/Low Pass, 0 for default
        HPf0   = 40; 
        LPf0   = 70;
        order0 = 2;
        [bbp0,abp0] = butter(order0,[HPf0,LPf0]/Fs*2,'bandpass');
    end
    %% Parameter settings
    % f_ stands for 'frequency (of)'
    f_smooth_range = 13; % Hz
    t_total        = length(signal)/Fs;
    f_resolution   = 1/t_total;
    NoP_smooth     = round(f_smooth_range/f_resolution);
    % Num. of points to smooth the Fourier spec
    min_f_flag    = 35;       % minimum possible flagellar swimming freq.
    max_f_flag    = 90;
    ROI_low    = min_f_flag;  % ROI: [Hz] region of interest   
    ROI_high   = 220; % Include at maximum 4 harmonics        
    min_pkwith = 4.0; % For piezo generated flow, this value is much smaller
    min_log_p  = 0.62; % The smallest prominence to qualify peak
    init_log_p = 1.0;
    passbandsize_unitPeakWidth = 0.85;
    
    
    %% Fourier transformation
    [f,pow]      =  fft_mag(signal,Fs);
    pow_smooth   =  smooth(pow,NoP_smooth);
    idx_OutOfROI = find((f<ROI_low)|(f>ROI_high));
    
    f(idx_OutOfROI) = []; 
    pow_smooth(idx_OutOfROI) = [];

    
    %% Find the fundamental peak
    pow_search   = log(pow_smooth);
    min_p_temp   = init_log_p;
    [pks,locs,w,p] = findpeaks(pow_search,f,...
                     'MinPeakDistance',min_f_flag,...
                     'MinPeakProminence',min_p_temp,...
                     'MinPeakWidth',min_pkwith);
    while(length(locs)<1 && min_p_temp>0.02)
        min_p_temp = min_p_temp - 0.02;
        [pks,locs,w,p] = findpeaks(pow_search,f,'MinPeakDistance',min_f_flag,...
                         'MinPeakProminence',min_p_temp,'MinPeakWidth',min_pkwith);
    end
    
    if ~isempty(pks)
        fund_f  = locs(1);
        fund_p  = p(1);

        if fund_p<min_log_p || fund_f>max_f_flag
            pks = [];  w    = [];      % if fund_peak is too small
            p   = [];  locs = [];
        end
        NoPeak   = length(pks);
    else
        NoPeak = 0;
    end
    
    switch NoPeak
        case 0 % no peak found
            signal_filt = filtfilt(bbp0,abp0,signal);
        case 1 % only one peak found
            if 2*passbandsize_unitPeakWidth*w(1)>20 
                w(1) = 10/passbandsize_unitPeakWidth;
            end
            HPf    = locs(1)-passbandsize_unitPeakWidth*w(1); 
            LPf    = locs(1)+passbandsize_unitPeakWidth*w(end);
            HPf    = max([1,HPf]);
            LPf    = min([Fs/2-1,LPf]);
            order = 2;
            [bbp,abp] = butter(order,[HPf,LPf]/Fs*2,'bandpass');
            signal_filt = filtfilt(bbp,abp,signal);
        otherwise
            HPf    = locs(1)  -passbandsize_unitPeakWidth*w(1); 
            LPf    = locs(end)+passbandsize_unitPeakWidth*w(end);
            HPf    = max([1,HPf]);
            LPf    = min([Fs/2-1,LPf]);
            order = 2;
            [bbp,abp] = butter(order,[HPf,LPf]/Fs*2,'bandpass');
            signal_filt = filtfilt(bbp,abp,signal);
    end
        
    pks = exp(pks);
    
    switch NoArgOutExtra
        case 1 ; varargout{1} = pks;
        case 2 ; varargout{1} = pks; varargout{2} = locs;
        case 3 ; varargout{1} = pks; varargout{2} = locs;
                 varargout{3} = w;
        case 4 ; varargout{1} = pks; varargout{2} = locs;
                 varargout{3} = w;   varargout{4} = p;
        case 5 ; varargout{1} = pks; varargout{2} = locs;
                 varargout{3} = w;   varargout{4} = p;
                 varargout{5} = pow_smooth;
        case 6 ; varargout{1} = pks; varargout{2} = locs;
                 varargout{3} = w;   varargout{4} = p;
                 varargout{5} = pow_smooth; varargout{6} = f;
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
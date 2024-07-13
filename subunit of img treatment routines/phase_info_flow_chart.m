% Extract the frequency info from the interrogation window signal, use
% filtering, smoothing, hilbert transformation etc.

%% Note1 
% The principle is, anything that reflects the periodic motion of the 
% flagellum skimming over the mask, can work

%% Note2 
% Analytic signal which is used by others doesn't promise better results. Tested by Da.

function [flag,dif_flag,A_Ph,H_Ph,...
          H_Ph_filt,accu_Ph,flag_f] = phase_info_flow_chart(flag_raw,Fs)

    flag      = smooth(smooth(flag_raw,7),7);
    dif_flag  = diff(flag);                         % dif: diff()
    A_Ph      = get_instantaneous_phase(dif_flag);  % construct absolute phase by analytic signal.
    H1        = hilbert(dif_flag);                  % H: hilbert transform, use the phase of hilbert transform directly as the absolute phase
    H_Ph      = angle(H1);                          % Ph: Phase


    flag_filt       = BPF_for_flag(flag_raw,Fs);
    dif_flag_filt   = smooth(smooth(diff(flag_filt),7),7);
    H_Ph_filt       = angle(hilbert(dif_flag_filt));
    accu_Ph         = unwrap(H_Ph_filt,2); % accu: accumulated
    flag_f          = get_freq_from_phase(accu_Ph,Fs,200); % _f: freq.
    % 200 ms~10 beating periods, freq accuracy ~5 Hz,
    % below which instantaneous freq. doesn't make sense




end
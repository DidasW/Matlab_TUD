%% Band pass filtering the input signal. 
% 3dB pass band: 15Hz to 90Hz;
% 6dB pass band: 10Hz to 95Hz; 

function signal_out = BPF_for_flag(signal_in,Fs)
    d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,10,15,90,95,Fs);
    %3dB 15Hz to 90Hz
    %6dB 10Hz to 95Hz
    %out there -60dB
    d.Stopband1Constrained = true;
    d.Astop1 = 60; %-dB
    d.Stopband2Constrained = true;
    d.Astop2 = 60;
    Hd = design(d,'equiripple');
    signal_out = filter(Hd,signal_in);
end
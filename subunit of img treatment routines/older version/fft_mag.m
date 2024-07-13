%compute and plot frequency spectrum
%slightly revised by Da 20160407
%1. Change the names of variables to be self-explanatory
%2. Notes are added
function [freq_sequence,magitude]=fft_mag(signal,fs)
%fs is sampling frequency
%signal is a 1D array
    L=length(signal);
    nfft = 2^nextpow2(10*L); % Next power of 2 from length of y
    %10*L is used for the zeropadding
    Y = fft(signal,nfft)/L;
    magitude=2*abs(Y(1:nfft/2+1)); % Magnitude of FFT
    % take only the positive frequency
    freq_sequence = fs/2*linspace(0,1,nfft/2+1);
end



% Visualize the spectrogram.

%% About the function spectrogram(), note 1
% About window size and window overlap:
%           NoWin (Number of Windows) = NoI/(Size - Overlap).
% NoWin determines the time resolution of the obtained spectrogram
% The single window size determines the frequency resolution:
%           Freq_reso = Fs/Size-------(Size/Fs = total time)
    

%% About the function spectrogram(), note 2
% f_spectrogram: a vector of freq. from 0 to Fs/2, having the same size with 
% the first dimension of PSD_windows
% PSD_windows: matrix, size of 1st dimension  <No. of freq. bins>*<NoWin>,
%   e.g. PSD_windows(:,1) is the power spectrum distribution of the
%   first window.
% t_windows is a vector containing the central time for each window.
%   Its size is the No. of windows. Total length is NoI/Fs    


function [fig_spectrogram,...
          f_spectrogram_1,t_Win_1,PSD_Win_1,... % PSD: Power spectral density (PSD)
          f_spectrogram_2,t_Win_2,PSD_Win_2    ] = plot_spectrogram(H_Ph1,H_Ph2,Win_size,Win_overlap,Fs,SFN,freq_range)

      
NFFT            =  2^nextpow2(length(H_Ph1))     ; 
fig_spectrogram = figure('Name','Spectrogram of two flag.')  ;   % figure 4

set(   fig_spectrogram     ,'DefaultAxesFontSize',       15,...
    'DefaultAxesFontWeight','bold','defaultaxeslinewidth',2,...
    'defaultpatchlinewidth',1);

subplot(1,2,1)     
[~,f_spectrogram_1,t_Win_1,PSD_Win_1]=spectrogram(H_Ph1,Win_size,Win_overlap,NFFT,Fs);
spectrogram(H_Ph1,Win_size,Win_overlap,NFFT,Fs);
xlim(freq_range);
subplot(1,2,2)
[~,f_spectrogram_2,t_Win_2,PSD_Win_2]=spectrogram(H_Ph2,Win_size,Win_overlap,NFFT,Fs);
spectrogram(H_Ph2,Win_size,Win_overlap,NFFT,Fs);
xlim(freq_range);

title_string=['from folder: ',SFN,'       || L:Flag. 1, R:Flag. 2'];
uicontrol('Parent',fig_spectrogram,'Units','normalized','Position',[0.1 0.9 0.8 0.1],...
          'Style','text','String',title_string,'Fontsize',15,'Fontweight','bold');
xlabel('Frequency (Hz)','FontSize',18,'Fontweight','bold');
ylabel('Time (s)'      ,'FontSize',18,'Fontweight','bold');


end






    
    
  
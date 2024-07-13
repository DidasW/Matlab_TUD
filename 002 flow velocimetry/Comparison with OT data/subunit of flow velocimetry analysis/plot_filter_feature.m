%% Settings
double_panel_fig_setting;
f_smth      = 10; % Hz
NoP_smth    = f_smth*length(vx_raw)/Fs;
SuperTitle  = suptitle([sprintf('exp:%s, bead pos.: %02d--(%.1f,%.1f)$\\mu$m\n',...
                experiment,pt,xgb,ygb),...
              'Frequency domain characteristics']);
SuperTitle.FontSize = 12;

%% Subplots
% subplot fft nmx
ax_fftx         = subplot(211);
set(ax_fftx,'Yscale','log','Xscale','log')
hold on 
% raw sig spec
[f0x,pow0x]   =  fft_mag(vx_raw,Fs);
pow0x_smth    =  smooth(pow0x,NoP_smth);
plt_fftx0     =  plot(f0x,pow0x_smth,'r');
% filtered sig spec
[f1x,pow1x]   =  fft_mag(vx,Fs);
pow1x_smth    =  smooth(pow1x,NoP_smth);
plt_fftx1     =  plot(f1x,pow1x_smth,'b'); 

xlim([10,Fs/2])
ylim([min(pow0x_smth(f0x>10))*0.5,max(pow0x_smth(f0x>10))*2])
ylabel('Magnitude (-)', 'FontSize', 14, 'FontWeight', 'bold')
legend([plt_fftx0,plt_fftx1],{'Raw data (axial)','BPF'},'FontSize',12);
legend('boxoff')
%%%Mark Peaks%%%
NoPeak = length(pksx);
for j = 1:NoPeak
    text(locsx(j),pksx(j),sprintf('%.2f Hz',locsx(j)))
end
%%%%%%%%%%%%%%%%


% subplot fft nmy
ax_ffty         = subplot(212);
set(ax_ffty,'Yscale','log','Xscale','log')
hold on 
% raw sig spec
[f0y,pow0y]   =  fft_mag(vy_raw,Fs);
pow0y_smth    =  smooth(pow0y,NoP_smth);
plt_ffty0     =  plot(f0y,pow0y_smth,'r');
% filtered sig spec
[f1y,pow1y]   =  fft_mag(vy,Fs);
pow1y_smth    =  smooth(pow1y,NoP_smth);
plt_ffty1     =  plot(f1y,pow1y_smth,'b'); 

xlim([10,Fs/2])
ylim([min(pow0y_smth(f0y>10))*0.5,max(pow0y_smth(f0y>10))*2])
xlabel('Freqency (Hz)', 'FontSize', 14, 'FontWeight', 'bold')
ylabel('Magnitude (-)', 'FontSize', 14, 'FontWeight', 'bold')
legend([plt_ffty0,plt_ffty1],{'Raw data (lateral)','BPF'},'FontSize',12);
legend('boxoff')

%%%Mark Peaks%%%
NoPeak = length(pksy);
for j = 1:NoPeak
    text(locsy(j),pksy(j),sprintf('%.2f Hz',locsy(j)))
end
%%%%%%%%%%%%%%%%%%

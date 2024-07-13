% plot the spectrum of the the two flag. in the same figure.

function fig_fft_spec = plot_flag_fft(f1,pow1,f2,pow2,SFN)
    fig_fft_spec = figure('Name','Power spectra of two flag.');  % figure 1
    set(fig_fft_spec,'DefaultAxesFontSize', 15,'DefaultAxesFontWeight',...
        'bold','defaultaxeslinewidth',2,'defaultpatchlinewidth',1);
    hold on
    
    plt1_1 = plot(f1,smooth(pow1,7),'b'); 
    plt1_2 = plot(f2,smooth(pow2,7),'r'); 
    legend([plt1_1,plt1_2],{'Flag.1', 'Flag.2'});
    legend('boxoff');
    
    xlim([0 160]);
    title(['Flag. frequency from folder: ',SFN]);
    xlabel('Frequency (Hz)', 'FontSize',18,'Fontweight','bold');
    ylabel('Mag./sqrt(N)'  , 'FontSize',18,'Fontweight','bold');
end
    
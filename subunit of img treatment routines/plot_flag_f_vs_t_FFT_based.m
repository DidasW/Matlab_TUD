function fig_f_vs_t_FFT_based = plot_flag_f_vs_t_FFT_based(f_spectrogram_1,PSD_Win_1,t_Win_1,...
                                                       f_spectrogram_2,PSD_Win_2,t_Win_2,...
                                                       f_imp,SFN,freq_range)
    
    band_pass_array_1 = (plus(f_spectrogram_1>90,f_spectrogram_1<5)==1); 
    PSD_Win_1(band_pass_array_1,:)=[];
    f_spectrogram_1(band_pass_array_1)=[];
    
    band_pass_array_2 = (plus(f_spectrogram_2>90,f_spectrogram_2<5)==1);
    PSD_Win_2(band_pass_array_2,:)=[];
    f_spectrogram_2(band_pass_array_2)=[];
    
    % Abandon parts of the spectrum, which are not of our interest
  
    [~,arg_max_1]=max(PSD_Win_1);
    [~,arg_max_2]=max(PSD_Win_2);
    % e.g. arg_max_1(1) = 555, then the max value in PSD_Win(:,1)
    %   is PSD_Win_1(555,1) 
      
    fig_f_vs_t_FFT_based = figure('Name','Flag. freq. vs. time');  % figure 5
    set(fig_f_vs_t_FFT_based ,'DefaultAxesFontSize', 15,...
        'DefaultAxesFontWeight','bold','defaultaxeslinewidth',2,...
        'defaultpatchlinewidth',1);
    hold on
    % To show how the beating freq. of two flag. change with time
    
    F_IMP = ones(length(t_Win_1),1)*f_imp;
    plt5_1 = plot(t_Win_1,f_spectrogram_1(arg_max_1),'b','linewidth',2);
    plt5_2 = plot(t_Win_2,f_spectrogram_2(arg_max_2),'r','linewidth',2);
    plt5_3 = plot(t_Win_1,F_IMP,'k--','linewidth',1);
    ylim(freq_range);
    
    if f_imp ~= 0
        legend([plt5_1, plt5_2, plt5_3],{'Flag. 1 freq.','Flag. 2 freq.','Imposed freq.'});
        legend('boxoff');
    else
        legend([plt5_1, plt5_2],{'Flag. 1 freq.','Flag. 2 freq.'});
        legend('boxoff');
    end
    
    xlabel('Frequency (Hz)','FontSize',18,'Fontweight','bold')
    ylabel(  'Time (s)'    ,'FontSize',18,'Fontweight','bold')
    title(['Flagella frequency vs. time, Fd ',SFN])
end
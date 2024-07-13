%% Doc
% Inputs are made backward compatible
% 1. Some never-used outputs are deleted.
% 2. Optional calculation of theoretical phase (ThPh) is calculated 
% 3. If ThPh is calculated, instantaneous frequency will be calculated from 
%   its derivative 
% 4. Usage of fullfile and try to make script Mac-compatible

    flag1raw=zeros(NoI-1,1);   %_flag: flagellum(a)
    flag2raw=zeros(NoI-1,1);
    tic
    for i_read=1:NoI-1   % No. of adjusted img. = NoI - 1, due to diff()
        full_file_name = construct_file_name(file_name,i_read,...
                                             format_string);
        current_img    = im2double(imread(fullfile(SF_adjusted_path,...
                                   full_file_name),'tif'));
        
        flag1window   = current_img.*white_mask_1;
        flag2window   = current_img.*white_mask_2;
 
        flag1raw(i_read) = sum(flag1window(:))/mask_1_size; 
        flag2raw(i_read) = sum(flag2window(:))/mask_2_size;
    end
    toc
    
    %% for others
     flag1 = flag1raw;
     flag2 = flag2raw;
    
    %% for oda1,oda6 mutants only
%      [blp,alp] = butter(4,25/Fs*2,'low');
%      flag1 =  filtfilt(blp,alp,flag1raw);
%      flag2 =  filtfilt(blp,alp,flag2raw);

    %% for oda11
%     flag1 =  AutoBPF_FlagSig_v2(flag1raw,Fs,30,50);
%     flag2 =  AutoBPF_FlagSig_v2(flag2raw,Fs,30,50);
    
    %%
    H_Ph1 = calcHilbertPhase(flag1);
    H_Ph2 = calcHilbertPhase(flag2);
    h_Ph1_unwrapped = unwrap(H_Ph1);
    h_Ph2_unwrapped = unwrap(H_Ph2);
  
    if exist('calculateTheoreticalPhase','var') && ...
       calculateTheoreticalPhase == 1
        ThPh1_unwrapped = transformProtoPhase(h_Ph1_unwrapped); 
        ThPh2_unwrapped = transformProtoPhase(h_Ph2_unwrapped);
    else
        ThPh1_unwrapped = h_Ph1_unwrapped; 
        ThPh2_unwrapped = h_Ph2_unwrapped; 
    end
        
    flag1_f = smooth(diff(ThPh1_unwrapped)*Fs/2/pi,0.1*Fs);
    flag2_f = smooth(diff(ThPh2_unwrapped)*Fs/2/pi,0.1*Fs);
    % Only care about the frequency variation over 0.1 second (5cycs)
    % for oda1 mutant, 0.3 sec amounts for 5 cyc 
    
    %% 4. Showing results
    %% Figure 1: frequency spectrum of flagella motion
    [f1,pow1]=fft_mag(H_Ph1,Fs);
    [f2,pow2]=fft_mag(H_Ph2,Fs);
    fig_fft_spec = plot_flag_fft(f1,pow1,f2,pow2,SFN);

    
    %% Figure 2: find synchrony between flag. and imposed signal
    switch where_to_find_f_imp
        case 'Folder name'  
            f_imp = str2double(SFN);
        case 'Spectrum selection'
            f_imp = find_f_imp_from_fig(f1,pow1);
        case 'Manual input'
            f_imp_raw =  inputdlg('What is the imposed freq?');
            f_imp = str2double(f_imp_raw{1});
        case 'No imposed freq.'
    end
    if ~strcmp(where_to_find_f_imp,'No imposed freq.')
        [t_imp_interp1,...
            d_H_Ph1_interp] = compare_with_imposed_phase(H_Ph1,Fs,f_imp);
        [t_imp_interp2,...
            d_H_Ph2_interp] = compare_with_imposed_phase(H_Ph2,Fs,f_imp);
        % _interp: interpolation
        % d_     : difference from (imposed phase);
        fig_entrainment     =  plot_external_entrainment(...
                                t_imp_interp1,d_H_Ph1_interp,...
                                t_imp_interp2,d_H_Ph2_interp,SFN);
    end
    
    
    %% Figure 3: find synchrony between flag.
    [t_interflag_interp,...
        Ph_interflag_interp]   =  compare_phase_between_flag(H_Ph1,H_Ph2,Fs);
    fig_Ph_dif_interflag       =  plot_Ph_dif_interflag(t_interflag_interp,...
                                    Ph_interflag_interp,SFN);
    
    
    %% Figure 4: Spectrogram
     [fig_spectrogram,...
      f_spectrogram_1,t_Win_1,PSD_Win_1,...
      f_spectrogram_2,t_Win_2,PSD_Win_2    ] = plot_spectrogram(H_Ph1,H_Ph2,...
                                               Win_size,Win_overlap,...
                                               Fs,SFN,freq_range);   
      
      
    %% Figure 5: Freq. of each flag. vs. t, FFT_based
    if ~strcmp(where_to_find_f_imp,'No imposed freq.')
        fig_f_vs_t_FFT_based   = plot_flag_f_vs_t_FFT_based(...
                                 f_spectrogram_1,PSD_Win_1,t_Win_1,...
                                 f_spectrogram_2,PSD_Win_2,t_Win_2,...
                                 f_imp,SFN,freq_range);
    else
        fig_f_vs_t_FFT_based   = plot_flag_f_vs_t_FFT_based(...
                                 f_spectrogram_1,PSD_Win_1,t_Win_1,...
                                 f_spectrogram_2,PSD_Win_2,t_Win_2,...
                                 0,  SFN,freq_range);    
    end
    
    
    %% Figure 6: Freq. of each flag. vs. t, accumulated phase based
    if ~strcmp(where_to_find_f_imp,'No imposed freq.')
        fig_f_vs_t_accu_Ph_based = plot_flag_f_vs_t_accu_Ph_based(...
                                   flag1_f,flag2_f,Fs,f_imp,SFN,freq_range);
    else
        fig_f_vs_t_accu_Ph_based = plot_flag_f_vs_t_accu_Ph_based(...
                                   flag1_f,flag2_f,Fs,0,SFN,freq_range);
    end
        
    
    %% Save and finish 
    clear('PSD_Win_1','PSD_Win_2','marked_black_img','CBnP_mask_list');
     close(fig_spectrogram);
    save(result_path);
    
    if strcmp(save_figures_or_not,'All')
        storage_full_path = fullfile(storage_folder_path,MFN);
        if ~exist(storage_full_path,'dir')
            mkdir(storage_full_path)
        end
        print(fig_fft_spec,...
            fullfile(storage_full_path,['FFT spec, Fd_',SFN,'.png']),...
            '-dpng','-r180');
        print(fig_Ph_dif_interflag,...
            fullfile(storage_full_path,['Interflag Ph dif, Fd_',...
            SFN,'.png']),'-dpng','-r180');
        print(fig_f_vs_t_FFT_based,...
            fullfile(storage_full_path,['Flag freq(FFT), Fd_',...
            SFN,'.png']),'-dpng','-r180');
        print(fig_f_vs_t_accu_Ph_based,...
             fullfile(storage_full_path,['Flag freq(Instant), Fd_',...
             SFN,'.png']),'-dpng','-r180');
        if ~strcmp(where_to_find_f_imp,'No imposed freq.')
        print(fig_entrainment,...
             fullfile(storage_full_path,['External entrainment, Fd_',...
             SFN,'.png']),'-dpng','-r180');
        end
    end
    
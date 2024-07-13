saveMatFileTo_fdpth = 'D:\000 RAW DATA FILES\181129 new phase\matfiles';
saveFigTo_fdpth     = 'D:\000 RAW DATA FILES\181129 new phase\figures';


for i = 89:size(slipRateTable_allWTCells,1)
    tic
    date = slipRateTable_allWTCells.date{i};
    experiment = slipRateTable_allWTCells.experiment{i};
    matfilepath = slipRateTable_allWTCells.phaseMatFilePath{i};
    specStr     = slipRateTable_allWTCells.beforePiezoFlow{i};
    if ~isempty(matfilepath)
        load(matfilepath,'flag1raw','flag2raw','Fs')
        if strcmp(date,'180710')
            caConc = slipRateTable_allWTCells.calciumConcentration(i);
            if caConc == 0.005
            experiment = [experiment,'_5mMCa'];
            else
            experiment = [experiment,'_0.3mMCa'];    
            end 
        end
        experimentStr = [experiment,'_',specStr];
        fig_fdpth = fullfile(saveFigTo_fdpth,experimentStr);
        if ~exist(fig_fdpth,'dir'); mkdir(fig_fdpth);end
        
        %% Hilbert phase
        H_Ph1 = calcHilbertPhase(flag1raw);
        H_Ph2 = calcHilbertPhase(flag2raw);
        h_Ph1_unwrapped = unwrap(H_Ph1);
        h_Ph2_unwrapped = unwrap(H_Ph2);
        
        %% Theoretical phase
        ThPh1_unwrapped = transformProtoPhase(h_Ph1_unwrapped);
        ThPh2_unwrapped = transformProtoPhase(h_Ph2_unwrapped);
        ThPh1 = wrapToPi(ThPh1_unwrapped);
        ThPh2 = wrapToPi(ThPh2_unwrapped);
        
        %% freq
        flag1_f = smooth(diff(ThPh1_unwrapped)*Fs/2/pi,0.1*Fs);
        flag2_f = smooth(diff(ThPh2_unwrapped)*Fs/2/pi,0.1*Fs);
        % Only care about the frequency variation over 0.1 second (5cycs)
        
        %% FFT spec
        [f1,pow1]=fft_mag(ThPh1,Fs);
        [f2,pow2]=fft_mag(ThPh2,Fs);
        
        %% phase difference between flag.
        [t_interflag_interp,...
        Ph_interflag_interp] =  compare_phase_between_flag(...
                                ThPh1,ThPh2,Fs);
    
        
        %% Figure 1: frequency spectrum of flagella motion
        fig_fft_spec         =  plot_flag_fft(f1,pow1,f2,pow2,specStr);

        %% Figure 2: synchrony between flagella
        fig_Ph_dif_interflag =  plot_Ph_dif_interflag(...
                                    t_interflag_interp,...
                                    Ph_interflag_interp,specStr);
        
        %% Figure 3: Freq. of each flag. vs. t, phase based
        fig_f_vs_t = plot_flag_f_vs_t_accu_Ph_based(...
                         flag1_f,flag2_f,Fs,0,specStr,[20,100]);
        %%
        save(fullfile(saveMatFileTo_fdpth,[experimentStr,'.mat']),...
            'flag1raw','flag2raw',...
            'flag1_f','flag2_f',...
            'H_Ph1','H_Ph2',...
            'ThPh1','ThPh2',...
            'h_Ph1_unwrapped','h_Ph2_unwrapped',...
            'ThPh1_unwrapped','ThPh2_unwrapped',...
            't_interflag_interp','Ph_interflag_interp',...
            'Fs');
        
        savefig(fig_fft_spec,...
                fullfile(fig_fdpth,'01FreqSpec.fig'))
        savefig(fig_Ph_dif_interflag,...
                fullfile(fig_fdpth,'02InterflagPhaseDif.fig'))
        savefig(fig_f_vs_t,...
                fullfile(fig_fdpth,'03FreqTimeSeries.fig'))
        toc
        if mod(i,3)==0
            close all
        end
    end
end




    
    
 

    
  
      
      
 
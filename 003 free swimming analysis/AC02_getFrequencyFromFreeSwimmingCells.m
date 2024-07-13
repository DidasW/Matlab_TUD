%% Doc: Current version v4
%{  
  v0: get peak freq from FFT of pxSum(i) = sum(Image_i(:)), 
      i is the ith image in the sequence. Signal's lower freq components 
      were discarded and higher ones used for generating the spectrum.
      Preliminary results were available, but the process was slow and 
      signal sometimes not conspicuous.
  v1: image sequence based on a tracking camara view, everything else is
      blacked out so that the available pxSum are smaller and more relevant
      to the cellbody's vibration. Improve in signal quality is confirmed
      by user.
  v2: due to the cell's entering/exiting the image, the spectrum is
      sometimes deteriorated due to sudden upshoot corresponding to the
      decrease in total meaningful px number. A cut was adopted at two ends
      of the signal to improve quality, however it left less points
  v3: - using the pxSum/maskSize instead of pxSum as the raw signal 
      alleviates the upshoot. Very effective.
      - A trial using complement image to enhance the signal of cellbody 
      vibration failed.
      - Make cutHeadTail automated  
  v4: - Include the FFT spectrum from tracks.

%}


%% Folder structure
FOLDER_ROOT         = fullfile('F:','190129 wt');
croppedImageFdpth   = fullfile(FOLDER_ROOT,'001 Image cropped');
trackFdpth          = fullfile(FOLDER_ROOT,'003 Tracks formatted');
maskedImgRootFdpth  = fullfile(FOLDER_ROOT,'004 Image masked');
freqAnalysisFdpth   = fullfile(FOLDER_ROOT,'005 Beat freq analysis');
intermediateFdpth   = fullfile(FOLDER_ROOT,'999 Intermediates');

%% Parameter setting
cd(maskedImgRootFdpth)
fps               = 301.08;     % [Hz]
spectrumSmooth    = 9;          % [Hz]
freqHPFTrack      = 10;         % [Hz] 
[bhp,ahp]         = butter(4,freqHPFTrack/fps*2,'high');
headTailDef       = 0.1;        % fraction of the total duration
SFL = dir(); SFL(1:2) = [];     % Sub Folder List


%% Processing
trackFileList       = dir(fullfile(trackFdpth,'*.txt'));
trackFilenameList   = {trackFileList.name};
NoFd                = numel(SFL);
pxSumArray_list     = cell(NoFd,1);

for i_Fd = 1:NoFd
    cellName        = SFL(i_Fd).name;
    disp(['Processing cell ',cellName])
    
    %% make the time series of image brightness 
    [pxSum,~,...
     maskSize ]     = calcPxSumOfImgSequence(cellName);
    pxSumScaled     = pxSum./maskSize;
    t               = make_time_series(pxSumScaled,fps,'ms');
    
    %% load tracks
    idx_track     = find(contains(trackFilenameList,cellName),1);
    trackFilename = trackFileList(idx_track).name;
    trackInfo     = dlmread(fullfile(trackFdpth,trackFilename));
    x_px          = trackInfo(:,2);
    y_px          = trackInfo(:,3);
    
    %% leave only frequencies of interests
    pxSumVariation = filtfilt(bhp,ahp,pxSumScaled); 
    x_px           = filtfilt(bhp,ahp,x_px); 
    y_px           = filtfilt(bhp,ahp,y_px); 
    
    %% alleviate artefacts from cell's entering/exiting
    sigLength= t(end); % [ms]
    sig      = pxSumVariation;
    idx_head = find(t<=sigLength*headTailDef);
    idx_tail = find(t>=sigLength*(1-headTailDef));
    idx_mid  = find(t>sigLength*headTailDef & ...
                    t<sigLength*(1-headTailDef));
    sigHead  = sig(idx_head);
    sigTail  = sig(idx_tail);
    sigMid   = sig(idx_mid);
    
    sigFFT   = sig;
    refSigAmpl = std(sigMid);
    if std(sigTail) >= 2*refSigAmpl
        sigFFT (idx_tail) = [];
        cutTail = 1;
    else
        cutTail = 0;
    end
    % NOTE, cut head has to be after cut tail, otherwise idx will be wrong
    if std(sigHead) >= 2*refSigAmpl
        sigFFT (idx_head) = [];
        cutHead  = 1;
    else
        cutHead  = 0;
    end     
    
    %% calculate frequency spectrum
    [f,pow]  = fft_mag(sigFFT,fps);
    pow(f<freqHPFTrack)=0;
    N_smth   = numel(find(f<spectrumSmooth));
    pow_smth = smooth(pow,N_smth);
    pow_smth = normalize_MaxToMin(pow_smth);
    [pks,locs]      = findpeaks(pow_smth,f,'minpeakdistance',5,...
                          'minPeakProminence',0.1);
                       
    [f_track,powx]  = fft_mag(x_px,fps);
    [~      ,powy]  = fft_mag(y_px,fps);
    powx(f_track<freqHPFTrack)=0;
    powy(f_track<freqHPFTrack)=0;
    pow_track = powx + powy; 
    pow_track = smooth(pow_track,N_smth);
    pow_track = normalize_MaxToMin(pow_track);                 
    % addition + normalize:
    % if two are similar, powTrack = the average
    % if one dominates,   powTrack = the dominant
    
    [pks_track,...
     locs_track   ]= findpeaks(pow_track,f_track,'minpeakdistance',5,...
                         'minPeakProminence',0.1);
    %% subplot1 - time series of PixelValueSum 
    figure('Units','normalized','Position',[0.3,0.3,0.5,0.3],...
           'defaultAxesColorOrder',[[0 0 0]; [0 0 0]],...
           'defaultTextInterpreter','latex');
    subplot(1,2,1)
    hold on, grid on, box on
    plot(t,pxSumScaled,'LineWidth',1.5)
    ylabel('px sum (-)')
    yyaxis right
    
    lw = 1.5; lineSpec= 'r-';
    plot(t(idx_mid),sig(idx_mid),lineSpec,'LineWidth',lw)
    
    lw = 1.5; lineSpec= 'r-';
    if cutHead == 1; lw = 1; lineSpec = 'k:'; end
    plot(t(idx_head),sig(idx_head),lineSpec,'LineWidth',lw)
    
    lw = 1.5; lineSpec= 'r-';
    if cutTail == 1; lw = 1; lineSpec = 'k:'; end
    plot(t(idx_tail),sig(idx_tail),lineSpec,'LineWidth',lw)
    
    xlabel('Time (ms)')
    ylabel('Fine variantion (-)')
    
    %% subplot2 - freq spectrum
    subplot(1,2,2)
    plot_powSpecFromTrackAndImage(f,pow_smth,locs,pks,...
        f_track,pow_track,locs_track,pks_track);
    
    %% save variables
    save(fullfile(freqAnalysisFdpth,[SFL(i_Fd).name,'.mat']),...
        'fps','spectrumSmooth','freqHPFTrack','headTailDef',...
        't','pxSum','maskSize','pxSumScaled','cutTail','cutHead',...
        'idx_head','idx_mid','idx_tail','sigFFT',...
        'pxSumVariation','pks','locs','f','pow','pow_smth',...
        'locs_track','pks_track', 'f_track','pow_track')
    print(gcf,fullfile(freqAnalysisFdpth,[SFL(i_Fd).name,'.png']),...
        '-dpng','-r300')
    
%     close(gcf)
end
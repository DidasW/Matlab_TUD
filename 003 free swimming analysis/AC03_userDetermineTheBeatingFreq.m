%% Folder structure
FOLDER_ROOT         = fullfile('F:','190129 wt');
croppedImageFdpth   = fullfile(FOLDER_ROOT,'001 Image cropped');
trackFdpth          = fullfile(FOLDER_ROOT,'003 Tracks formatted');
maskedImgRootFdpth  = fullfile(FOLDER_ROOT,'004 Image masked');
freqAnalysisFdpth   = fullfile(FOLDER_ROOT,'005 Beat freq analysis');
intermediateFdpth   = fullfile(FOLDER_ROOT,'999 Intermediates');


%% parse name and create filelist
[~,temp,~] = fileparts(FOLDER_ROOT); temp = strsplit(temp,' ');
expDate    = temp{1}; 
strain     = temp{2};

cd(freqAnalysisFdpth)
matFileList     = dir('*.mat');
NoFile          = numel(matFileList);
filenameList    = {matFileList.name};
swimFreqTable   = table();


%%
for i_cell = 1:NoFile
    matfilename = filenameList{i_cell};
    cellname    = matfilename(1:3);
    load(matfilename,'locs','pks','f','pow_smth',...
        'locs_track','pks_track', 'f_track','pow_track','fps')
    
    %% plot
    figure('Units','normalized','Position',[0.4 0.48 0.2 0.32],...
           'defaultAxesColorOrder',[[0 0 0]; [0 0 0]],...
           'defaultTextInterpreter','latex');
    title(cellname)
    plot_powSpecFromTrackAndImage(f,pow_smth,locs,pks,...
        f_track,pow_track,locs_track,pks_track);
    
    %% parse peak-findings
    peakPosAll = horzcat(locs,locs_track);
    peakPosAll = uniquetol(peakPosAll,1e-3);
    NoPks = numel(peakPosAll);
    peakFreqStrList = cell(NoPks,1);
    peakFreqList    = zeros(NoPks,1);
    for i_pk = 1:NoPks
        peakFreqList(i_pk)    = peakPosAll(i_pk);
        peakFreqStrList{i_pk} = num2str(peakPosAll(i_pk),'%.2f');
    end
    
    % cleaning impossible peaks <20 Hz or >80Hz
    peakFreqStrList(peakFreqList<30|peakFreqList>75) = [];
    peakFreqList   (peakFreqList<30|peakFreqList>75) = [];
    peakFreqStrList   = vertcat(peakFreqStrList,'Not sure');
    
    %% User determination
    % determine the synchrnous beating freq
    syncBeatFreqStr = ui_multiButtonQuestDlg(peakFreqStrList,...
                      'Choose the synchronous freq (Hz)',...
                      'Position',[0.4 0.2 0.3 0.16]);
    if strcmp(syncBeatFreqStr,'Not sure')
        syncBeatFreq = NaN;
    else
        idx_syncBeatFreq = find(strcmp(syncBeatFreqStr,peakFreqStrList));
        syncBeatFreq     = peakFreqList(idx_syncBeatFreq);
    end
        
    % determine if there is slip
    singlePeak = ui_multiButtonQuestDlg({'Yes','No','Not Sure'},...
                               'Only a well-defined peak?',...
                               'Position',[0.4 0.2 0.3 0.16]);
    switch singlePeak
        case 'Yes'
            slipOrNot   = 0;
        case 'No'
            slipOrNot   = 1;
        case 'Not Sure'
            slipOrNot   = NaN;    
    end
    close(gcf)
    
    %% Save to table
    resultThisExp = {expDate,cellname,strain,fps,...
                     syncBeatFreq,slipOrNot};
    swimFreqTable = [swimFreqTable;resultThisExp]; %#ok<AGROW>
end

varNames  = {'Date','CellName','Strain','FrameRate',...
             'BeatFreq','SlipOrNot'};
swimFreqTable.Properties.VariableNames= varNames;
% add process time to avoid replacing good data
processDate = datestr(now,30); 
processDate = strrep(processDate,'T','-');
processDate = processDate(3:end); % YYMMDD-HHMMSS

save(fullfile(intermediateFdpth,...
     sprintf('swimFreqTable_%s_%dTracks_%s.mat',strain,NoFile,processDate)),...
     'swimFreqTable');


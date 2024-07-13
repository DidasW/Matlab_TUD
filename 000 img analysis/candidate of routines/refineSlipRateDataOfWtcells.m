AB00_importExperimentPathList;
if ~exist('slipRateTable','var')
    slipRateTable = table();
    operation     = 'create';
else
    disp('slipRateTable already exist, add new rows?')
    operation = ui_multiButtonQuestDlg({'add','create','stop'},...
               'slipRateTable already exist, add new rows?');
    switch operation
        case 'create'
            slipRateTable = table();
        case 'add'
           slipRateTable = table();
        case 'stop'
            error('Stopped by user')
    end
   
end
% _before_/_after_ means before or after applying piezo flows
saveToFdpth = 'D:\SURFdrive folder\002 Academic writing\180225 Manuscript for Cis-Trans difference\up-to-date tables';

%%
for i_exp = 1:numel(experiment_path_list)
    experiment_path = experiment_path_list{i_exp};
    experiment  = parseExperimentPath(experiment_path);
    temp = strsplit(experiment);
    expDate = temp{1};     cellNo  = temp{2};  clearvars temp

    if strcmp(operation,'add')
        existingExperimentList = slipRateTable.experiment;
        isAnalyzed = ~isempty(find(contains(...
                      slipRateTable.experiment,experiment),1));
        if isAnalyzed
            continue
        end
    end
    AB00_experimentalConditions;
    calciumConcentration = getCalciumConcentration(expCondition);
    
    %% 1.check directory existence
    freeBeat = nan;
    freeBeatBefore = nan;
    freeBeatAfter  = nan;
    img_before_fdpth = '';
    img_after_fdpth  = '';
    phaseInfo_before_pth = '';
    phaseInfo_after_pth = '';

    if exist(fullfile(experiment_path,'00NoFlow'),'dir')
        freeBeat = 1;
        %% before piezoflow
        if exist(fullfile(experiment_path,'00NoFlow','before'),'dir')
           freeBeatBefore = 1;
           img_before_fdpth = fullfile(experiment_path,...
                                   '00NoFlow','before');
           phaseInfo_before_pth = fullfile(experiment_path,...
                                   '00NoFlow','Folder_before.mat');
        end
        %% after piezoflow
        if exist(fullfile(experiment_path,'00NoFlow','after'),'dir')
           freeBeatAfter = 1;
           img_after_fdpth  = fullfile(experiment_path,...
                                   '00NoFlow','after');
           phaseInfo_after_pth = fullfile(experiment_path,...
                                   '00NoFlow','Folder_after.mat');
        end
        
    end
    %% 2.register number of slips
    duration_before = nan;
    duration_after  = nan;
    NoSlip_before   = nan;
    NoSlip_after    = nan;
    avgFreq_before  = nan;
    avgFreq_after   = nan;
    stdFreq_before  = nan;
    stdFreq_after   = nan;
    Fs_interp = 1000; %all phases are resampled @1kHz in the routine
    
    % The begining and ending are each cut by 0.25 sec, as the phases are
    % often not stablized due to multiple smooth() and diff() in the
    % analysis routine
    
    if ~isempty(phaseInfo_before_pth)
        load(phaseInfo_before_pth,'t_interflag_interp',...
             'Ph_interflag_interp','flag1_f','flag2_f')
        duration_before = t_interflag_interp(end) - 0.5;
        N_slip  = abs(Ph_interflag_interp(end-floor(0.25*Fs_interp))-...
                      Ph_interflag_interp(ceil(0.25*Fs_interp))); 
        NoSlip_before = floor(N_slip);
        avgFreq_before  = mean([mean(flag1_f),mean(flag2_f)]);
        stdFreq_before  = mean([std(flag1_f),std(flag2_f)]);
    end
    
    %
    if ~isempty(phaseInfo_after_pth)
        load(phaseInfo_after_pth,'t_interflag_interp',...
             'Ph_interflag_interp','flag1_f','flag2_f')
        duration_after = t_interflag_interp(end) - 0.5;
        N_slip  = abs(Ph_interflag_interp(end-floor(0.25*Fs_interp))-...
                      Ph_interflag_interp(ceil(0.25*Fs_interp))); 
        NoSlip_after = floor(N_slip);
        avgFreq_after  = mean([mean(flag1_f),mean(flag2_f)]);
        stdFreq_after  = mean([std(flag1_f),std(flag2_f)]);
    end
    
    %% 3.Check if there are misrecognition of the slips
    NoSlip_manuReal_before     = nan;
    NoSlip_manuFalse_before    = nan;
    NoSlip_manuReal_after      = nan;
    NoSlip_manuFalse_after     = nan;
    idx_realSlip_before        = [];
    idx_falseSlip_before       = [];
    idx_realSlip_after         = [];
    idx_falseSlip_after        = [];
    REDO_before                = 'No';
    REDO_after                 = 'No';
    
    if NoSlip_before == 0
        NoSlip_manuReal_before = 0;
        NoSlip_manuFalse_before = 0;
    end
    
    if NoSlip_after == 0
        NoSlip_manuReal_after = 0;
        NoSlip_manuFalse_after = 0;
    end
    
    if ~isempty(phaseInfo_before_pth) && NoSlip_before ~= 0
        load(phaseInfo_before_pth,'t_interflag_interp',...
             'Ph_interflag_interp')
        [NoSlip_manuReal_before,...
         NoSlip_manuFalse_before,...
         idx_realSlip_before,...
         idx_falseSlip_before] =  checkPhaseSlipByUser(Ph_interflag_interp,...
                                  img_before_fdpth,fps,Fs_interp);
        if NoSlip_manuFalse_before == 9999
            REDO_before   =  'YES';
        end
    end
    
    if ~isempty(phaseInfo_after_pth) && NoSlip_after ~= 0
        load(phaseInfo_after_pth,'t_interflag_interp',...
             'Ph_interflag_interp')
        [NoSlip_manuReal_after,...
         NoSlip_manuFalse_after,...
         idx_realSlip_after,...
         idx_falseSlip_after] =  checkPhaseSlipByUser(Ph_interflag_interp,...
                             img_after_fdpth,fps,Fs_interp);
        if NoSlip_manuFalse_after == 9999
            REDO_after   =  'YES';
        end
    end
    
    %% 4. register all the values
    resultThisExp_before = {experiment,expDate,'before',...
                            expCondition,calciumConcentration,...
                            freeBeatBefore,...
                            img_before_fdpth,...
                            phaseInfo_before_pth,...
                            duration_before,...
                            NoSlip_before,...
                            avgFreq_before,...
                            stdFreq_before,...
                            NoSlip_manuReal_before,...
                            NoSlip_manuFalse_before,...
                            {idx_realSlip_before},...
                            {idx_falseSlip_before},...
                            REDO_before};
    resultThisExp_after  = {experiment,expDate,'after',...
                            expCondition,calciumConcentration,...
                            freeBeatAfter,...
                            img_after_fdpth,...
                            phaseInfo_after_pth,...
                            duration_after,...
                            NoSlip_after,...
                            avgFreq_after,...
                            stdFreq_after,...
                            NoSlip_manuReal_after,...
                            NoSlip_manuFalse_after,...
                            {idx_realSlip_after},...
                            {idx_falseSlip_after},...
                            REDO_after};
    
    slipRateTable = [slipRateTable;resultThisExp_before]; %#ok<AGROW>
    slipRateTable = [slipRateTable;resultThisExp_after];
    disp([num2str(i_exp),'/',num2str(numel(experiment_path_list)), 'done'])
end
varNames    = {'experiment','date','beforePiezoFlow',...
               'expCondition','calciumConcentration',...
               'freeBeatRecordExist',...
               'imageFolderPath',...
               'phaseMatFilePath',...
               'recordDuration',...
               'phaseChangeInRecord',...
               'avgFreq',...
               'stdFreq',...
               'NoSlipConfirmed',...
               'NoSlipMisRecog',...
               'posOfSlip',...
               'posOfMisreog',...
               'needRedefFIW'};
slipRateTable.Properties.VariableNames= varNames;
slipRateTable_allWTCells = slipRateTable;
save(fullfile(saveToFdpth,'slipRateTable_allWTCells.mat'),...
    'slipRateTable_allWTCells');
%% rootfolder path list
clear all
close all

%%
AB00_experimentalConditions
AB00_importExperimentPathList_oda1;
experiment_path_list  = keepExperimentListByDate(...
                        experiment_path_list,{'190728'});

mama_folder_path_list = formMamaFdList(experiment_path_list,0);
mama_folder_path_list = discardFolderPathListByKeyWords(...
                        mama_folder_path_list,{'00NoFlow','99Deflag'});

                          
library_fdpth = 'D:\000 RAW DATA FILES\189999 wvfm calib library\';
% library_fdpth = 'D:\000 RAW DATA FILES\199999 wvfm library for oda1 study\';
measureFreqByPipette = 1;
FROI = [20,60];          % Frequency Range Of Interest

%%
for i_mamafd = 1:numel(mama_folder_path_list)
    %% Folders to rename
    mama_folder_path   = mama_folder_path_list{i_mamafd};
    [~,experiment,~]   = parseMamaFolderPath(mama_folder_path);
    AB00_experimentalConditions;
    fprintf('Processing "%s"\n',experiment);
    % SF_ :subfolder.
    SF_list= dir(mama_folder_path); 
    SF_list(~[SF_list.isdir]) = []; 
    SF_list(1:2) = [];   
    NoSubFd            = numel(SF_list);
    
    %% Find the set frequencies
    NoLine             = 0;
    wvfmFilePath       = findWvfmFilePath(mama_folder_path);
    fileID             = fopen(wvfmFilePath,'r');
    setFreqList        = []; 
    %%
    while ~feof(fileID)
        thisLine = fgetl(fileID);
        lineParts = strsplit(thisLine,'_');
        freqPart  = lineParts{2};
        temp      = textscan(freqPart,'%4c%.2f%2c');
        freq      = temp{2}; clear temp
        setFreqList = [setFreqList,freq]; %#ok<AGROW>
        NoLine = NoLine + 1;
    end
    fclose(fileID);
    
    if NoLine~=NoSubFd
        disp([mama_folder_path,' WAS NOT PROCESSED'])
        continue
    end
    
    %% Find the frequency applied by previous calibration
    lookupTableFilePath = findLookupTableFilePath(mama_folder_path,...
                          library_fdpth);
    freqAmplLookupTable = readtable(lookupTableFilePath);
    rowNumList  = [];      
    
    %% Find the frequency applied by pipette vibration
    if measureFreqByPipette
        figure()
        set(gcf,'DefaultAxesFontSize',10,'DefaultAxesFontWeight','normal',...
            'DefaultAxesLineWidth',1.5,'unit','normalized',...
            'position',[0.02,0.02,0.9,0.88],'PaperPositionMode','auto',...
            'DefaultTextInterpreter','Latex')
        panelsPerRow = 4;
        panelsPerCol = NoSubFd/panelsPerRow;
        if mod(panelsPerCol,1)>0.1
            panelsPerCol = floor(panelsPerCol)+1;
        end
    end
    
    for i_subfd = 1:NoSubFd
        SFN = SF_list(i_subfd).name;
        setFreq = setFreqList(i_subfd);
        rowNum  = find(freqAmplLookupTable.SetFreq==setFreq);
        
        %% Rename
        if ~isempty(rowNum) && length(rowNum)==1
            calibFreq = freqAmplLookupTable.GetFreqX(rowNum);
            actualFreq = calibFreq;
            %% Measure f_imp by pipette vibration
            if measureFreqByPipette
                load(fullfile(mama_folder_path,SFN,'shift vs time.mat')); 
                [f,pow] = powerSpecPipetteShakeFFT(u,v,fps,FROI);                
                
                subplot(panelsPerRow,panelsPerCol,i_subfd)
                
                plot(f,pow);
                [p,f_pks] = findpeaks(pow,f,'MinPeakProminence',0.7);
                findpeaks(pow,f,'MinPeakProminence',0.7);
                
                idx     = find(f_pks<calibFreq+10 &...
                               f_pks>calibFreq-10);
                if ~isempty(idx); p = p(idx); f_pks=f_pks(idx);
                else;             p = p(1);   f_pks=f_pks(1);
                end % if p = [], p(1) = [], no marker will be drawn
                xlabel('Freq (Hz)'); xlim(FROI); ylim([-0.05,1.2]);
                text(f_pks-10,p+0.1,...
                     ['measure - calib Freq =',...
                     num2str(f_pks-calibFreq,'%.2f'),' Hz'],...
                     'FontSize',8,'FontWeight','bold')
                if ~isempty(f_pks); actualFreq = f_pks; end
            end
            
            % For folders with many files, this system shell command 
            % works 30 times faster than the movefile() function in matlab;
            % "" is a must, as many folder names contain spaces
            if ~exist(fullfile(mama_folder_path,...
                num2str(actualFreq,'%.2f')),'dir')
                cmd = ['move',' "',fullfile(mama_folder_path,SFN),...
                       '" "',fullfile(mama_folder_path,...
                       num2str(actualFreq,'%.2f')),'"'];
            else
                cmd = ['move',' "',fullfile(mama_folder_path,SFN),...
                       '" "',fullfile(mama_folder_path,...
                       num2str(actualFreq,'%.3f')),'"'];
                disp('Misnamed File Exist')
            end
            system(cmd);
            rowNumList = [rowNumList,rowNum]; %#ok<AGROW>
        else
            disp(['Folder',SFN,' in ', mama_folder_path, ' was ',...
                'not processed because ',num2str(setFreq,'%.2f'), ' Hz',...
                'cannot be found in the file:',...
                reportFilePathList{i_rootfd}])
            continue
        end
        

        
    end
    relevantLookupTable = freqAmplLookupTable(rowNumList,1:end);
    save(fullfile(mama_folder_path,'Freq and Ampl lookup table.mat'),...
        'relevantLookupTable')
    if measureFreqByPipette
        print(gcf,fullfile(mama_folder_path,'freqMeasureByPipetteVib.png'),...
            '-dpng','-r300');
        close(gcf)
    end
end


%%
function lookupTableFilePath = findLookupTableFilePath(...
                               mama_folder_path,library_folder_path)
    lookupTableFilePath = [];
    MF_pth = mama_folder_path;
    if MF_pth(end) == '\' || MF_pth(end) == '/'
        [~,MFN,~] = fileparts(MF_pth(1:end-1));
    else
        [~,MFN,~] = fileparts(MF_pth);
    end
    
    
    isMinXYFlow = contains(MFN,'MinXY');
    isXYFlow    = contains(MFN,'XY') && ~isMinXYFlow;
    isStrongAxialFlow = contains(MFN,'StrongAxial');
    isAxialFlow       = contains(MFN,'Axial')&&...
                        ~isStrongAxialFlow;
    isCrossFlow = contains(MFN,'Cross');
    
    
    if isXYFlow
        lookupTableFilePath = fullfile(library_folder_path,...
                              'ReportXY.txt');
    end
    if isMinXYFlow
        lookupTableFilePath = fullfile(library_folder_path,...
                              'ReportMinXY.txt');
    end
    if isAxialFlow
        lookupTableFilePath = fullfile(library_folder_path,...
                              'ReportAxial.txt');
    end
    if isCrossFlow
        lookupTableFilePath = fullfile(library_folder_path,...
                              'ReportCross.txt');
    end
    if isStrongAxialFlow
        lookupTableFilePath = fullfile(library_folder_path,...
                              'ReportStrongAxial.txt');
    end
    
    if isempty(lookupTableFilePath)
        disp('Current mama_folder does not contain the right key word')
        warning('Use Axial flow')
        lookupTableFilePath = fullfile(library_folder_path,...
                              'ReportAxial.txt');
    end

end

%% function: locate waveform lists 
function wvfm_list_file_path = findWvfmFilePath(mama_folder_path)
    MF_pth = mama_folder_path;
    if MF_pth(end) == '\' || MF_pth(end) == '/'
        [temp,MFN,~] = fileparts(MF_pth(1:end-1));
    else
        [temp,MFN,~] = fileparts(MF_pth);
    end
    
    [experiment_path,~,~] = fileparts(temp);
    wvfm_folder_path = fullfile(experiment_path,'000 wvfm list');
    
    if contains(MFN,'_Chopped')
        idx_beforeSuffix = strfind(MFN,'_Chopped')-1;
        MFN_stem = MFN(1:idx_beforeSuffix);
    else
        MFN_stem = MFN;
    end
    
    wvfm_list_file_name = [MFN_stem,'_FlowList.txt'];
    wvfm_list_file_path = fullfile(wvfm_folder_path,wvfm_list_file_name);
end
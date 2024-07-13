%% Doc
% This function take piezo-flow-type of experiment names(YYMMDD cXX)
% e.g. 180717 c1, 181221 c03, and finds which hard disk is the data in.
%
% The reason to write this function is that whether the same disk is O:\ or
% P:\ or Q:\ changes over time, and it is a mess to always locate them
% manually.
%
% input: experiment
% output: experiment_path, such as 'Q:/000 Fast Cam Data/181212 c1/c1/'
%         1. "/" or "\" is added by fullfile() function, so compatible wit both
%            Mac and Windows;
%         2. For backward compatibility, a "/" (not '\') is always added at
%            the end of the path string

function experiment_path = getExperimentPathByExpName(experiment)
    hardDiskList = {'E:','F:','G:','H:','I:','O:' ,'P:','Q:'};
    masterFdName = '000 Fast Cam Data';
    fdSuffix     = {'_Chopped',''}; % '_Chopped' has priority over '' 
    experiment_path = '';
    
    parseStr     = strsplit(experiment,' ');
    %expDate      = parseStr{1};
    cellNo       = parseStr{2};
    
    for i_hd     = 1:numel(hardDiskList)
        hardDisk = hardDiskList{i_hd};
        
        fdpthFount = 0;
        
        for i_suffix = 1:numel(fdSuffix)
            suffix   = fdSuffix{i_suffix};
            fdNameFull   = [cellNo,suffix];
            expPath_temp = fullfile(hardDisk,masterFdName,...
                           experiment,fdNameFull);
            if exist(expPath_temp,'dir')
                experiment_path = [expPath_temp,'/'];
                fdpthFount = 1;
                break
            else % Fdpth does not exist
                expPath_temp = fullfile(hardDisk,'',experiment,fdNameFull);
                % try without using '000 Fast Cam Data' folder
                if exist(expPath_temp,'dir')
                    experiment_path = [expPath_temp,'/'];
                    fdpthFount = 1;
                    break
                end
            end
        end
        if fdpthFount == 1; break; end
    end
end
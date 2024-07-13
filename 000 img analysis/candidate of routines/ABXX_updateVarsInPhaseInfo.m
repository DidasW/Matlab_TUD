AB00_experimentalConditions;
AB00_importExperimentPathList_oda1;

%% Use whatever method to construct a mama_folder_path_list
experiment_path_list  = keepExperimentListByDate(...
                        experiment_path_list,{'190706'});
mama_folder_path_list = formMamaFdList(experiment_path_list,1);
%%                            
Win_size = 1024;          % spectrogram setting, window size
Win_overlap = 512;        % spectrogram setting, window overlap
if Win_overlap>Win_size
    error('ERROR: Spectrogram window overlap > size');
end
freq_range = [0,50];      % Freq. region of interest, usually 40Hz ~ 60Hz


%%
for i_mamafd = 1:numel(mama_folder_path_list)
    
    mama_folder_path   = mama_folder_path_list{i_mamafd};
    [MFN,experiment,~] = parseMamaFolderPath(mama_folder_path);
    fprintf('Updating %s of %s %d/%d\n', MFN,experiment,i_mamafd,33);
    cd(mama_folder_path);
    matfilelist = dir('Folder_*.mat');
    
    for i_mat = 1:numel(matfilelist)
        load(matfilelist(i_mat).name,...
            'ThPh1_unwrapped','ThPh2_unwrapped','Fs');
        flag1_f = smooth(diff(ThPh1_unwrapped)*Fs/2/pi,0.3*Fs);
        flag2_f = smooth(diff(ThPh2_unwrapped)*Fs/2/pi,0.3*Fs);
        save(matfilelist(i_mat).name,'-append','flag1_f','flag1_f');
        fprintf('--- processing %s\n',matfilelist(i_mat).name);  
    end
    
end
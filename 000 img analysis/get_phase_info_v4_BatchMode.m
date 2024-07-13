%%
calculateTheoreticalPhase = 1;      % Whether intra-cyclic phase is 
                                    % of interest.
                                    % 1: calculate theoretical phase, may
                                    %    cost much more time
                                    % 0: Use directly unwrapped Hilbert
                                    %    phase


%% Workspace check
if ~exist('mama_folder_path','var')
   error('Input missing: mama_folder_path') 
end

cd(mama_folder_path);


if ~exist('User defined data.mat','file')
    error('File missing: User defined data.mat') 
end

if ~exist('Flagellar interrogation windows.mat','file')
    error('File missing: Flagellar interrogation windows.mat') 
end

if mama_folder_path(end)=='\' || mama_folder_path(end)=='/'
    mama_folder_path_temp     = mama_folder_path(1:end-1);
else
    mama_folder_path_temp     = mama_folder_path;
end


[temp,MFN,~] = fileparts(mama_folder_path_temp);

if contains(MFN,'_Chopped')
    idx_beforeSuffix = strfind(MFN,'_Chopped')-1;
    MFN = MFN(1:idx_beforeSuffix);
end

[experiment_path,~,~]   = fileparts(temp);
storage_folder_path       = fullfile(experiment_path,'001 phase figure');
if ~exist(storage_folder_path,'dir'); mkdir(storage_folder_path); end
clear temp mama_folder_path_temp
  
SFL     = dir(mama_folder_path);          %Sub Folder List
SFL     = SFL([SFL.isdir]);
SFL(1:2)=[];                              %delelte '..' and '.'
NoFd    = length(SFL);                    %No. of Folderode


%%
load('User defined data.mat',...
     '-regexp',['^(?!(mama_folder_path|SFL|',...
     'NoFd|mama_folder_path_list|i_mamafd)$).']);
load('Flagellar interrogation windows.mat',...
     'mask_1_list'     ,'mask_2_list',...
     'mask_1_size_list','mask_2_size_list',...
     'where_to_find_f_imp','save_figures_or_not')
if ~exist('where_to_find_f_imp','var')
    where_to_find_f_imp='Folder name';
end
if ~exist('save_figures_or_not','var')
    save_figures_or_not='All';
end

 %%
for i1=1:NoFd   
    SFN           = SFL(i1).name;                     % Name (of this folder),Sub Folder Name
    SF_adjusted_path = [fullfile(mama_folder_path,SFN,'adjust'),'/'];
    result_path   = fullfile(mama_folder_path,['Folder_',SFN,'.mat']);
    file_name     = char(file_name_list(i1));         % Filename
    format_string = char(file_format_list(i1));       % Format string
    
    if process_all_img
        NoI       = numel(dir(fullfile(SF_adjusted_path,'*.tif')));
    end
    
    if Win_size>NoI
        warning('Spectrogram window size > NoI, change to 1/2*NoI');
        Win_size = floor(NoI/2);
    end

    white_mask_1 = mask_1_list{i1};
    white_mask_2 = mask_2_list{i1};
    mask_1_size  = mask_1_size_list(i1);
    mask_2_size  = mask_2_size_list(i1);
    compute_and_draw_flagellar_phases_v2;
    if mod(i1,2)==0 % close ~10 figures at once, avoiding overcrowding
        close all
    end

end
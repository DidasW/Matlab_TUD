experiment = '190104c37lc';
AA05_experiment_based_parameter_setting;
NoPos     = length(pt_list);
idx_start = 1;

%% Backward compatibility check
%{
% marked_image_list was the name in the first place
% marked_image_list_list looks odd, so "marked_image_list_cell" was used
% It's too long and confusing, so abbreviation MIL and MIL_list are used
% instead.
% A copy named marked_image_list(_cell) is created at the end, and saved at
% the same time for backwards compatibility
%}
if exist('marked_image_list_cell','var') && ...
   ~exist('MIL_list','var') 
    MIL_list = marked_image_list_cell;
end

%% Backup existing variable and inform user
if exist('MIL_list','var')
    if numel(MIL_list) ~= NoPos
        disp('Find a list of wrong size, re-initialize')
        disp('To avoid reinitialization, stop during the pause')
        pause
        MIL_list = cell(NoPos,1);
    elseif isempty(find(cellfun(@isempty,MIL_list),1)) 
        % no empty element in MIL_list
        disp('Find a full list of proper size, re-initialize')
        disp('To avoid reinitialization, stop during the pause')
        pause
        MIL_list = cell(NoPos,1);
    else % find a list of right size but with empty elements
        disp('Find a half-full list of proper size')
        fillEmptyOnes = ui_multiButtonQuestDlg({'Yes','No'},...
                        'Start from first empty element?')
        switch fillEmptyOnes            
            case 'Yes'
                idx_start = find(cellfun(@isempty,MIL_list),1);
            case 'No'
                idx_start = 1;
        end
    end
elseif exist('marked_image_list_cell','var')
    MIL_list_backup = marked_image_list_cell;
else
    [MIL_list,marked_image_list_cell] = deal(cell(NoPos,1));
end

%% Locate folder for each scenarios (cell-bead positions)
scenario_fdpth = uigetdir(fullfile('D:','001 RAW MOVIES'),...
                'Where to find image sequences for each position');    
subFdList = dir(scenario_fdpth); 
subFdList = subFdList([subFdList.isdir]);
if length(subFdList)>=2; subFdList(1:2) = []; end
if length(subFdList) < NoPos
    disp('Scenario folder does not have enough subfolders')
    scenario_fdpth = uigetdir(fullfile('D:','001 RAW MOVIES'),...
        'Where to find image sequences for each position');
end

%%
for i = idx_start:NoPos
    pt = pt_list(i) %#ok<*NOPTS>
    %% figure out the right folder name
    img_fdpth = [fullfile(scenario_fdpth,...
                 sprintf('%02d_AF',pt)),'\'];
    if ~exist(img_fdpth,'dir')
        warning('Folder name does not contain _AF, already cut?')
        img_fdpth = [fullfile(scenario_fdpth,...
                     sprintf('%02d',pt)),'\'];
    end
    MIL_list{i} = manual_mark_img_sequence(img_fdpth,...
                                '1','%04d',fps,f0);
end

%%
if ~exist('material_fdpth','var')
    material_fdpth = uigetdir(scenario_fdpth,'Where to save the list?');
end
marked_image_list_cell = MIL_list;
save(fullfile(material_fdpth,'all_marked_list.mat'),...
     'marked_image_list_cell','MIL_list');
clear scenario_fdpth

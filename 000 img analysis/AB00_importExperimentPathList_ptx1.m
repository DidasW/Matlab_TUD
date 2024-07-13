%% Doc
% Running this script leaves you an "experiment_path_list" in the workspace
% The exp_path_list can be further refined by:
%     discardExperimentListByDate({'190320','190803'})
%     keepExperimentListByDate({'190320','190803'})
%     discardFolderPathListByKeyWords{'c1',{1803}}
   
%% exp to discard, for Directional Flow Experiments
experiment_list = {...
    '181030 c01', '181030 c02', '181030 c03', '181030 c04',...
    '181030 c05', '181030 c06', '181030 c07', '181030 c08'...
    '181030 c09', '181130 c1' , '181130 c2', '181130 c3',...
    '181130 c4',  '181130 c5'};

%% confirm existence and swap hard drive 
experiment_path_list = {};
N_defined = numel(experiment_list);
for i_exp = 1:N_defined
    experiment = experiment_list{i_exp};
    exp_path = getExperimentPathByExpName(experiment);
    if isempty(exp_path)
        fprintf('Cannot find %s\n',experiment);
    else
        experiment_path_list = vertcat(experiment_path_list,exp_path);
    end
end

N_exist   = numel(experiment_path_list);
fprintf('%d experiment defined, %d exist\n',N_defined,N_exist)
clear idx_pathNotExist experiment_path%%

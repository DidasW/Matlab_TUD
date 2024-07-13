function mama_folder_path_list = formMamaFdList(experiment_path_list,...
                                 includeNoFlowFolder)
    N_exp = numel(experiment_path_list);
    MFPL = {};
    for i_exp = 1:N_exp
        experiment_path = experiment_path_list{i_exp};
        if exist(experiment_path,'dir')
            subFdStruct = dir(experiment_path);
            subFdStruct = subFdStruct([subFdStruct.isdir]);
            subFdStruct(1:2) = [];
            if includeNoFlowFolder == 0
                idx_noFlow = find(strcmp({subFdStruct.name},'00NoFlow'));
                subFdStruct(idx_noFlow) = []; %#ok<FNDSB>
            end
            for i_flow = 1:numel(subFdStruct)
                MFPL{numel(MFPL)+1} = [fullfile(experiment_path,...
                                       subFdStruct(i_flow).name),'\'];
            end
        end
    end
    mama_folder_path_list = MFPL;
end
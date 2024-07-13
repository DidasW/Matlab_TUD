function experiment_path_list = discardExperimentListByDate(...
                                experiment_path_list,...
                                sixDigitsDateCell)
    idx_keep = ~contains(experiment_path_list,sixDigitsDateCell);
    experiment_path_list=experiment_path_list(idx_keep);
end
                        
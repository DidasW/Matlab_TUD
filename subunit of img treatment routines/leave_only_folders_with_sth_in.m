% This function removes all the elements which are not directory from SFL
% don't use parfor in this case, will cost 1000 times more time
function SFL = leave_only_folders_with_sth_in(SFL_raw,mama_folder_path)

SFL_raw(~[SFL_raw.isdir]) = [];

folder_is_empty = zeros(length(SFL_raw),1);
for i = 1:length(SFL_raw)
    folder_is_empty(i)= isempty(dir(fullfile(...
                        mama_folder_path,SFL_raw(i).name,'*.tif')));
end
SFL_raw(logical(folder_is_empty)) = [];
SFL = SFL_raw;
end


% This function removes all the elements which are not directory from SFL
% don't use parfor in this case, will cost 1000 times more time
function SFL = leave_only_folders(SFL_raw)
len = length(SFL_raw);
is_folder = zeros(len,1);
folder_has_tif = zeros(len,1);
for i = 1:len
    is_folder(i) = SFL_raw(i).isdir;
    is_content_folder(i) = isempty()
end
SFL_raw(logical(~is_folder + ~folder_has_tif)) = [];
SFL = SFL_raw;
end


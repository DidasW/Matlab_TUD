% this function checks whehter all the folders in the SFL has at least NoI
% or N_section images.
function check_image_amount(SFL,NoI,input_name) %Sub Folder List, No. of Images
    NoFd = length(SFL); % No. of Folder
    NoI_each_Fd = zeros(NoFd,1);
    for i = 1:NoFd
        tif_file_list = dir(fullfile(SFL(i).name,'*.tif'));
        NoI_each_Fd(i)= length(tif_file_list);
    end
    [NoI_min,min_index] = min(NoI_each_Fd);
    if NoI>NoI_min
        error_message = sprintf('%s too large, subfolder %s only has %d file',...
                                input_name,SFL(min_index).name,NoI_each_Fd(min_index));
        error(error_message);
    end
end
    
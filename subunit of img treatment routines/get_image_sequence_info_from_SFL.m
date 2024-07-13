% This function gives lists in which the filenames, image sequence format
% and number of image are stored, in respect to a subfolder name list
% struct
% NOTE that the input is a struct array.
% NOTE that the output are two cell array and their elements can only be
%       used as a string by char() operation. 
%2016-09-26: parfor saves ~53% running time

function [file_name_list,file_format_list,...
        image_number_list,FF_name_list,img_size_list] = get_image_sequence_info_from_SFL(SFL)
% FF: First File
NoFd = length(SFL);
image_number_list = zeros(NoFd,1);    %store the number of .tif files per folder

file_name_list   = cell(NoFd,1);     %initialization
file_name_list(:)={'1'};

file_format_list   = cell(NoFd,1); 	
file_format_list(:)={'%04d'};       %rumor says that preallocation is faster

FF_name_list   = cell(NoFd,1); 	
FF_name_list(:)={'1_0001.tif'};

img_size_list = zeros(NoFd,2);

for i = 1:NoFd
    file_struct_list   = dir(fullfile(SFL(i).name,'*.tif'));
    image_number_list(i)= length(file_struct_list);
    FF_name = file_struct_list(1).name;
    FF_name_list(i) = {FF_name};
    
    FF_name_and_format = strsplit(FF_name,'_'); 
    
    format_raw = FF_name_and_format(end);
    format_length = length(char(format_raw));
       
    file_name    = FF_name(1:end-format_length-1); %last -1 is the '_' between file_name and format_raw
    file_name_list(i) = {file_name};
        
    if strcmp(format_raw,'0001.tif')
        file_format_list(i) = {'%04d'};
    end
    if strcmp(format_raw,'000001.tif')
        file_format_list(i) = {'%06d'};
    end    
    
    img_temp = imread([SFL(i).name,'\',char(FF_name_list(i))]);
    if length(size(img_temp)) == 3
        img_size_list(i,:) = size(img_temp(:,:,1));
    else
        img_size_list(i,:) = size(img_temp);
    end
end

function full_file_name = construct_file_name(file_name,index,format_string)
        full_file_name = [file_name,'_',num2str(index,format_string),'.tif'];
end
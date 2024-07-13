function [first_file_suffix,format_string] = first_file_name(NoI,file_type)
%is this a help file?
    if NoI>10000
        first_file_suffix = ['_000001','.',file_type];
        format_string = '%06d';
        % return the format string for the image names.       
    else
        first_file_suffix = ['_0001','.',file_type];
        format_string = '%04d';
    end
end
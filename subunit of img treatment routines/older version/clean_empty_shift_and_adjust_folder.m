function clean_empty_shift_and_adjust_folder()
if exist('shift','dir')
    if isempty(dir(['shift','*.tif']));
        delete('shift')
    end
end

if exist('adjust','dir')
    if isempty(dir(['adjust','*.tif']));
        delete('adjust')
    end
end

end
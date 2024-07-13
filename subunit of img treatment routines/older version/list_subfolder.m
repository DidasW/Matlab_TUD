function SFNL = list_subfolder(mama_folder_path)
    content = dir(mama_folder_path);
    SFNL = [];
    for i = [1:length(content)]
        name = content(i).name;
        if exist([mama_folder_path,name],'dir')
            criterion1 = strcmp(name,'.');
            criterion2 = strcmp(name,'..');
            invalid_folder_name = criterion1+criterion2;
            if ~invalid_folder_name
                if name(end)=='0'
                    %get rid of the 0 at the end by rename the whole
                    %directory
                    valid_name = str2num(name);
                    valid_name_str = num2str(valid_name);
                    if ~strcmp(valid_name_str,name)               
                        movefile([mama_folder_path,name],...
                                 [mama_folder_path,valid_name_str]);% rename
                    end
                end
                SFNL=[SFNL;str2num(name)];
                % e.g. ...\12.10\ would generate an element 12.1, which
                %   doesn't exist as a folder. 
                % e.g.2: ...\12.0\ would be a more tricky case. thus I use str2num
                %   as a filter, FIRST TO RENAME ALL THE FOLDERS
                % e.g.3: ...\3000\ valid_name_str = name, then 'rename'
                %   would fail
            end
        end
    end
end
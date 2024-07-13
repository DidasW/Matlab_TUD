pt_list_temp = [];
if exist('pt_list','var')
    switch class(pt_list)
        case 'char'
            if strcmp(pt_list,'ExtractFromFilenames') && ...
               exist('rawdata_AF_struct','var')
                
                disp('Extract pt_list from file names.')
                for i_file = 1:numel(rawdata_AF_struct)
                    filename   = rawdata_AF_struct(i_file).name;
                    temp       = strsplit(filename,'_');
                    posStr     = temp{3};
                    pos        = str2double(posStr(4:end));
                    pt_list_temp = [pt_list_temp,pos];
                end
                pt_list = pt_list_temp;
            end
        case 'double'
            if isempty(pt_list)
                error('pt_list is empty')
            end
    end
end
clearvars temp posStr posCode pt_list_temp
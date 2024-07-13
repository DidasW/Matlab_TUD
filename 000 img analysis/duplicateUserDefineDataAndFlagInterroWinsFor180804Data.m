UDD_filepath = 'F:\180804\180804\User defined data.mat';
FIW_filepath = 'F:\180804\180804\Flagellar interrogation windows.mat';

putToPath    = 'F:\180804\180804_Chopped';
fdList       = dir(putToPath);
fdList       = fdList([fdList.isdir]); fdList(1:2)=[];
fdNameList   = {fdList.name};

for i_Fd = 1:numel(fdList)
    load(UDD_filepath,...
        'mama_folder_path','SFL','NoFd',...
        'file_name_list','file_format_list','image_number_list',...
        'ref_img_idx_list','FFFN_list','img_size_list',...
        'ref_point_list','CBnP_mask_list','crop1_list','crop2_list',...
        'NoI','Fs','section_size',...
        'process_all_img','to_save_all_shift','to_save_all_adjust',...
        'Fs','Ts','jsize','isize','dim','sigma','gauss_filter',...
        'section_size')
    
    load(FIW_filepath,...
        'mask_1_list'     ,'mask_2_list',...
        'mask_1_size_list','mask_2_size_list',...
        'where_to_find_f_imp','save_figures_or_not')
    
    
    
    fdName = fdNameList{i_Fd};
    choppedFdList = dir(fullfile(putToPath,fdName));
    choppedFdList = choppedFdList([choppedFdList.isdir]); 
    choppedFdList(1:2)=[];
    NoChoppedFd = numel(choppedFdList);
    
    temp1 = cell(NoChoppedFd,1);
    temp1(:) = file_name_list(i_Fd);
    file_name_list = temp1;
    
    temp1(:) = file_format_list(i_Fd);
    file_format_list = temp1;
    
    temp1(:) = FFFN_list(i_Fd);
    FFFN_list = temp1;
    
    temp1(:) = CBnP_mask_list(i_Fd);
    CBnP_mask_list = temp1;
    
    temp1(:) = mask_1_list(i_Fd);
    mask_1_list = temp1;
    
    temp1(:) = mask_2_list(i_Fd);
    mask_2_list = temp1;
    
    clear temp1
    
    %% These are wrong values
    temp2 = zeros(NoChoppedFd,1);
    temp2(:) = ref_img_idx_list(i_Fd);
    ref_img_idx_list = temp2;
    
    temp2(:) = image_number_list(i_Fd);
    image_number_list = temp2;
    
    %% Correct values
    temp2(:) = mask_1_size_list(i_Fd);
    mask_1_size_list = temp2;
    
    temp2(:) = mask_2_size_list(i_Fd);
    mask_2_size_list = temp2;
    
    clear temp2
    
    temp3 = zeros(NoChoppedFd,2);
    temp3(:,1) = img_size_list(i_Fd,1);
    temp3(:,2) = img_size_list(i_Fd,2);
    img_size_list = temp3;
    
    temp3 = zeros(NoChoppedFd,2);
    temp3(:,1) = ref_point_list(i_Fd,1);
    temp3(:,2) = ref_point_list(i_Fd,2);
    ref_point_list = temp3;
    
    clear temp3
    
    temp4 = zeros(NoChoppedFd,4);
    temp5 = temp4;
    for i_col = 1:4
        temp4(:,i_col) = crop1_list(i_Fd,i_col);
        temp5(:,i_col) = crop2_list(i_Fd,i_col);
    end
    crop1_list = temp4;
    crop2_list = temp5;
    
    clear temp4 temp5
    
    save(fullfile(putToPath,fdName,'User defined data.mat'),...
        'mama_folder_path','SFL','NoFd',...
        'file_name_list','file_format_list','image_number_list',...
        'ref_img_idx_list','FFFN_list','img_size_list',...
        'ref_point_list','CBnP_mask_list','crop1_list','crop2_list',...
        'NoI','Fs','section_size',...
        'process_all_img','to_save_all_shift','to_save_all_adjust',...
        'Fs','Ts','jsize','isize','dim','sigma','gauss_filter',...
        'section_size')
    save(fullfile(putToPath,fdName,'Flagellar interrogation windows.mat'),...
        'mask_1_list'     ,'mask_2_list',...
        'mask_1_size_list','mask_2_size_list',...
        'where_to_find_f_imp','save_figures_or_not')
    
    
end
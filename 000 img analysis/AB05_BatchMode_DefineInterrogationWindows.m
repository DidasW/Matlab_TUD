clc
% AB00_importExperimentPathList_oda1;
% experiment_path_list  = keepExperimentListByDate(...
%                         experiment_path_list,{'190728'});
% mama_folder_path_list = formMamaFdList(experiment_path_list,1);
mama_folder_path_list = {...
        'F:\013 MutantSlipRate\mstg 190110 c38-c39\c38\',...
        'F:\013 MutantSlipRate\mstg 190110 c38-c39\c39\',...
        'F:\013 MutantSlipRate\mstg 190214 c40-c43\c40b1\',...
        'F:\013 MutantSlipRate\mstg 190214 c40-c43\c41b2\',...
        'F:\013 MutantSlipRate\mstg 190214 c40-c43\c42b3\',...
        'F:\013 MutantSlipRate\mstg 190214 c40-c43\c43b4\',...
        'F:\013 MutantSlipRate\mstg 190315 c48-c50\c48b1\',...
        'F:\013 MutantSlipRate\mstg 190315 c48-c50\c49b3\',...
        'F:\013 MutantSlipRate\mstg 190315 c48-c50\c50b5\',...
        'F:\013 MutantSlipRate\mstg 180821 c3m-c5m\c3m\',...
        'F:\013 MutantSlipRate\mstg 180821 c3m-c5m\c4m\',...
        'F:\013 MutantSlipRate\mstg 180821 c3m-c5m\c5m\',...
        'F:\013 MutantSlipRate\cw15 190429 c51-c53\190428 c 51\',...
        'F:\013 MutantSlipRate\cw15 190429 c51-c53\190428 c52\',...
        'F:\013 MutantSlipRate\cw15 190429 c51-c53\190428 c53\',...
        'F:\013 MutantSlipRate\cw15 190224 c44-c47\190224\c44b1\',...
        'F:\013 MutantSlipRate\cw15 190224 c44-c47\190224\c44b2\',...
        'F:\013 MutantSlipRate\cw15 190224 c44-c47\190224\c45b3\',...
        'F:\013 MutantSlipRate\cw15 190224 c44-c47\190224\c46b5\',...
        'F:\013 MutantSlipRate\cw15 190224 c44-c47\190224\c46b6\',...
        'F:\013 MutantSlipRate\cw15 190224 c44-c47\190224\c47b7\',...
        'F:\013 MutantSlipRate\cw15 190224 c44-c47\190224\c47b8\',...
        'F:\013 MutantSlipRate\cw15 100810 c1c-c3c\c1c\',...
        'F:\013 MutantSlipRate\cw15 100810 c1c-c3c\c2c\',...
        'F:\013 MutantSlipRate\cw15 100810 c1c-c3c\c3c\',...
        'F:\013 MutantSlipRate\cw15 181009 c5c-c7c\181009 c5c\',...
        'F:\013 MutantSlipRate\cw15 181009 c5c-c7c\181009 c6c\',...
        'F:\013 MutantSlipRate\cw15 181009 c5c-c7c\181009 c7c\',...
        'F:\013 MutantSlipRate\cw15 190604 c57-c60\c57b1\',...
        'F:\013 MutantSlipRate\cw15 190604 c57-c60\c58b2\',...
        'F:\013 MutantSlipRate\cw15 190604 c57-c60\c59b3\',...
        'F:\013 MutantSlipRate\cw15 190604 c57-c60\c60b4\'}
%% settings
where_to_find_f_imp ='No imposed freq.';
%                    'Folder name';
%                    'No imposed freq.'
%                    'Spectrum selection';
%                    'Manual input';

% FIW: Flagellar Interrogation Window
defineFIWByChoppedSequence = 'No';  % 'Yes'/'No'

save_figures_or_not = 'All';

%% adopt settings
% switch where_to_find_f_imp
%     case 'No imposed freq.'
%         MFPL = keepFolderPathListByKeyWords(mama_folder_path_list,...
%                {'00NoFlow','99Deflag'});
%     case 'Folder name'
%         MFPL = discardFolderPathListByKeyWords(mama_folder_path_list,...
%                {'00NoFlow','99Deflag'});
% end
% mama_folder_path_list  = MFPL;      

switch defineFIWByChoppedSequence
    case 'No'
        fprintf('Define FIW based on img sequences before chopping\n')
        mama_folder_path_list = erase(mama_folder_path_list,'_Chopped');
    case 'Yes'
        fprintf('Define FIW based on chopped img sequences\n')
end            

clc; disp(mama_folder_path_list');
pause()

%% execute
for i_mamafd = 17: numel(mama_folder_path_list)
    tic
    mama_folder_path = mama_folder_path_list{i_mamafd}
    cd(mama_folder_path);
    
    load('User defined data.mat',...
        '-regexp',...
        '^(?!(mama_folder_path|SFL|NoFd|mama_folder_path_list)$).');
    
    MFN_temp= strsplit(mama_folder_path,'\'); % MFN: mama_folder_name
    MFN     = char(MFN_temp(end-1)); clear MFN_temp
    SFL     = dir(mama_folder_path);          %Sub Folder List
    SFL     = SFL([SFL.isdir]);
    SFL(1:2)=[];                              %delelte '..' and '.'         
    NoFd    = length(SFL);                    %No. of Folderode

    %%
    mask_1_list   = cell(NoFd,1);% mask for first defined flagella, a list for all the folders
    mask_2_list  =  cell(NoFd,1);% for the second one.
    for i0 = 1:NoFd              % Initialize a cell array to store masks
        mask_1_list(i0) = {zeros(img_size_list(i0,:))};
        mask_2_list(i0) = {zeros(img_size_list(i0,:))};
    end
    mask_1_size_list   = zeros(NoFd,1);
    mask_2_size_list   = zeros(NoFd,1);
    
    %%
    
    
    for i1=1:NoFd
    
        SFN           = SFL(i1).name;                     % Name (of this folder),Sub Folder Name
        SF_adjusted_path = fullfile(mama_folder_path,SFN,'adjust');
        result_path   = [mama_folder_path,'Folder_',SFN,'.mat'];
        file_name     = char(file_name_list(i1));         % Filename
        format_string = char(file_format_list(i1));       % Format string
        if process_all_img
            NoI       = image_number_list(i1);            % NoI
        end

        
        %% 2  Define two masks
        define_two_interrogation_windows;
        
        white_mask_1 = 1-mask_1;
        white_mask_2 = 1-mask_2;
        mask_1_list(i1) = {white_mask_1};
        mask_2_list(i1) = {white_mask_2};
        mask_1_size = sum(white_mask_1(:));
        mask_2_size = sum(white_mask_2(:));
        mask_1_size_list(i1) = mask_1_size;
        mask_2_size_list(i1) = mask_2_size;
        
    end

    
    %%
    save('Flagellar interrogation windows.mat',...
        'mask_1_list'     ,'mask_2_list',...
        'mask_1_size_list','mask_2_size_list',...
        'where_to_find_f_imp','save_figures_or_not')
    
    toc
    

end
 
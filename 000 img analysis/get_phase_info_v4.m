%% Doc is moved to the end

%%
close all
clc %add this path
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))

%% 1. Initialization 
%%
mama_folder_path = [uigetdir('D:\','SELECT VIDEO FILE FOLDER'),'/'];
% mama_folder_path=[('O:\VIDEO ANALYSIS'),'/']; %folder with the image sequences  % Manual input
cd(mama_folder_path);
MFN_temp= strsplit(mama_folder_path,'/'); % MFN: mama_folder_name
MFN     = char(MFN_temp(end-1)); clear MFN_temp
SFL     = dir(mama_folder_path);          %Sub Folder List
SFL(1:2)=[];                              %delelte '..' and '.'
SFL     = SFL([SFL.isdir]);          
NoFd    = length(SFL);                    %No. of Folderode

%%                            
Win_size = 512;              %spectrogram setting, window size
Win_overlap = 256;           %spectrogram setting, window overlap
if Win_overlap>Win_size
    error('ERROR: Spectrogram window overlap > size');
end

%%
%Camera acquisition frequency
Fs=561.82;   Ts=1/Fs;
%Plot parameters
freq_range = [35,100];      %Freq. region of interest, usually 40Hz ~ 60Hz


%% 

if exist('User defined data.mat','file')
    load_or_not =  questdlg('User defined data found, load it?',...
                   'Load or not','Remap','Load','Load');             
    if strcmp(load_or_not,'Load')
        load('User defined data.mat',...
             '-regexp','^(?!(mama_folder_path|Fs|Ts|SFL|NoFd)$).');
              % variables not to load
    else
        [file_name_list,file_format_list,...
         image_number_list,    FFFN_list,...
         img_size_list        ] = get_image_sequence_info_from_SFL(SFL);
        % FFFN: First File Full Name
        [NoI,process_all_img  ] = ask_user_all_phase_extraction(SFL,...
                                    NoFd,Fs,Win_size,Win_overlap);
    end
end

%% where to look for the imposed frequency, if any
where_to_find_f_imp = ui_where_to_find_f_imp ; 

%% Save phase plots
save_figures_or_not = questdlg('Save all figures?',... % question message   
                               'Tell me', ...          % dialogue title
                               'All','None',...        % Button names
                               'All');
if strcmp(save_figures_or_not,'All')
    storage_folder_path = [...
        uigetdir(mama_folder_path,'Save the figures to...'),'/'];
end


%% Load defined interrogation windows
load_or_not2 = 'Redo';
if exist('Flagellar interrogation windows.mat','file')
    load_or_not2 =...
    questdlg('Find defined interrogation windows, load?',...%
             'Load or not','Redo','Load','Load');
    if strcmp(load_or_not2,'Load')
        load('Flagellar interrogation windows.mat',...
             'mask_1_list'     ,'mask_2_list',...
             'mask_1_size_list','mask_2_size_list')
    else
       
        
        mask_1_list   = cell(NoFd,1);% mask for first defined flagella, a list for all the folders
        mask_2_list  =  cell(NoFd,1);% for the second one.
        for i0 = 1:NoFd              % Initialize a cell array to store masks
            mask_1_list(i0) = {zeros(img_size_list(i0,:))};
            mask_2_list(i0) = {zeros(img_size_list(i0,:))};
        end
        mask_1_size_list   = zeros(NoFd,1);
        mask_2_size_list   = zeros(NoFd,1);
        %%
        fig_position    = [0.15 0.15 0.7 0.7];
        R1_button_position = [0.8, 0.45, 0.15, 0.1];
        L1_button_position = [0.05,0.45, 0.15, 0.1];
        L2_button_position = L1_button_position - [0,0.2,0,0];
        L3_button_position = L2_button_position - [0,0.2,0,0];
        M1_button_position = L3_button_position + [0.2,0,0,0];
    end
     process_data_when=...
            questdlg('Process data now or later?',...
            'What to do','Now','Later','Later');
else
    process_data_when=...
    questdlg('Process data now or later?',...%
             'What to do','Now','Later','Later');
end


for i1= 1:NoFd
    
    SFN           = SFL(i1).name;                     % Name (of this folder),Sub Folder Name
    SF_adjusted_path = [mama_folder_path,SFN,'/','adjust/'];
    result_path   = [mama_folder_path,'Folder_',SFN,'.mat'];
    file_name     = char(file_name_list(i1));         % Filename
    format_string = char(file_format_list(i1));       % Format string
    if process_all_img
        NoI       = image_number_list(i1);            % NoI
    end
    
    if Win_size>NoI
        warning('Spectrogram window size > NoI, change to 1/2*NoI');
        Win_size = floor(NoI/2);
    end

    %% 2  Define two masks
    switch load_or_not2
        case 'Redo'
            define_two_interrogation_windows;
            
            white_mask_1 = 1-mask_1;  
            white_mask_2 = 1-mask_2;
            mask_1_list(i1) = {white_mask_1};  
            mask_2_list(i1) = {white_mask_2};
            mask_1_size = sum(white_mask_1(:)); 
            mask_2_size = sum(white_mask_2(:));
            mask_1_size_list(i1) = mask_1_size; 
            mask_2_size_list(i1) = mask_2_size;
        case 'Load'
            white_mask_1 = mask_1_list{i1};
            white_mask_2 = mask_2_list{i1};
            mask_1_size  = mask_1_size_list(i1); 
            mask_2_size  = mask_2_size_list(i1);
    end
    
    if strcmp(process_data_when,'Later')
        continue % don't process now
    end
    %% 3. Extract phase info. from imgs.   
    compute_and_draw_flagellar_phases_v2;
    if mod(i1,4)==0 % close ~20 figures at once, avoiding overcrowding
        close all
    end
end

if ~exist('Flagellar interrogation windows.mat','file')
    save('Flagellar interrogation windows.mat',...
         'mask_1_list'     ,'mask_2_list',...
         'mask_1_size_list','mask_2_size_list',...
         'where_to_find_f_imp','save_figures_or_not')
end



%% DONOT README
%%%%%%%%%%%%%%%%%%%%%%%%%HISTORY OF THIS ROUTINE%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Greta Quaranta wrote the code in the first place (v0). 
% User is asked to select two windows where the each flagellum swipes once
% per cycle. The sum of gray scale is then used to get the info of
% synchrony. Essentially, it is the flagella's changing in speed and 
% beating slightly out of focus that change the pixel value, and in the end
% relected by a scalar signal.
% 
% 2016-03-30, a copy of code was passed to Da. The code was organized to 
% enhance readability.
% 
% 2016-10-11, Da started to put in some user interface. f_imp problem is 
% solved, compatibility added and functions for readability. Also added is
% an 'instantaneous frequency' calculation unwrapped flagellar phase. (v2)
%
% 2018-06-30, mask definition is extracted as another routine. Phase
% computation too. This aims at a batch processing mode. (v3, v3_Batch)
%
% 2018-09-21, previous calculated unwrapped flagellar phase is realized to 
% be inaccurate for t<t_cycle. An update in algorithm (PRE 77,066205(2008))
% is made. compute_and_draw_flagellar_phases_v2 now has such feature and
% other redundant outputs are deleted. (v4, v4_Batch)

%%%%%%%%%%%%%%%%%%%%%%NOMINATION AND CODING RULES%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 0. Rule of thumb: READABILITY comes first.
% 1. Names:
%       * Try to name only in uncap. letters.
%       * '_' means space in the variable names.
%       * Capital letters are mostly used as abbreviations (abbr.).
%       * Abbr. will have its full name immediately written after.
%       * Explanation repeat in each .m file once. 
%       * All the folder paths are ended with '/'.
%       * Folder path with '_rel' means 'relative filepath', avoidit
% 2. 'tic','toc',time are put with no indentation, followed by its meaning.
% 3. Avoid
%       * exposure of petty operation, wrap them up in functions with
%         readable names.
%       * cd() operation. It will slow things down and confuse user 
% 
%----------------------------------- 
%% README
%%%%%%%%%%%%%%%%%%%%%%%%%HISTORY OF THIS ROUTINE%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Greta Quaranta wrote the seminal code in the first place, thus v0. It was
% used to 1) shift thousands of images with respect to a reference
% point, 2) crop a part of the image, which contains usually only the pair  
% of beating flagella,3)and do median filtering, background subtraction and
% contrast enhancement.
% 
% Around 2016-03-30, a copy of code was passed to Da. Modifications are made
% in order to improve readability and user friendliness (which is a kind of
% nonsense). That makes the v1.
%
% Around 2016-09-23, Da had a shortconnected wire in his brain, thus he
% started this v2, rewrote codes into different functions, tried to
% use parallel image analysis.
%
% 2016-10-11, before committing suicide, Da finalized this version as v2.2.
% Load-Manipulation-Save strategy together with the usage of RAM are
% optimized (to a certain degree). Parfor loop are selectively used.
% After testing both on local drive or portable hardisk, it should be 2~3
% times faster than before.





%%%%%%%%%%%%%%%%%%%%%%NOMINATION AND CODING RULES%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 0. Rule of thumb: READABILITY comes first.
% 1. Names:
%       * Try to name only in uncap. letters.
%       * '_' means space in the variable names.
%       * Capital letters are mostly used as abbreviations (abbr.).
%       * Abbr. will have its full name immediately written after.
%       * Explanation repeat in each .m file once. 
%       * All the folder pathes are ended with '/'.
%       * Folder path with '_rel' means 'relative filepath', avoidit
% 2. 'tic','toc',time are put with no indentation, followed by its meaning.
% 3. Avoid
%       * exposure of petty operation, wrap them up in functions with
%         readable names.
%       * cd() operation. It will slow things down and confuse user 
% 
%-----------------------------------



%% 1.PARAMETERS INITIALIZATION

% run(fullfile('D:','002 MATLAB codes','000 Routine',...
%     'subunit of img treatment routines','add_path_for_all.m'))
close all
% clc
% mama_folder_path = [uigetdir('D:\001 RAW MOVIES\180619 cell 1, asymmetric flow load\','SELECT VIDEO FILE FOLDER'),'\'];
% mama_folder_path=[('O:\VIDEO ANALYSIS'),'\']; %folder with the image sequences  % Manual input
cd (mama_folder_path);

SFL     = dir(mama_folder_path);         %Sub Folder List
SFL(1:2)= [];                            %delelte '..' and '.'
SFL     = leave_only_folders_with_sth_in(SFL,mama_folder_path);          
NoFd    = length(SFL);                   %No. of Folder
             


%% 1.1 Mode selection
% input_mode = questdlg('Where to find all the user defined parameters?',... 
%                          'Select input mode',...    % dialogue title
%                          'Interactive','Load',...   % Button names
%                          'Interactive');            % default choice 
input_mode = 'Load';
if strcmp(input_mode,'Load')
    if exist('User defined data.mat','file')
        load('User defined data.mat','-regexp',...
            '^(?!(mama_folder_path|SFL|mama_folder_path_list)$).');
        input_mode = 'Load';
        else
        input_mode = 'Interactive';
        warning('Predefined data does not exist, switch to Interactive mode');
    end
end

        

%% 2.INTERACTIVE DEFINITION OF ALL THE PARAMETERS
if strcmp(input_mode,'Interactive') %User defines all the parameters   
    
    %Other settings
    Fs = 801.42; Ts=1/Fs  ;
    %interrogation window size
    jsize = 40 ; isize= 60;

    dim  = 5   ; sigma= 3 ;
    gauss_filter = fspecial('gaussian',dim, sigma);

    section_size= 500; %sectioning for parallel computing
    run('user_define_module.m');
end   



%% 3. Processing
WB_process = waitbar(0,'','Name','Processing'); %Wait_Bar_shift
for i2 = 1:NoFd
%% 3.1 Initialization              
    %% Prepare folder info. 
    SFN           = SFL(i2).name;               % Sub Folder Name
    SF_path = [mama_folder_path,SFN,'\'];
    
t_total = 0;
tic;  % timer starts
    fileID = fopen([SF_path,'time consumption.dat'],'w');
    
    ref_point     = ref_point_list(i2,:);        % Ref. point coordinates
    if process_all_img
        NoI       = image_number_list(i2);       
    end
    file_name     = char(file_name_list(i2));    
    format_string = char(file_format_list(i2));  

    ref_img_idx             = ref_img_idx_list(i2);% Reference image index
    ref_img                 = imread([SF_path,file_name,'_',...
                             num2str(ref_img_idx,format_string),'.tif']);
    if numel(size(ref_img)) ==3; ref_img =ref_img(:,:,1); end 
    ref_img =  mat2gray(ref_img);
    
                                                   % Reference image     
    [img_size_1,img_size_2] = size(ref_img);       
                                                      
    CBnP_mask = cell2mat(CBnP_mask_list(i2));                                                            
    crop1 = crop1_list(i2,:);                      % Region of interest
    crop2 = crop2_list(i2,:);                      % Region to sample noise
    y_from = max([1,floor(crop1(2))]);             
    y_to   = min([img_size_1,ceil(crop1(2)+crop1(4))]);                      
    x_from = max([1,floor(crop1(1))]); 
    x_to   = min([img_size_2,ceil(crop1(1)+crop1(3))]);     
    cropped_CBnP_mask = CBnP_mask(y_from:y_to,x_from:x_to);    
                                                   % CBnP mask - crop1 region      
    %% Prepare sectioning
    folded_list = sectioning_num_list_to_matrix(1,NoI,section_size);   
    Tot_NoSect = size(folded_list,2);                 % Total number of Sections   
    
    u = cell(Tot_NoSect,1);                           % Vectors recording shifts 
    v = cell(Tot_NoSect,1);                           % u for x, v for y    
    for i_sect = 1 : Tot_NoSect %Initialization
        sublist = folded_list(:,i_sect);
        sublist(sublist==0)= [];                 % delete zero padding in the list
        len = length(sublist);                   % e.g.: 3500 imgs with 1000-file sectioning
                                                 % last len = 500
        u(i_sect) = {zeros(len,1)};
        v(i_sect) = {zeros(len,1)};
    end
    
    
    %% Prepare subfolders and waitbar
    if to_save_all_shift~=0
        if exist([SF_path,'shift'],'dir')==0
            mkdir([SF_path,'shift']);
        end
    end
    
    if to_save_all_adjust~=0
        if exist([SF_path,'adjust'],'dir')==0
            mkdir([SF_path,'adjust']);
        end
    end
        
    waitbar((i2-1)/NoFd,WB_process,{sprintf('Processing Fd: %s',SFN);...
                                    sprintf('%% %.1f',(i2-1)/NoFd*100)});
                                  
t1 = toc; % t1: initialization
%% 3.2 Loading     
    for i_sect = 1 : Tot_NoSect     %%%%%%Never put parfor here%%%%%%%%%%%%
tic; 
        sublist = folded_list(:,i_sect);
        sublist(sublist==0)= [];                           
        len = length(sublist);      
        
        if i_sect~=1                % this mess roots in the fact that we need a "(len+1)" batch for shifting, which will give a "len" batch of img whose background were subtracted by diff()
            sublist_shift   = cat( 1, sublist(1)-1, sublist);
            len_shift       = length(sublist_shift); 
        else
            sublist_shift   = sublist;
            len_shift       = len;
        end
        
        img_batch_uint8 = zeros(img_size_1,img_size_2,len_shift,'uint8'); 

        for i_load = 1:len_shift
            full_file_name             = construct_file_name(file_name,...
                                         sublist_shift(i_load),...
                                         format_string);
            I = imread([SF_path,full_file_name],'tif');
            if numel(size(I)) == 3; I = I(:,:,1);end 
            img_batch_uint8(:,:,i_load) = I;
        end
        
        img_batch = mat2gray(img_batch_uint8);
        clear img_batch_uint8
t2=toc; % t2: loading        
tic;
%% 3.3 Shifting        
        [img_batch,u_sect,v_sect] = frame_shift_v3_1_par(i_sect,img_batch,...
                                    sublist_shift,ref_point,SF_path,...
                                    file_name,format_string,ref_img,...
                                    to_save_all_shift,...%<------- to save or not        
                                    [jsize,isize]);      %<------- interrogation window size   
                                    % load img batch into workspace
                                    % shift them, output shifting                                 
        u(i_sect) = {u_sect};
        v(i_sect) = {v_sect};
        
        t3 = toc; % t3: shift
        tic;
        
        
%% 3.4 Cropping
        cropped_img_batch = img_batch(y_from:y_to,x_from:x_to,:);  
        clear img_batch
               
%% 3.5 Gaussian filter
       
        for i_S = 1:size(cropped_img_batch,3)       % index of Subtracting (background)
            cropped_img_batch(:,:,i_S) = imfilter(...
                                         cropped_img_batch(:,:,i_S),...
                                         gauss_filter); 
        end
        
        
%% 3.6 Subtract background by diff(), enhance meaningful info. by abs()
%         dif_CIB = diff(cropped_img_batch,1,3); %CIB : Cropped Image Batch
        dif_CIB = abs(diff(cropped_img_batch,1,3));
        clear cropped_img_batch
        
%% 3.7 Masking out region
        for i_mask = 1:size(dif_CIB,3)       % index of Masking out CBnP
            dif_CIB(:,:,i_mask) = dif_CIB(:,:,i_mask).*cropped_CBnP_mask;
        end
        t4 = toc; % t4: crop and subtrac background  
        tic;

        
%% 3.8 Sampling noise and adjust the img
       
        adjusted_img_batch = sample_noise_and_adjust_v2_1(...
                             dif_CIB,i_sect,sublist,crop2,SF_path,...
                             file_name,format_string,to_save_all_adjust);     
        clear dif_CIB
        
        t5 = toc; % t5: adjust and save
        t_total = t_total+t2+t3+t4+t5;
        fprintf(fileID,'%d\t%.4f\t%.4f\t%.4f\t%.4f\r\n',...
                i_sect,t2,t3,t4,t5);

    end      
   
    fprintf(fileID,'%.4f\r\n',t1);
    fclose(fileID);    
    
    t_total = t_total + t1;
    disp(time_report(NoI,SFN,t_total,'process'));%last argument is the key word to display
    save([SF_path,'shift vs time.mat'],'u','v');
   
    
end 
delete(WB_process);






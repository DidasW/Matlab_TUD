%% README
%%%%%%%%%%%%%%%%%%%%%%%%%HISTORY OF THIS ROUTINE%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Greta Quaranta wrote the seminal code in the first place (v0). 
% User is asked to select two windows where the each flagellum swipes once
% per cycle. The sum of gray scale is then used to get the info of
% synchrony
% 
% 2016-03-30, a copy of code was passed to Da. The code was organized to 
% enhance readability.
% 
% 2016-10-11, Da started to put in some user interface, solve the f_imp problem
% adding compatibility, make functions into subunits, and add an 'instantaneous 
% frequency' calculation based on the extracted hibert-phase. v2
%
% 2018-06-30, mask definition is extracted as another routine. This will
% enable batach process. 


%%%%%%%%%%%%%%%%%%%%%%NOMINATION AND CODING RULES%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 0. Rule of thumb: READABILITY comes first.
% 1. Names:
%       * Try to name only in uncap. letters.
%       * '_' means space in the variable names.
%       * Capital letters are mostly used as abbreviations (abbr.).
%       * Abbr. will have its full name immediately written after.
%       * Explanation repeat in each .m file once. 
%       * All the folder pathes are ended with '\'.
%       * Folder path with '_rel' means 'relative filepath', avoidit
% 2. 'tic','toc',time are put with no indentation, followed by its meaning.
% 3. Avoid
%       * exposure of petty operation, wrap them up in functions with
%         readable names.
%       * cd() operation. It will slow things down and confuse user 
% 
%-----------------------------------

close all
clear all 
clc %add this path
addpath('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines')


%% 1. Initialization 
%%
mama_folder_path = [uigetdir('D:\001 RAW MOVIES\180619 cell 1, asymmetric flow load\XY flow\','SELECT VIDEO FILE FOLDER'),'\'];
% mama_folder_path=[('O:\VIDEO ANALYSIS'),'\']; %folder with the image sequences  % Manual input
cd (mama_folder_path);
MFN_temp = strsplit(mama_folder_path,'\'); % MFN: mama_folder_name
MFN      = char(MFN_temp(end-1));
clear MFN_temp
SFL=dir(mama_folder_path);              %Sub Folder List
SFL(1:2)=[];                            %delelte '..' and '.'
SFL = leave_only_folders_with_sth_in(SFL,mama_folder_path);          
NoFd=length(SFL);                       %No. of Folder

%%                            
Win_size = 512;              %spectrogram setting, window size
Win_overlap = 256;            %spectrogram setting, window overlap
if Win_overlap>Win_size
    error('ERROR: Spectrogram window overlap > size');
end

%%
%Camera acquisition frequency
Fs=964.54;   Ts=1/Fs;
%Plot parameters
freq_range = [20,100];      %Freq. region of interest, usually 40Hz ~ 60Hz


%%
if exist('User defined data.mat','file')
    load_or_not =  questdlg('User defined data found, load it?',...% question message   
                         'Load or not',...    % dialogue title
                         'Remap','Load',...   % Button names
                         'Load');             % default choice 
    if strcmp(load_or_not,'Load')
        load('User defined data.mat','-regexp','^(?!(mama_folder_path|Fs|Ts|SFL|NoFd)$).');%don't load mama_folder,Fs and Ts
    else
        [file_name_list,file_format_list,...
         image_number_list,    FFFN_list,...
         img_size_list        ] = get_image_sequence_info_from_SFL(SFL);
        % FFFN: First File Full Name
        [NoI,process_all_img  ] = ask_user_all_phase_extraction(SFL,NoFd,Fs,Win_size,Win_overlap);
    end
end

%%
where_to_find_f_imp = ui_where_to_find_f_imp ; 

%%
save_figures_or_not = questdlg('Save all figures?',... % question message   
                               'Tell me', ...          % dialogue title
                               'All','None',...        % Button names
                               'All');
if strcmp(save_figures_or_not,'All')
    storage_folder_path = [uigetdir(mama_folder_path,'Save the figures to...'),'\'];
end


%%
mask_1_list   = cell(NoFd,1);% mask for first defined flagella, a list for all the folders
mask_2_list  =  cell(NoFd,1);% for the second one.
for i0 = 1:NoFd              % Initialize a cell array to store masks
    mask_1_list(i0) = {zeros(img_size_list(i0,:))};
    mask_2_list(i0) = {zeros(img_size_list(i0,:))};
end

mask_1_size_list   = zeros(NoFd,1);
mask_2_size_list   = zeros(NoFd,1);

fig_position    = [0.15 0.15 0.7 0.7];  
R1_button_position = [0.8, 0.45, 0.15, 0.1];
L1_button_position = [0.05,0.45, 0.15, 0.1];
L2_button_position = L1_button_position - [0,0.2,0,0];
L3_button_position = L2_button_position - [0,0.2,0,0];
M1_button_position = L3_button_position + [0.2,0,0,0];



%% 2  Define two masks
for i1=1:NoFd
    
    SFN      = SFL(i1).name;                          % Name (of this folder),Sub Folder Name
    SF_adjusted_path  =     [mama_folder_path,SFN,'\','adjust\'];
    matfilepath = [mama_folder_path,'Folder_',SFN,'.mat'];
    %% 2.1 Prepare a img
    
    fig_user_define = figure('NumberTitle','off','Units','normalized');  
    setappdata(gcf,'blackout_img',[]);
    setappdata(gcf,'black_mask' ,[]);  
    setappdata(gcf,'ref_img_idx',1);
    
    file_name     = char(file_name_list(i1));         % Filename
    format_string = char(file_format_list(i1));       % Format string 
    first_img_path = fullfile(SF_adjusted_path,char(FFFN_list(i1)));
%     
%     img_size_1    = img_size_list(i1,1);              % Img size
%     img_size_2    = img_size_list(i1,2);
    if process_all_img
        NoI       = image_number_list(i1);            % NoI
    end
    
    if Win_size>NoI
        warning('Spectrogram window size > NoI, change to 1/2*NoI');
        Win_size = floor(NoI/2);
    end
    
   
    I_user_def = imread(first_img_path);
    imshow(I_user_def);
    
    %% 2.2 Select a img to deine mask
    set(gcf,'Name',sprintf('Folder %s, Define first mask',SFN),'Position',fig_position);
    [next_img_button,...
     previous_img_button]     = ui_display_other_img(SF_adjusted_path,file_name,format_string,...
                                                     R1_button_position,L1_button_position);    
    
    %% 2.3 Define the first mask
    tell_user                 = ui_show_message_in_figure('Find a good img and define the 1st mask');
    define_mask_button        = ui_define_new_mask(L3_button_position);
       
    uiwait(gcf);
    blackout_img = getappdata(gcf,'blackout_img');
    mask_1       = getappdata(gcf, 'black_mask' );
    
    delete(tell_user);
    imshow(blackout_img);
       
    %% 2.4 Define the second mask
    tell_user = ui_show_message_in_figure('Define the 2nd mask');   
    uiwait(gcf);
    
    blackout_img = getappdata(gcf,'blackout_img');
    mask_2   = getappdata(gcf, 'black_mask' );
    imshow(blackout_img);
    
    delete(tell_user); 
    close(gcf);
    
    white_mask_1 = 1-mask_1           ;  white_mask_2 = 1-mask_2;
    mask_1_list(i1) = {white_mask_1}  ;  mask_2_list(i1) = {white_mask_2};
    mask_1_size = sum(white_mask_1(:));  mask_2_size = sum(white_mask_2(:));               
    mask_1_size_list(i1) = mask_1_size;  mask_2_size_list(i1) = mask_2_size;
    
    
 %% 3. Extract phase info. from imgs.   
    flag1raw=zeros(NoI,1);                          %_flag: flagellum(a)
    flag2raw=zeros(NoI,1);
    tic
    for i_read=1:NoI-1                              % No. of adjusted img. = NoI - 1, due to diff()
        full_file_name = construct_file_name(file_name,i_read,format_string);
        current_img    = im2double(imread([SF_adjusted_path,full_file_name],'tif'));
        
        flag1window   = current_img.*white_mask_1;
        flag2window   = current_img.*white_mask_2;
 
        flag1raw(i_read) = sum(flag1window(:))/mask_1_size; 
        flag2raw(i_read) = sum(flag2window(:))/mask_2_size;
    end
    toc
    [flag1,dif_flag1,A_Ph1, H_Ph1,...
     H_Ph1_filt, accu_Ph1,flag1_f] = phase_info_flow_chart(flag1raw,Fs);
    [flag2,dif_flag2,A_Ph2, H_Ph2,...
     H_Ph2_filt, accu_Ph2,flag2_f] = phase_info_flow_chart(flag2raw,Fs);

    
%% 4. Showing results
    %% Figure 1: frequency spectrum of flagella motion
    [f1,pow1]=fft_mag(H_Ph1,Fs);
    [f2,pow2]=fft_mag(H_Ph2,Fs);
    fig_fft_spec = plot_flag_fft(f1,pow1,f2,pow2,SFN);

    
    %% Figure 2: find synchrony between flag. and imposed signal
    switch where_to_find_f_imp
        case 'Folder name'  
            f_imp = str2double(SFN);
        case 'Spectrum selection'
            f_imp = find_f_imp_from_fig(f1,pow1);
        case 'Manual input'
            f_imp_raw =  inputdlg('What is the imposed freq?');
            f_imp = str2double(f_imp_raw{1});
        case 'No imposed freq.'
    end
    if ~strcmp(where_to_find_f_imp,'No imposed freq.')
        [t_imp_interp1,d_H_Ph1_interp]  =  compare_with_imposed_phase(H_Ph1,Fs,f_imp);
        [t_imp_interp2,d_H_Ph2_interp]  =  compare_with_imposed_phase(H_Ph2,Fs,f_imp);
        % _interp: interpolation
        % d_     : difference from (imposed phase);
        % output a united time-axis for the signal and the imposed frequence
        fig_entrainment        =  plot_external_entrainment(t_imp_interp1,d_H_Ph1_interp,...
                                                   t_imp_interp2,d_H_Ph2_interp,SFN);
    end
    
    
    %% Figure 3: find synchrony between flag.
    [t_interflag_interp,...
        Ph_interflag_interp]   =  compare_phase_between_flag(H_Ph1,H_Ph2,Fs);
    fig_Ph_dif_interflag       =  plot_Ph_dif_interflag(t_interflag_interp,Ph_interflag_interp,SFN);
    
    
    %% Figure 4: Spectrogram
    [fig_spectrogram,...
          f_spectrogram_1,t_Win_1,PSD_Win_1,...
          f_spectrogram_2,t_Win_2,PSD_Win_2    ] = plot_spectrogram(H_Ph1,H_Ph2,Win_size,Win_overlap,Fs,SFN,freq_range);   
      
      
    %% Figure 5: Freq. of each flag. vs. t, FFT_based
    if ~strcmp(where_to_find_f_imp,'No imposed freq.')
        fig_f_vs_t_FFT_based   = plot_flag_f_vs_t_FFT_based(f_spectrogram_1,PSD_Win_1,t_Win_1,...
                                                            f_spectrogram_2,PSD_Win_2,t_Win_2,...
                                                            f_imp,SFN,freq_range);
    else
        fig_f_vs_t_FFT_based   = plot_flag_f_vs_t_FFT_based(f_spectrogram_1,PSD_Win_1,t_Win_1,...
                                                            f_spectrogram_2,PSD_Win_2,t_Win_2,...
                                                              0,  SFN,freq_range);    
    end
    
    
    %% Figure 6: Freq. of each flag. vs. t, accumulated phase based
    if ~strcmp(where_to_find_f_imp,'No imposed freq.')
        fig_f_vs_t_accu_Ph_based = plot_flag_f_vs_t_accu_Ph_based(flag1_f,flag2_f,Fs,f_imp,SFN,freq_range);
    else
        fig_f_vs_t_accu_Ph_based = plot_flag_f_vs_t_accu_Ph_based(flag1_f,flag2_f,Fs,    0,SFN,freq_range);
    end
        
    
    %% Save and finish 
    clear('PSD_Win_1','PSD_Win_2','marked_black_img','CBnP_mask_list');
    close(fig_spectrogram);
    save(matfilepath);
    
   
    
    if strcmp(save_figures_or_not,'All')
        storage_full_path = [storage_folder_path,MFN,'\'];
        if ~exist(storage_full_path,'dir')
            mkdir(storage_full_path)
        end
        print(fig_fft_spec   ,         [storage_full_path,'FFT spec, Fd_',SFN,'.png'],'-dpng','-r180');
        print(fig_Ph_dif_interflag,    [storage_full_path,'Interflag Ph dif, Fd_',SFN,'.png'],'-dpng','-r180');
        print(fig_f_vs_t_FFT_based,    [storage_full_path,'Flag freq(FFT), Fd_',SFN,'.png'],'-dpng','-r180');
        print(fig_f_vs_t_accu_Ph_based,[storage_full_path,'Flag freq(Instant), Fd_',SFN,'.png'],'-dpng','-r180');
        if exist('fig_entrainment','var')
            print(fig_entrainment,     [storage_full_path,'External entrainment, Fd_',SFN,'.png'],'-dpng','-r180');
        end
    end
    
    if mod(i1,4)==0 % close ~20 figures at once, avoiding overcrowding
        close all
    end
end
 
%% DONT READ ME
%%%%%%%%%%%%%%%%%%%%%%%%%HISTORY OF THIS ROUTINE%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sometimes programming can be addictive. Da started to do this around
% 2016-10-01. Learned a lot about making a user interface.

%% READ ME
% this module will create a user interface to inquire the user about the
% definition of reference point, crop range etc. regarding each folder;
% lastly it will save such data under mama_folder, serving other routines.

%% 2.1 Preallocation of all the user defined settings
[NoFd,NoI,Fs,section_size,...
process_all_img,to_save_all_shift,...
                to_save_all_adjust] = ask_user_all(SFL,NoFd,Fs,section_size);

[file_name_list,file_format_list,...
image_number_list,FFFN_list,...  % FFFN: First File Full Name
                    img_size_list]  = get_image_sequence_info_from_SFL(SFL);
                
ref_point_list  = zeros(NoFd,2);        
ref_img_idx_list= zeros(NoFd,1); %reference img index list
                                 %the figure on which the ref. points
                                 %are defined

CBnP_mask_list   = cell(NoFd,1);% Cell Body and Pipette mask boudary list
for i0 = 1:NoFd             % Initialize a cell array to store masks
    CBnP_mask_list(i0) = {zeros(img_size_list(i0,:))};
end

crop1_list = zeros(NoFd,4); % Crop the region of interest (containing flag.)
crop2_list = zeros(NoFd,4); % Subregion in rect1_list to sample noise
                            % the 4-element vector is [xmin ymin width height] 

fig_position    = [0.15 0.15 0.7 0.7];  
R1_button_position = [0.8, 0.45, 0.15, 0.1];
L1_button_position = [0.05,0.45, 0.15, 0.1];
L2_button_position = L1_button_position - [0,0.2,0,0];
L3_button_position = L2_button_position - [0,0.2,0,0];
M1_button_position = L3_button_position + [0.2,0,0.20,0];
C1_button_position = [0.33,0.05,0.15,0.1];
C2_button_position = [0.52,0.05,0.15,0.1];


%% 2.2 Start definition
for i1=1:NoFd                       %i1 is the first loop index
    try 
        figure(fig_user_define)
    catch
        fig_user_define = figure('NumberTitle','off','Units','normalized');  
    end
    setappdata(gcf,'ref_img_idx',1);
    setappdata(gcf,'ref_point',[-1,-1]);
    setappdata(gcf,'blackout_img',[]);
    setappdata(gcf, 'black_mask' ,[]);  
    
    SFN = SFL(i1).name;             %Sub Folder Name
    file_name     = char(file_name_list(i1));         % Filename
    format_string = char(file_format_list(i1));       % Format string 
    img_size_1    = img_size_list(i1,1);        % Img size
    img_size_2    = img_size_list(i1,2);
    first_img_path = fullfile(SFN,char(FFFN_list(i1)));

    I_user_def = imread(first_img_path);
    imshow(I_user_def);

    
    %% Select a good img and define reference point
    set(gcf,'Name',sprintf('Folder %s, define a Ref. point',SFN),...
        'Position',fig_position);
    tell_user = ui_show_message_in_figure('Select a Ref. Point');

    [next_img_button,...
     previous_img_button]     = ui_display_other_img([SFN,'\'],file_name,...
                                format_string,R1_button_position,...
                                L1_button_position);    
    if i1 > 1 
        previous_marker_button= ui_previous_ref_point(...
                                M1_button_position,ref_point_list(i1-1,:));
    end
    ref_point_button          = ui_define_new_ref_point(jsize,isize,...
                                fig_position,L2_button_position); 
                                %this sends uiresume(gcf)
    
    uiwait(gcf);  
    
    ref_point_list(i1,:)  = getappdata(gcf,'ref_point');
    ref_img_idx_list(i1)  = getappdata(gcf,'ref_img_idx');
    delete([next_img_button,previous_img_button,...
            ref_point_button,tell_user]);
    if i1 > 1
        delete(previous_marker_button);
    end
      
    %% Define the masks for cell body and pipette 
    set(gcf,'Name',sprintf('Folder %s, define a mask,',SFN));
    tell_user = ui_show_message_in_figure(...
                'L-click to define a cell-pipe-mask, others to end');      
    
    define_mask_button        = ui_define_new_mask(L1_button_position,...
                                'polygon');
    if i1>1 
        prev_black_mask       = cell2mat(CBnP_mask_list(i1-1));
        show_prev_mask_button = ui_show_prev_mask(...
                                prev_black_mask,L3_button_position);
        use_prev_mask_button  = ui_use_prev_mask (...
                                prev_black_mask,M1_button_position);
                                % this also contains uiresume(gcf)
    end

    uiwait(gcf);
    
    %% Show current markings
    blackout_img = getappdata(gcf,'blackout_img');
    black_mask   = getappdata(gcf, 'black_mask' );
    CBnP_mask_list(i1) = {black_mask};
    
    if isappdata(gcf,'previous_crop1') && isappdata(gcf,'previous_crop2')
        previous_crop1  = getappdata(gcf,'previous_crop1');
        previous_crop2  = getappdata(gcf,'previous_crop2');
        
        blackout_img     = insertShape (blackout_img,'Rectangle',...
                                        previous_crop1,'LineWidth',1);
        second_rect_position = previous_crop2 + [previous_crop1(1:2),0,0]; 
        blackout_img     = insertShape(blackout_img,'Rectangle',...
                               second_rect_position,'LineWidth',1);
    end
    
    imshow(blackout_img);
    
    delete([define_mask_button,tell_user]);
    if i1>1 
        delete([use_prev_mask_button,show_prev_mask_button]);
    end

    
    %% Define region of interest and region to sample noise 
    use_previous_crops = 0;
    if isappdata(fig_user_define,'previous_crop1') &&...
       isappdata(fig_user_define,'previous_crop2')
        [yes_button,no_button] = ui_use_previous_crops(fig_user_define,...
                                  C1_button_position,C2_button_position);
        uiwait(fig_user_define);
        use_previous_crops =  getappdata(fig_user_define,...
                                         'use_previous_crops');
        delete(yes_button);
        delete(no_button);
    end
    if use_previous_crops
        crop1_list(i1,:) = getappdata(gcf,'previous_crop1');
        crop2_list(i1,:) = getappdata(gcf,'previous_crop2');
    else
    %% ROI
        set(gcf,'Name',sprintf('Folder %s, define region of interest',SFN));
        tell_user = ui_show_message_in_figure(...
                    'Define region of interest, 1st crop;'); 
        [I_flag_and_background, crop1_list(i1,:)]=imcrop(gcf);   
        
        %crop on the current figure
        delete(tell_user);
        setappdata(gcf,'previous_crop1',crop1_list(i1,:));


        %% Region of noise 
        fig_second_crop = figure('NumberTitle','off','Name',...
                         'Define noise sampling region, do not include flag.');
        [~, crop2_list(i1,:)]=imcrop(I_flag_and_background);
        close(fig_second_crop);
        setappdata(gcf,'previous_crop2',crop2_list(i1,:));
    end

    
    %% Before going to the next folder, a preview
    figure(fig_user_define);
    % show all the user-defined features.
    marked_black_img     = insertShape (blackout_img,'Rectangle',...
                                        crop1_list(i1,:),'LineWidth',2);
    second_rect_position = crop2_list(i1,:) + [crop1_list(i1,1:2),0,0]; 
    marked_black_img     = insertShape(marked_black_img,'Rectangle',...
                           second_rect_position,'LineWidth',2);
    marked_black_img     = surprise_me_after_cropping(marked_black_img,...
                           second_rect_position(1:2)+...
                           second_rect_position(3:4)); %<--- a stupid joke

    imshow(marked_black_img);
    tell_user            = ui_show_message_in_figure(...
                            {'Result preview';'Click to continue'});                   


    
    %% end this folder session
    waitforbuttonpress;
    clf(fig_user_define);
    if i1 == NoFd
        close(fig_user_define)
        save([mama_folder_path,'User defined data.mat'],...
        'mama_folder_path','SFL','NoFd',...
        'file_name_list','file_format_list','image_number_list',...
        'ref_img_idx_list','FFFN_list','img_size_list',...
        'ref_point_list','CBnP_mask_list','crop1_list','crop2_list',...
        'NoI','Fs','section_size',...
        'process_all_img','to_save_all_shift','to_save_all_adjust',...
        'Fs','Ts','jsize','isize','dim','sigma','gauss_filter',...
        'section_size')
    
           
    end     
end   
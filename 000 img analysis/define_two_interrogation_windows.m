%% 2.1 Prepare a img
fig_position    = [0.15 0.15 0.7 0.7];  
R1_button_position = [0.8, 0.45, 0.15, 0.1];
L1_button_position = [0.05,0.45, 0.15, 0.1];
L2_button_position = L1_button_position - [0,0.2,0,0];
L3_button_position = L2_button_position - [0,0.2,0,0];
M1_button_position = L3_button_position + [0.28,0,0.20,0];
C1_button_position = [0.33,0.05,0.15,0.1];
C2_button_position = [0.52,0.05,0.15,0.1];

fig_user_define = figure('NumberTitle','off','Units','normalized');
setappdata(gcf,'blackout_img',[]);
setappdata(gcf,'black_mask' ,[]);
setappdata(gcf,'ref_img_idx',1);

first_img_path = fullfile(SF_adjusted_path,char(FFFN_list(i1)));
I_user_def = imread(first_img_path);
imshow(I_user_def);

%% 2.2 Select a img to deine mask
set(gcf,'Name',sprintf('Folder %s, Define first mask',SFN),...
    'Position',fig_position);
[next_img_button,...
    previous_img_button]     = ui_display_other_img(...
                               SF_adjusted_path,file_name,format_string,...
                               R1_button_position,L1_button_position);

%% 2.3 Define the first mask
tell_user                 = ui_show_message_in_figure(...
                            'Find a good img and define the 1st mask');
define_mask_button        = ui_define_new_mask(M1_button_position);
if isappdata(gcf,'previou_mask_1') && isappdata(gcf,'previou_mask_2')
    ui_show_previous_masks()
    ui_use_previous_masks()
end
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

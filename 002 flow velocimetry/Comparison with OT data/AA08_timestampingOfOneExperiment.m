experiment = '180903c22a2';
AA05_experiment_based_parameter_setting;
imgAF_fdpth = 'D:\001 RAW MOVIES\180903\c3b3_AF\';
NoPos = length(pt_list);
if ~exist('marked_image_list_cell','var')
    marked_image_list_cell = cell(NoPos,1);
elseif numel(marked_image_list_cell) ~= NoPos
    disp('re-initiate a marked list, if not wanted ,cancel during pause')
    pause
    marked_image_list_cell = cell(NoPos,1);
end
for i = 1:NoPos
    pt = pt_list(i)
    img_fdpth = fullfile(imgAF_fdpth,...
                 [sprintf('%02d_AF',pt),'/']);
    marked_image_list_cell{i} = manual_mark_img_sequence(img_fdpth,...
                                '1','%04d',fps,f0);
                            
end

%% Adding more marks to one pos
% pt = 10;
% img_fdpth = ['D:\001 RAW MOVIES\180419\c1b1_AF\',...
%              sprintf('%02d_AF',pt),'\'];
% newlyMarked = manual_mark_img_sequence(img_fdpth,'1','%04d','FirstImgIndex',1);
% old_marked_list = marked_image_list_cell{pt};
% new_marked_list = unique([old_marked_list;newlyMarked]);


%%
save(fullfile(material_fdpth,'all_marked_list.mat'),...
     'marked_image_list_cell');

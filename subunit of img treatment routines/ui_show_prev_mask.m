function show_prev_mask_button = ui_show_prev_mask(prev_black_mask,button_position) 

show_prev_mask_button = uicontrol('Style','Pushbutton','String','Show prev. mask',...
                                  'Units','normalized','Position',button_position,...
                                  'Fontsize',15,'FontWeight','bold','BackgroundColor','w',...
                                  'Callback',{@cast_opaque_mask,prev_black_mask});
                                                                    
    function cast_opaque_mask(~,~,black_mask)
        img_all = getimage(gcf);
        img     = mat2gray(img_all(:,:,end));
        opaque_mask = black_mask;
        opaque_mask(black_mask==0) = 0.5;
        opaque_img = img.*opaque_mask;
        set(gcf,'Units','normalized','Nextplot','add');
        imshow(opaque_img);
    end

end
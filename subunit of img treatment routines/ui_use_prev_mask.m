function use_prev_mask_button = ui_use_prev_mask(prev_black_mask,button_position) 

use_prev_mask_button = uicontrol('Style','Pushbutton','String','Use prev. mask',...
                                  'Units','normalized','Position',button_position,...
                                  'Fontsize',15,'FontWeight','bold','BackgroundColor','w',...
                                  'Callback',{@cast_black_mask,prev_black_mask});

    function cast_black_mask(~,~,black_mask)
        setappdata(gcf,'black_mask',black_mask);  
        img_all = getimage(gcf);
        img     = mat2gray(img_all(:,:,end));
        blackout_img = img.*black_mask;
        setappdata(gcf,'blackout_img',blackout_img);
        uiresume(gcf);
    end

end
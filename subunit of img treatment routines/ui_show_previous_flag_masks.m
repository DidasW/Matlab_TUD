function button = ui_show_previous_flag_masks(button_position)
    button = uicontrol('Style','Pushbutton',...
                    'String','Show prev. mask','Units','normalized',...
                    'Position',button_position,'Fontsize',15,...
                    'FontWeight','bold','BackgroundColor','w',...
                    'Callback',@cast_invert_mask);
                                                                    
    function cast_invert_mask(~,~)
        img_all = getimage(gcf);
        img     = mat2gray(img_all(:,:,end));
        img(black_mask==0) = 1 - img(black_mask==0);
        set(gcf,'Units','normalized','Nextplot','add');
        imshow(img);
    end
end
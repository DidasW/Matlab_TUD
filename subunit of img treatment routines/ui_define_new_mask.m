function define_mask_button = ui_define_new_mask(button_position,varargin)
    mask_click_mode = '';
    if ~isempty(varargin)
        mask_click_mode = varargin{1};
    end
    
    switch mask_click_mode
        case 'circle'
            define_mask_button = uicontrol(...
                'Style','Pushbutton','String','Define new mask',...
                'Units','normalized','Position',button_position,...
                'Fontsize',12,'FontWeight','bold','BackgroundColor','w',...
                'Callback',@define_new_mask_circle);
        case 'polygon'
            define_mask_button = uicontrol(...
                'Style','Pushbutton','String','Define new mask',...
                'Units','normalized','Position',button_position,...
                'Fontsize',12,'FontWeight','bold','BackgroundColor','w',...
                'Callback',@define_new_mask_polygon);
        otherwise     
            define_mask_button = uicontrol(...
                'Style','Pushbutton','String','Define new mask',...
                'Units','normalized','Position',button_position,...
                'Fontsize',12,'FontWeight','bold','BackgroundColor','w',...
                'Callback',@define_new_mask_circle);
    end

    function define_new_mask_circle(~,~)
        [blackout_img,black_mask,~] = ui_make_mask_by_mouse_click('circle');
        setappdata(gcf,'blackout_img',blackout_img);
        setappdata(gcf, 'black_mask' ,black_mask);
        uiresume(gcbf);
    end
    
    function define_new_mask_polygon(~,~)
        [blackout_img,black_mask,~] = ui_make_mask_by_mouse_click('polygon');
        setappdata(gcf,'blackout_img',blackout_img);
        setappdata(gcf, 'black_mask' ,black_mask);
        uiresume(gcbf);
    end                               
end
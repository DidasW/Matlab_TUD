function draw_marker_button = ui_draw_marker(button_position)

draw_marker_button   = uicontrol('Style','Pushbutton','String','Draw a marker',...
                                'Units','normalized','Position',button_position,...
                                'Fontsize',15,'FontWeight','bold','BackgroundColor','w',...
                                'Callback',{@ui_show_marker});

                            
function ui_show_marker(~,~)
    [X_temp,Y_temp,mouse_click] = ginput(1);
    if mouse_click == 1                    % proceed if it's L-click
        img_all    = getimage(gcf);
        img        = img_all(:,:,end);
        [img_size_1,img_size_2] = size(img);
         if X_temp>=1 && X_temp<=img_size_2 &&...
            Y_temp>=1 && Y_temp<=img_size_1% proceed if the click is within the img
            hold on
            plot(X_temp,Y_temp,'y+','MarkerSize',10);
        end
    end
end
                              
                              

end

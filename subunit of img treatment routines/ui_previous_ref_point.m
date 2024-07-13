function previous_marker_button = ui_previous_ref_point(button_position,last_marker)
previous_marker_button = uicontrol('Style','Pushbutton','String','Show last marker',...
                                'Units','normalized','Position',button_position,...
                                'Fontsize',15,'FontWeight','bold','BackgroundColor','w',...
                                'Callback',{@ui_show_given_marker,last_marker});
function ui_show_given_marker(~,~,given_coordinate)
    X_temp = given_coordinate(1);
    Y_temp = given_coordinate(2);
    img_all    = getimage(gcf);
    img        = img_all(:,:,end);
    [img_size_1,img_size_2] = size(img);
     if X_temp>=1 && X_temp<=img_size_2 &&...
        Y_temp>=1 && Y_temp<=img_size_1% proceed if the click is within the img
        hold on
        plot(X_temp,Y_temp,'y+','MarkerSize',12);
    end
end
                            
end

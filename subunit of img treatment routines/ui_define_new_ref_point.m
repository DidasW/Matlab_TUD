function ref_point_button = ui_define_new_ref_point(jsize,isize,fig_position,button_position)


ref_point_button   = uicontrol('Style','Pushbutton','String','Define Ref Point',...
                               'Units','normalized','Position',button_position,...
                               'Fontsize',15,'FontWeight','bold','BackgroundColor','w',...
                               'Callback',{@ui_show_valid_marker,jsize,isize,fig_position});
guidata(ref_point_button,[-1,-1]); %initialization
                           
function ui_show_valid_marker(~,~,jsize,isize,fig_position)
    [X_temp,Y_temp,mouse_click] = ginput(1);
    if mouse_click == 1                    % proceed if it's L-click
        img_all    = getimage(gcf);
        img        = img_all(:,:,end);
        [img_size_1,img_size_2] = size(img);
        if X_temp-isize/2>=0 && X_temp+isize/2<=img_size_2 &&...
           Y_temp-jsize/2>=0 && Y_temp+jsize/2<=img_size_1 
                                           % proceed if the interro window
                                           % is within the img
       
            hold on
            plot(X_temp,Y_temp,'yx','MarkerSize',12);
            interro_win_poistion = [X_temp-isize/2,Y_temp-jsize/2,isize,jsize];
             % Interrogation Window Position

            marked_img = insertShape(img,'Rectangle',interro_win_poistion,...
                                     'LineWidth',1,'Color','w');

            setappdata(gcf,'ref_point',[X_temp,Y_temp]);  
            imshow(marked_img);
            set(gcf,'Units','normalized','Position',fig_position);              
            uiresume(gcf);
        end
    end
end

end

% This function creates two button on the left and right side of the image
%  the current image index is stored in the button handle and can be
%  extracted by guidata(next_button)

function [next_img_button,...
          prev_img_button] = ui_display_other_img(...
                               img_fdpth,file_name,...
                               format_str,NextButtonPos,...
                               PrevButtonPos)

next_img_button   =  uicontrol('Style','Pushbutton','String','Next Img',...
                     'Units','normalized','Position',NextButtonPos,...
                     'Fontsize',12,'FontWeight','bold','BackgroundColor','w',...
                     'Callback',{@next_img,img_fdpth,file_name,format_str});

prev_img_button   =  uicontrol('Style','Pushbutton','String','Prev Img',...
                     'Units','normalized','Position',PrevButtonPos,...
                     'Fontsize',12,'FontWeight','bold','BackgroundColor','w',...
                     'Callback',{@prev_img,img_fdpth,file_name,format_str});
                 
    function next_img(~,~,img_fdpth,file_name,format_str)
        %% update current_img_idx
        current_img_idx = getappdata(gcf,'ref_img_idx');
        next_img_path   = fullfile(img_fdpth,...
                          [file_name,'_',...
                          num2str(current_img_idx+1,format_str),...
                          '.tif']);
        next_img_exist = exist(next_img_path,'file');
        if next_img_exist
            next_img      = imread(next_img_path);
        else
            next_img_path = fullfile(img_fdpth,...
                            [file_name,'_',...
                             num2str(current_img_idx,format_str),...
                            '.tif']);
            next_img      = imread(next_img_path);
        end
        %% show current img
        set(gcf,'Nextplot','add');
        imshow(next_img); % this current img should be the just-loaded "next image"
        fig_name = get(gcf,'Name');
        temp     = strsplit(fig_name,'|');
        fig_name = char(temp(1)); clear temp;    

        if next_img_exist
            fig_name = [fig_name,'| No.',num2str(current_img_idx+1)];
            setappdata(gcf,'ref_img_idx',current_img_idx+1);        
        else
            fig_name = [fig_name,'| No.',num2str(current_img_idx)];
        end
        set(gcf,'Name',fig_name);
    end
    function prev_img(~,~,img_fdpth,file_name,format_str)
    %% update current_img_idx
    current_img_idx = getappdata(gcf,'ref_img_idx');  
    if current_img_idx > 1 
        previous_img_path = fullfile(img_fdpth,...
                            [file_name,'_',...
                            num2str(current_img_idx-1,format_str),...
                            '.tif']);
        previous_img      = imread(previous_img_path);
    else 
        previous_img_path = fullfile(img_fdpth,[file_name,'_',...
                            num2str(1,format_str),'.tif']);
        previous_img      = imread(previous_img_path);
    end
    
    %% show current img
    set(gcf,'Nextplot','add');
    fig_name = get(gcf,'Name');
    temp     = strsplit(fig_name,'|');
    fig_name = char(temp(1)); clear temp;
    
    if current_img_idx > 1
        setappdata(gcf,'ref_img_idx',current_img_idx-1);
        imshow(previous_img);
        fig_name = [fig_name,'| No.',num2str(current_img_idx-1)];
        set(gcf,'Name',fig_name);
    else
        setappdata(gcf,'ref_img_idx',1);
        fig_name = [fig_name,'| No.1'];
        set(gcf,'Name',fig_name);
    end
end                  


end

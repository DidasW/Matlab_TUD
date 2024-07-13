%define a polygonal/circular mask by clicking mouse on the current img or
%another particular image
function [blackout_img,black_mask,mask_size] =...
                                    ui_make_mask_by_mouse_click(mode,img)
    
    switch nargin
    case 0
        current_fig = gcf;
        figure(current_fig);
        img_all = getimage(current_fig);
        img = img_all(:,:,end);
        [size1,size2] = size(img);
        mode = 'polygon';
    case 1
        current_fig = gcf;
        figure(current_fig);
        img_all = getimage(current_fig);
        img = img_all(:,:,end);
        [size1,size2] = size(img);
    case 2
        try
            imshow(img);
            [size1,size2] = size(img);
        catch
            current_fig = gcf;
            figure(current_fig);
            img_all = getimage(current_fig);
            img = img_all(:,:,end);
            [size1,size2] = size(img);
        end
    end
hold on ;

switch mode
    case 'polygon'
        X = zeros(999);Y = zeros(999);

        % Note the Y axis on the screen for the img is actually horizontal axis of
        % the image matrix. Thus we denote size1(2) instead of sizex(y). X and Y
        % are names defined from user's perspective.
        for i = 1:999
            [x_temp,y_temp,mouse_click] = ginput(1);

            %if a point is close to the edge, set it on the edge   
            if x_temp<10  && x_temp>=0.5               
                x_temp = 1;
            elseif size2 - x_temp < 10 && x_temp <= size2
                x_temp = size2;
            end

            if y_temp<10 && y_temp>=0.5
                y_temp = 1;
            elseif size1 - y_temp < 10 && y_temp <= size1
                y_temp = size1;
            end

            if x_temp<=size2 && x_temp>=1 && y_temp<=size1 && y_temp>=1 
            X(i) =x_temp;
            Y(i) =y_temp;
            end

            plot(X(i),Y(i),'ys','MarkerFaceColor','y')
            if mouse_click ~=1 % 1: left click, 2:roller click, 3: right click
                break
            end
        end
        X(i+1)=X(1); Y(i+1)=Y(1);
        X(X==0)=[] ; Y(Y==0)=[];
    case 'circle'
        x_cent = -1;
        y_cent = -1;
        while (x_cent<1 || x_cent>size2 || y_cent<1 || y_cent>size1)
            [x_cent,y_cent,~] = ginput(1);
        end
        theta = linspace(0,2*pi,20);
        X = round(x_cent + 30*cos(theta));
        Y = round(y_cent + 30*sin(theta));
        X(X>=size2) = size2;
        X(X<=1)     = 1;
        Y(Y>=size1) = size1;
        Y(Y<=1)     = 1;
        plot(x_cent,y_cent,'ys','MarkerFaceColor','y');
        plot(X,Y,'y--','LineWidth',1);
    otherwise
        error('wrong mode')
end

polygon_mask       = poly2mask(X,Y,size1,size2);
mask_size          = sum(polygon_mask(:));
black_mask = 1-polygon_mask;

img = mat2gray(img); %if img is uint8, it cannot multiply the mask
blackout_img = img.*black_mask;
end
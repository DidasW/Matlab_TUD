%define a polygon mask by clicking mouse
function [blackout_img,black_mask,mask_size] = ui_make_mask_by_mouse_click(img)

if nargin<1S
    current_fig = gcf;
    figure(current_fig);
    img_all = getimage(current_fig); 
    img = img_all(:,:,end);
    [size1,size2] = size(img);
else
    imshow(img);
    [size1,size2] = size(img);
end
hold on ;
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
polygon_mask       = poly2mask(X,Y,size1,size2);
mask_size          = sum(polygon_mask(:));
black_mask = 1-polygon_mask;

img = mat2gray(img); %if img is uint8, it cannot multiply the mask
blackout_img = img.*black_mask;
end
function img_sweptArea = calcFlagSweptAreaByImgStack_v2(img_fdpth,varargin)
    NoArgInExtra = nargin - 1 ; 
    NoI_user = -1 ;
    cropImg  = -1 ;
    if NoArgInExtra > 0
        temp = strcmp(varargin,'NoI'); 
        if any(temp); NoI_user  = varargin{find(temp)+1}; end
        temp = strcmp(varargin,'Crop'); 
        if any(temp); cropImg=1; cropRect = varargin{find(temp)+1}; end
    end
    
    %% store all images in a stack
    imgCube = [];
    imgFiles = dir(fullfile(img_fdpth,'*.tif'));
    
    if NoI_user == -1 
        NoI = numel(imgFiles);
    else 
        NoI = NoI_user;
    end
    
    for i_img = 1:NoI
        imgFile  = imgFiles(i_img);
        filepath = fullfile(imgFile.folder,imgFile.name);
        img = imread(filepath,'tif');
        
        if numel(size(img))==3
            img = img(:,:,1);
        end 
        if cropImg == 1
            img = imcrop(img,cropRect);
        end
        img = im2double(img);
        img = wiener2(img);
        
        
        if i_img == 1
            imgCube = img;
        else
            imgCube = cat(3,imgCube,img);
        end
    end
    img_median  = median(imgCube,3);

    %% process each frame of the stack
    imgCube_out = imgCube;
    for i_img = 1:NoI
        layer = imgCube_out(:,:,i_img);
        layer = abs(layer - img_median);
        layer = medfilt2(layer,[6,6]);
        imgCube_out(:,:,i_img) = layer;
    end

    %% output 
    img_std  = std(imgCube_out,0,3);
    img_sweptArea = imadjust(img_std);
    img_sweptArea = imadjust(img_sweptArea,[],[],0.7);
end
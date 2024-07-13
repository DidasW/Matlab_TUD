function img_sweptArea = calcFlagSweptAreaByImgStack(img_fdpth)
    %% store all images in a stack
    imgCube = [];
    imgFiles = dir(fullfile(img_fdpth,'*.tif'));
%     NoI      = numel(imgFiles);
    NoI = 100;
    for i_img = 1:NoI
        imgFile  = imgFiles(i_img);
        filepath = fullfile(imgFile.folder,imgFile.name);
        img = im2double(imread(filepath,'tif'));
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
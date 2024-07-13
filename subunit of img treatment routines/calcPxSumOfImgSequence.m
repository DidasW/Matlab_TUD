%% Doc
%{
This function calculate the sum of pixel value of each image in a sequence.
The returned time series can be used to analyze the background illumination
or in frequency analysis of vibrating objects.

input: image folder path where the image sequence is stored
output: an array whose elements are the pixel sum of each image.

Note, if the folder contains masked images, and the mask size is changing,
such trend can also be registered by a second output variable, maskSize
%}

%%
function [pxSumTimeSeries,varargout] = calcPxSumOfImgSequence(img_fdpth)
    
    imgList = dir(fullfile(img_fdpth,'*.tif'));
    NoI     = numel(imgList);
    [pxSum_t,pxSumNot_t,maskSize] = deal(zeros(NoI,1)); 
   
    for i_img  = 1:NoI
        I      = imread(fullfile(img_fdpth,imgList(i_img).name));
        I_not  = imcomplement(I); 
        I      = im2double(I);
        I_not  = im2double(I_not);
        cameraSight = I~=0;
        
        pxSum_t(i_img)   = sum(I(:));
        pxSumNot_t(i_img)= sum(I_not(:));
        maskSize(i_img)  = sum(cameraSight(:));
    end
    
    
    pxSumTimeSeries            = pxSum_t;
    pxSumTimeSeries_complement = pxSumNot_t;
    switch nargout-1
        case 1
            varargout{1} = pxSumTimeSeries_complement;
        case 2
            varargout{1} = pxSumTimeSeries_complement;
            varargout{2} = maskSize;
        otherwise
            error('To many outputs')
    end
end
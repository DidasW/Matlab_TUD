function saveImgSequenceByFrame_beta(img_fdpth,save_fdpth,img_name,...
                                fileformatstr,start_frame,end_frame)   
    %% pilot run, check img format (RGB/BW), check input validity
    if ~exist(save_fdpth,'dir')
        mkdir(save_fdpth)   % if save folder path doesn't exist, create
    end
    
    img_struct      = dir(fullfile(img_fdpth,'*.tif'));
    NoI_tot         = length(img_struct);
    imgIndexInNames = zeros(NoI_tot,1);
    for i_img       = 1:NoI_tot
        [~,imgName,~]     = fileparts(img_struct(i_img).name); %1_0032
        temp              = split(imgName,'_');
        imgIndexInName    = str2double(temp(2)); 
        imgIndexInNames(i_img) = imgIndexInName;
    end
    clearvars temp
    
    imgIndexMax     = max(imgIndexInNames);
    if end_frame > imgIndexMax
        end_frame = imgIndexMax;
    end
    
    img_test_path  = fullfile(img_fdpth,img_struct(1).name);
    img_test       =  imread(img_test_path,'tif');
    if length(size(img_test))==3 %% RGB image
        imgType       = 'RGB';
    else
        imgType       = 'BW';
    end
    
    %% Save the image sequence and rename them
    switch imgType
        case 'RGB'
            for i_img=start_frame:end_frame
                imgPath_from  = fullfile(img_fdpth,img_struct(i_img).name);
                current_img   = imread(imgPath_from,'tif');
                current_img   = current_img(:,:,1);
                imgName_to    = construct_file_name(img_name,...
                                i_img-start_frame+1,fileformatstr);
                imwrite(current_img,fullfile(save_fdpth,imgName_to));
            end
        case 'BW'
           for i_img=start_frame:end_frame
                imgPath_from  = fullfile(img_fdpth,img_struct(i_img).name);
                imgName_to    = construct_file_name(img_name,...
                                    i_img-start_frame+1,...
                                    fileformatstr);
                copyfile(imgPath_from,fullfile(save_fdpth,imgName_to),'f');
           end   
    end
                           
    function fullFileName = construct_file_name(fileName,idx,fmtStr)
        fullFileName = [fileName,'_',num2str(idx,fmtStr),'.tif'];
    end
                               
end
function saveImgSequenceByFrame(img_fdpth,save_fdpth,img_name,fileformatstr,...
                                start_frame,end_frame)
    if ~exist(save_fdpth,'dir')
        mkdir(save_fdpth)   % if save folder path doesn't exist, create
    end
    
    img_struct      = dir(fullfile(img_fdpth,'*.tif'));
    No_totImg       = length(img_struct);
    imgIndexInNames   = zeros(No_totImg,1);
    for i_img       = 1:No_totImg
        [~,imgName,~]     = fileparts(img_struct(i_img).name); %1_0032
        temp              = split(imgName,'_');
        imgIndexInName    = str2double(temp(2)); clear temp;
        imgIndexInNames(i_img) = imgIndexInName;
    end
    imgIndexMax     = max(imgIndexInNames);

    %% Save the image sequence and rename them
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
    switch imgType
        case 'RGB'
            for i_img=start_frame:end_frame
                full_img_path     = fullfile(img_fdpth,img_struct(i_img).name);
                current_img       =  imread(full_img_path,'tif');
                current_img       =  current_img(:,:,1);
                AF_file_name      = construct_file_name(img_name,...
                                    i_img-start_frame+1,...
                                    fileformatstr);
                imwrite(current_img,fullfile(save_fdpth,AF_file_name));
            end
        case 'BW'
           for i_img=start_frame:end_frame
                full_img_path     = fullfile(img_fdpth,img_struct(i_img).name);
                current_img       =  imread(full_img_path,'tif');
                AF_file_name      = construct_file_name(img_name,...
                                    i_img-start_frame+1,...
                                    fileformatstr);
                imwrite(current_img,fullfile(save_fdpth,AF_file_name));
            end   
    end
                           
    function full_file_name = construct_file_name(...
                              file_name,index,format_string)
        full_file_name = [file_name,'_',num2str(index,format_string),...
                          '.tif'];
    end
                               
end
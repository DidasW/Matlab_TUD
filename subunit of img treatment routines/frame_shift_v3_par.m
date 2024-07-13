% This function shifts a image batch at once and will optionally save them.
% The only tricky thing is about the "if i_sect ~= 1" part. That is because
% the batch will subtract the previous img to get rid of the background,
% parallel computing makes it hard to pass a last image to the next loop.
% Thus I choose to load one more image and add it at the head of the
% 'sublist'. In that way, the image loss will be only one frame and the
% indexing will be continuous.

function [img_batch,u,v] = frame_shift_v3_par(i_sect,sublist,ref_point,...
                                              Fd_path,file_name,format_string,ref_img,...
                                              to_save_all_shift,WinSize) 
                                                                     
    %% Initialization
    X_ref=ref_point(1); %select a point at the edge of the tip and half the tip height
    Y_ref=ref_point(2); 
    len = length(sublist);
    u=zeros(1,len);
    v=zeros(1,len);
    [img_size_1,img_size_2]  = size(ref_img); 
    [x,y]=meshgrid(1:img_size_2,1:img_size_1);              
    % NOTE: size(img,1) gives the pixel size in y direction
    
    isize = WinSize(2) ; jsize = WinSize(1); %parameters set by jerry: size of interrogation window
    % older value 40,34; Da changes it to the current value on 2016-09-17


    if i_sect~=1
        sublist   = cat( 1, sublist(1)-1, sublist);
        len       = length(sublist); 
    end
    img_batch_uint8 = zeros(img_size_1,img_size_2,len,'uint8'); 

    for i = 1:len
        full_file_name = construct_file_name(file_name,sublist(i),format_string);
        img_batch_uint8(:,:,i)=imread([Fd_path,full_file_name],'tif');
    end

    img_batch = mat2gray(img_batch_uint8);
    
    parfor i = 1:len
            
        %% Shifting
  

        I = img_batch(:,:,i);
        [U,V,~] = pwInterrogate(ref_img,I,X_ref,Y_ref,[jsize isize],...
                                0,0,0,0,1,0);
        u(i) = U(1);
        v(i) = V(1);

        %% interpolate image
        I_shifted = interp2(x,y,I,x+u(i),y+v(i),'linear');
        ind= isnan(I_shifted)==1;
        I_shifted(ind)=I(ind);
        img_batch(:,:,i) = I_shifted;

        %% save shifted files, optional.
        file_path_shifted = [Fd_path,'shift\',full_file_name];
        optional_save(to_save_all_shift,I_shifted,file_path_shifted);

    end
    
    if i_sect ~= 1 
        u(1) = [];
        v(1) = [];
    end
end

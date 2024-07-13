function  adjusted_img_batch = sample_noise_and_adjust(cropped_img_batch,...
                                                                sublist,crop2,...
                                                                file_name, format_string,...
                                                                to_save_all_adjust)

[cropped_img_size_1,cropped_img_size_2] = size(cropped_img_batch(:,:,1));
len = length(sublist);

y_from = crop2(2); y_to = y_from + crop2(4);
if y_to > cropped_img_size_1
    y_to = cropped_img_size_1;
end
        
x_from = crop2(1); x_to = x_from + crop2(3); 
if x_to > cropped_img_size_2
    x_to = cropped_img_size_2;
end

adjusted_img_batch = zeros(cropped_img_size_1,cropped_img_size_2,len);

parfor i_adjust = 1:len
    
    I_adjusted = cropped_img_batch(:,:,i_adjust);
    [I_adjusted,~] = wiener2(I_adjusted,[5,5]);
    
    low_high   = stretchlim(I_adjusted,0.04) ; 
    I_adjusted = imadjust(I_adjusted,low_high,[0,1],10);
    
    I_adjusted = medfilt2(I_adjusted,[5,5]);
       
    noise_region =  I_adjusted(y_from:y_to,x_from:x_to);
    noise_max = max(noise_region(:));
    I_adjusted(I_adjusted<noise_max) = 0;
    
    adjusted_img_batch(:,:,i_adjust) = I_adjusted;
      
    
    %% optional saving imgs
    if to_save_all_adjust == 0
        continue
    elseif to_save_all_adjust == 1
       adjusted_file_path = ['adjust\',file_name,'_',num2str(sublist(i_adjust),format_string),'.tif']; 
       imwrite(I_adjusted,adjusted_file_path);
    else
        if rand(1)<0.005
            adjusted_file_path = ['adjust\',file_name,'_',num2str(sublist(i_adjust),format_string),'.tif'];
            imwrite(I_adjusted,adjusted_file_path);
        end  
    end
end


end
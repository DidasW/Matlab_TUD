% the first version is too slow, f*king slow
function  adjusted_img_batch = sample_noise_and_adjust_v2(dif_CIB,i_sect,sublist,crop2,...
                                                          Fd_path,file_name, format_string,...
                                                          to_save_all_adjust)

adjusted_img_batch = dif_CIB;
len = length(sublist);

if i_sect == 1              % len > length(dif_CIB)
    sublist(1) = [];        % say sublist = 1:1000 --> 2:1000
    len = len - 1 ;         % now len = length(dif_CIB);
end

parfor i_adjust = 1:len
    
    I_adj   = dif_CIB(:,:,i_adjust); %adj : adjust
    
    noise_region = imcrop(I_adj,crop2);
    noise_mean   = mean2(noise_region);
    noise_std    = std2(noise_region);
    
    I_adj(I_adj<noise_mean+3*noise_std) = 0;
    
    I_adj = wiener2(I_adj);
    
    low_high = stretchlim(I_adj,0.01);
    I_adj = imadjust(I_adj,low_high,[0,1],2);
    
    adjusted_img_batch(:,:,i_adjust) = I_adj;
      
    
    %% optional saving imgs 
    full_file_name =  construct_file_name(file_name,sublist(i_adjust)-1,format_string);
                            % for i_sect = 1, sublist = 2:1k, file names
                            % are 1:999;
                            % for i_sect > 1, say = 2, sublist = 1001:2k,
                            % file names are 1k:1999;
                            % So at last, in total NoI-1 files, named from
                            % 1:NoI-1.
    file_path_adjusted = [Fd_path,'adjust\',full_file_name];
    optional_save(to_save_all_adjust,I_adj,file_path_adjusted)
    
end


end
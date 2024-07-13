function optional_save(to_save_all,image,file_path)
    if to_save_all == 0
        
    elseif to_save_all == 1
       imwrite(image,file_path);
    else
        if rand(1)<0.005
            imwrite(image,file_path);
        end
    end
end
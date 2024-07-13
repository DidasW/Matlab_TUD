
function [shifted_img_batch,u,v] = frame_shift_v4(img_batch,sublist,ref_img,ref_img_idx,...
                                         ref_point,file_name,format_string,...
                                         to_save_all_shift,WinSize)    
    %% Initialization
    X_ref=ref_point(1); %select a point at the edge of the tip and half the tip height
    Y_ref=ref_point(2); 
    len = length(sublist);
    rel_u=zeros(1,len);
    u    =zeros(1,len); 
    rel_v=zeros(1,len);
    v    =zeros(1,len);
    [img_size_1,img_size_2]  = size(ref_img); 
    [x,y]=meshgrid(1:img_size_2,1:img_size_1);              
    % NOTE: size(img,1) gives the pixel size in y direction
    
    isize = WinSize(2) ; jsize = WinSize(1); %parameters set by jerry: size of interrogation window
    % older value 40,34; Da changes it to the current value on 2016-09-17
    
    if isempty(find(sublist==ref_img_idx,1))
        % if this batch of img doesn't contain the reference image,then
        % firstly use a large interrogation window to get the relative
        % shift for the first img of this batch. Shift other img in this
        % batch with respect to it
        
        I = img_batch(:,:,1);
        ix = round(X_ref);%integer_x
        iy = round(Y_ref);%integer_y
        temp_isize = min([120,2*ix,2*(img_size_2-ix)]);
        temp_jsize = min([120,2*iy,2*(img_size_1-iy)]);
        [U,V,~] = pwInterrogate(ref_img,I,X_ref,Y_ref,[temp_jsize temp_isize],...
                                    0,0,0,0,1,0);%I_next + (ui,vi) = I
        rel_u(1) = U(1);
        rel_v(1) = V(1);
        
        for i = 1:len-1      
            I = img_batch(:,:,i);
            I_next = img_batch(:,:,i+1);

            [U,V,~] = pwInterrogate(I,I_next,X_ref-rel_u(i),Y_ref-rel_v(i),[jsize isize],...
                                    0,0,0,0,1,0);%I_next + (ui,vi) = I
            rel_u(i+1) = U(1);
            rel_v(i+1) = V(1);
        end
        
    else
        for i = ref_img_idx:len-1      
            I = img_batch(:,:,i);
            I_next = img_batch(:,:,i+1);

            [U,V,~] = pwInterrogate(I,I_next,X_ref-rel_u(i),Y_ref-rel_v(i),[jsize isize],...
                                    0,0,0,0,1,0);%I_next + (ui,vi) = I
            rel_u(i+1) = U(1);
            rel_v(i+1) = V(1);
        end

        for i = ref_img_idx:-1:2
            I = img_batch(:,:,i);
            I_next = img_batch(:,:,i-1);

            [U,V,~] = pwInterrogate(I,I_next,X_ref-rel_u(i),Y_ref-rel_v(i),[jsize isize],...
                                    0,0,0,0,1,0);%I_next + (ui,vi) = I
            rel_u(i-1) = U(1);
            rel_v(i-1) = V(1);
        end
    end
    
    
    for i = 1:len
        u(i) = sum(rel_u(1:i));
        v(i) = sum(rel_v(1:i));
    end
    
    shifted_img_batch = zeros(size(img_batch));
    for i = 1:len
        I = img_batch(:,:,i);
        I_shifted = interp2(x,y,I,x+u(i),y+v(i),'linear');
        ind                    = isnan(I_shifted)==1;
        I_shifted(ind)         = 0;
        shifted_img_batch(:,:,i)= I_shifted;
        
        %% save shifted files, optional.
                
        if to_save_all_shift == 0
            continue
        elseif to_save_all_shift == 1
           shifted_file_path = ['shift\',file_name,'_',num2str(sublist(i),format_string),'.tif']; 
           imwrite(I_shifted,shifted_file_path);
        else
            if rand(1)<0.005
                shifted_file_path = ['shift\',file_name,'_',num2str(sublist(i),format_string),'.tif'];
                imwrite(I_shifted,shifted_file_path);
            end
        end
    end
end

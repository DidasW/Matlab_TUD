
function frame_shift_v2(folder_path,list,input,NoI,file_name)    
%LOOP to crop ONE point in every image set
%loop to process images

    cd(folder_path); %folder 
    X=input(1); %select a point at the edge of the tip and half the tip height
    Y=input(2); 
    isize = 80 ; jsize = 68; %parameters set by jerry: size of interrogation window
    % older value 40,34; Da changes it to the current value on 2016-09-17
    
    %open reference image
    [first_file_suffix,format_string] = first_file_name(NoI,'tif');
    %NoI as total number of images in one folder
    file0=strcat(file_name,first_file_suffix);
    [I0]=imread(file0);
    I0=mat2gray(I0);

    u=zeros(1,length(list));
    v=zeros(1,length(list));
    for p=list(1:end)

    % 1. Open one image
        p_str=num2str(p,format_string);
        % n is a string, e.g. '0002'
        % format string is either '%04d' or '%06d', depending on total file number
        file=strcat(file_name,'_',p_str,'.tif');
        [I]=imread(file);
        I=mat2gray((I));

        [U,V,~] = pwInterrogate(I0,I,X,Y,[jsize isize],0,0,0,0,1,0);
        u(p) = U(1);
        v(p) = V(1);

        %interpolate image
        [x,y]=meshgrid(1:size(I,2),1:size(I,1));

        I2 = interp2(x,y,I,x+u(p),y+v(p),'linear');
        ind=find(isnan(I2)==1);
        I2(ind)=I(ind);
        % imagesc(I2); axis image; colormap(gray);
        imwrite(I2,['shift\',file_name,'_',p_str,'.tif']);

    end


    imwrite(I0,['shift\',file_name,first_file_suffix]);



end

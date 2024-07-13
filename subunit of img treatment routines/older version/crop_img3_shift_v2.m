%FUNCTION to crop TWO rectangles in every image set: FIRST is region to process, SECOND
%is background ,
% 20160411 add the title of figure for clarity
% 20160917 modify the function so that for each subfolder there can be a
% different crop.
% Last modification: 20160411, Da.


function [R1,R2]=crop_img3_shift_v2(NoFd,mama_folder_path,SFNL,first_file_suffix)
    %NoFd is abbr. for Number of Folder
    %original name of NoFd is 'l' (small letter for L)
    
    %SFNL is abbr. for SubFolder Name List
    %original name of SFNL is 'points'
    
    R1=zeros(NoFd,4); %   Box to limit the image processing to smaller image
    R2=zeros(NoFd,4); %   Box to extract the background from each frame


    %creat sub_folder_path
    %change current folder to the 'shift' folder in it
    NoFd=length(SFNL);
    for j = 1:NoFd
        SFN=num2str(SFNL(j));
    first_SFd_name=num2str(SFNL(1));
    %SFd is abbr. for SubFolder
    %SFN is abbr. for SubFolder Name
    %I am not very satisfied with SFNL being a list of numbers
    %So far just leave it like this
    
    ([mama_folder_path,first_SFd_name,'\shift\']) %folder  
    file_name='1';
    file1=strcat(file_name,first_file_suffix);
    I1=imread(file1);
    I1=mat2gray((I1));
    screen_size = get(groot,'ScreenSize');
    figure('Name','Crop FLAG. & BACKGROUND','NumberTitle','off',...
           'OuterPosition',[0 0 screen_size(3) screen_size(4)]...
           ); 
    imshow(I1);

    [I_flag_and_background, rect1]=imcrop(I1);
    R1(1,:)=rect1;
    [I_background, rect2]=imcrop(I_flag_and_background);
    R2(1,:)=rect2;
    for i=2:NoFd
       R1(i,:)=rect1;
       R2(i,:)=rect2;  
    end
close all
end
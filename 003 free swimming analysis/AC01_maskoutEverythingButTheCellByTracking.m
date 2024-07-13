%% Folder structure
FOLDER_ROOT         = fullfile('F:','190206 mstg1');
croppedImageFdpth   = fullfile(FOLDER_ROOT,'001 Image cropped');
trackFdpth          = fullfile(FOLDER_ROOT,'003 Tracks formatted');
maskedImgRootFdpth  = fullfile(FOLDER_ROOT,'004 Image masked');
freqAnalysisFdpth   = fullfile(FOLDER_ROOT,'005 Beat freq analysis');
intermediateFdpth   = fullfile(FOLDER_ROOT,'999 Intermediates');

%% Parameter setting
% tracks are named c##.txt, image folders c##
fps                     = 301.08;    % [Hz]
camRadius               = 70;        % [px], 1px = 0.107 micron
stablizeTrackingCamera  = 0;
makeCellBodyWhite       = 1;
[blp0,alp0]             = butter(4,10/fps*2,'low');
trackFileList           = dir(fullfile(trackFdpth,'*.txt'));
NoTrack                 = numel(trackFileList);
 
%% Processing
for i_track = 10:25%NoTrack
    filename = trackFileList(i_track).name;
    disp(['Processing ',filename(1:end-4)])
    trackInfo = dlmread(fullfile(trackFdpth,filename));
    frame     = trackInfo(:,1);
    x_px      = trackInfo(:,2);
    y_px      = trackInfo(:,3);
    x_px_stablized = filtfilt(blp0,alp0,x_px);
    y_px_stablized = filtfilt(blp0,alp0,y_px);
    
    if ~contains(filename,'_m') % non-manual tracking start from frame 0
        frame     = frame+1;
    end
    first_frame_idx = frame(1);
    first_frame_name_str = num2str(first_frame_idx,'%04d');
    
    %% Find the corresponding frame
    imageFdpth    = fullfile(croppedImageFdpth,filename(1:3));
    imageList     = dir(fullfile(imageFdpth,'*.tif'));
    imageNameList = {imageList.name};
    
    idx_1stImgOfTrack = find(contains(imageNameList,...
                             first_frame_name_str));
    image     = imread(fullfile(imageFdpth,...
                       imageList(idx_1stImgOfTrack).name));
    figure('Units','inches','Position',[1,1,5,5])
    imshow(image)
    hold on
    plot(x_px,y_px,'-','LineWidth',1,'MarkerFaceColor','none',...
         'MarkerSize',10,'color',[1 0.2 0.2 0.4]);
    
    skipOrNot = questdlg('Does the beginning match?');
%     skipOrNot = 'Yes';
    maskedImgFdpth = fullfile(maskedImgRootFdpth,filename(1:3));
    switch skipOrNot
        case 'Yes'
            if ~exist(maskedImgFdpth,'dir'); mkdir(maskedImgFdpth); end
            print(gcf,fullfile(intermediateFdpth,...
                [filename(1:3),'_overlay.png']),'-dpng','-r300');
            close(gcf)
        case 'No'
            disp([filename,' is not processed'])
            continue
        otherwise
            disp([filename,' is not processed'])
            continue
    end
    
    %% Proceed only if the beginning of tracks and img indices match
    NoFrame = numel(frame);
    sizeY = size(image,1);
    sizeX = size(image,2);
    
    if stablizeTrackingCamera
        x_use = x_px_stablized;
        y_use = y_px_stablized;
    else
        x_use = x_px;
        y_use = y_px;
    end
    
    for i_frame = 1:NoFrame
        idx = find(contains(imageNameList,num2str(frame(i_frame),'%04d')));
        if ~isempty(idx)
            x_cent = x_use(i_frame);
            y_cent = y_use(i_frame);
            theta = linspace(0,2*pi,20);
            X = round(x_cent + camRadius*cos(theta));
            Y = round(y_cent + camRadius*sin(theta));
            X(X>=sizeX) = sizeX;
            X(X<=1)     = 1;
            Y(Y>=sizeY) = sizeY;
            Y(Y<=1)     = 1;
            circle_mask = poly2mask(X,Y,sizeY,sizeX);
            img = im2double(imread(fullfile(imageFdpth,...
                           imageList(idx).name)));
            img_masked = img.*circle_mask;
            img_name   = construct_file_name('1',i_frame,'%04d');
            imwrite(img_masked,fullfile(maskedImgFdpth,img_name))
        end
    end


end 
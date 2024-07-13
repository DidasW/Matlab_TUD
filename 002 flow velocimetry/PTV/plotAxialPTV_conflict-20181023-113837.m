%%
try
    run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
catch
    run(fullfile('C:','SurfDrive','008 MATLAB code backup',...
        '000 Routine','subunit of img treatment routines',...
        'add_path_for_all.m'))
end
color_palette;
%%
PTVexperiment = '281012c32ptvAx';
tracksFdpth = 'D:\OTV databank from D drive\181004 Axial PTV after 180901';
trackFdpth  = fullfile(tracksFdpth,PTVexperiment);
trackFileList = dir(fullfile(trackFdpth,'*dat'));
cellCenterCoordsFilepath = fullfile(tracksFdpth,...
                        [PTVexperiment,'_cellCenterCoords.txt']);
cellCenterCoordsList = dlmread(cellCenterCoordsFilepath);
minimunAxialDistance = 10;      % [micron]
px2micron            = 0.107;   % [micron/px]
%% 
colormap = autumn(13);
switch PTVexperiment
    case '180925c2ptvAx'
        fps =104.96; 
        flagLength = 12.12;
        beatFreq = 49.00;
        color = colormap(1,:);
        axialDirection = 'Y';
    case '180925c4ptvAx'
        fps =100.82;
        flagLength = 12.12;
        beatFreq = 49.00;
        color = colormap(3,:);
        axialDirection = 'Y';
    case '281002c27ptvAx'
        fps = 231.90;
        flagLength = 12.06;
        beatFreq = 51.43;
        color = colormap(5,:);
        axialDirection = 'X';
    case '281002c28ptvAx'
        fps = 232.39;
        flagLength = 12.10;
        beatFreq = 48.60;
        color = colormap(7,:);
        axialDirection = 'X';
    case '281002c29ptvAx'
        fps = 200.00;
        flagLength = 13.47;
        beatFreq = 48.81;
        color = colormap(9,:);
        axialDirection = 'X';
    case '281012c32ptvAx'
        fps = 200.00;
        flagLength = 13.51;
        beatFreq = 42.90;
        color = colormap(11,:);
        axialDirection = 'X';
    case '281012c33ptvAx'
        fps = 200.00;
        flagLength = 13.47;
        beatFreq = 49.50;
        color = colormap(13,:);
        axialDirection = 'X';
end

speedScale   = flagLength*beatFreq;
distanceScale= 1000*sqrt(0.9565./beatFreq);  % [micron], water 22 degrees
frame2cyc   = floor(fps/beatFreq*5) + 1;
frame5cyc   = floor(fps/beatFreq*5) + 1;
%%
% figure()
hold on 

for i_track = 1:numel(trackFileList)
    trackName = trackFileList(i_track).name;
    trackCode = str2double(trackName(1:2));
    rowNum = find(cellCenterCoordsList(:,1)==trackCode);
    x_cc =  cellCenterCoordsList(rowNum,2);
    y_cc =  cellCenterCoordsList(rowNum,3);
    
    trackData = dlmread(fullfile(trackFdpth,trackName));
    t = trackData(:,1)/fps; % [s]
    x_b2c = smooth(trackData(:,2)-x_cc,frame5cyc)*px2micron; %[micron]
    y_b2c = smooth(trackData(:,3)-y_cc,frame5cyc)*px2micron; %[micron]
    
    switch axialDirection
        case 'X'
            ax_b2c = x_b2c;
            lat_b2c= y_b2c;
        case 'Y'
            ax_b2c = y_b2c;
            lat_b2c= x_b2c;
    end
    
    idx_keep = find(ax_b2c>minimunAxialDistance);
    [t,x_b2c,y_b2c,ax_b2c,lat_b2c] = takeTheseIndices(idx_keep,...
                                     t,x_b2c,y_b2c,ax_b2c,lat_b2c);
    
    speedAx = abs(ax_b2c(1+frame2cyc:end)-...
                 ax_b2c(1:end-frame2cyc))*fps/frame2cyc;
    speedLat = abs(lat_b2c(1+frame2cyc:end)-...
                 lat_b2c(1:end-frame2cyc))*fps/frame2cyc;
    if strcmp(axialDirection,'tilt')
        speedAx = sqrt(speedAx.^2 + speedLat.^2);
    end
    scaledSpeedAx = speedAx/speedScale;
    scaledDistanceAx = abs(ax_b2c(1:end-frame2cyc))/distanceScale;
    scaledDistanceLat = abs(lat_b2c(1:end-frame2cyc))/distanceScale;
    if strcmp(axialDirection,'tilt')
        speedAx = sqrt(scaledDistanceAx.^2 + scaledDistanceLat.^2);
    end
    
    plot(scaledDistanceAx,scaledSpeedAx,'Color',[color,0.4],'LineWidth',1)
    hold on
end
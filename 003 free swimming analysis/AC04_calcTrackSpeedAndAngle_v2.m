d% 2019-1-29
% Get average swimming speed for algae
% Update FOLDER_ROOT if the folder structure is defined similarly
% Otherwise update trackFdpth to the one that stores all the .txt tracks
% 2019-4-17
% Calculate U_max by both the mode of velocity and the speed over arc
% length

clear all
close all

%% Folder structure
FOLDER_ROOT         = fullfile('C:','SurfDrive','TrackSpeedAnalysis',...
                      '190129 wt');
croppedImageFdpth   = fullfile(FOLDER_ROOT,'001 Image cropped');
trackFdpth          = fullfile(FOLDER_ROOT,'003 Tracks formatted');
maskedImgRootFdpth  = fullfile(FOLDER_ROOT,'004 Image masked');
freqAnalysisFdpth   = fullfile(FOLDER_ROOT,'005 Beat freq analysis');
trackAnalysisFdpth  = fullfile(FOLDER_ROOT,'006 Track analysis');
intermediateFdpth   = fullfile(FOLDER_ROOT,'999 Intermediates');
[~,experiment,~]    = fileparts(FOLDER_ROOT) ;
experiment          = erase(experiment,' ');

%% Parameter setting
fps               = 301.08;     % [Hz]
spectrumSmooth    = 9;          % [Hz]
freqHPFTrack      = 10;         % [Hz] 
[blp,alp]         = butter(4,freqHPFTrack/fps*2,'low');
[bhp,ahp]         = butter(4,freqHPFTrack/fps*2,'high');
px2micron         = 0.107;      % [micron/px]
tWindow_ms        = 10;         % [ms]

%% Processing each track
trackFileList       = dir(fullfile(trackFdpth,'c*.txt'));
trackFilenameList   = {trackFileList.name};
NoCell              = numel(trackFileList);
% scalars
[U_bar_list    ,...
 U_arc_max_list,...
 U_mod_max_list,...
 U_along_max_list,...
 U_normal_max_list,...
 U_arc_max_medPk_list,...
 U_mod_max_medPk_list,...
 U_along_max_medPk_list,...
 U_normal_max_medPk_list ]   = deal( NaN(NoCell,1));

% scalar time series
[Ut_arc_list  , Ut_mod_list,...
 Ut_along_list, Ut_normal_list,...
 theta_t_list         ]      = deal(cell(NoCell,1));

% vector time series
[Ut_vel_list,unitVec_t_list] = deal(cell(NoCell,1));

for i_cell = 2%1:NoCell
    %% load track
    trackFilename = trackFilenameList{i_cell};
    cellname      = trackFilename(1:3);
    trackInfo     = dlmread(fullfile(trackFdpth,trackFilename));
    x_t           = trackInfo(:,2)*px2micron;
    y_t           = trackInfo(:,3)*px2micron;
    % stablize
    x_t_stab      = filtfilt(blp,alp,x_t);
    y_t_stab      = filtfilt(blp,alp,y_t);
    % oscillatory
    x_t_osci      = filtfilt(bhp,ahp,x_t);
    y_t_osci      = filtfilt(bhp,ahp,y_t);
    
    %% average speed
    arcLen_tot = arclength(x_t_stab,y_t_stab,'spline');
    t_tot      = numel(x_t)/fps;       % [s]
    U_bar      = arcLen_tot/t_tot;% [micron/s]

    %% calc speed by arc length
    Ut_arc= calcSpeedByArcLength(x_t,y_t,fps,tWindow_ms);
    
    %% calc velocity
    Ut_vel     = calcVelocity(x_t,y_t,fps,tWindow_ms);    
    
    %% calc track direction
    [theta_t,unitVec_t] = calcTrackDirection(x_t_stab,y_t_stab,...
                          fps,tWindow_ms);
    %% calc velocity component along/perpendicular to the track
    Ut_mod   = sqrt(sum(Ut_vel.^2,2));
    Ut_along = sum(Ut_vel .* unitVec_t,2);                  
    Ut_normal= sqrt(Ut_mod.^2 - Ut_along.^2);
    
    %% calc the maximum of instantaneous speed
    U_arc_max     = prctile(Ut_arc,95); 
    U_mod_max     = prctile(Ut_mod,95);
    U_along_max   = prctile(Ut_along,95);
    U_normal_max  = prctile(Ut_normal,95);
    
    %% use median of the peaks as the maximum speed
    U_arc_max_medPk     = calcMedianPeakSpeed(Ut_arc); 
    U_mod_max_medPk     = calcMedianPeakSpeed(Ut_mod);
    U_along_max_medPk   = calcMedianPeakSpeed(Ut_along);
    U_normal_max_medPk  = calcMedianPeakSpeed(Ut_normal);

    %% save values
    U_bar_list(i_cell) = U_bar;
    
    U_arc_max_list(i_cell) = U_arc_max;
    U_mod_max_list(i_cell) = U_mod_max;
    U_along_max_list(i_cell) = U_along_max;
    U_normal_max_list(i_cell)= U_normal_max;       
    
    U_arc_max_medPk_list(i_cell) = U_arc_max_medPk;
    U_mod_max_medPk_list(i_cell) = U_mod_max_medPk;
    U_along_max_medPk_list(i_cell) = U_along_max_medPk;
    U_normal_max_medPk_list(i_cell)= U_normal_max_medPk;     
    
    Ut_arc_list{i_cell}   = Ut_arc;
    Ut_mod_list{i_cell}   = Ut_mod;
    Ut_along_list{i_cell} = Ut_along;
    Ut_normal_list{i_cell}= Ut_normal;
    theta_t_list{i_cell}  = theta_t;
    
    Ut_vel_list{i_cell}    = Ut_vel;
    unitVec_t_list{i_cell} = unitVec_t;
    
    disp([cellname,' processed'])
end
 
% if ~exist(trackAnalysisFdpth,'dir'); mkdir(trackAnalysisFdpth); end
% save(fullfile(trackAnalysisFdpth,...
%     [experiment,'_trackSpeedAndAngle_',num2str(tWindow_ms),...
%     'msWindow.mat']),...
%     'fps','freqHPFTrack','blp','alp','px2micron','tWindow_ms',...       
%     'U_bar_list',...
%     'U_arc_max_list','U_mod_max_list',...
%     'U_along_max_list','U_normal_max_list',...
%     'Ut_arc_list','Ut_mod_list',...
%     'Ut_along_list','Ut_normal_list',...
%     'U_arc_max_medPk_list',...
%     'U_mod_max_medPk_list',...
%     'U_along_max_medPk_list',...
%     'U_normal_max_medPk_list',...
%     'theta_t_list',...
%     'Ut_vel_list','unitVec_t_list')

function medOfPeaks = calcMedianPeakSpeed(Ut)
    pks = findpeaks(Ut);
    medOfPeaks = median(pks);
end

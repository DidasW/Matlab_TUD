close all; clc
%% Add paths
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
experiment= '180903c22a1'; 
AA05_experiment_based_parameter_setting;

%% Set correct folders and add relevant folders
user = 'Da';
switch user
    case 'Da'
        cd('D:\004 FLOW VELOCIMETRY DATA\')
        run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')
        % will add all the pathes needed
    case 'Daniel'
    case 'other'
        %Please fill in the relevant folders here
end

%% Parameter settings
screenmagnif = 100;
supfld = [uni_name,'\'];     % Folder immediately below main folder
pt         = 99;           % Selected image folder
cd(strcat(cd,'\',supfld,num2str(pt,'%02d')));
                             % Change current folder        

% auto_generate_correctlist;
% manual_generate_correctlist;
% 
% if  exist('clist_manu','var')
%     correctlist   = clist_manu;
%     N_manu        = length(clist_manu);
%     if exist('clist_auto','var') 
%         N_auto        = length(clist_auto);
%         common_frames = intersect(clist_auto,clist_manu);
%         N_found       = length(common_frames);
%         misrecog_found_ratio   = N_found/N_manu;
%         misrecog_found_efficasy= N_found/N_auto;
%         fprintf(['Manually found %d mis-recognitions\n',...
%                  'first-time mis-recog rate: %.2f\n',...
%                  'auto-detect found %d mis-recognitions\n',...
%                  'success rate : %.2f\n',...
%                  'efficasy : %.2f\n'],...
%                  N_manu,N_manu/nframes,N_auto,misrecog_found_ratio,...
%                  misrecog_found_efficasy)
%     end
% end
correctlist = 23;
% pause
%% Correction
for kk=1:length(correctlist)
    %Open image-
    image = correctlist(kk)-list(1)+1;
    n = num2str(correctlist(kk),fileformatstr); %Generate image string
    file = (['1_',n,'.tif']);           %First image
    Im = mat2gray(imread(file));            %Grayscale version of image
    [Im,~] = wiener2(Im);                   %Apply Wiener filter for Gaussian noise removal
    
    %Correct shape
    for lr=1:2
        manualcorrect_after
    end
end

%Post
phase_stats
velocity

%Save
filename = strcat('lib',num2str(pt,'%02d'),'_',num2str(beginimg),'_',...
        num2str(endimg),'_',datestr(datetime('now'),'yyyy-mm-dd_HHMM'));
save(filename,'Cell','kappasave','xflag','yflag','Bshape','phishape',...
    'phase','princpts','nmodes','velx0','vely0','lf0','scale','fps',...
    'thetal','thetar','phi_body','beginimg','endimg','list','nframes',...
    'xperim_el','yperim_el','optsfmc','R',...
    'fileformatstr','fold','xbase','ybase','ssc','Im','supfld','pt')

%Make movie
makemovie = 1
movieflagellum
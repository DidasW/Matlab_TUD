%% SCRIPT IMAGE_PROCESSING
%Handles the complete image processing for a set of images. Multiple runs
%of the algorithm and principal component analysis are done to get the
%quickest, most accurate approximation of the limit cycle.
%% Add paths
run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all; clc
%------------------------------USER INPUT---------------------------------%
user      = 'Da';          %User name, used to add relevant folders (Adjust in 'initialization' file)   
supfld    = 'c16l1\';        %Folder immediately below main folder
experiment= '171029c16l1'; 
pt        = 99;            %Selected image folder
AA05_experiment_based_parameter_setting;

% % % Now placed all in AA05. 
% fileformatstr = '%06d'; % Format of image numbers
% colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
% colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
% colorb    = 1;          % Cell body halo color   0=dark, 1=bright
% scale     = 9.35;       % Scale                  [px/micron]
% lf0       = 13.5;
% orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
%                         % right,anti-clockwise rotation direction, 
%                         % 1.5 pi for camera setting after 20170502
% f0        = 50;         % Cell beat frequency estimate, [Hz]
% fps       = 801.42;     % Theoretical camera framing rate, [Hz]
% list      = 1:60;       % List of image idx in each case folder      

%-----------------------------DEBUG TOOLS---------------------------------%
% dbstop if error

userclick  = 1;         %Click points to determine flagellar base?
plotshapes = 1;         %Plot detected shapes?
debugfmc   = 0;         %0 = No extra info about optimization
                        %1 = Show initial and final condition for fmincon, info per step 
                        %2 = also display initial fitting of limit cycle shapes
                        %3 = also show motion of shape during optimization (=SLOW!)

%minimalgorithm = 2;    %1 = Use limit cycle shapes as initial guess
                        %2 = Use raw shapes as initial guess

%-------------------------OTHER INITIALIZATION----------------------------%  
Initialization

%------------------------STARTING POINT DETECTION-------------------------%
base_coord

%% %%%%%%%%%%%%%RUN USING MINIMIZATION ALGORITHM, SELECT SHAPES%%%%%%%%%%%%
%For 2-3 cycles?
cycleframes = ceil(fps/f0);     %Frames per beat cycle  [-]

%--------------------INITIALIZE MINIMIZATION ALGORITHM--------------------%
minimalgorithm = 1;
firstimg = 1;                     %First image to process in this series
endimg = firstimg+2*cycleframes;  %Last image to process in this series

load('Blimit_0');
Initialize_minimization

%------------------------------RUN ALGORITHM------------------------------%
Flagella_detection_select
% %%%%%%%%%%%%%%%%%%%%%%%RETRIEVE LIMIT CYCLE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PCA_DFT
filename = strcat('Blimit_',num2str(pt,'%02d'),'_initial');
save(filename);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%REFINEMENT RUN%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minimalgorithm = 1;         %Use shapes directly rather than limit cycle
scanalgorithm = 0;
beginimg = endimg;             %First image to process in this series
endimg = length(list);         %Last image to process in this series

Initialize_minimization_2
Flagella_detection_select_2

%% SAVE FINAL SHAPES
PCA_DFT
filename = ['Blimit_',num2str(pt,'%02d'),'_final'];
% 
save(filename,'Bdata','Blimit','kappasave','PCA_store');
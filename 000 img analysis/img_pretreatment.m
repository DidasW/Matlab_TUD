%% Script description
% Interactively define the:
%     1.) reference point,
%     2.) cell and pipette mask,
%     3.) interested region (by crop1), 
%     4.) noise sampling region (by crop2)
% with respect to each folder.
%
% Data will be saved under mama_folder, 
% serving routines: 
%     * img_shift_and_adjust_v*** 
%     * get_phase_info_v***.

close all

%%
% mama_folder_path = [uigetdir('O:\161021 deflag 4 cells\cell 3 deflag\',...
%                     'SELECT VIDEO FILE FOLDER'),'\'];
% mama_folder_path=[('O:\VIDEO ANALYSIS'),'\'];     % Manual input
cd (mama_folder_path);
SFL     = dir(mama_folder_path);         %Sub Folder List
SFL(1:2)= [];                            %delelte '..' and '.'
SFL     = leave_only_folders_with_sth_in(SFL,mama_folder_path);          
NoFd    = length(SFL);                    %No. of Folder                    
%%

Fs=756.90;%**** UPDATE
Ts=1/Fs;
jsize = 32;%height,interrogation window size
isize = 40;%width 
dim =5; 
sigma=3;
gauss_filter = fspecial('gaussian',dim, sigma);
section_size = 300; %sectioning for parallel computing



%% 2.1 Preallocation of all the user defined settings
run('user_define_module.m');
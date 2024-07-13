%% DOC
%{
 User-dependent script. 
 This specifies folder and filepaths to load and save
 variable for one complete round of BEM computation
 
 For bored users who wants to know more, go to the Log section at the end
%}

%% Load user dependent filenames and paths
user  =  'Da';
switch user
    case 'Da'
        %% Addpath and Folder tree
        run(fullfile('D:','002 MATLAB codes','000 Routine',...
            'subunit of img treatment routines','add_path_for_all.m'))
        topfld = 'D:\004 FLOW VELOCIMETRY DATA\';
        cd(topfld) 
        
        experiment    = '180918c23wv';
        AA05_experiment_based_parameter_setting;
        
        supfld = [uni_name,'/'];    % name of the experiment
        cd(supfld)
        
        pt = 99;            % name of the case (position) to analyze
        
        casefld_fullpath   = [topfld,supfld,num2str(pt,'%02d'),'/'];
        cd(casefld_fullpath)

   
        %% Pipette shape
%         pipettefile        = [topfld,'pipette_201',...
%                               experiment(2:6),'_',uni_name,'.mat'];
        pipettefile        = [topfld,'pipette_201',...
                              experiment(2:6),'_c23g.mat'];
        
        %% Waveform of the flagella
        waveformsfilestruct= dir('lib*.mat'); 
        waveformsfilename  = waveformsfilestruct(1).name;
        waveformsfile      = [casefld_fullpath,waveformsfilename]; 
                
        %% Filename to save the general results
        solutionfile       = ['BEMsolution_',uni_name,'_position',...
                             num2str(pt,'%02d'),'_FlowOff.mat'];
        
        %% Filename to save the OTV flow results (at the beads)                 
        set(0,'defaulttextinterpreter','latex','DefaultAxesFontSize',16);
        OTVfilename = [casefld_fullpath,'FlowSpeedOTV_',...
                       uni_name,'_',num2str(pt,'%02d'),'_FlowOff.mat'];
    case 'other'
        %Please fill in the relevant folders here
     
end


%% Log
%{
% CONVENTION OF NAMING:
%       highest level : in Da's case, it corresponds to 'topfld', 'level0'.
%                       It's a folder that contains all flow velocimetry
%                       experiments. The immediate subfolders are named 
%                       with unique names, e.g. c1g, c5l etc.
%       scenario level: in Da's case, it corresponds to 'supfld', 'level1'.
%                       It's a folder contain consists of ~10 case folders.
%                       Each scenario is on one cell (till 20170718), with 
%                       beads placed at different positions away from the
%                       cell
%       case level    : in Da's case, it corresponds to 'casefld','level2'.
%                       One case folder contains 50~500 imgs where the cell
%                       swims for 5~50 cycles. 
%                       It's worth noticing that the name of each case
%                       folder must be 1~2 digit(s) number. The variable 
%                       that stores this number is named 'pt' for point, due 
%                       to historical reason. 
%}
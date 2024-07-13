% This script adds all the maybe-needed subfunctions and scripts to the
% current working space

fdPathOneLevelHigherThan000Routine = fullfile('D:','SurfDrive',...
                                     '008 MATLAB code backup');
fdAllRoutines                      = fullfile(...
                                     fdPathOneLevelHigherThan000Routine,...
                                     '000 Routine');

%% hydrodynamics
addpath(fullfile(fdAllRoutines,'subunit of hydrodynamics'))
                                 
%% img analysis
addpath(fullfile(fdAllRoutines,'PIVware','PIVware for Matlab'))
addpath(fullfile(fdAllRoutines,'000 img analysis'))
addpath(fullfile(fdAllRoutines,'subunit of img treatment routines'))

%% PSD signal treatment
addpath(fullfile(fdAllRoutines,'001 PSD signal analysis'))
addpath(fullfile(fdAllRoutines,'subunit of PSD treatment routines'))

%% miscellaneous
addpath(fullfile(fdAllRoutines,'subunit of miscellaneous data treatment'))
addpath(fullfile(fdPathOneLevelHigherThan000Routine,...
        '003 Standalone scripts'));
    
%% Flow velocimetry
fdFlowVelocimetries = fullfile(fdAllRoutines,'002 flow velocimetry');
addpath(fdFlowVelocimetries)
addpath(fullfile(fdFlowVelocimetries,'Comparison with OT data'))
addpath(fullfile(fdFlowVelocimetries,'Comparison with OT data',...
        'subunit of flow velocimetry analysis'))

addpath(fullfile(fdFlowVelocimetries,'Image processing'))
addpath(fullfile(fdFlowVelocimetries,'CFD'))      
addpath(fullfile(fdFlowVelocimetries,'CFD','BEM'))      
addpath(fullfile(fdFlowVelocimetries,'CFD','distmesh'))     
addpath(fullfile(fdFlowVelocimetries,'CNN flagella tracking')) 

addpath(fullfile(fdFlowVelocimetries,'PTV'))      


%% Danish Lorentzian package.
addpath(fullfile('D:','Programs and files','Optical tweezers calib. v2',...
        'tweezercalib'))
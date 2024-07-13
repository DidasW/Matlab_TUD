clear variables;
close all; clc
addpath(genpath('./'))
addpath(genpath('./BEM'));
addpath(genpath('./distmesh'));
addpath('/Users/Jan/Documents/MEGA/WB/M2/Thesis/Matlab/Flagella tracking/movies/4-26/cal'); %path for the flagella signal
set(0,'defaulttextinterpreter','latex')
set(0,'DefaultAxesFontSize',16)

scenario = 'NoSynchrony';

switch scenario
    case 'Synchrony'
        datasets        = 6;                    %Number of datasets
        flnm       = cell(datasets);       %File names
        flnm{1}    = 'Data/Synchrony/4-26 19 2000-2750 corrected.mat';
        flnm{2}    = 'Data/Synchrony/4-26 32 2000-2750 corrected.mat';
        flnm{3}    = 'Data/Synchrony/4-26 45 2000-2750 corrected.mat';
        flnm{4}    = 'Data/Synchrony/4-26 58 2000-2750 corrected.mat';
        flnm{5}    = 'Data/Synchrony/4-26 73 2000-2750 corrected.mat';
        flnm{6}    = 'Data/Synchrony/4-26 88 2000-2750 corrected.mat';
        name{1}         = '4-26 19';    name{2}         = '4-26 32';
        name{3}         = '4-26 45';    name{4}         = '4-26 58';
        name{5}         = '4-26 73';    name{6}         = '4-26 88';
    case 'NoSynchrony'
        datasets        = 6;
        flnm       = cell(datasets);       %File names
        flnm{1}    = 'Data/No Synchrony/4-26 9 2000-2750 corrected';
        flnm{2}    = 'Data/No Synchrony/4-26 17 2000-2750 corrected';
        flnm{3}    = 'Data/No Synchrony/4-26 27 2000-2750 corrected';
        flnm{4}    = 'Data/No Synchrony/4-26 40 2000-2750 corrected';
        flnm{5}    = 'Data/No Synchrony/4-26 53 6000-6750 corrected';
        flnm{6}    = 'Data/No Synchrony/4-26 68 3000-3750 corrected';
        name{1}         = '4-26 9';     name{2}         = '4-26 17';
        name{3}         = '4-26 27';    name{4}         = '4-26 40';
        name{5}         = '4-26 53';    name{6}         = '4-26 68';
end

pipettefile     = './Data/meshes/pipette_4-26_445_328';

switch scenario
    case {'Synchrony','NoSynchrony'}
        for ff=1:datasets
            clearvars -except scenario datasets flnm name ff pipettefile flowshift
            waveformsfile = flnm{ff};
            savefilename = [name{ff} ' new BEMsolution'];
            flowshift = 0;
            Flow_Around_Chlamy 
        end
    case 'Shift'
        phistep  = pi/8;
        phishift = phistep:pphistep:2*pi-phistep;
        waveformsfile = 'Data/Shift/Shift 0 corrected BEMsolution.mat';
        for ss=1:length(phishift)
            flowshift = phishift(ss);
            savefilename = ['Shift ' num2str(flowshift/pi) ' pi new BEMsolution.mat'];
            Flow_Around_Chlamy
        end
end
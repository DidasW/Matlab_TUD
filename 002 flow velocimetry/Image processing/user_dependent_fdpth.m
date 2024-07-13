%% Add relevant folders, used in Image processing package for flow velocimetry

switch user
    case 'Chris'
        cd('/Users/Jan/Documents/MEGA/WB/M2/Thesis/Matlab/Flagella tracking/movies')
        addpath('/Users/Jan/Documents/MEGA/WB/M2/Thesis/Matlab/Flagella tracking/Geyer2013/PCA fmincon curv');
    case 'Greta'
    case 'Daniel'
    case 'Da'
        cd('D:\004 FLOW VELOCIMETRY DATA\')
        run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')
        % will add all the pathes needed

    case 'other'
        %Please fill in the relevant folders here
end
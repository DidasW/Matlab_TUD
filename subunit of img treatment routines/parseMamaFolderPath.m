%% Doc
% The folder structure used in investigating the flagellar synchrnoization
% to external flow of different directions, is as follows:
% experiment_path:  ...\YYMMDD c<i>\c<i>\
% mama_folder_path: ...\experiment_path\01XY\,
%                   ...\experiment_path\02MinXY\,
%                   ...\experiment_path\03Axial\,
%                   ...\experiment_path\##XXXXX\.
% note: variable name adopted for backward compatibility.
%     Any folder named as such contains directly the folders that each
%     contains an experimental recording.
% 
% experiment: this string is used in the switch-case structure that
%     specifies the experimental parameters, such as fps, strain, cell
%     orientation, etc.

%%
function [MFN,experiment,...
          experiment_path] = parseMamaFolderPath(mama_folder_path)
    if mama_folder_path(end) == '\' || mama_folder_path(end) == '/'
        [experiment_path,MFN,~]= fileparts(mama_folder_path(1:end-1)); 
    else
        [experiment_path,MFN,~]= fileparts(mama_folder_path); 
    end
    
    if experiment_path(end) == '\' || experiment_path(end) == '/'
        [temp,~,~]= fileparts(experiment_path(1:end-1)); 
    else
        [temp,~,~]= fileparts(experiment_path); 
    end
    [~,experiment,~] = fileparts(temp); 
end
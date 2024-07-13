% scenario level operation
source_filepth= 'D:\004 FLOW VELOCIMETRY DATA\c18r\04\Blimit_04_final.mat';
L1_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\c18r\';
L2_fdpth_list = dir(L1_fdpth);
N_L2          = length(L2_fdpth_list);
filename      = 'Blimit_04_final.mat';

for i = 1:N_L2
    L2_fdname= L2_fdpth_list(i).name;
    L2_fdpth = [fullfile(L1_fdpth,L2_fdname),'\'];
    file_to_fullpth = fullfile(L2_fdpth,filename);
    if ~strcmp(source_filepth,file_to_fullpth)
        copyfile(source_filepth,file_to_fullpth);
    end
end
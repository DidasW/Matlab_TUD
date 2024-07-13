%% DOC
% level0_fdpth_from: the scenario folder which is usually named as
%                    XXXX_AF. XXXX here indicates the uni-name of a 
%                    cell-bead combination.
% level0_fdpth_to  : in general in the 004 FLOW VELOCIMETRY DATA\
%                    YOU DO NOT NEED TO SPECIFY THE SCENARIO NAME.
% img_idx_from/to  : images that one wants to analyze. It denpends on
%                    how many cycles of beat and the fps of image
%                    sequence. It cannot exceed the NoI value in the
%                    previous routine (Cut_image_sequence... .m)
% format_string    : format of the image names. In case the image is stored
%                    with names such as 1_000001.tif (%06d), usually don't
%                    need to modify.
% e.g.
% level0: ...\170703
% level1: ...\170703\c1b1_AF,c2b3_AF...
% level2: ...\170703\c1b1_AF\01,02,...,12
%% Add paths
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
%% Manually update settings
level0_fdpth_from = 'D:\001 RAW MOVIES\180903\';
level0_fdpth_to   = 'D:\004 FLOW VELOCIMETRY DATA\';
img_idx_from      = 1;       img_idx_to =100; 
format_string     = '%04d';
target_fdname     = 'c3b3_AF';
copy_all_level1_fd= 0;
% cell level, level 0 
% containing:  level1 folder such as 'c2b2_AF' and 'c2b3_AF'

level1_fdpth_from_list = dir(fullfile(level0_fdpth_from,'*_AF'));            
NoFd_level1            = length(level1_fdpth_from_list);
move_copy_list         = 1:NoFd_level1;

if ~copy_all_level1_fd
    level1_fdnamelist      = {level1_fdpth_from_list.name};
    move_copy_list         = find(strcmp(level1_fdnamelist,target_fdname));
end

%% Run
for i1 = move_copy_list
    % scenario level , level 1, e.g.  'c2b2_AF'
    % containing:  case folders such as '11_AF' and '14_AF'
    level1_fdname     = level1_fdpth_from_list(i1).name;  
	level1_fdpth_from = [level0_fdpth_from,level1_fdname,'\'];
	level1_fdpth_to   = [level0_fdpth_to  ,level1_fdname(1:end-3),'\'];% end-3 is to get rid of the '_AF' suffix
%     level1_fdpth_to   = [level0_fdpth_to  ,'c2f\'];
	if ~exist(level1_fdpth_to,'dir')
		mkdir(level1_fdpth_to);
	end
	level2_fdpath_from_list = dir(fullfile(level1_fdpth_from,'*_AF'));
	NoFd_level2       = length(level2_fdpath_from_list);

	for i2 = 1:NoFd_level2
        % case level, level 2, e.g. '14_AF' 
        % containing: MAYBE level 3 'shift' folder
		level2_fdname       = level2_fdpath_from_list(i2).name;
		level2_fdpth_from   = [level1_fdpth_from, level2_fdname,'\'];
		level2_fdpth_to     = [level1_fdpth_to,   level2_fdname(1:end-3),'\'];
		if ~exist(level2_fdpth_to,'dir')
			mkdir(level2_fdpth_to);
		end

		if exist([level2_fdpth_from,'shift\'],'dir')
			level2_fdpth_from = [level2_fdpth_from,'shift\'];
        end
        
		%% moving image
		for i3 = img_idx_from:img_idx_to
            % inside level 2(3), where imgs are stored
			img_name     = construct_file_name('1',i3,format_string);
            img_pth_from = [level2_fdpth_from,img_name];
            img_pth_to   = [level2_fdpth_to  ,img_name];
            copyfile(img_pth_from,img_pth_to);
        end
        sprintf('%s(L2 fd) under %s(L1 fd) processed',level2_fdname,level1_fdname)
	end

end
clear all
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
experiment = '181012c33l';
AA05_experiment_based_parameter_setting;

%%
NoPos = length(pt_list);
v_ax_raw_list  = cell(NoPos,1);
v_lat_raw_list = cell(NoPos,1);

for i = 1:NoPos
    pt = pt_list(i);
    posCode = num2str(pt,'%02d');
    findAllLogFile = dir(fullfile(AFpsd_fdpth,...
                     '*_AF_nm,ums,pN.mat'));
    allLogFileNames  = {findAllLogFile.name};
    idx_keyWordPos  = contains(allLogFileNames,'Pos');
    findAllLogFile(idx_keyWordPos) = [];
    
    if isempty(findAllLogFile)
        idx = contains(allLogFileNames,['Pos',posCode]);
        logFileName = allLogFileNames{idx};
    else
        idx = contains(allLogFileNames,posCode);
        logFileName = allLogFileNames{idx};
        if isempty(logFileName) % early data were named as 7_AF_nm... .mat
            idx = contains(allLogFileNames,num2str(pt));
            logFileName = allLogFileNames{idx};
        end
    end
    
    findLogFile = dir(fullfile(AFpsd_fdpth,logFileName));
    
    if strcmp(experiment,'171029c16l1')
        findLogFile = dir([AFpsd_fdpth,...
                           'Lateral_Pos',posCode,'_Meas01.mat']);
    end
    
    logFilePath = fullfile(findLogFile.folder,findLogFile.name);
    load(logFilePath,'v_x','v_y');
    disp([posCode,' compiled']);
       
    [vx_raw,vy_raw]=orient_flow_from_ScreenFrame_to_CellFrame(...
                    v_x,v_y,experiment); 
    v_ax_raw_list{i}  = vx_raw;
    v_lat_raw_list{i} = vy_raw;
end

save(fullfile(material_fdpth,'v_raw_list.mat'),...
    'v_ax_raw_list','v_lat_raw_list');
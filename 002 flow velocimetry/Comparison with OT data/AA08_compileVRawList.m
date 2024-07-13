clear all
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
experiment = '181002c28l1';
AA05_experiment_based_parameter_setting;

%% adjust oddly named pt_list
cd(AFpsd_fdpth)
if exist('*_AF.dat','file')
    rawdata_AF_struct = dir(fullfile(AFpsd_fdpth,'*_AF.dat')); % AF: after flash
else
    rawdata_AF_struct = dir(fullfile(AFpsd_fdpth,'*.dat')); 
end
pt_list_checkup

%%
NoPos = length(pt_list);
v_ax_raw_list  = cell(NoPos,1);
v_lat_raw_list = cell(NoPos,1);

for i = 1:NoPos
    pt = pt_list(i);
    
    if abs(pt) < 100
        posCode = num2str(pt,'%02d');
    else 
        posCode = num2str(pt);
    end
    
    %% Find converted .mat files by AA06
    if exist(fullfile(AFpsd_fdpth,'*_AF_nm,ums,pN.mat'),'file')
        findAllLogFile = dir(fullfile(AFpsd_fdpth,...
                         '*_AF_nm,ums,pN.mat'));
    else  
        findAllLogFile = dir(fullfile(AFpsd_fdpth,...
                         '*_nm,ums,pN.mat'));
    end
    
    %% Determine the naming system
    allLogFileNames  = {findAllLogFile.name};
    idx_keyWordPos  = contains(allLogFileNames,'Pos');
    findAllLogFile(~idx_keyWordPos) = [];
    
    % New system: PosXX_MeasXX.mat
    if ~isempty(findAllLogFile) 
        switch experiment
            case  {'190414c56g1','190414c56g2','190414c56g3',...
                    '190414c56g4','190414c56g5'}
                % e.g. parse 605 as x=06 y=05;
                posCode2 = posCode(end-1:end); % last 2 digits
                posCode1 = posCode(1:end-2);   % other digits
                posCode1 = sprintf('%02d',str2double(posCode1));
                idx = contains(allLogFileNames,['Pos',posCode1,...
                      '_Meas',posCode2]);
                logFileName = allLogFileNames{idx};
            otherwise
                idx = contains(allLogFileNames,['Pos',posCode]);
                logFileName = allLogFileNames{idx};
        end

    else % Old system: 7(_AF)_nm... .mat                     
        idx = contains(allLogFileNames,posCode);
        logFileName = allLogFileNames{idx};
        if isempty(logFileName) 
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
       
    [v_ax_raw,v_lat_raw]=orient_flow_from_ScreenFrame_to_CellFrame(...
                         v_x,v_y,experiment); 
    v_ax_raw_list{i}  = v_ax_raw;
    v_lat_raw_list{i} = v_lat_raw;
end

save(fullfile(material_fdpth,'v_raw_list.mat'),...
    'v_ax_raw_list','v_lat_raw_list');
save(fullfile(material_fdpth,'pt_list.mat'),...
    'pt_list');
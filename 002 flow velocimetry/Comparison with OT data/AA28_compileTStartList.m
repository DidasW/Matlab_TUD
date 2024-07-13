%%
experiment = '281002c27a' %'181207c34a';
AA05_experiment_based_parameter_setting;

NoPos = length(pt_list);
t_start_list = zeros(NoPos,1);
%%
for i = 1:NoPos
    pt = pt_list(i);
    
    if abs(pt) < 100
        posCode = num2str(pt,'%02d');
    else 
        posCode = num2str(pt);
    end
    
    %% find video cut log files
    switch length(posCode)
        case {1,2}
            findLogFile = dir([AFpsd_fdpth,'*',posCode,'_log.mat']);
            if isempty(findLogFile)
                posCode = num2str(pt,'%01d');
                findLogFile = dir([AFpsd_fdpth,'*',posCode,'_log.mat']);
            end
        case {3,4,5}
            posCode2 = posCode(end-1:end); % last 2 digits
            posCode1 = posCode(1:end-2);   % other digits
            posCode1 = sprintf('%02d',str2double(posCode1));
            findLogFile = dir([AFpsd_fdpth,'*',posCode1,posCode2,...
                          '_log.mat']);
    end
    
    %% test if the log matches 1-to-1
    switch length(findLogFile)
        case 0
            error(['Cannot find video cut log for pos',posCode]);
        case 1
            logFilePath = fullfile(findLogFile.folder,findLogFile.name);
            load(logFilePath,'t_start');
            t_start_list(i) = t_start;
        otherwise
            warning(['More than one video cut log found for pos',posCode]);
            disp('Use the first one found')
            logFilePath = fullfile(findLogFile(1).folder,...
                                   findLogFile(1).name);
            load(logFilePath,'t_start');
            t_start_list(i) = t_start;
    end
    disp([posCode,' registered, ', num2str(t_start,'%.3f'),' ms']);
end
%%
save(fullfile(material_fdpth,'t_start_list.mat'),'t_start_list');
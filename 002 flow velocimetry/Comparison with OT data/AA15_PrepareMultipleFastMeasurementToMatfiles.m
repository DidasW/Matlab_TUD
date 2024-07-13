%% dealing with data 20171008
%% Doc
% Convert the experimental PSD data into flow speed, in batch
clear all
close all

%% Add path of necessary functions
run('D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\add_path_for_all.m')

%% Experiment setting
experiment = '180419c17l';
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters
camera_orientation = 'after 201704';
conversion_method  = 2;                  % 0: use 5th order polinomial
                                         % 1: correct 5th order polynomial
                                         %    with linear conversion
                                         % 2: use linear plane conversion

%% Define folder path, build file list

temp  = dir(fullfile(AFpsd_fdpth,'volt*.dat')) ;
SubstrateVoltFileList = {temp.name};
clear temp

temp  = dir(fullfile(AFpsd_fdpth,'coef*.txt')) ;
CoefFileList = {temp.name};
clear temp

temp  = dir(fullfile(rawfiles_fdpth,'Flow*.dat')) ;
FlowFileList = {temp.name};
clear temp

%% Build position information list
beadcoords          = dlmread(beadcoords_pth);
[xgb_list,ygb_list] = BeadCoordsFromFile(beadcoords_pth,pt_list,experiment);
Nopos               = length(pt_list); % number of positions, 

% %% Preallocation
% temp1           = zeros(Nopos,1);  % array to store a list of scalars
% temp2           = cell (Nopos,1);  % cell to store a list of vectors    
% vx_raw_list     = temp2;     vy_raw_list     = temp2;
% vx_list         = temp2;     vy_list         = temp2;
% vx_max_list     = temp1;     vy_max_list     = temp1;
% vx_min_list     = temp1;     vy_min_list     = temp1;
% vx_mean_list    = temp1;     vy_mean_list    = temp1;
% vx_ampl_list    = temp1;     vy_ampl_list    = temp1;
% 
% f_list          = temp2;
% pos_info   = pt_list;
% clear temp1 temp2

%% begin processing
for i = 1:length(FlowFileList)
    % check whether it is for the same measurement
    VoltFileName = SubstrateVoltFileList{i};
    CoefFileName = CoefFileList{i};
    FlowFileName = FlowFileList{i};
    InfoStr1     = VoltFileName(6:end-4); 
    InfoStr2     = CoefFileName(6:end-4);
    InfoStr3     = FlowFileName(6:end-4);
    subs_path    = fullfile(rawfiles_fdpth,VoltFileName);
    coef_path    = fullfile(rawfiles_fdpth,CoefFileName);
    data_path    = fullfile(rawfiles_fdpth,FlowFileName);

    if strcmp(InfoStr3,InfoStr1) && strcmp(InfoStr3,InfoStr2)
        % fprintf('can proceed')
        % if all three files are from the same measurement
        InfoStr  = InfoStr1;
        temp     = strsplit(InfoStr,'_');
        direction_str   = temp{1};
        position_str    = temp{2};
        measurement_str = temp{3};
        direc     = direction_str;
        pos_code  = str2double(position_str(end-1:end));
        meas_code = str2double(measurement_str(end-1:end));
        [xgb,ygb] = BeadCoordsFromFile(beadcoords_pth,pos_code,experiment);
        
        %% substrate
        substrate_V= dlmread(subs_path);
        subx_V  = substrate_V(:,1);
        suby_V  = substrate_V(:,2);
        subs_nm = ConvertVtoNM(subx_V,suby_V,coef_path);
        % Cam orientation after 201704
        subx_nm = subs_nm(:,1); subx = mean(subx_nm);
        suby_nm = subs_nm(:,2); suby = mean(suby_nm);

        %% flow
        rawdata_V  = dlmread(data_path);
        Vx = rawdata_V(:,1);
        Vy = rawdata_V(:,2); 
        rawdata_nm     = ConvertVtoNM(Vx,Vy,coef_path);
        % Cam orientation after 201704
        nmx = rawdata_nm(:,1);
        nmy = rawdata_nm(:,2);
        % Cut substrate
        nmy_AS = nmy - suby;       %nmy_AS : after subtraction of the substrate
        nmx_AS = nmx - subx;
        v_y = nmx_AS * stiff_y / 0.8995 / beadsize * 100;   % micron/s, 
        v_x = nmy_AS * stiff_x / 0.8995 / beadsize * 100;   % 22 degrees Celcius
        
        
        v_ax_raw  = - v_y;
        v_lat_raw = - v_x;
        
        save(fullfile(matfiles_fdpth,[InfoStr,'.mat']))
       
    else
        sprintf('Combination problematic %s\n%s\n%s',SubstrateVoltFileList{i},...
            CoefFileList{i},FlowFileList{i})
        
    end
    
    
end

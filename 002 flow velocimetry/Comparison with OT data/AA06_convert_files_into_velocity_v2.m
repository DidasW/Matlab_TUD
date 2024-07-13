%% Doc
% Convert the experimental PSD data into flow speed, in batch
% 2017-11-15, I pack the core part of conversion into a function. Before,
% it was using ConvertVtoNM(), which essentially convert array to array;
% now it's ConvertPSDVoltFileToBeadPos() which directly takes the file
% paths in, and output the nmx and nmy on the screen's frame.

%% Add path of necessary functions
clear all
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
%% Experiment setting
experiment = '181002c28l1';
AA05_experiment_based_parameter_setting; % set file pathes and experiment
                                         % -based parameters
conversion_method  = 2;                  % 0: use 5th order polinomial
                                         % 1: correct 5th order polynomial
                                         %    with linear conversion
                                         % 2: use linear plane conversion
subtract_subs      = 0;                  % 1: subtract the background 
                                         %    measured in volt.dat
                              
                                         
%% Create an array of filepath
cd(AFpsd_fdpth)
if exist('*_AF.dat','file')
    rawdata_AF_struct = dir(fullfile(AFpsd_fdpth,'*_AF.dat')); % AF: after flash
else
    rawdata_AF_struct = dir(fullfile(AFpsd_fdpth,'*.dat')); 
end
NoFile            = length(rawdata_AF_struct);             % No. of File

%%
pt_list_checkup;

%% Convert each file
for i = 1:numel(pt_list)
    filename   = rawdata_AF_struct(i).name;
    posCode    = pt_list(i);
    posCodeStr = num2str(posCode,'%02d');
    data_path  = fullfile(AFpsd_fdpth,filename);
    handeled_filename = [filename(1:end-4),'_nm,ums,pN.mat'];
    %% For measurements that each has its own coef and volt 
    if ~exist('coef_path','var')
        findCoefFile = dir([RawPSD_fdpth,'*coef*Pos',posCodeStr,'*.txt']);
        if isempty(findCoefFile)
            findCoefFile = dir(fullfile(RawPSD_fdpth,'calib',...
                               ['*coef*Pos',posCodeStr,'*.txt']));
        end  
        idx_linearCoef = find(contains({findCoefFile.name},...
            'linear'));
        findCoefFile(idx_linearCoef) = [];
        switch length(findCoefFile)
            case 0
                error(['Cannot find coef*.txt file for pos',posCodeStr]);
            case 1
                coef_path = fullfile(findCoefFile.folder,findCoefFile.name);
            otherwise
                warning(['More than one coef*.txt file found for pos',...
                    posCodeStr]);
                disp('By default: 5th order ones')
                disp('Use the first one found')
                coef_path = fullfile(findCoefFile(1).folder,...
                                     findCoefFile(1).name);
        end
    end    
    if ~exist('subs_path','var')
        findVoltFile = dir(fullfile(RawPSD_fdpth,'calib',...
                           ['*volt*Pos',posCodeStr,'*.dat']));
        if isempty(findVoltFile)
            findVoltFile = dir([RawPSD_fdpth,'*volt*Pos',posCodeStr,'*.dat']);
        end
        switch length(findVoltFile)
            case 0
                error(['Cannot find volt*.txt file for pos',posCodeStr]);
            case 1
                subs_path = fullfile(findVoltFile.folder,findVoltFile.name);
            otherwise
                warning(['More than one volt*.txt file found for pos',posCodeStr]);
                disp('Use the first one found')
                subs_path = fullfile(findVoltFile(1).folder,...
                                     findVoltFile(1).name);
        end
    end

    
    [nmx,nmy] = ConvertPSDVoltFileToBeadPos(data_path,coef_path,subs_path,...
                                            experiment,subtract_subs);    

    switch conversion_method 
        case 0                  % use only 5th order, do nothing
        case {1,2}              % if linear conversion is needed, 
                                % check whether the coef_linear file is
                                % present
            coef_path_lin  = [coef_path(1:end-4),'_linear.txt'];
            if exist(coef_path_lin,'file')
                [nmx_lin,nmy_lin] = ConvertPSDVoltFileToBeadPos(data_path,...
                                    coef_path_lin,subs_path,experiment,...
                                    subtract_subs);
            else 
                warning('linear conversion not available, make the file first')
                warning('use 5th order polinomial to convert')
                nmx_lin = nmx; nmy_lin = nmy;
            end
        otherwise
            error('wrong conversion mode, set again.')
    end
    
    switch conversion_method
        case 0                  % use only 5th order, do nothing
        case 1                  % correct output with linear conversion
            % nmx
            dif_nmx = abs(nmx-nmx_lin);
            dif_nmy = abs(nmy-nmy_lin);
            idx_exceed = find(abs(nmx_lin)>80);
                                % ~80 nm is the valid range for 8 steps with
                                % 0.008 MHz stepsize.
            idx_differ = find(dif_nmx>5);
                                % when one axis trespass the valid range,
                                % the other one will share abnormality in
                                % the signal. While the linear conversion
                                % is more insensitive
            idx_combi  = cat(1,idx_exceed,idx_differ);
            idx_combi  = unique(idx_combi);
            nmx(idx_combi) = nmx_lin(idx_combi);
            
            % nmy
            idx_exceed = find(abs(nmy_lin)>80);
            idx_differ = find(dif_nmy>5);
            idx_combi  = cat(1,idx_exceed,idx_differ);
            idx_combi  = unique(idx_combi);
            nmy(idx_combi) = nmy_lin(idx_combi);
        case 2                  % use linear conversion
            nmx = nmx_lin;
            nmy = nmy_lin;
        otherwise
            error('wrong conversion mode, set again.')
    end
     
    % Note that the substrate has already been subtracted from nmx and nmy, 
    % if the subtract_subs == 1
    %% Calculating flow speed
    % NOTE: v_x, regardless of what is the camera orientation, is the
    % horizontal speed in the screen, and points to the left.
    % v_y points down with pipette heading right, up with pipette heading
    % down.
    
    if exist('beadsize','var')    
        v_y = nmy * stiff_y / 0.8995 / beadsize * 100;   % micron/s, 
        v_x = nmx * stiff_x / 0.8995 / beadsize * 100;   % 22 degrees Celcius
    else
        beadsize = 2.0;
        v_y = nmy * stiff_y / 0.8995 / beadsize * 100;   % micron/s, 
        v_x = nmx * stiff_x / 0.8995 / beadsize * 100;   % 22 degrees Celcius
        warning('Using default bead diameter %.2f micron',beadsize)
    end 
    %% Save necessary variables in to the matfile
    save(handeled_filename,'conversion_method', 'subtract_subs',...
        'Fs','beadsize','data_path','nmx','nmy','stiff_x','stiff_y',...
        'v_x','v_y','pt_list');
    
    disp([filename,'  done'])
end
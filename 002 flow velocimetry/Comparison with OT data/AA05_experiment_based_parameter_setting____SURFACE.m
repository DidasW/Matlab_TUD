%% Doc
% 20181005: change the meaning of the first digit of the date to the fast
%           camera orientation - defined also by the variable
%           pipettePointTo.
%           e.g. 180918c23g5 (no change), pipettePointTo: 'down'
%           e.g. 280918c23g4, same experiment done on cell-23,
%                pipettePointTo: 'right'
color_palette
%%
switch experiment
    case '181012c33l'          % local name c3b6
        %% Measurement setting
        Fs          = 10000;
        fps         = 712.37;
        fps_real    = fps ;         %
        stiff_x     = 0.016;      % x,y of the screen
        stiff_y     = 0.014;
        uni_name = experiment(7:end);%   
        pt_list        = [1:7];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181016 c31-c33';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
%         a            = 5.14;        
%         b            = 4.01;       
%         d            = 2.7;        
        beadsize     = 5.34;       
        flag_length  = 13.47;       
        
        fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        f0        = 49.50;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;       % List of image idx in each case folder          

%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '281012c33a2'         % local name c3b5
        %% Measurement setting
        Fs          = 10000;
        fps         = 712.37;
        fps_real    = fps ;         %
        stiff_x     = 0.016;      % x,y of the screen
        stiff_y     = 0.017;
        uni_name = experiment(7:end);%   
        pt_list        = [5:9];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181016 c31-c33';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
%         a            = 5.14;        
%         b            = 4.01;       
%         d            = 2.7;        
        beadsize     = 5.33;       
        flag_length  = 12.80;       
        
        fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        f0        = 52.50;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;       % List of image idx in each case folder          

%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '281012c33a1'         % local name c3b4
        %% Measurement setting
        Fs          = 10000;
        fps         = 712.37;
        fps_real    = fps ;         %
        stiff_x     = 0.018;      % x,y of the screen
        stiff_y     = 0.018;
        uni_name = experiment(7:end);%   
        pt_list        = [1:4];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181016 c31-c33';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
%         a            = 5.14;        
%         b            = 4.01;       
%         d            = 2.7;        
        beadsize     = 5.29;       
        flag_length  = 12.80;       
        
        fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        f0        = 52.50;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;       % List of image idx in each case folder          

%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '281012c32a'          % local name c2b3
        %% Measurement setting
        Fs          = 10000;
        fps         = 712.37;
        fps_real    = fps ;         %
        stiff_x     = 0.041;      % x,y of the screen
        stiff_y     = 0.044;
        uni_name = experiment(7:end);   
        pt_list        = [1:9];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181016 c31-c33';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
%         a            = 5.14;        
%         b            = 4.01;       
%         d            = 2.7;        
        beadsize     = 2.32;       
        flag_length  = 13.51;       
        
        fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        f0        = 42.90;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;       % List of image idx in each case folder          

%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '181012c32l'          % local name c2b2
        %% Measurement setting
        Fs          = 10000;
        fps         = 712.37;
        fps_real    = fps ;         %
        stiff_x     = 0.050;      % x,y of the screen
        stiff_y     = 0.048;
        uni_name = experiment(7:end);
        pt_list        = [1:7];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181016 c31-c33';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
%         a            = 5.14;        
%         b            = 4.01;       
%         d            = 2.7;        
        beadsize     = 2.47;       
        flag_length  = 13.51;       
        
        fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        f0        = 50 ;%42.90;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;       % List of image idx in each case folder          

%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '181012c31l'          % local name c1b1
        %% Measurement setting
        Fs          = 10000;
        fps         = 712.37;
        fps_real    = fps ;         %
        stiff_x     = 0.044;      % x,y of the screen
        stiff_y     = 0.042;
        uni_name = experiment(7:end);%   
        pt_list        = [1:6];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181016 c31-c33';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
%         a            = 5.14;        
%         b            = 4.01;       
%         d            = 2.7;        
        beadsize     = 2.28;       
        flag_length  = 13.47;       
        
        fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
%         f0        = 48.81;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;       % List of image idx in each case folder          

%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '181002c29l'          % local name c4b7
        %% Measurement setting
        Fs          = 10000;
        fps         = 717.06;
        fps_real    = fps ;         %
        stiff_x     = 0.011;      % x,y of the screen
        stiff_y     = 0.013;
        uni_name = experiment(7:end);%   
        pt_list        = [1:11];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181005 c27-c30';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
        a            = 5.14;        
        b            = 4.01;       
        d            = 2.7;        
        beadsize     = 5.96;       
        flag_length  = 13.47;       
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        f0        = 48.81;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;       % List of image idx in each case folder          

%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '281002c28l2'         % local name c3b5       
                %% Measurement setting
        Fs          = 10000;
        fps         = 712.37;
        fps_real    = fps ;       %
        stiff_x     = 0.039;      % x,y of the screen
        stiff_y     = 0.037;
        uni_name = experiment(7:end);%  
        pt_list        = [1:8];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181005 c27-c30';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
        a            = 3.69;        
        b            = 2.90;       
        d            = 2.7;        
        beadsize     = 2.44;       
        flag_length  = 12.10;               
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 48.60;         % Cell beat frequency estimate, [Hz]
%          list      = 1:50;       % List of image idx in each case folder          
% % 
%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '181002c28l1'         % local name c3b6
        %% Measurement setting
        Fs          = 10000;
        fps         = 712.37;
        fps_real    = fps ;       %
        stiff_x     = 0.017;      % x,y of the screen
        stiff_y     = 0.015;
        uni_name = experiment(7:end);%   'c28l1';
        pt_list        = [2:11];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181005 c27-c30';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
        a            = 3.69;        
        b            = 2.90;       
        d            = 2.7;        
        beadsize     = 5.37;       
        flag_length  = 12.10;               
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 48.60;         % Cell beat frequency estimate, [Hz]
%          list      = 1:50;       % List of image idx in each case folder          
% % 
%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '281002c29a'          % local name c4b8
        %% Measurement setting
        Fs          = 10000;
        fps         = 717.06;
        fps_real    = fps ;         %
        stiff_x     = 0.012;      % x,y of the screen
        stiff_y     = 0.012;
        uni_name = experiment(7:end);%   'c29a';
        pt_list        = [1:9];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181005 c27-c30';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
        a            = 5.14;        
        b            = 4.01;       
        d            = 2.7;        
        beadsize     = 5.29;       
        flag_length  = 13.47;       
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        f0        = 48.81;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;       % List of image idx in each case folder          

%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '281002c28a'          % local name c3b4
        %% Measurement setting
        Fs          = 10000;
        fps         = 664.59;
        fps_real    = fps ;         %
        stiff_x     = 0.039;      % x,y of the screen
        stiff_y     = 0.035;
        uni_name = experiment(7:end);%   'c28a';
        pt_list        = [1:12];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181005 c27-c30';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
        a            = 3.69;        
        b            = 2.90;       
        d            = 2.7;        
        beadsize     = 2.41;       
        flag_length  = 12.10;               
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 48.60;         % Cell beat frequency estimate, [Hz]
%          list      = 1:50;       % List of image idx in each case folder          
% % 
%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '281002c27a'          % local name c1b1
        %% Measurement setting
        Fs          = 10000;
        fps         = 660.56;
        fps_real    = fps ;         %
        stiff_x     = 0.015;      % x,y of the screen
        stiff_y     = 0.013;
        uni_name = experiment(7:end);%   'c27a';
        pt_list        = [1:12];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\181005 c27-c30';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
        a            = 5.19;        
        b            = 3.89;       
        d            = 2.0;        
        beadsize     = 5.40;       
        flag_length  = 12.06;       
        
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 51.43;         % Cell beat frequency estimate, [Hz]
%          list      = 1:50;       % List of image idx in each case folder          
% 
%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '180918c26wv'          % local name c4b8
        %% Measurement setting
        Fs          = 10000;
        fps         = 1362.42;
        fps_real    = fps ;         %
        %         stiff_x     = 0.021;      % x,y of the screen
        %         stiff_y     = 0.018;
        uni_name = experiment(7:end);%    = 'c23g1';
    case '180918c25wv'          % local name c3b7
        %% Measurement setting
        Fs          = 10000;
        fps         = 1362.42;
        fps_real    = fps ;         %
        %         stiff_x     = 0.021;      % x,y of the screen
        %         stiff_y     = 0.018;
        uni_name = experiment(7:end);%    = 'c23g1';
    case '180918c24wv'          % local name c2b7
        %% Measurement setting
        Fs          = 10000;
        fps         = 1362.42;
        fps_real    = fps ;         %
        %         stiff_x     = 0.021;      % x,y of the screen
        %         stiff_y     = 0.018;
        uni_name = experiment(7:end);%    = 'c23g1';
    case '180918c23wv'          % local name c1b6
        %% Measurement setting
        Fs          = 10000;
        fps         = 1362.42;
        fps_real    = fps ;         %
        %         stiff_x     = 0.021;      % x,y of the screen
        %         stiff_y     = 0.018;
        uni_name = experiment(7:end);%    = 'c23g1';
    case '180918c23g5'          % local name c1b5
        %% Measurement setting
        Fs          = 10000;
        fps         = 630.02;
        fps_real    = fps ;         %
        %         stiff_x     = 0.021;      % x,y of the screen
        %         stiff_y     = 0.018;
        uni_name = experiment(7:end);%   'c23g1';
        pt_list        = [1:5,11:15,21:25,31:35,41:45];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\180920 c23-c26';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
%       % cell  
%         a            = 4.20;        
%         b            = 4.20;       
%         d            = 3.8;        
%         beadsize     = 5.32;       
%         flag_length  = 11.66;       
% %         
%         fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
%         scale     = 9.35;       % Scale                  [px/micron]
%         lf0       = flag_length;
%         orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
%                                 % right,anti-clockwise rotation direction, 
%                                 % 1.5 pi for camera setting after 20170502
%         f0        = 51;         % Cell beat frequency estimate, [Hz]
% %          list      = 1:50;       % List of image idx in each case folder          
% % 
%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2; 
    case '280918c23g4'          % local name c1b4
        %% Measurement setting
        Fs          = 10000;
        fps         = 471.83;
        fps_real    = fps ;         %
        %         stiff_x     = 0.021;      % x,y of the screen
        %         stiff_y     = 0.018;
        uni_name = experiment(7:end);%   'c23g1';
        pt_list        = [3:8,13:19];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\180920 c23-c26';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
%       % cell  
%         a            = 4.20;        
%         b            = 4.20;       
%         d            = 3.8;        
%         beadsize     = 5.32;       
%         flag_length  = 11.66;       
% %         
%         %% For Make_limit_cycle.
%         fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
%         scale     = 9.35;       % Scale                  [px/micron]
%         lf0       = flag_length;
%         orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
%                                 % right,anti-clockwise rotation direction, 
%                                 % 1.5 pi for camera setting after 20170502
%         f0        = 51;         % Cell beat frequency estimate, [Hz]
% %          list      = 1:50;       % List of image idx in each case folder          
% % 
%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2;  
    case '280918c23g3'          % local name c1b3
        %% Measurement setting
        Fs          = 10000;
        fps         = 471.83;
        fps_real    = fps ;         %
        %         stiff_x     = 0.021;      % x,y of the screen
        %         stiff_y     = 0.018;
        uni_name = experiment(7:end);%   'c23g1';
        pt_list        = [3:8,13:18,23:28];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\180920 c23-c26';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
%       % cell  
%         a            = 4.20;        
%         b            = 4.20;       
%         d            = 3.8;        
%         beadsize     = 5.32;       
%         flag_length  = 11.66;       
% %         
%         %% For Make_limit_cycle.
%         fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
%         scale     = 9.35;       % Scale                  [px/micron]
%         lf0       = flag_length;
%         orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
%                                 % right,anti-clockwise rotation direction, 
%                                 % 1.5 pi for camera setting after 20170502
%         f0        = 51;         % Cell beat frequency estimate, [Hz]
% %          list      = 1:50;       % List of image idx in each case folder          
% % 
%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2; 
    case '280918c23g2'          % local name c1b2
        %% Measurement setting
        Fs          = 10000;
        fps         = 471.83;
        fps_real    = fps ;         %
        %         stiff_x     = 0.021;      % x,y of the screen
        %         stiff_y     = 0.018;
        uni_name = experiment(7:end);%   'c23g1';
        pt_list        = [1:8,14:18,24:28,34:38,43:44];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\180920 c23-c26';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];        
        %% Flagellar recognition
%       % cell  
%         a            = 4.20;        
%         b            = 4.20;       
%         d            = 3.8;        
%         beadsize     = 5.32;       
%         flag_length  = 11.66;       
% %         
%         %% For Make_limit_cycle.
%         fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
%         scale     = 9.35;       % Scale                  [px/micron]
%         lf0       = flag_length;
%         orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
%                                 % right,anti-clockwise rotation direction, 
%                                 % 1.5 pi for camera setting after 20170502
%         f0        = 51;         % Cell beat frequency estimate, [Hz]
% %          list      = 1:50;       % List of image idx in each case folder          
% % 
%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2; 
    case '280918c23g1'          % local name c1b1
        %% Measurement setting
        Fs          = 10000; 
        fps         = 471.83;
        fps_real    = fps ;         %
%         stiff_x     = 0.021;      % x,y of the screen
%         stiff_y     = 0.018;
        uni_name = experiment(7:end);%   'c23g1';
        pt_list        = [1:8,11:18,21:28,31:38,41:48,51:58];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = 'D:\OTV databank from D drive\180920 c23-c26';
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
                         '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
                          ['Position ',uni_name,'_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
                         '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
                         '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end                
               
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];        
        %% For Make_limit_cycle
%       % cell  
%         a            = 4.20;        
%         b            = 4.20;       
%         d            = 3.8;        
%         beadsize     = 5.32;       
%         flag_length  = 11.66;       
% %         
%         %% For Make_limit_cycle.
%         fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;          % Cell body halo color   0=dark, 1=bright
%         scale     = 9.35;       % Scale                  [px/micron]
%         lf0       = flag_length;
%         orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
%                                 % right,anti-clockwise rotation direction, 
%                                 % 1.5 pi for camera setting after 20170502
%         f0        = 51;         % Cell beat frequency estimate, [Hz]
% %          list      = 1:50;       % List of image idx in each case folder          
% % 
%       % plot
%         markertype   = 's';
%         markersize   = 6;
%         markersolid  = 0;     
%         markerColorSet = 2; 
    case '280903c22a2'          % local name c3b4
        %% Measurement setting
        Fs          = 10000; 
        fps         = 707.75;
        fps_real    = fps ;         %
        stiff_x     = 0.021;        % x,y of the screen
        stiff_y     = 0.018;
        uni_name    = experiment(7:end);% 'c22a2';
        %% Folder and file paths
        PSDtop_fdpth   = 'D:/000 RAW DATA FILES/180910 c20-c22/000 raw files/';
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        material_fdpth = [fullfile('D:/000 RAW DATA FILES/180910 c20-c22',...
                         '001 material',uni_name),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
                          ['Position ',uni_name,'_AfterRot_um.dat']);
        
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];

        result_fdpth   = [fullfile('D:\OTV databank from D drive\180910 c20-c22',...
                         '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        % video
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        
        
        pt_list        = [7:12];
        
        a            = 4.20;        
        b            = 4.20;       
        d            = 3.8;        
        beadsize     = 5.32;       
        flag_length  = 11.66;       
%         
        %% For Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 51;         % Cell beat frequency estimate, [Hz]
%          list      = 1:50;       % List of image idx in each case folder          
% 
        markertype   = 'h';
        markersize   = 6;
        markersolid  = 0;     
        markerColorSet = 2; 
    case '280903c22a1'          % local name c3b3
        %% Measurement setting
        Fs          = 10000; 
        fps         = 707.75;
        fps_real    = fps ;         %
        stiff_x     = 0.020;        % x,y of the screen
        stiff_y     = 0.017;
        uni_name    = experiment(7:end);% 'c22a1';
        %% Folder and file paths
        PSDtop_fdpth   = 'D:/000 RAW DATA FILES/180910 c20-c22/000 raw files/';
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        material_fdpth = [fullfile('D:/000 RAW DATA FILES/180910 c20-c22',...
                         '001 material',uni_name),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
                          ['Position ',uni_name,'_AfterRot_um.dat']);
        
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];

        result_fdpth   = [fullfile('D:\OTV databank from D drive\180910 c20-c22',...
                         '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        % video
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        
        
        pt_list        = [1:6];
        
        a            = 4.20;        
        b            = 4.20;       
        d            = 3.8;        
        beadsize     = 5.32;       
        flag_length  = 11.66;       
%         
        %% For Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 49;         % Cell beat frequency estimate, [Hz]
% %         list      = 1:50;       % List of image idx in each case folder          

        markertype   = 'h';
        markersize   = 6;
        markersolid  = 0;     
        markerColorSet = 2; 
    case '280903c21a'           % local name c2b2
        %% Measurement setting
        Fs          = 10000; 
        fps         = 707.75;
        fps_real    = fps ;         %
        stiff_x     = 0.022;        % x,y of the screen
        stiff_y     = 0.019;
        uni_name    = experiment(7:end);% 'c21a';
        %% Folder and file paths
        PSDtop_fdpth   = 'D:/000 RAW DATA FILES/180910 c20-c22/000 raw files/';
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        material_fdpth = [fullfile('D:/000 RAW DATA FILES/180910 c20-c22',...
                         '001 material',uni_name),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
                          ['Position ',uni_name,'_AfterRot_um.dat']);
        
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];

        result_fdpth   = [fullfile('D:\OTV databank from D drive\180910 c20-c22',...
                         '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        % video
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        
        
        pt_list        = [0:13];
        
        a            = 6.50;       
        b            = 5.90;        
        d            = 3.8;        
        beadsize     = 5.29;        % [micron], std 0.06
        flag_length  = 13.91;       %    
        %% For Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 48;         % Cell beat frequency estimate, [Hz]
        list      = 1:50;       % List of image idx in each case folder          

        markertype   = 'p';
        markersize   = 6;
        markersolid  = 1;     
        markerColorSet = 2;
    case '280903c20a'           % local name c1b1
        %% Measurement setting
        Fs          = 10000; 
        fps         = 707.75;
        fps_real    = fps ;         %
        stiff_x     = 0.045;        % x,y of the screen
        stiff_y     = 0.040;
        uni_name    = experiment(7:end);% 'c20a';
        %% Folder and file paths
        PSDtop_fdpth   = 'D:/000 RAW DATA FILES/180910 c20-c22/000 raw files/';
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        material_fdpth = [fullfile('D:/000 RAW DATA FILES/180910 c20-c22',...
                         '001 material',uni_name),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
                          ['Position ',uni_name,'_AfterRot_um.dat']);
        
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];

        result_fdpth   = [fullfile('D:\OTV databank from D drive\180910 c20-c22',...
                         '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        % video
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        
        
        pt_list        = [0:13];
        
        a            = 4.22;        
        b            = 3.90;       
        d            = 3.8;        
        beadsize     = 2.06;        % [micron], std 0.10
        flag_length  = 12.30;       % std 0.6            
        %% For Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 48;         % Cell beat frequency estimate, [Hz]
        list      = 1:50;       % List of image idx in each case folder          

        markertype   = 'v';
        markersize   = 6;
        markersolid  = 1;     
        markerColorSet = 2;
    case '180419c17l'           % local name c6b3
        Fs          = 10000; 
        fps         = 602.17;
        fps_real    = fps ;         %
        stiff_x     = 0.020;        % x,y of the screen
        stiff_y     = 0.019;
        uni_name    = experiment(7:end);% 'c17l';
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\180501 c17\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        material_fdpth = [PSDtop_fdpth,'material\'];
        beadcoords_pth = [PSDtop_fdpth,'position\',...
                          'Position c17l_AfterRot_um.dat'];
        
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\180501 c17\002 results\',...
                          uni_name,'\'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        % video
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        
        
        pt_list        = [1:16,18:20,22:31];
        
        a            = 5.37;        % std 0.10
        b            = 4.65;        % std 0.05
        d            = 4.0;        % avg 4.74, std 0.01,pos27
        beadsize     = 5.48;        % [micron], std 0.08
        flag_length  = 12.87;       % std 0.43 (181011) ||13.55 std 0.60 (measured 180425)            
        %% Flagellar recognition
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 51;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;       % List of image idx in each case folder          

        markertype   = 'd';
        markersize   = 6;
        markersolid  = 0;     
    case '171029c16l2'           % local name c6b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c16l2';
        
        TopRawData_fdpth = 'D:\OTV databank from D drive\171029 c13-c16\';
        beadcoords_pth = [TopRawData_fdpth, 'position\',...
                          'Position c16l2_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '000 raw files\'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '001 mat files\'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '002 mat files _ trash deleted\'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'\003 results\'];
        pt_list        = 0:7;
        
        a            = 4.97;        % std 0.11
        b            = 4.15;        % std 0.15
        d            = 3.47;        % std 0.06, measured with c3b3pos7
        beadsize     = 5.40;        % [micron], std 0.06
        flag_length  = 13.37;       % std 0.6    
        
        markertype   = '^';
        markersize   = 6;
        markersolid    = 1;       
    case '171029c16l1'           % local name c5b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c16l1';
        
        TopRawData_fdpth = 'D:\OTV databank from D drive\171029 c13-c16\';
        beadcoords_pth = [TopRawData_fdpth, 'position\',...
                          'Position c16l1_AfterRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '000 raw files\'];
        RawPSD_fdpth   = rawfiles_fdpth;
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '001 mat files\'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '002 mat files _ trash deleted\'];
        AFpsd_fdpth    = matfiles_fdpth;
        material_fdpth = 'D:\OTV databank from D drive\171029 c13-c16\c16l1\material\';
        result_fdpth   = [TopRawData_fdpth,uni_name,'\003 results\'];
        compiledData_pth = [result_fdpth,'171029c16l1_FitSegAvg.mat'];
        pt_list        = [0,3:14];
        
        %% For Make_limit_cycle.
        a            = 4.97;        % std 0.11
        b            = 4.15;        % std 0.15
        d            = 3.50;        % 3.47 std 0.06, measured with c3b3pos7
        beadsize     = 5.40;        % [micron], std 0.06
        
        flag_length  = 13.37;       % std 0.6    
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 53;         % Cell beat frequency estimate, [Hz]
        list      = 1:34;       % List of image idx in each case folder          
        
        %% Plot settings
        markertype   = '^';
        markersize   = 6;
        markersolid    = 1;
    case '171029c15l'            % local name c4b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c15l';
        
        TopRawData_fdpth = 'D:\OTV databank from D drive\171029 c13-c16\';
        beadcoords_pth = [TopRawData_fdpth, 'position\',...
                          'Position c15l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '000 raw files\'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '001 mat files\'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '002 mat files _ trash deleted\'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'\003 results\'];
        pt_list        = 3:8;
        
        a            = 3.15;        % std 0.13
        b            = 2.87;        % std 0.21
        d            = 3.47;        % std 0.06, measured with c3b3pos7
        beadsize     = 5.40;        % [micron], std 0.06
        flag_length  = 8.56;        % std 0.22    
        
        markertype   = 'x';
        markersize   = 10;
        markersolid    = 1;      
    case '171029c14l'            % local name c3b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c14l';
        
        TopRawData_fdpth = 'D:\OTV databank from D drive\171029 c13-c16\';
        beadcoords_pth = [TopRawData_fdpth, 'position\',...
                          'Position c14l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '000 raw files\'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '001 mat files\'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '002 mat files _ trash deleted\'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'\003 results\'];
        pt_list        = [6,7,8];
        
        a            = 3.50;        % std 0.14
        b            = 3.05;        % std 0.11
        d            = 3.47;        % std 0.06, measured with c3b3pos7
        beadsize     = 5.40;        % [micron], std 0.06
        flag_length  = 7.55;        % std 0.55    
        
        markertype   = 's';
        markersize   = 6;
        markersolid    = 1;   
    case '171029c13l'            % local name c2b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c13l';
        
        TopRawData_fdpth = 'D:\OTV databank from D drive\171029 c13-c16\';
        beadcoords_pth = [TopRawData_fdpth, 'position\',...
                          'Position c13l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '000 raw files\'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '001 mat files\'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '002 mat files _ trash deleted\'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'\003 results\'];
        pt_list        = [1,3,5,6];
        
        a            = 5.41;        % std 0.08
        b            = 4.65;        % std 0.12
        d            = 3.47;        % std 0.06, measured with c3b3pos7
        beadsize     = 5.40;        % [micron], std 0.06
        flag_length  = 12.27;       % std 0.33    
        
        markertype   = '.';
        markersize   = 10;
        markersolid    = 1; 
    case '171015c12l'               % local name c2b4
        Fs          = 10000; 
        fps         = 703.18;
        fps_real    = fps ;         %
        stiff_x     = 0.048;        % x,y of the screen
        stiff_y     = 0.057;
        uni_name    = experiment(7:end);% 'c12l';
        
        TopRawData_fdpth = 'D:\OTV databank from D drive\171015 c11-c12\';
        beadcoords_pth = [TopRawData_fdpth, 'position\',...
                          'Position c12l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '000 raw files\'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '001 mat files\'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '002 mat files _ trash deleted\'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'\003 results\'];
        pt_list        = 0:6;
        
        a            = 3.89;        %
        b            = 3.28;        % 
        d            = 3.52;        % std 0.12
        beadsize     = 2.54;        % [micron], std 0.05
        flag_length  = 10.65;       % std 0.54     
        
        markertype   = '+';
        markersize   = 6;
        markersolid    = 1;     
    case '171015c11l3'              % local name c1b3
        Fs          = 10000; 
        fps         = 626.40;
        fps_real    = fps ;         %
        stiff_x     = 0.044;        % x,y of the screen
        stiff_y     = 0.045;
        uni_name    = experiment(7:end);% 'c11l3';
        
        TopRawData_fdpth = 'D:\OTV databank from D drive\171015 c11-c12\';
        beadcoords_pth = [TopRawData_fdpth, 'position\',...
                          'Position c11l3_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '000 raw files\'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '001 mat files\'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '002 mat files _ trash deleted\'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'\003 results\'];
        pt_list      = 1:3;  
        
        a            = 5.05;        %
        b            = 5.08;        % 
        d            = 3;           % 2.51
        beadsize     = 2.35;        % [micron], std 0.05
        flag_length  = 13.18;       % std 0.39     
        
        markertype   = 'o';
        markersize   = 6;
        markersolid    = 1;
    case '171015c11l2'              % local name c1b2
        Fs          = 10000; 
        fps         = 637.39;
        fps_real    = fps ;         %
        stiff_x     = 0.026;        % x,y of the screen
        stiff_y     = 0.029;        % AVERAGED! CALIBRATION MISSING
        uni_name    = experiment(7:end);% 'c11l2';

        TopRawData_fdpth = 'D:\OTV databank from D drive\171015 c11-c12\';
        beadcoords_pth = [TopRawData_fdpth, 'position\',...
                          'Position c11l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '000 raw files\'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '001 mat files\'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '002 mat files _ trash deleted\'];                      
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'\003 results\'];
        pt_list      = 6:8;       
        
        a            = 5.05;        %
        b            = 5.08;        % 
        d            = 3;           % 2.51
        beadsize     = 5.32;        % [micron], std 0.05
        flag_length  = 13.18;       % std 0.39     
        
        markertype   = 'o';
        markersize   = 6;
        markersolid    = 1;
    case '171015c11l1'              % local name c1b1
        Fs          = 10000; 
        fps         = 637.39;
        fps_real    = fps ;         %   
        stiff_x     = 0.027;        % x,y of the screen
        stiff_y     = 0.027;        % AVERAGED! CALIBRATION MISSING
        uni_name    = experiment(7:end);% 'c11l1';
        
        TopRawData_fdpth = 'D:\OTV databank from D drive\171015 c11-c12\';
        beadcoords_pth = [TopRawData_fdpth, 'position\',...
                          'Position c11l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '000 raw files\'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '001 mat files\'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'\'...
                          '002 mat files _ trash deleted\'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'\003 results\'];
        pt_list      = 4:6;       
        
        a            = 5.05;        %
        b            = 5.08;        % 
        d            = 3;           % 2.51
        beadsize     = 6.03;        % [micron], std 0.05
        flag_length  = 13.18;       % std 0.39 
        
        markertype   = 'o';
        markersize   = 6;
        markersolid    = 1;
    case '171008c10l'               % local name c2b1
        Fs          = 10000;  
        fps         = 668.67;
        fps_real    = fps ;         %   
        stiff_x     = 0.021;        % x,y of the screen
        stiff_y     = 0.021;
        uni_name    = experiment(7:end);     % 'c10l';
        TopRawData_fdpth = 'D:\OTV databank from D drive\171008 c10\';
        beadcoords_pth = [TopRawData_fdpth, 'position\',...
                          'Position c10l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,'000 raw files\'];
        matfiles_fdpth = [TopRawData_fdpth,'001 mat files\'];
        matfiles_checked_fdpth = [TopRawData_fdpth,...
                          '002 mat files _ trash deleted\'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,'003 results\'];
        pt_list      = 1:8;
        
        a            = 3.27;    %
        b            = 3.02;    % 
        d            = 3;       % 3.19
        beadsize     = 5.99;    % [micron], std 0.06
        flag_length  = 9.36;   
        
        markertype   = 's';
        markersize   = 6;
        markersolid    = 0;
    case '170703c9l'                % local name c3b3
        uni_name    = experiment(7:end);% 'c9l';     
        Fs          = 10000;        % [Hz]
        stiff_x     = 0.020;        % x,y of the screen
        stiff_y     = 0.022;        % [pN/nm]
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171129 c5-c9\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171129 c5-c9\position\',...
                          'Position ',uni_name,'_AfterRot_um.dat'];
        compiledData_pth = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                            uni_name,'\',experiment,'_FitSegAvg.mat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters             
        start_frame    = 1;
        pt_list        = 1:10;
        
        a            = 5.13;   % cell's half long axis, micron. std 0.07
        b            = 4.31;   % half short axis, std 0.03
        d            = 3.10;   % pipette opening, outer diameter, std 0.19,
                               % measured in c8l pos6,2.89 in the first
                               % place, changed to 3.1 to generate pipette
        beadsize     = 5.46;   % [micron], std 0.06
        flag_length  = 11.27;  % [micron], std 0.44, use left flag
 
        % % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 53;         % Cell beat frequency estimate, [Hz]
        fps       = 813.38;     % Theoretical camera framing rate, [Hz]
        fps_real  = fps ;       %   
        list      = 1:120;      % List of image idx in each case folder          
        %% Plot
        markertype   = 'o';
        markersize   = 6;
        markersolid    = 0;
    case '170703c8l'                % local name c2b3
        uni_name    = experiment(7:end);        % 'c8l';     
        Fs          = 10000;                    % Hz
        stiff_x     = 0.020;                    % x,y of the screen
        stiff_y     = 0.022;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171129 c5-c9\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171129 c5-c9\position\',...
                          'Position ',uni_name,'_AfterRot_um.dat'];
        compiledData_pth = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                            uni_name,'\',experiment,'_FitSegAvg.mat'];                      
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters             
        start_frame    = 1;
        pt_list        = 3:12;
        
        a = 3.77; % long axis of the cell (half size), micron. std 0.05
        b = 3.39; % short axis, stf 0.05; 
        d = 3.10; % pipette opening. same pipette as c7,c9.
        beadsize     = 5.44;   % micron; std 0.06
        flag_length  = 10.20;  % [micron], left 10.13 std 0.23,
                               %          right 10.37 std 0.19
        % % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 50;        % Cell beat frequency estimate, [Hz]
        fps       = 813.38;    % Theoretical camera framing rate, [Hz]
        fps_real  = fps ;       %   
        list      = 1:120;     % List of image idx in each case folder
        %% Plot
        markertype   = '+';
        markersize   = 9;
        markersolid  = 1;
    case '170703c7l'                % local name c1b1
        uni_name    = experiment(7:end);   % 'c7l';           
        Fs          = 10000;               % [Hz]
        stiff_x     = 0.021;               % x,y of the screen
        stiff_y     = 0.024;               % [pN/nm]
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171129 c5-c9\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171129 c5-c9\position\',...
                          'Position ',uni_name,'_AfterRot_um.dat'];
        compiledData_pth = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                            uni_name,'\',experiment,'_FitSegAvg.mat'];
        material_fdpth = 'D:\OTV databank from D drive\180328 flow inversion\c7l\material\';
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters             
        start_frame    = 1;
        pt_list        = 1:12; % pos1 too far
%         pt_list      = [1];
        a            = 5.36;   % cell's half long axis, micron. std 0.13
        b            = 4.20;   % half short axis, std 0.12
        d            = 3.1;    % pipette opening 2.89, outer diameter, 
                               % std 0.19, measured in c8l pos6
                               % Adjusted to 3.1, otherwise pipette mesh
                               % fails
        beadsize     = 5.40;   % [micron], std 0.07
        flag_length  = 12.64;  % [micron], std 0.24,
 
        % % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 53;         % Cell beat frequency estimate, [Hz]
        fps       = 813.38;     % Theoretical camera framing rate, [Hz]
        fps_real  = fps ;       %   
        list      = 1:120;      % List of image idx in each case folder  
        %% Plot
        markertype   = '.';
        markersize   = 10;
        markersolid  = 1;
    case '170502c5g3'               % local name cell1b3grid
        uni_name    = experiment(7:end);        % 'c5g3';
        Fs          = 50000;                    % Hz
        stiff_x     = 0.059;                    % x,y of the screen
        stiff_y     = 0.063;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171129 c5-c9\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171129 c5-c9\position\',...
                          'Position ',uni_name(1:3),'_AfterRot_um.dat'];
        compiledData_pth = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                            uni_name,'\',experiment,'_FitSegAvg.mat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters             
        start_frame    = 1;
        pt_list        = [10 17 20 30 37 47 57];
                
        a            = 4.17;    % same as c5g1
        b            = 3.97;    % same as c5g1
        d            = 3.00;    % same as c5g1
        beadsize     = 2.46;    % [micron], std 0.05
        flag_length  = 13.30;   % same as c5g1
 
        % % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 47;         % Cell beat frequency estimate, [Hz]
        fps       = 381.09;     % Theoretical camera framing rate, [Hz]
        fps_real  = fps ;       %   
        list      = 1:60;       % List of image idx in each case folder
    case '170502c5g2'               % local name cell1b2grid
        uni_name    = experiment(7:end);        % 'c5g2';
        Fs          = 50000;                    % Hz
        stiff_x     = 0.058;                    % x,y of the screen
        stiff_y     = 0.058;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171129 c5-c9\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171129 c5-c9\position\',...
                          'Position ',uni_name(1:3),'_AfterRot_um.dat'];
        compiledData_pth = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                            uni_name,'\',experiment,'_FitSegAvg.mat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters             
        start_frame    = 1;
        pt_list        = [41:43,53:56,63:67,73:77,82:87];
%         pt_list        = [63:67];
%         pt_list        = [53:57];
        a            = 4.17;    % same as c5g1
        b            = 3.97;    % same as c5g1
        d            = 3.00;    % same as c5g1
        beadsize     = 2.43;    % [micron], std 0.05
        flag_length  = 13.30;   % same as c5g1
        % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 47;         % Cell beat frequency estimate, [Hz]
        fps       = 381.09;     % Theoretical camera framing rate, [Hz]
        fps_real  = fps ;       %         
        list      = 1:60;       % List of image idx in each case folder
    case '170502c5g1'               % local name cell1b1grid
        uni_name    = experiment(7:end);        % 'c5g1';
        Fs          = 50000;                    % Hz
        stiff_x     = 0.059;                    % x,y of the screen
        stiff_y     = 0.064;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171129 c5-c9\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171129 c5-c9\position\',...
                          'Position ',uni_name(1:3),'_AfterRot_um.dat'];
        compiledData_pth = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                            uni_name,'\',experiment,'_FitSegAvg.mat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters             
        start_frame    = 1;
        pt_list        = [11:16,21:26,31:36,44:46];
        %        
        a            = 4.17;    % cell's half long axis, micron. std 0.22
        b            = 3.97;    % half short axis, std 0.06
        d            = 3.00;    % 4.72 as the outer diameter, 3.00, 8degree, displacement 2.5
                                % adjusted pipette shape
                                % pipette opening, outer diameter, std 0.22
        beadsize     = 2.36;    % [micron], std 0.06
        flag_length  = 13.30;   % [micron], std 0.53, use left flag
                                % right flag: 12.84, std 0.53
        % % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 47;         % Cell beat frequency estimate, [Hz]
        fps       = 381.09;     % Theoretical camera framing rate, [Hz]
        fps_real  = fps ;       % 
        list      = 1:60;       % List of image idx in each case folder
    case '170502c5l'                % local name cell1b1lateral
        uni_name       = experiment(7:end);     % 'c5l';
        Fs             = 50000;                 % Hz
        stiff_x        = 0.050;                 % x,y of the screen
        stiff_y        = 0.054;                 % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171129 c5-c9\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171129 c5-c9\position\',...
                          'Position ',uni_name,'_AfterRot_um.dat'];
        compiledData_pth = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                            uni_name,'\',experiment,'_FitSegAvg.mat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171129 c5-c9\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters             
        start_frame    = 1;
        pt_list        = 1:12;
        %
        a            = 4.17;    % same as c5g1
        b            = 3.97;    % same as c5g1
        d            = 4.72;    % same as c5g1
        beadsize     = 2.31;    % [micron], std 0.07
        flag_length  = 13.30;   % same as c5g1
        % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 47;         % Cell beat frequency estimate, [Hz]
        fps       = 493.18;     % Theoretical camera framing rate, [Hz]
        fps_real  = fps ;       % theoretical 493.18;
        list      = 1:250;      % List of image idx in each case folder      
        %% Plot
        markertype   = 's';
        markersize   = 6;
        markersolid    = 1;
%% UNDERGOING REGISTRATION
    case '270223c3g2'               % local name c2b4
        uni_name    = experiment(7:end);        % 'c3g2';
        Fs          = 50000;                    % Hz
        fps         = 475.95;                   % Theoretical camera framing rate, [Hz]
        fps_real    = fps ;                     %
        stiff_x     = 0.091;                    % x,y of the screen
        stiff_y     = 0.087;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171128 c0-c3\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171128 c0-c3\position\',...
                          'Position ',uni_name,'_AfterRot_um.dat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171128 c0-c3\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters       
        start_frame    = 1;
        pt_list        = [13,14,21:24,31:34,41,44,51,54];
       
%         a            = 5.36;   % cell's half long axis, micron. std 0.13
%         b            = 4.20;   % half short axis, std 0.12
%         d            = 3.1;    % pipette opening 2.89, outer diameter, 
%                                
        beadsize     = 1.32;   % [micron], std 0.08
        flag_length  = 12.04;  % [micron], std 0.98,
 
        % % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;     % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 50;         % Cell beat frequency estimate, [Hz]
        list      = 1:55;      % List of image idx in each case folder       
    % Note: In all foregoing scenarios, room temperature has been set as 25
    % degrees, i.e. stokes coefficient 0.840. Since 170223c3g2, the
    % temperature is set as 22 degree celcius, corresponding to a drag
    % coefficient of 0.8995
    case '270130c2f'                % local name c2f
        uni_name       = experiment(7:end);     % 'c2f';
        Fs             = 5000;                  % Hz
        fps            = 573.65;
        fps_real       = fps;                   % theoretical 573.65;
        stiff_x        =  0.059;                % x,y of the screen
        stiff_y        =  0.065;                % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171128 c0-c3\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171128 c0-c3\position\',...
                          'Position ',uni_name,'_AfterRot_um.dat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171128 c0-c3\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters             
        start_frame = 1;                     %
        pt_list     = 0:7;
        a           = 4.32; % long axis of the cell (half size), micron.
        b           = 3.33; % short axis
        d           = 3.09; % pipette opening.
        beadsize    = 1.23 ;% micron, std 0.05       
		flag_length  = 11.65;  % [micron], std 0.31,
 
        % % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;     % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 50;         % Cell beat frequency estimate, [Hz]
        list      = 1:40;      % List of image idx in each case folder    
    case '270130c2g'                % local name c2r, name before 20171128 c2r
        uni_name        = 'c2g';
        Fs              = 5000;                 % Hz
        fps             = 336.40;
        fps_real        = fps;                  % theoretical 336.40;
        stiff_x         = 0.059 ;               % x,y of the screen
        stiff_y         = 0.065 ;               % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171128 c0-c3\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171128 c0-c3\position\',...
                          'Position ',uni_name,'_AfterRot_um.dat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171128 c0-c3\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters      
        pt_list         = [1,2,3,4,11,12,13,14];
        start_frame     = 1;                    %
        a            = 4.38;   % cell's half long axis, micron. std 0.08
        b            = 3.22;   % half short axis, std 0.05
		d 			 = 2.60;   % pipette opening.std 0.13                                
        beadsize     = 1.32;   % [micron], std 0.08
        flag_length  = 11.65;  % [micron], std 0.31,
 
        % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;     % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 50;         % Cell beat frequency estimate, [Hz]
        list      = 1:70;      % List of image idx in each case folder    
    case '270130c1g'                % local name c1g
        uni_name   = 'c1g';
        Fs         = 5000;                      % Hz
        fps        = 411.29;
        fps_real   = fps;                       % theoretical 411.29; 
        stiff_x    =  0.055;                    % x,y of the screen
        stiff_y    =  0.061;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171128 c0-c3\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171128 c0-c3\position\',...
                          'Position ',uni_name,'_AfterRot_um.dat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171128 c0-c3\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters        
        pt_list         = [32,31,33:35,11:15,21:25,41,42,52,55];
        start_frame_list= ones(size(pt_list))*101;
        pt_list         = [pt_list,45,51];
        start_frame_list= [start_frame_list,201,511];
 
%         start_frame    = 201;
%         pt_list        = [45];
               
%         start_frame    = 510;
%         pt_list        = [51];
        a = 4.01; % std 0.05 long axis of the cell (half size), micron.
        b = 2.81; % std 0.06short axis
        d = 2.60; % pipette opening.std 0.13 
        beadsize     = 1.26; % [micron] std 0.09; 
		flag_length  = 9.32;  % [micron], std 0.28,
 
        % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        % colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        % colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        % colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;     % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 50;         % Cell beat frequency estimate, [Hz]
        list      = 1:70;      % List of image idx in each case folder  
    case '261230c0g2'               % local name c2b3
                                    % for case folders 21-23,31-34
        uni_name       = experiment(7:end);     % 'c0g2';
        Fs             = 50000;                 % Hz
        fps            = 434.23;
        fps_real       = fps;                   % theoretical 434.23;
        stiff_x        = 0.069 ;                % x,y of the screen
        stiff_y        = 0.088 ;                % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171128 c0-c3\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171128 c0-c3\position\',...
                          'Position ',uni_name(1:3),'_AfterRot_um.dat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171128 c0-c3\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters             
        start_frame    = 201; 
        pt_list        = [21:23,32:34]; 
%         pt_list      = [34];
        a            = 4.43;   % cell's half long axis, micron. std 0.13
        b            = 4.03;   % half short axis, std 0.07
		d            = 3.31;   % std 0.14                               
        beadsize     = 1.37;   % [micron], std 0.16
        flag_length  = 13.87;  % [micron], std 0.70,
 
        % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;     % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 50;         % Cell beat frequency estimate, [Hz]
        list      = 1:70;      % List of image idx in each case folder  
    case '261230c0g1'               % local name c2b2
                                    % for case folders 11-14,24
        %% Measurement setting
        Fs          = 10000;
        fps         = 717.06;
        fps_real    = fps ;         %
        stiff_x     = 0.012;      % x,y of the screen
        stiff_y     = 0.012;
        uni_name = experiment(7:end);%   'c29a';
        uni_name       = experiment(7:end);     % 'c0g1';
        Fs             = 50000;                 % Hz
        fps            = 475.95;
        fps_real       = fps;                   % theoretical 475.95;
        stiff_x        = 0.068 ;                % x,y of the screen
        stiff_y        = 0.083 ;                % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = 'D:\OTV databank from D drive\171128 c0-c3\000 raw files\';
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'\'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF\'];
        coef_path      = [RawPSD_fdpth,'calib\coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib\volt.dat'];% Substrate of the voltage signal, filepath 
        beadcoords_pth = ['D:\OTV databank from D drive\171128 c0-c3\position\',...
                          'Position ',uni_name(1:3),'_AfterRot_um.dat'];
        % video
        top_fdpth      = 'D:\004 FLOW VELOCIMETRY DATA\';
        scenario_fdpth = [top_fdpth,uni_name,'\'];
        % results 
        result_fdpth   = ['D:\OTV databank from D drive\171128 c0-c3\002 results\',...
                          uni_name,'\'];
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
        %% CFD parameters             
        pt_list         = [11,12,13,14,24];   % only for case 11, it is 200 
        start_frame_list= [201,501,501,501,501];
%         start_frame     = 501;
        
        
        a            = 4.43;   % cell's half long axis, micron. std 0.13
        b            = 4.03;   % half short axis, std 0.07
		d            = 3.31;   % std 0.14                               
        beadsize     = 1.37;   % [micron], std 0.16
        flag_length  = 13.87;  % [micron], std 0.70,
 
        % for Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
         colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
         colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
         colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;     % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 50;         % Cell beat frequency estimate, [Hz]
        fps       = 475.95;     % Theoretical camera framing rate, [Hz]
        list      = 1:70;      % List of image idx in each case folder      
    otherwise 
        error('experiment does not exist')
end

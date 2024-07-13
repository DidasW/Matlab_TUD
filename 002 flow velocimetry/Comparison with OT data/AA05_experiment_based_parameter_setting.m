 %% Doc
% 20181005: change the meaning of the first digit of the date to the fast
%           camera orientation - defined also by the variable
%           pipettePointTo.
%           e.g. 180918c23g5 (no change), pipettePointTo: 'down'
%           e.g. 280918c23g4, same experiment done on cell-23,
%                pipettePointTo: 'right'
% Keywords:    l, lateral
%              a/f, axial
%              g, grid
%              wv, waveform
%              c t, cis and trans

%% Da
localDataPath = 'F:\999 PhD Data\Analyzed Data';
OTVBackupPath = 'F:\999 PhD Data\Analyzed Data\008 OTV';
MSTGBackupPath= 'F:\999 PhD Data\mstg pack';
switch experiment
    case {'190604c60wvc','190604c60wvt'} % local name c4b4, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 707.75;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190604c60wvt'  % local name c1b1
                pt_list     = [1:2]; %#ok<*NBRAK>
                stiff_x     = 0.03915; % x,y of the screen
                stiff_y     = 0.03639;
                beadsize    = 2.30;  % default
            case '190604c60wvc' % local name c1b1
                pt_list     = [3:4];
                stiff_x     = 0.03915; % x,y of the screen
                stiff_y     = 0.03639;
                beadsize    = 2.30;  % default
                
        end
        flag_length = 10.88; 
        lf0         = flag_length;
        f0          = 45.34;    
        eyespot     = 'left';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190604 c57-c60');
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
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.dat'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        top_fdpth      = 'M:\tnw\bn\mea\Shared\Algae\005 Flow velocimetry images\'; % images
        %% Flagellar recognition
        % cell  
        a            = 4.34;        
        b            = 3.73;       
        d            = 2.87;        
        beadsize     = 2.78;     
        
        fileformatstr = '%05d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        list      = 1:50;       % List of image idx in each case folder
    case {'190604c59wvc','190604c59wvt'} % local name c3b3, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 707.75;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190604c59wvc'  % local name c1b1
                pt_list     = [1:2]; %#ok<*NBRAK>
                stiff_x     = 0.02392; % x,y of the screen
                stiff_y     = 0.01965;
                beadsize    = 2.30;  % default
            case '190604c59wvt' % local name c1b1
                pt_list     = [3:4];
                stiff_x     = 0.02392; % x,y of the screen
                stiff_y     = 0.01965;
                beadsize    = 2.30;  % default
                
        end
        flag_length = 9.46; 
        lf0         = flag_length;
        f0          = 45.34;    
        eyespot     = 'right';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190604 c57-c60');
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
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.dat'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        top_fdpth      = 'M:\tnw\bn\mea\Shared\Algae\005 Flow velocimetry images\'; % images
        %% Flagellar recognition
        % cell  
        a            = 3.67;        
        b            = 2.39;       
        d            = 1.93;        
        beadsize     = 2.78;     
        
        fileformatstr = '%05d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        list      = 1:50;       % List of image idx in each case folder
    case {'190604c58wvc','190604c58wvt'} % local name c2b2, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 707.75;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190604c58wvt'  % local name c1b1
                pt_list     = [1:2]; %#ok<*NBRAK>
                stiff_x     = 0.03815; % x,y of the screen
                stiff_y     = 0.03753;
                beadsize    = 2.30;  % default
            case '190604c58wvc' % local name c1b1
                pt_list     = [3:4];
                stiff_x     = 0.03815; % x,y of the screen
                stiff_y     = 0.03753;
                beadsize    = 2.30;  % default
                
        end
        flag_length = 12.26; 
        lf0         = flag_length;
        f0          = 45.34;    
        eyespot     = 'left';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190604 c57-c60');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_BeforeRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.dat'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        top_fdpth      = 'M:\tnw\bn\mea\Shared\Algae\005 Flow velocimetry images\'; % images
        %% Flagellar recognition
        % cell  
        a            = 4.06;        
        b            = 2.96;       
        d            = 1.98;        
        beadsize     = 2.78;     
        
        fileformatstr = '%05d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        list      = 1:50;       % List of image idx in each case folder
    case {'190604c57wvc','190604c57wvt'} % local name c1b1, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 707.75;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190604c57wvt'  % local name c1b1
                pt_list     = [1:2]; %#ok<*NBRAK>
                stiff_x     = 0.04283; % x,y of the screen
                stiff_y     = 0.03856;
                beadsize    = 2.30;  % default
            case '190604c57wvc' % local name c1b1
                pt_list     = [3:4];
                stiff_x     = 0.04283; % x,y of the screen
                stiff_y     = 0.03856;
                beadsize    = 2.30;  % default
                
        end
        flag_length = 7.98; 
        lf0         = flag_length;
        f0          = 45.34;    
        eyespot     = 'left';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190604 c57-c60');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_BeforeRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.dat'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        top_fdpth      = 'M:\tnw\bn\mea\Shared\Algae\005 Flow velocimetry images\'; % images
        %% Flagellar recognition
        % cell  
        a            = 4.02;        
        b            = 3.17;       
        d            = 2.07;        
        beadsize     = 2.43;     
        
        fileformatstr = '%05d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        list      = 1:50;       % List of image idx in each case folder

    case {'190414c56g1','190414c56g2','190414c56g3',...
          '190414c56g4','190414c56g5',...
          '190414c56wvc','190414c56wvt'}% local name c1b1-c1b6
        %% Measurement setting
        Fs          = 10000;
        uni_name    = experiment(7:end);
        switch experiment
            case '190414c56g1'
                pt_list     = [101:2:113,201:2:213]; 
                stiff_x     = 0.0086; % x,y of the screen
                stiff_y     = 0.0086;
                beadsize    = 5.40; % default  
                fps         = 668.67;
            case '190414c56g2'
                pt_list     = [301:2:311,401:2:411,...
                               501:2:511,512,...
                               607:2:611,612]; 
                stiff_x     = 0.0097; % x,y of the screen
                stiff_y     = 0.0079;
                beadsize    = 5.40; % default  
                fps         = 668.67;               
            case '190414c56g3'
                pt_list     = [400:2:412,502:2:510,...
                               601,602,603:2:607]; 
                stiff_x     = 0.0110; % x,y of the screen
                stiff_y     = 0.0087;
                beadsize    = 5.40; % default  
                fps         = 668.67;
            case '190414c56g4'
                pt_list     = [300:2:310,604:2:610]; 
                stiff_x     = 0.0097; % x,y of the screen
                stiff_y     = 0.0088;
                beadsize    = 5.40; % default  
                fps         = 668.67;
            case '190414c56g5'
                pt_list     = [100:2:112,200:2:212]; 
                stiff_x     = 0.0090; % x,y of the screen
                stiff_y     = 0.0079;
                fps         = 668.67;
                beadsize    = 5.40; % default  
            case '190414c56wvc'
                pt_list     = [1:3]; 
                stiff_x     = 0.0282; % x,y of the screen
                stiff_y     = 0.0180;
                beadsize    = 2.30; % default  
                fps         = 1415.50;
            case '190414c56wvt'
                pt_list     = [4,6]; 
                stiff_x     = 0.0282; % x,y of the screen
                stiff_y     = 0.0180;
                beadsize    = 2.30; % default  
                fps         = 1415.50;
        end        
        fps_real    = fps ;
        flag_length = 18.82; 
        lf0         = flag_length; 
        f0          = 51.10; % default    
        strain      = 'wt';
        eyespot     = 'right';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190415 c56');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoef
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% BrownianMotion
    case '190409c55lz' % local name c5b6
        %% Measurement setting
        Fs          = 10000;
        fps         = 801.42;
        fps_real    = fps ; 
        uni_name    = experiment(7:end);
        pt_list     = [1:14]; %#ok<*NBRAK>
        stiff_x     = 0.0115; % x,y of the screen
        stiff_y     = 0.0148;
        beadsize    = 5.45;  
        flag_length = 13.0; % 1.80 estimation
        lf0         = flag_length; 
        f0          = 50.09;    
        strain      = 'wt';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190410 c51-c55');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoef
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% BrownianMotion
    case '190409c54lz' % local name c4b5
        %% Measurement setting
        Fs          = 10000;
        fps         = 801.42;
        fps_real    = fps ; 
        uni_name    = experiment(7:end);
        pt_list     = [1:4,6:14]; %#ok<*NBRAK>
        stiff_x     = 0.0157; % x,y of the screen
        stiff_y     = 0.0137;
        beadsize    = 5.27;  % default
        flag_length = 11.56; % 1.80 estimation 
        lf0         = flag_length;
        f0          = 48.57;    
        strain      = 'wt';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190410 c51-c55');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoef
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% BrownianMotion
    case {'190409c53lz','190409c53l'} % local name c3b3-c3b4
        %% Measurement setting
        Fs          = 10000;
        fps         = 801.42;
        fps_real    = fps ; 
        uni_name    = experiment(7:end);
        switch experiment
            case '190409c53lz' % local name c3b3
                pt_list     = [1:14]; %#ok<*NBRAK>
                stiff_x     = 0.0153; % x,y of the screen
                stiff_y     = 0.0137;
                beadsize    = 5.27;  
            case '190409c53l' % local name c3b4
                pt_list     = [1:12]; 
                stiff_x     = 0.0140; % x,y of the screen
                stiff_y     = 0.0145;
                beadsize    = 5.49;  
        end
        flag_length = 12.04; 
        lf0         = flag_length;
        f0          = 52.04;    
        strain      = 'wt';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190410 c51-c55');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoef
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% BrownianMotion
    case '190409c52l'  % local name c2b2
        %% Measurement setting
        Fs          = 10000;
        fps         = 801.42;
        fps_real    = fps ; 
        uni_name    = experiment(7:end);
        pt_list     = [1:12]; %#ok<*NBRAK>
        stiff_x     = 0.0158; % x,y of the screen
        stiff_y     = 0.0140;
        beadsize    = 5.53;  
        flag_length = 11.02; 
        lf0         = flag_length;
        f0          = 57.24;    
        strain      = 'wt';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190410 c51-c55');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoef
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% BrownianMotion
    case '190409c51lz' % local name c1b1
        %% Measurement setting
        Fs          = 10000;
        fps         = 801.42;
        fps_real    = fps ; 
        uni_name    = experiment(7:end);
        pt_list     = [2:12]; %#ok<*NBRAK>
        stiff_x     = 0.0154; % x,y of the screen
        stiff_y     = 0.0155;
        beadsize    = 5.41; 
        flag_length = 10.0; % 1.80 estimation 
        lf0         = flag_length;
        f0          = 42.00;    
        strain      = 'wt';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190410 c51-c55');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoef
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% BrownianMotion
        
    case {'NOTE'}
    %{
      Note: 190409c51-c55 are wildtype cells taken for the phase delay on 
      Z direction of the cell, while the flagella plane is perpendicular 
      to the focal plane. As the dates do not conflict with mstg experiments
      190429c51-53, names are kept in the same way.
      190414c56 is a huge cell taken for flow field as well as the waveform.
      The reducer was put back to the camera during c56
    %}
    case {'190429c53wvc','190429c53wvt',... %re-name c58
         } % local name c10c, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 698.67;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190429c53wvt'  % local name c1b1
                pt_list     = [1:2]; %#ok<*NBRAK>
                stiff_x     = 0.04266; % x,y of the screen
                stiff_y     = 0.03624;
                beadsize    = 2.30;  % default
            case '190429c53wvc' % local name c1b2
                pt_list     = [3:4];
                stiff_x     = 0.04266; % x,y of the screen
                stiff_y     = 0.03624;
                beadsize    = 2.30;  % default
                
        end
        flag_length = 10.22; 
        lf0         = flag_length;
        f0          = 45.34;    
        eyespot     = 'right';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190429 c51-c53');
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
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.dat'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        top_fdpth      = 'M:\tnw\bn\mea\Shared\Algae\005 Flow velocimetry images\'; % images
        %% Flagellar recognition
        % cell  
        a            = 3.40;        
        b            = 3.24;       
        d            = 1.82;        
        beadsize     = 2.73;     
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        list      = 1:50;       % List of image idx in each case folder 
    case {'190429c52wvc','190429c52wvt',... %re-name c57
         } % local name c9c, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 698.67;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190429c52wvt'  % local name c1b1
                pt_list     = [3:4]; %#ok<*NBRAK>
                stiff_x     = 0.03518; % x,y of the screen
                stiff_y     = 0.03449;
                beadsize    = 2.30;  % default
            case '190429c52wvc' % local name c1b2
                pt_list     = [1:2];
                stiff_x     = 0.03518; % x,y of the screen
                stiff_y     = 0.03449;
                beadsize    = 2.30;  % default
                
        end
        flag_length = 11.50; 
        lf0         = flag_length;
        f0          = 45.34;    
        eyespot     = 'right';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190429 c51-c53');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_BeforeRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.dat'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        top_fdpth      = 'M:\tnw\bn\mea\Shared\Algae\005 Flow velocimetry images\'; % images
        %% Flagellar recognition
        % cell  
        a            = 3.84;        
        b            = 2.60;       
        d            = 1.80;        
        beadsize     = 2.57;     
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        list      = 1:50;       % List of image idx in each case folder 
    case {'190429c51wvc','190429c51wvt',... %re-name c56
         } % local name c8c, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 698.67;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190429c51wvt'  % local name c1b1
                pt_list     = [1:2]; %#ok<*NBRAK>
                stiff_x     = 0.03719; % x,y of the screen
                stiff_y     = 0.03763;
                beadsize    = 2.30;  % default
            case '190429c51wvc' % local name c1b2
                pt_list     = [3:4];
                stiff_x     = 0.03719; % x,y of the screen
                stiff_y     = 0.03763;
                beadsize    = 2.30;  % default
                
        end
        flag_length = 11.50; 
        lf0         = flag_length;
        f0          = 45.34;    
        eyespot     = 'left';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190429 c51-c53');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_BeforeRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.dat'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        top_fdpth      = 'M:\tnw\bn\mea\Shared\Algae\005 Flow velocimetry images\'; % images
        %% Flagellar recognition
        % cell  
        a            = 3.96;        
        b            = 2.60;       
        d            = 2.22;        
        beadsize     = 2.79;     
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                    % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        list      = 1:50;       % List of image idx in each case folder
    case {'190315c50l','190315c50wvc','190315c50wvt',...
         } % local name c1b1-c1b2, mstg1
        %% Measurement setting
        Fs          = 10000;
        fps         = 756.9;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190315c50l'  % local name c1b1
                pt_list     = [1:13]; 
                stiff_x     = 0.007; % x,y of the screen
                stiff_y     = 0.006;
                beadsize    = 6.63;  % default     
            case '190315c50wvc' % local name c1b2
                pt_list     = [3,4];
                stiff_x     = 0.036; % x,y of the screen
                stiff_y     = 0.033;
                beadsize    = 2.64;  % default
            case '190315c50wvt' % local name c1b2
                pt_list     = [1,2];
                stiff_x     = 0.036; % x,y of the screen
                stiff_y     = 0.033;
                beadsize    = 2.64;  % default
        end
        flag_length = 11.92; 
        lf0         = flag_length;
        f0          = 50;    
        eyespot     = 'left';   
        strain      = 'mstg1';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190315 c48-c50');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
    case {'190315c49l','190315c49wvc','190315c49wvt',...
         } % local name c2b3-c2b4, mstg1
        %% Measurement setting
        Fs          = 10000;
        fps         = 756.9;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190315c49l'  % local name c1b1
                pt_list     = [1:14]; 
                stiff_x     = 0.014; % x,y of the screen
                stiff_y     = 0.012;
                beadsize    = 5.27;  % default     
            case '190315c49wvc' % local name c1b2
                pt_list     = [1,2];
                stiff_x     = 0.035; % x,y of the screen
                stiff_y     = 0.032;
                beadsize    = 2.64;  % default
            case '190315c49wvt' % local name c1b2
                pt_list     = [3,4];
                stiff_x     = 0.035; % x,y of the screen
                stiff_y     = 0.032;
                beadsize    = 2.64;  % default
        end
        flag_length = 12.07; 
        lf0         = flag_length;
        f0          = 50;    
        eyespot     = 'right';   
        strain      = 'mstg1';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190315 c48-c50');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
                         ['Position c49wvc_AfterRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
    case {'190315c48l','190315c48wvc','190315c48wvt',...
         } % local name c1b1-c1b2, mstg1
        %% Measurement setting
        Fs          = 10000;
        fps         = 756.9;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190315c48l'  % local name c1b1
                pt_list     = [1:13]; 
                stiff_x     = 0.011; % x,y of the screen
                stiff_y     = 0.012;
                beadsize    = 5.31;  % default     
            case '190315c48wvc' % local name c1b2
                pt_list     = [1,2];
                stiff_x     = 0.038; % x,y of the screen
                stiff_y     = 0.035;
                beadsize    = 2.57;  % default
            case '190315c48wvt' % local name c1b2
                pt_list     = [3,4];
                stiff_x     = 0.038; % x,y of the screen
                stiff_y     = 0.035;
                beadsize    = 2.57;  % default
        end
        flag_length = 11.58; 
        lf0         = flag_length;
        f0          = 50;    
        eyespot     = 'right';   
        strain      = 'mstg1';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190315 c48-c50');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion           
    case {'190224c47l','190224c47wvc','190224c47wvt',...
         } % local name c4b7-c4b8, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 717.06;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190224c47l'  % local name c4b7
                pt_list     = [1:2,4:13]; 
                stiff_x     = 0.014; % x,y of the screen
                stiff_y     = 0.012;
                beadsize    = 5.40;  % default     
            case '190224c47wvc' % local name c4b8
                pt_list     = [1,2,6];
                stiff_x     = 0.043; % x,y of the screen
                stiff_y     = 0.036;
                beadsize    = 2.30;  % default
            case '190224c47wvt' % local name c4b8
                pt_list     = [3:5];
                stiff_x     = 0.043; % x,y of the screen
                stiff_y     = 0.036;
                beadsize    = 2.30;  % default
        end
        flag_length = 12.17; 
        lf0         = flag_length;
        f0          = 43.76;    
        eyespot     = 'right';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190226 c44-c47');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion           
    case {'190224c46wvt','190224c46wvc','190224c46l',...
         } % local name c3b5-c3b6, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 717.06;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190224c46wvt' % local name c3b5
                pt_list     = [1:3];
                stiff_x     = 0.040; % x,y of the screen
                stiff_y     = 0.032;
                beadsize    = 2.30;  % default
            case '190224c46wvc' % local name c3b5
                pt_list     = [4:5];
                stiff_x     = 0.040; % x,y of the screen
                stiff_y     = 0.032;
                beadsize    = 2.30;  % default
            case '190224c46l'  % local name c3b6
                pt_list     = [1:9,11:13]; 
                stiff_x     = 0.014; % x,y of the screen
                stiff_y     = 0.012;
                beadsize    = 5.40;  % default     
        end
        flag_length = 9.31; 
        lf0         = flag_length;
        f0          = 40.14;    
        eyespot     = 'left';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190226 c44-c47');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion           
    case {'190224c45l','190224c45wvc',...
         } % local name c2b3-c2b4, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 717.06;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190224c45l'  % local name c2b3
                pt_list     = [1:15]; %#ok<*NBRAK>
                stiff_x     = 0.014; % x,y of the screen
                stiff_y     = 0.013;
                beadsize    = 5.40;  % default
            case '190224c45wvc' % local name c2b4
                pt_list     = [1:2];
                stiff_x     = 0.042; % x,y of the screen
                stiff_y     = 0.036;
                beadsize    = 2.30;  % default
        end
        flag_length = 12.10; 
        lf0         = flag_length;
        f0          = 45.90;    
        eyespot     = 'left';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190226 c44-c47');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion           
    case {'190224c44l','190224c44wvc','190224c44wvt',...
         } % local name c1b1-c1b2, cw15
        %% Measurement setting
        Fs          = 10000;
        fps         = 717.06;
        fps_real    = fps ;  %
        uni_name    = experiment(7:end);
        switch experiment
            case '190224c44l'  % local name c1b1
                pt_list     = [1,3:12]; %#ok<*NBRAK>
                stiff_x     = 0.013; % x,y of the screen
                stiff_y     = 0.012;
                beadsize    = 5.40;  % default
            case '190224c44wvc' % local name c1b2
                pt_list     = [1:4];
                stiff_x     = 0.041; % x,y of the screen
                stiff_y     = 0.038;
                beadsize    = 2.30;  % default
            case '190224c44wvt' % local name c1b2
                pt_list     = [5:7];
                stiff_x     = 0.041; % x,y of the screen
                stiff_y     = 0.038;
                beadsize    = 2.30;  % default
                
        end
        flag_length = 14.50; 
        lf0         = flag_length;
        f0          = 45.34;    
        eyespot     = 'right';   
        strain      = 'cw15';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190226 c44-c47');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion           
    case {'190214c43l','190214c43wv1','190214c43wv2',...
         }           % local name c3b3, mstg1
        %% Measurement setting
        Fs          = 10000;
        fps         = 756.90;
        fps_real    = fps ;  %
        stiff_x     = 0.024; % x,y of the screen
        stiff_y     = 0.024;
        uni_name    = experiment(7:end);
        switch experiment
            case '190214c43l'
                pt_list     = [1:18]; 
            case '190214c43wv1'
                pt_list     = [5];
            case '190214c43wv2'
                pt_list     = [17];
        end
        beadsize    = 2.30;  % default
        flag_length = 11.02; 
        lf0         = flag_length;
        f0          = 48.63;
        strain      = 'mstg1';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190214 c40-c43');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion    
    case {'190214c42l','190214c42wv1','190214c42wv2',...
         }% local name c3b3, mstg1
        %% Measurement setting
        Fs          = 10000;
        fps         = 756.90;
        fps_real    = fps ;  %
        stiff_x     = 0.025; % x,y of the screen
        stiff_y     = 0.021;
        uni_name    = experiment(7:end);
        switch experiment
            case '190214c42l'
                pt_list     = [1:18]; 
            case '190214c42wv1'
                pt_list     = [5];
            case '190214c42wv2'
                pt_list     = [17];
        end
        beadsize    = 2.30;  % default
        flag_length = 11.02;
        lf0         = flag_length;
        f0          = 55.40;
        strain      = 'mstg1';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190214 c40-c43');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion    
    case {'190214c41l','190214c41wv',...
         }% local name c2b2, mstg1
        %% Measurement setting
        Fs          = 10000;
        fps         = 756.90;
        fps_real    = fps ;  %
        stiff_x     = 0.025; % x,y of the screen
        stiff_y     = 0.025;
        uni_name    = experiment(7:end);
        switch experiment
            case '190214c41l'
                pt_list     = [1:10];
            case '190214c41wv' % wvt, based on slip
                pt_list     = [2:3];
        end
        beadsize    = 2.30;  % default
        flag_length = 9.26; 
        lf0         = flag_length;
        f0          = 55.47;    
        strain      = 'mstg1';
        
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190214 c40-c43');
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
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion     
    case {'190214c40l','190214c40wvt','190214c40wvc',...
         } % local name c1b1, mstg1
        %% Measurement setting
        Fs          = 10000;
        fps         = 756.90;
        fps_real    = fps ;  %
        stiff_x     = 0.023; % x,y of the screen
        stiff_y     = 0.025;
        uni_name    = experiment(7:end);
        switch experiment
            case '190214c40l'
                pt_list     = [1:18]; %#ok<*NBRAK>
            case '190214c40wvt'
                pt_list     = [4:6];
            case '190214c40wvc'
                pt_list     = [17:18];
        end
        beadsize    = 2.30;  % default
        flag_length = 14.66; 
        lf0         = flag_length;
        f0          = 50.59;    
        eyespot     = 'left';   
        strain      = 'mstg1';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190214 c40-c43');
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
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion           
    case '190110c39wvt'         % local name c2b6, mstg1
        %% Measurement setting
        Fs          = 10000;
        fps         = 908.28;
        fps_real    = fps ;  %
        stiff_x     = 0.020; % x,y of the screen
        stiff_y     = 0.025;
        uni_name    = experiment(7:end);
        pt_list     = [1:3];
        beadsize    = 2.30;  % default
        flag_length = 13.10; 
        lf0         = flag_length;
        f0          = 50;    % default
        strain      = 'mstg1';
        eyespot     = 'left';   
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190111 c38-c39');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion    
    case {'190110c38zc1','190110c38zc2','190110c38zt','190110c38z',...
          '190110c38wvc','190110c38wvt','190110c38lc','190110c38a',...
         }% local name c1b1-c1b5, mstg1 mutant
        %% Measurement setting
        Fs          = 10000;
        fps         = 908.28;
        fps_real    = fps ;         %
        switch experiment
            case {'190110c38zt','190110c38wvt'}  % local name c1b1
                stiff_x     = 0.037;           % x,y of the screen
                stiff_y     = 0.028;            
                  switch experiment 
                      case '190110c38zt'
                          pt_list     = 'ExtractFromFilenames';
                      case '190110c38wvt'
                          pt_list     = [1:4];
                  end
            case '190110c38zc1'                  % local name c1b2
                stiff_x     = 0.026;             % x,y of the screen
                stiff_y     = 0.028;           
                  pt_list     = 'ExtractFromFilenames';  
            case '190110c38zc2'                  % local name c1b3
                stiff_x     = 0.027;           % x,y of the screen
                stiff_y     = 0.030;           
                  pt_list     = 'ExtractFromFilenames';             
            case {'190110c38wvc','190110c38lc'}  % local name c1b4
                stiff_x     = 0.029;             % x,y of the screen
                stiff_y     = 0.029;            
                  switch experiment 
                      case '190110c38lc'
                          pt_list     = [1:5];
                      case '190110c38wvc'
                          pt_list     = [1:4];
                  end
            case {'190110c38a','190110c38z'}     % local name c1b5
                stiff_x     = 0.026;           % x,y of the screen
                stiff_y     = 0.023;            
                  switch experiment 
                      case '190110c38a'
                          pt_list     = [1:11];
                      case '190110c38z'
                          pt_list     = 'ExtractFromFilenames';   
                  end
        end
        uni_name = experiment(7:end);
        flag_length = 12.88; 
        beadsize    = 2.30;  % default
        lf0 = flag_length;
        f0  = 50;            % default
        eyespot     = 'left';
        strain      = 'mstg1';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190111 c38-c39');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        switch experiment
            case {'190110c38wvc','190110c38wvt'}
                AFpsd_fdpth=[fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
            otherwise
                AFpsd_fdpth    = RawPSD_fdpth;
        end
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
    case {'190104c37zc','190104c37zt',...
          '190104c37wvc','190104c37wvt','190104c37lc','190104c37z'...
         }% local name c2b3, c2b4
        %% Measurement setting
        Fs          = 10000;
        fps         = 698.67;
        fps_real    = fps ;         %
        switch experiment
            case {'190104c37zc','190104c37zt'} % local name c2b3
                stiff_x     = 0.013;           % x,y of the screen
                stiff_y     = 0.012;           % no flowCalib, use c36g2's
                beadsize    = 5.40;            % default    
                pt_list     = 'ExtractFromFilenames';
                eyespot     = 'right';
            case {'190104c37wvc','190104c37wvt'}% local name c2b4
                stiff_x     = 0.026;           % x,y of the screen
                stiff_y     = 0.025;
                beadsize    = 2.30;            % default
                pt_list     = [1:4];
                eyespot     = 'right';
            case '190104c37lc'                 % local name c2b4 
                stiff_x     = 0.026;           % x,y of the screen
                stiff_y     = 0.025;
                beadsize    = 2.30;            % default
                pt_list     = [1:7];
                eyespot     = 'right';
            case '190104c37z'                  % local name c2b4 
                stiff_x     = 0.026;           % x,y of the screen
                stiff_y     = 0.025;
                beadsize    = 2.30;            % default
                pt_list     = 'ExtractFromFilenames';
        end
        uni_name = experiment(7:end);
        flag_length = 11.13; 
        lf0 = flag_length;
        f0  = 46.58;
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190106 c36-c37');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        switch experiment
            case {'190104c37wvc','190104c37wvt'}
                AFpsd_fdpth=[fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
            otherwise
                AFpsd_fdpth    = RawPSD_fdpth;
        end
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
    case '190104c36g2'
        % local name c1b2
        %% Measurement setting
        Fs          = 10000;
        fps         = 698.67;  % unknown
        fps_real    = fps ;         %
        stiff_x     = 0.0130;      % x,y of the screen
        stiff_y     = 0.0120;
        uni_name    = experiment(7:end);
        pt_list     = [31:40,41:50,51:60,401,501,601];
          
        beadsize    = 5.40;  % default
        flag_length = 12.00; % default
        lf0 = flag_length;
        f0  = 50;            % default
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190106 c36-c37');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion    
        %% Extra note
        scale = 9.35/2; % reducer used
    case '190104c36g1'
        % local name c1b1
        %% Measurement setting
        Fs          = 10000;
        fps         = 698.67;  % unknown
        fps_real    = fps ;         %
        stiff_x     = 0.0130;      % x,y of the screen
        stiff_y     = 0.0125;
        uni_name    = experiment(7:end);
        pt_list     = [11:20,21:30,301];
          
        beadsize    = 5.40;  % default
        flag_length = 12.00; % default
        lf0 = flag_length;
        f0  = 50;            % default
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190106 c36-c37');
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        %% Extra note
        scale = 9.35/2; % reducer used
    case {'181207c35zt','181207c35zc'} % local name c3b5
        %% Measurement setting
        Fs          = 10000;
        fps         = 825.71;
        fps_real    = fps ;         %
        stiff_x     = 0.017;      % x,y of the screen
        stiff_y     = 0.018;
        uni_name    = experiment(7:end);    
        pt_list     = 'ExtractFromFilenames';
        beadsize    = 5.40;  % default
        flag_length = 12.79;
        lf0 = flag_length;
        f0  = 40;            % default
        eyespot = 'right';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'181207 c34zct-c35zct');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = RawPSD_fdpth;
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
    case {'181207c35a','181207c35lc','181207c35lt','181207c35z'}
        % local name c2b4,same cell as c2c,t, different bead
        %% Measurement setting
        Fs          = 10000;
        fps         = 825.71;
        fps_real    = fps ;         %
        stiff_x     = 0.017;      % x,y of the screen
        stiff_y     = 0.017;
        uni_name    = experiment(7:end);           
        switch experiment
            case '181207c35a'
                pt_list     = 1:13;
            case {'181207c35lc','181207c35lt'}
                pt_list     = 1:11;
                eyespot     = 'left';
            case '181207c35z'
                pt_list     = 'ExtractFromFilenames';
        end
        beadsize    = 5.53;  
        flag_length = 12.79;
        lf0 = flag_length;
        f0  = 40;            
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190103 c34-c35');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = RawPSD_fdpth;
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
    case {'181207c34zt','181207c34zc'} % local name c1b1
        %% Measurement setting
        Fs          = 10000;
        fps         = 825.71;
        fps_real    = fps ;       %
        stiff_x     = 0.016;      % x,y of the screen
        stiff_y     = 0.016;
        uni_name = experiment(7:end);
        pt_list     = 'ExtractFromFilenames';
        beadsize    = 5.40;  % default
        flag_length = 11.92;
        lf0         = flag_length;
        f0          = 50;    % default
        eyespot     = 'left';
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'181207 c34zct-c35zct');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = RawPSD_fdpth;
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
    case {'181207c34a','181207c34lc','181207c34lt'}
        % local name c1b1, same cell as c1t,c1c
        %% Measurement setting
        Fs          = 10000;
        fps         = 825.71;
        fps_real    = fps ;         %
        stiff_x     = 0.016;      % x,y of the screen
        stiff_y     = 0.016;
        uni_name = experiment(7:end);
        switch experiment
            case '181207c34a'
                pt_list     = 1:15;
            case '181207c34lc'
                pt_list     = 2:11;
            case '181207c34lt'
                pt_list     = 1:11;
        end
        
        beadsize    = 5.40;  % default
        flag_length = 11.92;
        lf0 = flag_length;
        f0  = 50;            % default
        eyespot     = 'left';        
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190103 c34-c35');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = RawPSD_fdpth;
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
    case '181207c34z'
        % local name c1b2, same cell as c1t,c1c
        %% Measurement setting
        Fs          = 10000;
        fps         = 825.71;  % unknown
        fps_real    = fps ;         %
        stiff_x     = 0.018;      % x,y of the screen
        stiff_y     = 0.017;
        uni_name    = experiment(7:end);
        pt_list     = 'ExtractFromFilenames';
          
        beadsize    = 5.40;  % default
        flag_length = 11.92;
        lf0 = flag_length;
        f0  = 50;            % default
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'190103 c34-c35');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = RawPSD_fdpth;
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
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion    
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
        RawMatResult_fdpth = fullfile(localDataPath,'181016 c31-c33');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
        RawMatResult_fdpth = fullfile(localDataPath,'181016 c31-c33');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];
        %% Flagellar recognition
        % cell  
%         a            = 5.14;        
%         b            = 4.01;       
%         d            = 2.7;        
        beadsize     = 5.33;       
        flag_length  = 12.80;       
        
        fileformatstr = '%04d'; % Format of image numbers
%         colorf(1) = 0;        % Flagellum color left   0=dark, 1=bright
%         colorf(2) = 1;        % Flagellum color right  0=dark, 1=bright
%         colorb    = 0;        % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;     % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi if cell is facing down
        f0        = 52.50;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;       % List of image idx in each case folder          
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
        RawMatResult_fdpth = fullfile(localDataPath,'181016 c31-c33');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
        RawMatResult_fdpth = fullfile(localDataPath,'181016 c31-c33');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
        RawMatResult_fdpth = fullfile(localDataPath,'181016 c31-c33');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
        RawMatResult_fdpth = fullfile(localDataPath,'181016 c31-c33');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
        f0        = 50;         % Cell beat frequency estimate, [Hz]
%         list      = 1:50;     % List of image idx in each case folder          
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
        RawMatResult_fdpth = fullfile(localDataPath,'181005 c27-c30');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
        list      = 1:40;       % List of image idx in each case folder          
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
        RawMatResult_fdpth = fullfile(localDataPath,'181005 c27-c30');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
    case '181002c28l1'           % local name c3b6
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
        RawMatResult_fdpth = fullfile(localDataPath,'181005 c27-c30');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
        RawMatResult_fdpth = fullfile(localDataPath,'181005 c27-c30');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
        RawMatResult_fdpth = fullfile(localDataPath,'181005 c27-c30');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
        RawMatResult_fdpth = fullfile(localDataPath,'181005 c27-c30');
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
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
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
    case '180918c26wv'         % local name c4b7
        %% Measurement setting
        Fs          = 10000;
        fps         = 1362.42;
        fps_real    = fps ;       %
        stiff_x     = 0.039;      % x,y of the screen
        stiff_y     = 0.056;
        uni_name = experiment(7:end);% 
        pt_list     = [1:3];
        beadsize    = 2.30;  % default
        flag_length = 13.03; 
        lf0 = flag_length;
        f0  = 43.94;         

        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
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
%         compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion    
    case '180918c25wv'         % local name c3b7
        %% Measurement setting
        Fs          = 10000;
        fps         = 1362.42;
        fps_real    = fps ;         %
        stiff_x     = 0.039;      % x,y of the screen
        stiff_y     = 0.056;
        uni_name = experiment(7:end);% 
        pt_list     = [1:3];
        beadsize    = 2.30;  % default
        flag_length = 10.82;
        lf0 = flag_length;
        f0  = 50.46;         

        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
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
%         compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion    
    case '180918c24wv'         % local name c2b7
        %% Measurement setting
        Fs          = 10000;
        fps         = 1362.42;
        fps_real    = fps ;         %
        stiff_x     = 0.039;      % x,y of the screen
        stiff_y     = 0.056;
        uni_name = experiment(7:end);% 
        pt_list     = [1:3];
        beadsize    = 2.30;  % default
        flag_length = 9.42; 
        lf0 = flag_length;
        f0  = 48.66;

        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
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
%         compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion    
    case '180918c23wv'         % local name c1b6
        %% Measurement setting
        Fs          = 10000;
        fps         = 1362.42;
        fps_real    = fps ;         %
        stiff_x     = 0.041;      % x,y of the screen
        stiff_y     = 0.051;
        uni_name = experiment(7:end);% 
        pt_list     = [1:3];
        
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
%         beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
%             ['Position ',uni_name,'_AfterRot_um.dat']);
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ',uni_name,'_BeforeRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
 
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion    
        
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
       
        %% For Make_limit_cycle
        % cell  
        a            = 5.95;        
        b            = 3.89;       
        d            = 3.0; % 2.40 measured        
        beadsize     = 2.39;       
        flag_length  = 13.97;               
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;     % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 46.98;      % Cell beat frequency estimate, [Hz]
        list      = 1:75;       % List of image idx in each case folder          
% % 
    case '180918c23wv2'        % local name c1b6
        %% Measurement setting
        Fs          = 10000;
        fps         = 681.21;     % manually down sampled  
        fps_real    = fps ;         %
        stiff_x     = 0.041;      % x,y of the screen
        stiff_y     = 0.051;
        uni_name = experiment(7:end);% % same as c23wv
        pt_list     = [1:3];
        
        %% Folder and file paths
        % PSD

        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ','c23wv','_BeforeRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
 
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
       
        %% For Make_limit_cycle
        % cell  
        a            = 5.95;        
        b            = 3.89;       
        d            = 3.0; % 2.40 measured        
        beadsize     = 2.39;       
        flag_length  = 13.97;               
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;     % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 46.98;      % Cell beat frequency estimate, [Hz]
        list      = 1:38;       % List of image idx in each case folder          
    case '180918c23wv3'        % local name c1b6
        %% Measurement setting
        Fs          = 10000;
        fps         = 340.61;     % manually down sampled 1/4
        fps_real    = fps ;       %
        stiff_x     = 0.041;      % x,y of the screen
        stiff_y     = 0.051;
        uni_name = experiment(7:end);% % same as c23wv
        pt_list     = [1:3];
        
        %% Folder and file paths
        % PSD

        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position ','c23wv','_BeforeRot_um.dat']);
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
 
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
       
        %% For Make_limit_cycle
        % cell  
        a            = 5.95;        
        b            = 3.89;       
        d            = 3.0; % 2.40 measured        
        beadsize     = 2.39;       
        flag_length  = 13.97;               
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;     % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 46.98;      % Cell beat frequency estimate, [Hz]
        list      = 1:19;       % List of image idx in each case folder          
    case '180918c23g5'         % local name c1b5
        %% Measurement setting
        Fs          = 10000;
        fps         = 630.02;
        fps_real    = fps ;         %
        stiff_x     = 0.039;      % x,y of the screen
        stiff_y     = 0.049;
        uni_name = experiment(7:end);%   
        pt_list        = [1:5,11:15,21:25,31:35,41:45];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
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
        coef_path      = fullfile(RawPSD_fdpth,'calib','coef.txt');
        subs_path      = fullfile(RawPSD_fdpth,'calib','volt.dat');
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end                
               
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [fullfile(...
                          'D:/001 RAW MOVIES/180918 c1b1-5 flow field',...
                          [uni_name,'_AF']),'/'];       
        %% For Make_limit_cycle
%       % cell  
        a            = 5.95;        
        b            = 3.89;       
        d            = 3.0; % 2.40 measured        
        beadsize     = 2.39;       
        flag_length  = 13.97;               
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 42.80;         % Cell beat frequency estimate, [Hz]
% %          list      = 1:50;       % List of image idx in each case folder          
% % 
    case '280918c23g4'         % local name c1b4
        %% Measurement setting
        Fs          = 10000;
        fps         = 471.83;
        fps_real    = fps ;         %
        stiff_x     = 0.047;      % x,y of the screen
        stiff_y     = 0.041;
        uni_name = experiment(7:end);%   
        pt_list        = [3:8,13:19]; 
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
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
        coef_path      = fullfile(RawPSD_fdpth,'calib','coef.txt');
        subs_path      = fullfile(RawPSD_fdpth,'calib','volt.dat');
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end                
               
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [fullfile(...
                          'D:/001 RAW MOVIES/180918 c1b1-5 flow field',...
                          [uni_name,'_AF']),'/'];        
        %% For Make_limit_cycle
%       % cell  
        a            = 5.95;        
        b            = 3.89;       
        d            = 3.0; % 2.40 measured        
        beadsize     = 2.52;       
        flag_length  = 13.97;               
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
         f0        = 42.80;         % Cell beat frequency estimate, [Hz]
% %          list      = 1:50;       % List of image idx in each case folder          
% % 
    case '280918c23g3'         % local name c1b3
        %% Measurement setting
        Fs          = 10000;
        fps         = 471.83;
        fps_real    = fps ;         %
        stiff_x     = 0.035;      % x,y of the screen
        stiff_y     = 0.032;
        uni_name = experiment(7:end);
        pt_list        = [3:8,13:18,23:28];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
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
        coef_path      = fullfile(RawPSD_fdpth,'calib','coef.txt');
        subs_path      = fullfile(RawPSD_fdpth,'calib','volt.dat');
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end                
               
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [fullfile(...
                          'D:/001 RAW MOVIES/180918 c1b1-5 flow field',...
                          [uni_name,'_AF']),'/'];              
        %% For Make_limit_cycle
        % cell  
        a            = 5.95;        
        b            = 3.89;       
        d            = 3.0; % 2.40 measured        
        beadsize     = 2.74;       
        flag_length  = 13.97;     
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 42.80;         % Cell beat frequency estimate, [Hz]
% %          list      = 1:50;       % List of image idx in each case folder          
% % 
    case '280918c23g2'         % local name c1b2
        %% Measurement setting
        Fs          = 10000;
        fps         = 471.83;
        fps_real    = fps ;         %
        stiff_x     = 0.053;      % x,y of the screen
        stiff_y     = 0.044;
        uni_name = experiment(7:end);  
        pt_list        = [1:8,14:18,24:28,34:38,43:44];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
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
        coef_path      = fullfile(RawPSD_fdpth,'calib','coef.txt');
        subs_path      = fullfile(RawPSD_fdpth,'calib','volt.dat');
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end                
               
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [fullfile(...
                          'D:/001 RAW MOVIES/180918 c1b1-5 flow field',...
                          [uni_name,'_AF']),'/'];              
        %% For Make_limit_cycle
%       % cell  
        a            = 5.95;        
        b            = 3.89;       
        d            = 3.0; % 2.40 measured        
        beadsize     = 2.48;       
        flag_length  = 13.97;           
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 42.80;         % Cell beat frequency estimate, [Hz]
% %          list      = 1:50;       % List of image idx in each case folder          
% % 
    case '280918c23g1'         % local name c1b1
        %% Measurement setting
        Fs          = 10000; 
        fps         = 471.83;
        fps_real    = fps ;         %
        stiff_x     = 0.056;      % x,y of the screen
        stiff_y     = 0.049;
        uni_name = experiment(7:end); 
        pt_list        = [1:8,11:18,21:28,31:38,41:48,51:58];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(localDataPath,'180920 c23-c26');
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
        coef_path      = fullfile(RawPSD_fdpth,'calib','coef.txt');
        subs_path      = fullfile(RawPSD_fdpth,'calib','volt.dat');
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end                
               
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [fullfile(...
                          'D:/001 RAW MOVIES/180918 c1b1-5 flow field',...
                          [uni_name,'_AF']),'/'];              
        %% For Make_limit_cycle
%       % cell  
        a            = 5.95;        
        b            = 3.89;       
        d            = 3.0; % 2.40 measured        
        beadsize     = 2.52;       
        flag_length  = 13.97;
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 0*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 42.80;         % Cell beat frequency estimate, [Hz]
% %          list      = 1:50;       % List of image idx in each case folder          
% % 
    case '280903c22a2'         % local name c3b4
        %% Measurement setting
        Fs          = 10000; 
        fps         = 707.75;
        fps_real    = fps ;         %
        stiff_x     = 0.021;        % x,y of the screen
        stiff_y     = 0.018;
        uni_name    = experiment(7:end);% 'c22a2';
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'180910 c20-c22',...
                          '000 raw files'),'/'];        
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        material_fdpth = [fullfile(OTVBackupPath,'180910 c20-c22',...
                         '001 material',uni_name),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
                          ['Position ',uni_name,'_AfterRot_um.dat']);
        
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];

        result_fdpth   = [fullfile(OTVBackupPath,'180910 c20-c22',...
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
    case '280903c22a1'         % local name c3b3
        %% Measurement setting
        Fs          = 10000; 
        fps         = 707.75;
        fps_real    = fps ;         %
        stiff_x     = 0.020;        % x,y of the screen
        stiff_y     = 0.017;
        uni_name    = experiment(7:end);% 'c22a1';
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'180910 c20-c22',...
                          '000 raw files'),'/'];        
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        material_fdpth = [fullfile(OTVBackupPath,'180910 c20-c22',...
                         '001 material',uni_name),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
                          ['Position ',uni_name,'_AfterRot_um.dat']);
        
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];

        result_fdpth   = [fullfile(OTVBackupPath,'180910 c20-c22',...
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
    case '280903c21a'          % local name c2b2
        %% Measurement setting
        Fs          = 10000; 
        fps         = 707.75;
        fps_real    = fps ;         %
        stiff_x     = 0.022;        % x,y of the screen
        stiff_y     = 0.019;
        uni_name    = experiment(7:end);% 'c21a';
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'180910 c20-c22',...
                          '000 raw files'),'/'];        
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        material_fdpth = [fullfile(OTVBackupPath,'180910 c20-c22',...
                         '001 material',uni_name),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
                          ['Position ',uni_name,'_AfterRot_um.dat']);
        
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];

        result_fdpth   = [fullfile(OTVBackupPath,'180910 c20-c22',...
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
    case '280903c20a'          % local name c1b1
        %% Measurement setting
        Fs          = 10000; 
        fps         = 707.75;
        fps_real    = fps ;         %
        stiff_x     = 0.045;        % x,y of the screen
        stiff_y     = 0.040;
        uni_name    = experiment(7:end);% 'c20a';
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'180910 c20-c22',...
                          '000 raw files'),'/'];        
        RawPSD_fdpth   = [fullfile(PSDtop_fdpth,uni_name),'/'];
        AFpsd_fdpth    = [fullfile(PSDtop_fdpth,[uni_name,'_AF']),'/'];
        material_fdpth = [fullfile(OTVBackupPath,'180910 c20-c22',...
                         '001 material',uni_name),'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
                          ['Position ',uni_name,'_AfterRot_um.dat']);
        
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [fullfile(top_fdpth,uni_name),'/'];

        result_fdpth   = [fullfile(OTVBackupPath,'180910 c20-c22',...
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
    case '180419c17l'          % local name c1b1
        %% Measurement setting
        Fs          = 10000; 
        fps         = 602.17;
        fps_real    = fps ;         %
        stiff_x     = 0.020;        % x,y of the screen
        stiff_y     = 0.019;
        uni_name    = experiment(7:end);% 'c17l';
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'180501 c17',...
                          '000 raw files'),'/'];  
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        material_fdpth = [PSDtop_fdpth,'material/'];
        beadcoords_pth = [PSDtop_fdpth,'position/',...
                          'Position c17l_AfterRot_um.dat'];
        
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'180501 c17',...
                         '002 results',uni_name),'/'];
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
    case '171029c16z'          % local name c6b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c16l2';
        TopRawData_fdpth = [fullfile(OTVBackupPath,'171029 c13-c16'),'/'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '000 raw files/'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '002 mat files/'];
        material_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '001 material/'];
        coef_path      = [rawfiles_fdpth,'calib/coef_Lateral_Pos999_Meas01.txt'];% 5thOrderCoeff.
        subs_path      = [rawfiles_fdpth,'calib/volt_Lateral_Pos999_Meas01.dat'];% Bead B-motion
              
        AFpsd_fdpth    = rawfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'/003 results/'];
        pt_list        = [53,55,57,59,60,61,63,65,67,70,75];
        
        a            = 4.97;        % std 0.11
        b            = 4.15;        % std 0.15
        d            = 3.47;        % std 0.06, measured with c3b3pos7
        beadsize     = 5.40;        % [micron], std 0.06
        flag_length  = 13.37;       % std 0.6        
    case '171029c16l2'         % local name c6b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c16l2';
        
        TopRawData_fdpth = [fullfile(OTVBackupPath,'171029 c13-c16'),'/'];
        beadcoords_pth = [TopRawData_fdpth, 'position/',...
                          'Position c16l2_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '000 raw files/'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '001 mat files/'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '002 mat files _ trash deleted/'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'/003 results/'];
        pt_list        = 0:7;
        
        a            = 4.97;        % std 0.11
        b            = 4.15;        % std 0.15
        d            = 3.47;        % std 0.06, measured with c3b3pos7
        beadsize     = 5.40;        % [micron], std 0.06
        flag_length  = 13.37;       % std 0.6    
        
        markertype   = '^';
        markersize   = 6;
        markersolid    = 1;       
    case '171029c16l1'         % local name c5b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c16l1';
        
        TopRawData_fdpth = [fullfile(OTVBackupPath,'171029 c13-c16'),'/'];
        beadcoords_pth = [TopRawData_fdpth, 'position/',...
                          'Position c16l1_AfterRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '000 raw files/'];
        RawPSD_fdpth   = rawfiles_fdpth;
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '001 mat files/'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '002 mat files _ trash deleted/'];
        AFpsd_fdpth    = matfiles_fdpth;
        material_fdpth = 'K:/bn/mea/Shared/Da/Analyzed Data/008 OTV/171029 c13-c16/c16l1/material/';
        result_fdpth   = [TopRawData_fdpth,uni_name,'/003 results/'];
        compiledData_pth = [result_fdpth,'171029c16l1_FitSegAvg.mat'];
%         compiledData_pth = 'K:/bn/mea/Shared/Da/Analyzed Data/008 OTV/171029 c13-c16/c16l1/003 results - Backup, before 180905, use own model cycle/171029c16l1_FitSegAvg.mat';
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
    case '171029c15l'          % local name c4b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c15l';
        
        TopRawData_fdpth = [fullfile(OTVBackupPath,'171029 c13-c16'),'/'];
        beadcoords_pth = [TopRawData_fdpth, 'position/',...
                          'Position c15l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '000 raw files/'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '001 mat files/'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '002 mat files _ trash deleted/'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'/003 results/'];
        pt_list        = 3:8;
        
        a            = 3.15;        % std 0.13
        b            = 2.87;        % std 0.21
        d            = 3.47;        % std 0.06, measured with c3b3pos7
        beadsize     = 5.40;        % [micron], std 0.06
        flag_length  = 8.56;        % std 0.22    
        
        markertype   = 'x';
        markersize   = 10;
        markersolid    = 1;      
    case '171029c14l'          % local name c3b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c14l';
        
        TopRawData_fdpth = [fullfile(OTVBackupPath,'171029 c13-c16'),'/'];
        beadcoords_pth = [TopRawData_fdpth, 'position/',...
                          'Position c14l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '000 raw files/'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '001 mat files/'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '002 mat files _ trash deleted/'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'/003 results/'];
        pt_list        = [6,7,8];
        
        a            = 3.50;        % std 0.14
        b            = 3.05;        % std 0.11
        d            = 3.47;        % std 0.06, measured with c3b3pos7
        beadsize     = 5.40;        % [micron], std 0.06
        flag_length  = 7.55;        % std 0.55    
        
        markertype   = 's';
        markersize   = 6;
        markersolid    = 1;   
    case '171029c13l'          % local name c2b3
        Fs          = 10000; 
        fps         = 801.42;
        fps_real    = fps ;         %
        stiff_x     = 0.046;        % x,y of the screen
        stiff_y     = 0.051;
        uni_name    = experiment(7:end);% 'c13l';
        
        TopRawData_fdpth = [fullfile(OTVBackupPath,'171029 c13-c16'),'/'];
        beadcoords_pth = [TopRawData_fdpth, 'position/',...
                          'Position c13l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '000 raw files/'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '001 mat files/'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '002 mat files _ trash deleted/'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'/003 results/'];
        pt_list        = [1,3,5,6];
        
        a            = 5.41;        % std 0.08
        b            = 4.65;        % std 0.12
        d            = 3.47;        % std 0.06, measured with c3b3pos7
        beadsize     = 5.40;        % [micron], std 0.06
        flag_length  = 12.27;       % std 0.33    
        
        markertype   = '.';
        markersize   = 10;
        markersolid    = 1; 
    case '171015c12l'          % local name c2b4
        Fs          = 10000; 
        fps         = 703.18;
        fps_real    = fps ;         %
        stiff_x     = 0.048;        % x,y of the screen
        stiff_y     = 0.057;
        uni_name    = experiment(7:end);% 'c12l';
        TopRawData_fdpth = [fullfile(OTVBackupPath,'171015 c11-c12'),'/'];
        beadcoords_pth = [TopRawData_fdpth, 'position/',...
                          'Position c12l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '000 raw files/'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '001 mat files/'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '002 mat files _ trash deleted/'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'/003 results/'];
        pt_list        = 0:6;
        
        a            = 3.89;        %
        b            = 3.28;        % 
        d            = 3.52;        % std 0.12
        beadsize     = 2.54;        % [micron], std 0.05
        flag_length  = 10.65;       % std 0.54     
        
        markertype   = '+';
        markersize   = 6;
        markersolid    = 1;     
    case '171015c11l3'         % local name c1b3
        Fs          = 10000; 
        fps         = 626.40;
        fps_real    = fps ;         %
        stiff_x     = 0.044;        % x,y of the screen
        stiff_y     = 0.045;
        uni_name    = experiment(7:end);% 'c11l3';
        
        TopRawData_fdpth = [fullfile(OTVBackupPath,'171015 c11-c12'),'/'];
        beadcoords_pth = [TopRawData_fdpth, 'position/',...
                          'Position c11l3_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '000 raw files/'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '001 mat files/'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '002 mat files _ trash deleted/'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'/003 results/'];
        pt_list      = 1:3;  
        
        a            = 5.05;        %
        b            = 5.08;        % 
        d            = 3;           % 2.51
        beadsize     = 2.35;        % [micron], std 0.05
        flag_length  = 13.18;       % std 0.39     
        
        markertype   = 'o';
        markersize   = 6;
        markersolid    = 1;
    case '171015c11l2'         % local name c1b2
        Fs          = 10000; 
        fps         = 637.39;
        fps_real    = fps ;         %
        stiff_x     = 0.026;        % x,y of the screen
        stiff_y     = 0.029;        % AVERAGED! CALIBRATION MISSING
        uni_name    = experiment(7:end);% 'c11l2';

        TopRawData_fdpth = [fullfile(OTVBackupPath,'171015 c11-c12'),'/'];
        beadcoords_pth = [TopRawData_fdpth, 'position/',...
                          'Position c11l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '000 raw files/'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '001 mat files/'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '002 mat files _ trash deleted/'];                      
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'/003 results/'];
        pt_list      = 6:8;       
        
        a            = 5.05;        %
        b            = 5.08;        % 
        d            = 3;           % 2.51
        beadsize     = 5.32;        % [micron], std 0.05
        flag_length  = 13.18;       % std 0.39     
        
        markertype   = 'o';
        markersize   = 6;
        markersolid    = 1;
    case '171015c11l1'         % local name c1b1
        Fs          = 10000; 
        fps         = 637.39;
        fps_real    = fps ;         %   
        stiff_x     = 0.027;        % x,y of the screen
        stiff_y     = 0.027;        % AVERAGED! CALIBRATION MISSING
        uni_name    = experiment(7:end);% 'c11l1';
        
        TopRawData_fdpth = [fullfile(OTVBackupPath,'171015 c11-c12'),'/'];
        beadcoords_pth = [TopRawData_fdpth, 'position/',...
                          'Position c11l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '000 raw files/'];
        matfiles_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '001 mat files/'];
        matfiles_checked_fdpth = [TopRawData_fdpth,uni_name,'/'...
                          '002 mat files _ trash deleted/'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,uni_name,'/003 results/'];
        pt_list      = 4:6;       
        
        a            = 5.05;        %
        b            = 5.08;        % 
        d            = 3;           % 2.51
        beadsize     = 6.03;        % [micron], std 0.05
        flag_length  = 13.18;       % std 0.39 
        
        markertype   = 'o';
        markersize   = 6;
        markersolid    = 1;
    case '171008c10l'          % local name c2b1
        Fs          = 10000;  
        fps         = 668.67;
        fps_real    = fps ;         %   
        stiff_x     = 0.021;        % x,y of the screen
        stiff_y     = 0.021;
        uni_name    = experiment(7:end);     % 'c10l';
        
        TopRawData_fdpth = [fullfile(OTVBackupPath,'171008 c10'),'/'];
        beadcoords_pth = [TopRawData_fdpth, 'position/',...
                          'Position c10l_BeforeRot_um.dat'];
        rawfiles_fdpth = [TopRawData_fdpth,'000 raw files/'];
        matfiles_fdpth = [TopRawData_fdpth,'001 mat files/'];
        matfiles_checked_fdpth = [TopRawData_fdpth,...
                          '002 mat files _ trash deleted/'];
        AFpsd_fdpth    = matfiles_fdpth;
        result_fdpth   = [TopRawData_fdpth,'003 results/'];
        pt_list      = 1:8;
        
        a            = 3.27;    %
        b            = 3.02;    % 
        d            = 3;       % 3.19
        beadsize     = 5.99;    % [micron], std 0.06
        flag_length  = 9.36;   
        
        markertype   = 's';
        markersize   = 6;
        markersolid    = 0;
    case '170703c9l'           % local name c3b3
        uni_name    = experiment(7:end);% 'c9l';     
        Fs          = 10000;        % [Hz]
        stiff_x     = 0.020;        % x,y of the screen
        stiff_y     = 0.022;        % [pN/nm]
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171129 c5-c9','position',...
                         ['Position ',uni_name,'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name,...
                          [experiment,'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name),'/'];
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
    case '170703c8l'           % local name c2b3
        uni_name    = experiment(7:end);        % 'c8l';     
        Fs          = 10000;                    % Hz
        stiff_x     = 0.020;                    % x,y of the screen
        stiff_y     = 0.022;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171129 c5-c9','position',...
                         ['Position ',uni_name,'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name,...
                          [experiment,'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name),'/'];
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
    case '170703c7l'           % local name c1b1
        uni_name    = experiment(7:end);   % 'c7l';           
        Fs          = 10000;               % [Hz]
        stiff_x     = 0.021;               % x,y of the screen
        stiff_y     = 0.024;               % [pN/nm]
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171129 c5-c9','position',...
                         ['Position ',uni_name,'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name,...
                          [experiment,'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name),'/'];
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
    case '170502c5g3'          % local name cell1b3grid
        uni_name    = experiment(7:end);        % 'c5g3';
        Fs          = 50000;                    % Hz
        stiff_x     = 0.059;                    % x,y of the screen
        stiff_y     = 0.063;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171129 c5-c9','position',...
                         ['Position ',uni_name(1:3),'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name,...
                          [experiment,'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name),'/'];
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
    case '170502c5g2'          % local name cell1b2grid
        uni_name    = experiment(7:end);        % 'c5g2';
        Fs          = 50000;                    % Hz
        stiff_x     = 0.058;                    % x,y of the screen
        stiff_y     = 0.058;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171129 c5-c9','position',...
                         ['Position ',uni_name(1:3),'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name,...
                          [experiment,'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name),'/'];
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
    case '170502c5g1'          % local name cell1b1grid
        uni_name    = experiment(7:end);        % 'c5g1';
        Fs          = 50000;                    % Hz
        stiff_x     = 0.059;                    % x,y of the screen
        stiff_y     = 0.064;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171129 c5-c9','position',...
                         ['Position ',uni_name(1:3),'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name,...
                          [experiment,'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name),'/'];
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
    case '170502c5l'           % local name cell1b1lateral
        uni_name       = experiment(7:end);     % 'c5l';
        Fs             = 50000;                 % Hz
        stiff_x        = 0.050;                 % x,y of the screen
        stiff_y        = 0.054;                 % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171129 c5-c9','position',...
                         ['Position ',uni_name(1:3),'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name,...
                          [experiment,'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171129 c5-c9',...
                          '002 results',uni_name),'/'];
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
    case '270223c3g2'          % local name c2b4
        uni_name    = experiment(7:end);        % 'c3g2';
        Fs          = 50000;                    % Hz
        fps         = 475.95;                   % Theoretical camera framing rate, [Hz]
        fps_real    = fps ;                     %
        stiff_x     = 0.091;                    % x,y of the screen
        stiff_y     = 0.087;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171128 c0-c3','position',...
                         ['Position ',uni_name(1:3),'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name,...
                          ['1',experiment(2:end),'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name),'/'];
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
    case '270130c2f'           % local name c2f 
        uni_name       = experiment(7:end);     % 'c2f';
        Fs             = 5000;                  % Hz
        fps            = 573.65;
        fps_real       = fps;                   % theoretical 573.65;
        stiff_x        =  0.059;                % x,y of the screen
        stiff_y        =  0.065;                % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171128 c0-c3','position',...
                         ['Position ',uni_name(1:3),'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name,...
                          ['1',experiment(2:end),'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name),'/'];
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
    case '270130c2g'           % local name c2r, name before 20171128 c2r
        uni_name        = 'c2g';
        Fs              = 5000;                 % Hz
        fps             = 336.40;
        fps_real        = fps;                  % theoretical 336.40;
        stiff_x         = 0.059 ;               % x,y of the screen
        stiff_y         = 0.065 ;               % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171128 c0-c3','position',...
                         ['Position ',uni_name(1:3),'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name,...
                          ['1',experiment(2:end),'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name),'/'];
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
    case '270130c1g'           % local name c1g
        uni_name   = 'c1g';
        Fs         = 5000;                      % Hz
        fps        = 411.29;
        fps_real   = fps;                       % theoretical 411.29; 
        stiff_x    =  0.055;                    % x,y of the screen
        stiff_y    =  0.061;                    % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171128 c0-c3','position',...
                         ['Position ',uni_name(1:3),'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name,...
                          ['1',experiment(2:end),'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name),'/'];
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
    case '261230c0g2'          % local name c2b3
                                    % for case folders 21-23,31-34
        uni_name       = experiment(7:end);     % 'c0g2';
        Fs             = 50000;                 % Hz
        fps            = 434.23;
        fps_real       = fps;                   % theoretical 434.23;
        stiff_x        = 0.069 ;                % x,y of the screen
        stiff_y        = 0.088 ;                % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171128 c0-c3','position',...
                         ['Position ',uni_name(1:3),'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name,...
                          ['1',experiment(2:end),'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name),'/'];
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
    case '261230c0g1'          % local name c2b2
                                    % for case folders 11-14,24
        %% Measurement setting
        uni_name       = experiment(7:end);     % 'c0g1';
        Fs             = 50000;                 % Hz
        fps            = 475.95;
        fps_real       = fps;                   % theoretical 475.95;
        stiff_x        = 0.068 ;                % x,y of the screen
        stiff_y        = 0.083 ;                % pN/nm
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5thOrderCoeff.
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Bead B-motion
        beadcoords_pth = fullfile(OTVBackupPath,'171128 c0-c3','position',...
                         ['Position ',uni_name(1:3),'_AfterRot_um.dat']);
                         
        compiledData_pth = fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name,...
                          ['1',experiment(2:end),'_FitSegAvg.mat']);
        % video
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        % results 
        result_fdpth   = [fullfile(OTVBackupPath,'171128 c0-c3',...
                          '002 results',uni_name),'/'];
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
end

%%
% This section documents the parameters for preliminary OTV assays.
% For example, to study the fine waveform of flagella, 
% or to study the in-plane-ness of cis and trans
% Variable names are made to be consistent to the best one can, however,
% missing/extra variables might present
switch experiment
    case '181009c7c'           % CW15 cell 7
        Fs          = 10000;
        fps         = 756.90;
        fps_real    = fps ;         %
        %% Get stiffnesses!!!
        stiff_x     = 0.018;        % x,y of the screen
        stiff_y     = 0.015;
        uni_name    = 'c7c';
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(MSTGBackupPath,'000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        material_fdpth = [fullfile(MSTGBackupPath,'181009 c5c-c7c',...
                          '001 material',uni_name),'/'];
        %% Get positions from video!!
        beadcoords_pth = [PSDtop_fdpth,'position/',...
                          'Position c7c_BeforeRot_um.dat'];    
        top_fdpth      = '/Users/guillermo/Documents/Algae mastigonemes/Experiments/Mstg 1/CW15 2018-10-09/cell 7/';
        scenario_fdpth = [top_fdpth,'c7c/'];
        % results 
        result_fdpth   = ['/Users/guillermo/Documents/Algae mastigonemes/Experiments/Mstg 1/001 results/',...
                          uni_name,'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
%         % video
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        

        pt_list        = [1:18];
        
        % microns
        a            = 3.85;        
        b            = 2.66;        
        d            = 2.17;        
        beadsize     = 5.18;        
        flag_length  = 11.2;               
        %% For Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 51;         % Cell beat frequency estimate, [Hz]
        list      = 1:80;       % List of image idx in each case folder 
        
    case '181009c6c'           % CW15 cell 6
        Fs          = 10000; 
        fps         = 756.90;
        fps_real    = fps ;         %
        %% Get stiffnesses!!!
        stiff_x     = 0.019;        % x,y of the screen
        stiff_y     = 0.014;
        uni_name    = 'c6c';
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(MSTGBackupPath,'000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        material_fdpth = [fullfile(MSTGBackupPath,'181009 c5c-c7c',...
                          '001 material',uni_name),'/'];
        %% Get positions from video!!
        beadcoords_pth = [PSDtop_fdpth,'position/',...
                          'Position c6c_BeforeRot_um.dat'];
        
        top_fdpth      = '/Users/guillermo/Documents/Algae mastigonemes/Experiments/Mstg 1/CW15 2018-10-09/cell 6/';
        scenario_fdpth = [top_fdpth,'c6c/'];
        
        % results 
        result_fdpth   = ['/Users/guillermo/Documents/Algae mastigonemes/Experiments/Mstg 1/001 results/',...
                          uni_name,'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
%         % video
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        
%         
%         
%         pt_list        = [1:17,19,20];
        pt_list        = [1:18];
%         pt_list        = [10:18];
        
        % microns
        a            = 4.13;        
        b            = 2.94;        
        d            = 2.10;        
        beadsize     = 5.18;        
        flag_length  = 13.5;       
        
        %% For Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 51;         % Cell beat frequency estimate, [Hz]
        list      = 1:80;       % List of image idx in each case folder 
 
    case '181009c5c'           % CW15 cell 5
        Fs          = 10000; 
        fps         = 756.90;
        fps_real    = fps ;         %
        %% Get stiffnesses!!!
        stiff_x     = 0.012;        % x,y of the screen
        stiff_y     = 0.011;
        uni_name    = 'c5c';
        %% Folder and file paths
        PSDtop_fdpth   = [fullfile(MSTGBackupPath,'000 raw files'),'/'];
        RawPSD_fdpth   = [PSDtop_fdpth,uni_name,'/'];
        AFpsd_fdpth    = [PSDtop_fdpth,uni_name,'_AF/'];
        coef_path      = [RawPSD_fdpth,'calib/coef.txt'];% 5th order coefficients, filepath
        subs_path      = [RawPSD_fdpth,'calib/volt.dat'];% Substrate of the voltage signal, filepath
        material_fdpth = [fullfile(MSTGBackupPath,'181009 c5c-c7c',...
                          '001 material',uni_name),'/'];
        %% Get positions from video!!
        beadcoords_pth = [PSDtop_fdpth,'position/',...
                          'Position c5c_BeforeRot_um.dat'];
        
        top_fdpth      = '/Users/guillermo/Documents/Algae mastigonemes/Experiments/Mstg 1/CW15 2018-10-09/cell 5/';
        scenario_fdpth = [top_fdpth,'c5c/'];
        
        % results 
        result_fdpth   = ['/Users/guillermo/Documents/Algae mastigonemes/Experiments/Mstg 1/001 results/',...
                          uni_name,'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
%         % video
        if ~exist(result_fdpth,'dir'); mkdir(result_fdpth); end        

        pt_list        = [1:16];
        
        % microns
        a            = 4.13;        
        b            = 3.05;        
        d            = 1.96;        
        beadsize     = 6.16;        
        flag_length  = 13.1;       
        
        %% For Make_limit_cycle.
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 51;         % Cell beat frequency estimate, [Hz]
        list      = 1:80;       % List of image idx in each case folder 
    case '190320c03BEM'
        %% Measurement setting
        fps         = 801.42;
        fps_real    = fps ;         %
        uni_name    = experiment(7:end); 
        pt_list     = [02]; % 00NoFlow, 01XY, 02MinXY, 03Axial, 04Cross
        %% Folder and file paths
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        %% Flagellar recognition
        % cell  
        a            = 6.85;        
        b            = 5.62;        
        d            = 3.5;        
        flag_length  = 14;            
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 0;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 50.6;         % Cell beat frequency estimate, [Hz]
        list      = 1:500;      % List of image idx in each case folder 
    case '181207c34BEM'
        %% Measurement setting
        fps         = 825.71;  % unknown
        fps_real    = fps ;         % 
        uni_name    = experiment(7:end); 
%         pt_list     = 99; 
        pt_list     = 2:11; % c34lc
%         pt_list     = 1:15; % c34a
        %% Folder and file paths
        RawMatResult_fdpth = fullfile(localDataPath,'190103 c34-c35');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
                         '000 raw files'),'/'];
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
            ['Position c34lc_AfterRot_um.dat']);
%         beadcoords_pth = fullfile(PSDtop_fdpth,'position',...
%             ['Position c34a_AfterRot_um.dat']);
        %% Flagellar recognition
        % cell  
        a            = 3.60;        
        b            = 3.40;        
        d            = 2.60;        
        flag_length  = 13.19;            
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 50;         % Cell beat frequency estimate, [Hz]
        list      = 1:55;       % List of image idx in each case folder 
    case '180703c02BEM'
        %% Measurement setting
        fps         = 801.42;
        fps_real    = fps ;         %
        uni_name    = experiment(7:end); 
        pt_list        = [0:4]; % 00NoFlow, 01XY, 02MinXY, 03Axial, 04Cross
        %% Folder and file paths
        top_fdpth      = 'D:/004 FLOW VELOCIMETRY DATA/';
        scenario_fdpth = [top_fdpth,uni_name,'/'];
        %% Flagellar recognition
        % cell  
        a            = 5.14;        
        b            = 4.45;        
        d            = 3.86;        
        flag_length  = 12.68;            
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 1;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 50;         % Cell beat frequency estimate, [Hz]
        list      = 1:500;      % List of image idx in each case folder 
    case '180810c3c'
        %% Measurement setting
        Fs          = 10000; 
        fps         = 756.90;
        fps_real    = fps ;         %
        stiff_x     = 0.019;        % x,y of the screen
        stiff_y     = 0.019;
        uni_name    = experiment(7:end); 
        pt_list     = [1:19];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190213 c1c-c3c');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end        
        %% Flagellar recognition
        % cell  
        a            = 4.28;        
        b            = 3.5;        
        d            = 2.8;        
        beadsize     = 5.14;        
        flag_length  = 11.0;   
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 0;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 51;         % Cell beat frequency estimate, [Hz]
        list      = 1:80;       % List of image idx in each case folder      
    case '180810c2c'
        %% Measurement setting
        Fs          = 10000; 
        fps         = 756.90;
        fps_real    = fps ;         %
        stiff_x     = 0.018;        % x,y of the screen
        stiff_y     = 0.018;
        uni_name    = experiment(7:end); 
        pt_list     = [1:8,10:19];

        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190213 c1c-c3c');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end        
        %% Flagellar recognition
        % cell  
        a            = 4.7;        
        b            = 4.1;        
        d            = 3.1;        
        beadsize     = 4.99;        
        flag_length  = 11.4;               
        
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
        list      = 1:80;       % List of image idx in each case folder  
    case '180810c1c'
        %% Measurement setting
        Fs          = 10000; 
        fps         = 756.90;
        fps_real    = fps ;         %
        stiff_x     = 0.019;        % x,y of the screen
        stiff_y     = 0.019;
        uni_name    = experiment(7:end); 
        pt_list     = [1:19];

        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190213 c1c-c3c');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end        
        %% Flagellar recognition
        % cell  
        a            = 5.14;        
        b            = 3.56;        
        d            = 3.18;        
        beadsize     = 5.31;        
        flag_length  = 11.7;              
        
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
        list      = 1:80;       % List of image idx in each case folder  
    case '180821c5m'
        %% Measurement setting
        Fs          = 10000; 
        fps         = 756.90;
        fps_real    = fps ;         %
        stiff_x     = 0.019;        % x,y of the screen
        stiff_y     = 0.027;
        uni_name    = experiment(7:end); 
        pt_list     = [1:9]; 
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190114 c3m-c5m');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end        
        %% Flagellar recognition
        % cell  
        a            = 5.14;        
        b            = 3.85;        
        d            = 2.73;        
        beadsize     = 5.24;        
        flag_length  = 10.7;              
        
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
        list      = 1:80;       % List of image idx in each case folder  
    case '180821c4m'
        %% Measurement setting
        Fs          = 10000; 
        fps         = 756.90;
        fps_real    = fps ;         %
        stiff_x     = 0.020;        % x,y of the screen
        stiff_y     = 0.027;
        uni_name    = experiment(7:end); 
        pt_list     = [1:9];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190114 c3m-c5m');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        %% Flagellar recognition
        % cell  
        a            = 4.76;        
        b            = 3.17;        
        d            = 2.10;        
        beadsize     = 5.14;        
        flag_length  = 13.6;          
        
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
        list      = 1:80;       % List of image idx in each case folder  
    case '180821c3m'
        %% Measurement setting
        Fs          = 10000; 
        fps         = 756.90;
        fps_real    = fps ;         %
        stiff_x     = 0.022;        % x,y of the screen
        stiff_y     = 0.019;
        uni_name    = experiment(7:end); 
        pt_list        = [1:9];
        %% Folder and file paths
        % PSD
        RawMatResult_fdpth = fullfile(MSTGBackupPath,'190114 c3m-c5m');
        PSDtop_fdpth   = [fullfile(RawMatResult_fdpth,...
            '000 raw files'),'/'];
        material_fdpth = [fullfile(RawMatResult_fdpth,...
            '001 material',uni_name),'/'];
        result_fdpth   = [fullfile(RawMatResult_fdpth,...
            '002 results',uni_name),'/'];
        compiledData_pth = [result_fdpth,experiment,'_FitSegAvg.mat'];
        if ~exist(PSDtop_fdpth,'dir');   mkdir(PSDtop_fdpth); end
        if ~exist(material_fdpth,'dir'); mkdir(material_fdpth); end
        if ~exist(result_fdpth,'dir');   mkdir(result_fdpth); end
        %% Flagellar recognition
        % cell  
        a            = 4.89;        
        b            = 3.55;        
        d            = 2.84;        
        beadsize     = 5.24;        
        flag_length  = 11.2;            
        
        fileformatstr = '%04d'; % Format of image numbers
        colorf(1) = 1;          % Flagellum color left   0=dark, 1=bright
        colorf(2) = 0;          % Flagellum color right  0=dark, 1=bright
        colorb    = 1;          % Cell body halo color   0=dark, 1=bright
        scale     = 9.35;       % Scale                  [px/micron]
        lf0       = flag_length;
        orientation = 1.5*pi;   % Cell body angle: 0 angle is cell facing 
                                % right,anti-clockwise rotation direction, 
                                % 1.5 pi for camera setting after 20170502
        f0        = 51;         % Cell beat frequency estimate, [Hz]
        list      = 1:80;       % List of image idx in each case folder 
    otherwise
        if ~exist('uni_name','var')
            error('Experiment is not registered')
        end
end
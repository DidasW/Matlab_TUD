% try
%     run(['D:\002 MATLAB codes\000 Routine\subunit of img treatment routines\',...
%         'add_path_for_all.m']);
% %     color_palette
% catch
%     disp('Cannot find the addpath list, define manually')
% end

%% Definition experimental conditions etc.
markerList = {'o','s','d','^','v','x','+','h','p'};
markerSizeList = [8,8,6,8,8,10,10,6,6];

expConditionSet     = {...
                        '0.33mM[Ca]-TRIS(1:1) + 0.5mM final[EGTA]',...
                        '0.033mM[Ca]-TRIS(1:10)',...
                        '0.33mM[Ca]-TRIS(1:10)',...
                        '1.2mM[Ca]-TRIS(1:10)',...
                        '3.5mM[Ca]-TRIS(1:10)',...
                        '5.0mM[Ca]-TRIS(1:10)',...
                        '20.0mM[Ca]-TRIS(1:5)',...
                        '30.0mM[Ca]-TRIS(1:4)',...
                        '60.0mM[Ca]-TRIS(1:4)',...
                        };
N_expCondition      = numel(expConditionSet);

expColorSetting     = containers.Map;
colorMap            = jet(N_expCondition);
for i_expCondi      = 1:N_expCondition
    expColorSetting(expConditionSet{i_expCondi})...
                    = colorMap(i_expCondi,:);
end

getCalciumConcentration = containers.Map;
CalciumConc = [1e-8,5e-5,3.3e-4,1.2e-3,3.5e-3,5.0e-3,2e-2,3e-2,6e-2];
for i_expCondi      = 1:N_expCondition
    getCalciumConcentration(expConditionSet{i_expCondi})...
                    = CalciumConc(i_expCondi);
end

%%
try
    switch experiment
        case '190728 c12'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 39;
        case '190728 c11'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 39;
        case '190728 c10'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 39.3;
        case '190728 c09'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 42;
        case '190728 c08'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 38;
        case '190728 c07'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 31;
        case '190728 c06'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 39;
        case '190728 c05'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 42;
        case '190728 c04'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 39;
        case '190728 c03'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 33;
        case '190728 c02'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 44; 
        case '190728 c01'
            strain       = 'oda11';
            fps          = 550.47;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 30; 
        case '190727 c18'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 23; % cis 22, trans 24 
        case '190727 c17'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default 
        case '190727 c16'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default 
        case '190727 c15'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default 
        case '190727 c14'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 20; % 17.2 for cis, 22.6 for trans
        case '190727 c13'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 21; % 18.4 for cis, 23 for trans
        case '190727 c12'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 17.8; 
        case '190727 c11'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 17.8; 
        case '190727 c10'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 17.8; 
        case '190727 c09'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 17.8; 
        case '190727 c08'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 17.8; 
        case '190727 c07'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default 
        case '190727 c06'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190727 c05'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190727 c04'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default 
        case '190727 c03'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190727 c02'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default 
        case '190727 c01'
            strain       = 'oda1';
            fps          = 406.69;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 19; 
        case '190706 c14'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c13'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c12'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c11'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c10'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c9'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c8'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c7'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c6'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c5'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c4'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c3'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c2'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default
        case '190706 c1'
            strain       = 'oda1';
            fps          = 502.27;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 18; % default        
        case '190610 c2'
            strain       = 'ptx1';
            fps          = 681.21;
            cisTransFlow = {'02MinXY','01XY'};
            eyespot      = 'left';
            expCondition = expConditionSet{3};
            centralFreq  = 47.5;
        case '190610 c1'
            strain       = 'wt';
            fps          = 681.21;
            cisTransFlow = {'01XY','02MinXY'};
            eyespot      = 'right';
            expCondition = expConditionSet{3};
            centralFreq  = 52.0;
        case '190320 c1'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{1};
            centralFreq  = 54.3;
        case '190320 c2'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{1};
            centralFreq  = 50.2;
        case '190320 c3'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{1};
            centralFreq  = 50.6;
        case '190320 c4'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{1};
            centralFreq  = 48.5;
        case '190319 c1'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 50.2;
        case '190319 c2'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 48.8;
        case '190319 c3'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 52.8;
        case '190319 c4'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 53.7;
        case '190319 c5'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 50.5;
        case '190319 c6'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 52.3;
        case '190319 c7'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 50.6;
        case '181212 c4'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 51.0;
        case '181212 c3'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 54.3;
        case '181212 c2'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 49.5;
        case '181212 c1'
            strain       = 'wt';        
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 53.5;
        case '181203 c2'
            strain       = 'wt';        
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 49.8;
        case '181203 c1'
            strain       = 'wt';        
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 53.0;            
        case '181203 c0'
            strain       = 'wt';        
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 54.0;            
        case '181130 c5'
            strain       = 'ptx1';
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 43.6;
        case '181130 c4'
            strain       = 'ptx1';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 47.1;
        case '181130 c3'
            strain       = 'ptx1';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 46.0;        
        case '181130 c2'
            strain       = 'ptx1';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 47.0;
        case '181130 c1'
            strain       = 'ptx1';
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 41.0;
        case '181030 c09'
            strain       = 'ptx1';
            fps          = 600.00;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 47.6;
        case '181030 c08'
            strain       = 'ptx1';
            fps          = 600.00;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 49.5;
        case '181030 c07'
            strain       = 'ptx1';
            fps          = 600.00;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 49.5;
        case '181030 c06'
            strain       = 'ptx1';
            fps          = 600.00;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 43.60;        
        case '181030 c05'
            strain       = 'ptx1';
            fps          = 600.00;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 45.5;
        case '181030 c04'
            strain       = 'ptx1';
            fps          = 600.00;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 49.5;
        case '181030 c03'
            strain       = 'ptx1';
            fps          = 600.00;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 49.5;        
        case '181030 c02'
            strain       = 'ptx1';
            fps          = 600.00;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 49.5;
        case '181030 c01'
            strain       = 'ptx1';
            fps          = 600.00;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 49.5;
        case '180803 c5'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{9};
            centralFreq  = 51.1;
        case '180803 c4'
            strain       = 'wt';
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{9};
            centralFreq  = 49.4;
        case '180803 c3'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{9};
            centralFreq  = 49.4;
        case '180803 c2'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{9};
            centralFreq  = 48.6;
        case '180803 c1'
            strain       = 'wt';            
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{9};
            centralFreq  = 49.0;
        case '180731 c6'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{8};
            centralFreq  = 44.8;
        case '180731 c5'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{8};
            centralFreq  = 46.6;
        case '180731 c4'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{8};
            centralFreq  = 48.0;
        case '180731 c3'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{8};
            centralFreq  = 49.4;
        case '180731 c2'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{8};
            centralFreq  = 49.0;
        case '180731 c1'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{8};
            centralFreq  = 52.0;
        case '180725 c6'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{7};
            centralFreq  = 52.6;
        case '180725 c5'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{7};
            centralFreq  = 49.0;
        case '180725 c4'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{7};
            centralFreq  = 49.0;
        case '180725 c3'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{7};
            centralFreq  = 49.0;
        case '180725 c2'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{7};
            centralFreq  = 49.0;
        case '180725 c1'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{7};
            centralFreq  = 49.0;
        case '180723 c1'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{5};
            centralFreq  = 51.1;
        case '180723 c2'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{5};
            centralFreq  = 51.0;
        case '180723 c3'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{5};
            centralFreq  = 50.9;
        case '180723 c4'
            strain       = 'wt';            
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{5};
            centralFreq  = 49.5;
        case '180717 c1'
            strain       = 'wt';            
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 50.7;
        case '180717 c2'
            strain       = 'wt';        
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{3};
            centralFreq  = 48.4;
        case '180717 c3'
            strain       = 'wt';        
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 46.5;
        case '180714 c1'
            strain       = 'wt';           
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{4};
            centralFreq  = 47.0;
        case '180714 c2'
            strain       = 'wt';           
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{4};
            centralFreq  = 51.0;
        case '180714 c3'
            strain       = 'wt';          
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{4};
            centralFreq  = 47.0;
        case '180714 c4'
            strain       = 'wt';           
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{4};
            centralFreq  = 50.8;
        case '180714 c5'
            strain       = 'wt';          
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{4};
            centralFreq  = 47.1;
        case '180711 c5'
            strain       = 'wt';           
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{6}; 
            centralFreq  = 50.4; 
        case '180711 c4'
            strain       = 'wt';           
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{6}; 
            centralFreq  = 50.0; 
        case '180711 c3'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{6}; 
            centralFreq  = 47.6; 
        case '180711 c2'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{6}; 
            entralFreq  = 47.3; 
        case '180711 c1'
            strain       = 'wt';            
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{6}; 
            centralFreq  = 49.0; 
        case '180703 c6'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{2}; 
            centralFreq  = 51.0; 
        case '180703 c5'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY','02MinXY'};
            expCondition = expConditionSet{2}; 
            centralFreq  = 49.5;   
        case '180703 c4'
            strain       = 'wt';            
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{2}; 
            centralFreq  = 50.4;   
        case '180703 c3'
            strain       = 'wt';           
            fps          = 801.42;
            cisTransFlow = {'02MinXY','01XY'};
            expCondition = expConditionSet{3}; 
            centralFreq  = 46.5;   
        case '180703 c2'
            strain       = 'wt';           
            fps          = 801.42;
            cisTransFlow = {'01XY', '02MinXY'};
            expCondition = expConditionSet{3}; 
            centralFreq  = 49.7;
        case '180703 c1'
            strain       = 'wt';             
            fps          = 801.42;
            cisTransFlow = {'01XY', '02MinXY'};
            expCondition = expConditionSet{3}; 
            centralFreq  = 49.7;
        case '180626 c4'
            strain       = 'wt';  
            fps          = 886.12;
            cisTransFlow = {'01XY', '02MinXY'};
            expCondition = expConditionSet{1}; 
            expCondition_extra = ' + MultiWvfm';
            centralFreq  = 46.0;
        case '180626 c3'
            strain       = 'wt'; 
            fps          = 964.54;
            cisTransFlow = {'01XY', '02MinXY'};
            expCondition = expConditionSet{1}; 
            centralFreq  = 49.0;
        case '180626 c2'
            strain       = 'wt'; 
            fps          = 964.54;
            cisTransFlow = {'02MinXY', '01XY'};
            expCondition = expConditionSet{1}; 
            centralFreq  = 49.0;
        case '180626 c1'
            strain       = 'wt'; 
            fps          = 973.16;
            cisTransFlow = {'02MinXY', '01XY'};
            expCondition = expConditionSet{1}; 
            centralFreq  = 56.7;
        case '180619 c2D'
            strain       = 'wt'; 
            fps          = 990.85;
            cisTransFlow = {'02MinXY', '01XY'};
            expCondition = expConditionSet{3}; 
            expCondition_extra = ' + deflagellation';
            centralFreq  = 49.0;
        case '180619 c2'
            strain       = 'wt'; 
            fps          = 990.85;
            cisTransFlow = {'02MinXY', '01XY'};
            expCondition = expConditionSet{3};
            centralFreq  = 49.0;
        case '180619 c1'
            strain       = 'wt'; 
            fps          = 990.85;
            cisTransFlow = {'02MinXY', '01XY'};
            expCondition = expConditionSet{3}; 
            centralFreq  = 49.0;
    end
catch
    disp('experiment not defined')
end
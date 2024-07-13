%% Addpath
% run(fullfile('D:','002 MATLAB codes','000 Routine',...
%     'subunit of img treatment routines','add_path_for_all.m'))

%% Control panel
% experiment = '190224c44l'
% plot_axOrLatComponent = 'axial';
% plot_axOrLatDistance  = 'lateral';
% plot_osciOrAvg        = 'osci';
sortByDistance        = 1;

idx_letters       = find(isletter(experiment));
experimentKeyword = experiment(idx_letters(2:end)); 
AA05_experiment_based_parameter_setting;
clearvars idx_type plt_exp
lateralKeywords = {'Lateral','lateral','Lat','lat','L','l'};
axialKeywords   = {'Axial','axial','Ax','ax','A','a'};

%% Check settings
if ~exist('plot_axOrLatDistance','var')
    switch experimentKeyword(1)
        case 'l'; plot_axOrLatDistance = 'lateral';  % Lateral
        case 'a'; plot_axOrLatDistance = 'axial';    % Axial
        case 'z'; plot_axOrLatDistance = 'z';
        otherwise % Lateral intersection as default
            error('Define plot_axOrLatDistance')
    end
end

if ~exist('plot_axOrLatComponent','var')||~exist('plot_osciOrAvg','var')
    error('Define what to plot');
end

if ~exist('sortByDistance','var'); sortByDistance = 0; end

%% Load data
load(fullfile(material_fdpth,'v_raw_list.mat'),...
     'v_ax_raw_list','v_lat_raw_list')

%% Get bead position
if ~strcmp(pt_list,'ExtractFromFilenames')
    [xgb_list,ygb_list] = BeadCoordsFromFile(...
                          beadcoords_pth,pt_list,experiment);
    zgb_list = zeros(size(xgb_list));
else
    if exist(fullfile(AFpsd_fdpth,'*_AF.dat'),'file') % AF: after flash
        rawdata_AF_struct = dir(fullfile(AFpsd_fdpth,'*_AF.dat')); 
    else
        rawdata_AF_struct = dir(fullfile(AFpsd_fdpth,'*.dat')); 
    end
    pt_list_checkup
    zgb_list = pt_list';
    xgb_list = zeros(size(zgb_list));
    ygb_list = zeros(size(zgb_list));
end

%% Discard
switch plot_osciOrAvg
    case {'avg','Average','Avg'}; AA99_discardPt_avgFlow;
    case {'osci','Oscillatory','Osci'}
        switch plot_axOrLatComponent
            case lateralKeywords; AA98_discardPt_osciFlow_V;
            case axialKeywords  ; AA98_discardPt_osciFlow_U;
        end
end

idx_keep     = ~ismember(pt_list,pt_discard);
[pt_list,xgb_list,ygb_list,zgb_list,...
 v_ax_raw_list,v_lat_raw_list]  = takeTheseIndices(idx_keep,...
                                  pt_list,xgb_list,ygb_list,zgb_list,...
                                  v_ax_raw_list,v_lat_raw_list);

%% Sort by distance, ascending order
d_lat_list    = abs(ygb_list);
d_ax_list     = abs(xgb_list);
d_z_list      = zgb_list;    %  > 0 means bead higher than the cell

if sortByDistance == 1
    switch plot_axOrLatDistance
        case lateralKeywords; [~,idx_sort]  = sort(d_lat_list);
        case axialKeywords  ; [~,idx_sort]  = sort(d_ax_list) ;
        case {'z','Z'}      ; [~,idx_sort]  = sort(d_z_list)  ;
    end
    [pt_list,xgb_list,ygb_list,...
    v_ax_raw_list,v_lat_raw_list,...
    d_ax_list,d_lat_list,d_z_list]  = takeTheseIndices(idx_sort,...
                                     pt_list,xgb_list,ygb_list,...
                                     v_ax_raw_list,v_lat_raw_list,...
                                     d_ax_list,d_lat_list,d_z_list);
end

%% Pre-allocate arrays to plot
NoPos                 = length(pt_list);
[avg_v_ax_list , avg_v_lat_list,...
 ampl_v_ax_list, ampl_v_lat_list] = deal(zeros(NoPos,1));  
freq_list             = ones(NoPos,1)*-1; 

%% Fills plot
for i_pos = 1:NoPos  
    pt                   = pt_list(i_pos);
    v_ax_raw             = v_ax_raw_list{i_pos};
    v_lat_raw            = v_lat_raw_list{i_pos};
    
    %% avg flow
    avg_v_ax_list(i_pos) = mean(v_ax_raw);
    avg_v_lat_list(i_pos)= mean(v_lat_raw);   
    
    %% osci flow
    [v_ax_bpf ,~,freq_ax ] = AutoBPF_FlagSig_v2(v_ax_raw ,Fs);
    [v_lat_bpf,~,freq_lat] = AutoBPF_FlagSig_v2(v_lat_raw,Fs);
    
    if numel(freq_ax)>=2 % deviation from sinusoidal shape
        ampl_v_ax_bpf     = prctile(v_ax_bpf,95) - prctile(v_ax_bpf,5);
    else
        [ampl_v_ax_bpf,~] = osciAmplByStatisticalPeakFinding(...
                             v_ax_bpf,'EXP',0);
    end
    
    if numel(freq_lat)>=2 % deviation from sinusoidal shape
        ampl_v_lat_bpf    = prctile(v_lat_bpf,95) - prctile(v_lat_bpf,5);
    else
        [ampl_v_lat_bpf,~]= osciAmplByStatisticalPeakFinding(...
                             v_lat_bpf,'EXP',0);
    end
    
    if isempty(ampl_v_ax_bpf);   ampl_v_ax_bpf =nan;  end
    if isempty(ampl_v_lat_bpf);  ampl_v_lat_bpf=nan;  end
    
    ampl_v_ax_list(i_pos) = ampl_v_ax_bpf;
    ampl_v_lat_list(i_pos)= ampl_v_lat_bpf;  
    
    %% determine freq, for scaling
    freq_ax    = min(freq_ax);
    freq_lat   = min(freq_lat);
    freq       = mean([freq_ax,freq_lat],'omitnan'); % no worry for '[]'
    if ~isnan(freq)
        freq_list(i_pos)=freq;  % else freq_list(i_pos) = -1
    end
end

%% signal correction
freq_list(freq_list==-1) = mean(freq_list(freq_list~=-1));
stiff_mean        = mean([stiff_x,stiff_y]);
f_corner          = stiff_mean/(5.65e-5*beadsize);
damping_list      = f_corner./sqrt(f_corner^2 + freq_list.^2);
norm_speed_list   = freq_list.*flag_length;    % [micron/sec]
norm_dist_list    = 1000*sqrt(0.9565./freq_list);

ampl_v_ax_list    = ampl_v_ax_list ./damping_list;
ampl_v_lat_list   = ampl_v_lat_list./damping_list;

%% save computed variables in this run
note = ['osci. damping already corrected,',...
        ' ax_avg flow direction adjusted,',...
        ' treatment date:',char(datetime('now'))];
save(fullfile(material_fdpth,'oscillatory and average flows.mat'),...
     'experiment','pt_list'  ,'xgb_list' ,'ygb_list', 'zgb_list',...
     'd_ax_list' ,'d_lat_list','freq_list',...
     'stiff_mean','f_corner'  ,'damping_list',...
     'norm_speed_list','norm_dist_list',...
     'v_ax_raw_list' ,'v_lat_raw_list',...
     'ampl_v_ax_list','ampl_v_lat_list',...
     'avg_v_ax_list' ,'avg_v_lat_list',...
     'note')

%% prepare plot arrays
d_latScaled_list  = d_lat_list  ./norm_dist_list;
d_axScaled_list   = d_ax_list   ./norm_dist_list;
d_zScaled_list    = d_z_list    ./norm_dist_list;
switch plot_axOrLatDistance
    case axialKeywords   ; d_plotScaled_list = d_axScaled_list;
    case lateralKeywords ; d_plotScaled_list = d_latScaled_list;
    case {'z','Z'}       ; d_plotScaled_list = d_zScaled_list;
end

switch plot_axOrLatComponent
    case axialKeywords
        v_osciPlotScaled_list = ampl_v_ax_list./norm_speed_list;
        v_avgPlotScaled_list  = -avg_v_ax_list./...
                                norm_speed_list;
        if ismember(plot_axOrLatDistance,{'z','Z'}) ||...
           strcmp(experimentKeyword,'lz')
            v_avgPlotScaled_list = abs(v_avgPlotScaled_list);
            disp('Study flow decay over Z, use absolute value');
        end
    case lateralKeywords
        v_osciPlotScaled_list = ampl_v_lat_list./norm_speed_list;
        v_avgPlotScaled_list  = avg_v_lat_list./norm_speed_list;
        v_avgPlotScaled_list  = abs(v_avgPlotScaled_list);
        disp('Lateral avg flow is the absolute value')
end

switch plot_osciOrAvg
    case {'oscillatory','osci'}; v_PlotScaled_list = v_osciPlotScaled_list;
    case {'average','avg'}     ; v_PlotScaled_list = v_avgPlotScaled_list;
end

%% plot
if ~exist('markerColor','var'); markerColor = 'k';      end
if ~exist('markerType' ,'var'); markerType  = 's';      end
if ~exist('markerSize' ,'var'); markerSize  = 6  ;      end
if beadsize<3; markerFaceColor = 'none';
else; markerFaceColor = markerColor; end

idx_NonNaN = find(~isnan(v_PlotScaled_list));
plt_exp = plot(d_plotScaled_list(idx_NonNaN),...
               v_PlotScaled_list(idx_NonNaN),...
               [markerType,'-'],'MarkerSize',markerSize,'LineWidth',1,...
               'Color',markerColor,'MarkerFaceColor',markerColor,...
               'MarkerEdgeColor','none');

%% add properties to the plotted lines/points          
if ~isprop(plt_exp,'plot_axOrLatComponent')
    addprop(plt_exp,'plot_axOrLatComponent');
end
set(plt_exp,'plot_axOrLatComponent',plot_axOrLatComponent);

if ~isprop(plt_exp,'plot_axOrLatDistance') 
    addprop(plt_exp,'plot_axOrLatDistance');
end
set(plt_exp,'plot_axOrLatComponent',plot_axOrLatComponent);

if ~isprop(plt_exp,'plot_osciOrAvg')
    addprop(plt_exp,'plot_osciOrAvg');  
end
set(plt_exp,'plot_osciOrAvg' ,plot_osciOrAvg);

if ~isprop(plt_exp,'experiment')
    addprop(plt_exp,'experiment');
end
set(plt_exp,'experiment',experiment);

clearvars markerColor markerType markerSize
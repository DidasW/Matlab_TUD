%% Define path
% clear all
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))
color_palette;
% experiment = '180419c17l'
AA05_experiment_based_parameter_setting;
[fdpth_temp,~,~] = fileparts(compiledData_pth);
saveReport_pth   = fullfile(fdpth_temp,[experiment,'_OsciFlow.dat']);
clear fdpth_temp
% plot_axOrLatComponent = 'axial';
% plot_axOrLatDistance  = 'lateral';
% plot_osciOrAvg        = 'oscillatory'


%% Load data
load(compiledData_pth, 'Fs','fps','pt_list' ,...
    'xgb_list','ygb_list','pos_info',...
    'vx_raw_list'    ,  'vy_raw_list'   ,...
    'U_raw_list'     ,  'V_raw_list'    ,...
    'freqx_list'     ,  'freqy_list'    )

%% discard mistaken measurements
switch experiment
    case '180419c17l'
        pt_discard = [4,9,24,31]; % 9,31,cell touching bead;
                                  % 4,24,no signal
    case '180903c20a'
        pt_discard = [9:13]       % 9-13 are zero shifted.
    otherwise 
        pt_discard = [];              
end

idx_keep     = ~ismember(pt_list,pt_discard);
pos_info = pos_info(idx_keep,:);
[pt_list,xgb_list,ygb_list,...
vx_raw_list,vy_raw_list,...
U_raw_list,V_raw_list,...
freqx_list,freqy_list] = takeTheseIndices(idx_keep,...
                                          pt_list,xgb_list,ygb_list,...
                                          vx_raw_list,vy_raw_list,...
                                          U_raw_list,V_raw_list,...
                                          freqx_list,freqy_list);

%% Sort by lateral distance, ascending order
if ~exist('plot_axOrLatDistance','var')
    [~,idx]         = sort(abs(ygb_list));
else
    switch plot_axOrLatDistance
        case 'axial'
            [~,idx]         = sort(abs(xgb_list));
        case 'lateral'
            [~,idx]         = sort(abs(ygb_list));
    end
end
[pt_list,xgb_list,ygb_list,...
vx_raw_list,vy_raw_list,...
U_raw_list,V_raw_list,...
freqx_list,freqy_list] = takeTheseIndices(idx,...
                                          pt_list,xgb_list,ygb_list,...
                                          vx_raw_list,vy_raw_list,...
                                          U_raw_list,V_raw_list,...
                                          freqx_list,freqy_list);

%% Prepare beating frequency for each position
freq_list                 = freqx_list;
idx_fNotFoundInX          = find(freqx_list==0);
freq_list(idx_fNotFoundInX)= freqy_list(idx_fNotFoundInX);

freq_list(freq_list==0)   = mean(freq_list(freq_list>0));
period_list               = 1000./freq_list;
avg_period_list           = period_list;

d_lat_list            = abs(ygb_list);
d_ax_list             = abs(xgb_list);
d_abs_list            = sqrt(d_lat_list.^2+d_ax_list.^2);
lf                    = flag_length;
v_ax_raw_list         = vx_raw_list;
v_lat_raw_list        = vy_raw_list;

%% Plot settings
if beadsize>3.5 
    markercolor = BaoLan;
else
    markercolor = YangHong;
end 

if markersolid == 0 
    markerface = 'None';
else
    markerface = markercolor;
end

if ~exist('markertype','var')
    markertype = 'o';
end
          
%% Calculate the oscillatory flow amplitude by statistics
gcf; set(gcf,'defaulttextinterpreter','LaTex')
hold on
 
%% constant flow and oscillatory flow
fileID                = fopen(saveReport_pth,'wt');
fprintf(fileID,['ExpCode\tLatDist\tScaledDist\tFlagLength\tAvgCyc\tAvgFreq\t',...
        'Damping\tAmplU\tAmplVaxBPFStat\n']);
NoPos = length(d_lat_list);
for i_pos = 1:NoPos         % position level
    v_ax_raw  = v_ax_raw_list{i_pos};
    v_lat_raw = v_lat_raw_list{i_pos};
    U_raw     = U_raw_list{i_pos};
    V_raw     = V_raw_list{i_pos};
    
    avg_period     = avg_period_list(i_pos);         % [ms]
    avg_freq       = 1000/avg_period;                % [Hz]
    norm_speed     = avg_freq*lf;                    % [micron/sec]
    norm_dist      = 1000*sqrt(0.9565/avg_freq);
    d_lat          = d_lat_list(i_pos);
    d_ax           = d_ax_list(i_pos);
    d_abs          = d_abs_list(i_pos);
    d_latScaled    = d_lat/norm_dist;
    d_axScaled     = d_ax/norm_dist;
    d_absScaled    = d_abs/norm_dist;
    
    
    stiff_mean     = mean([stiff_x,stiff_y]);
    f_corner       = stiff_mean/(5.65e-5*beadsize);
    damping        = f_corner/sqrt(f_corner^2 + avg_freq^2);

    
    fprintf(fileID,'%02d\t%.2f\t%.2f\t%.2f\t%.4f\t%.4f\t%.4f\t',...
            pt_list(i_pos), d_lat, d_latScaled, lf, avg_period,...
            avg_freq, damping);
    
    v_ax_BPF       = AutoBPF_FlagSig_v2(v_ax_raw,Fs);
    v_lat_BPF      = AutoBPF_FlagSig_v2(v_lat_raw,Fs);
    v_ax_BPF       = v_ax_BPF/damping;
    v_lat_BPF      = v_lat_BPF/damping;
 
    ampl_U_Osci    =osciAmplByStatisticalPeakFinding(U_raw,'CFD',0);
    ampl_V_Osci    =osciAmplByStatisticalPeakFinding(V_raw,'CFD',0);
    fprintf(fileID,'%.4f\t',ampl_U_Osci);
    
    %% 
    if ~exist('plot_axOrLatDistance','var')
        d_plotScaled = d_latScaled;
    else
        switch plot_axOrLatDistance
            case 'axial'
                d_plotScaled = d_axScaled;
            case 'lateral'
                d_plotScaled = d_latScaled;
        end
    end

    
    %%  v_ax_BPF oscillatory amplitude
    [ampl_v_ax_bpf,~]  = osciAmplByStatisticalPeakFinding(...
                         v_ax_BPF,'EXP',0);
    if ~isempty(ampl_v_ax_bpf)
        ampl_v_ax_bpf_str = num2str(ampl_v_ax_bpf,'%.2f');
        if strcmp(plot_axOrLatComponent,'axial')
            plt_exp = plot(d_plotScaled, ampl_v_ax_bpf / norm_speed,...
                      markertype,'MarkerSize',markersize,'LineWidth',1,...
                      'Color',markercolor,'MarkerFaceColor',markerface);
        end
    else
        ampl_v_ax_bpf_str  = '-';
    end
    fprintf(fileID,'%s\n',ampl_v_ax_bpf_str);
    
    %%  v_lat_BPF oscillatory amplitude
    [ampl_v_lat_bpf,~] = osciAmplByStatisticalPeakFinding(...
                         v_lat_BPF,'EXP',0);
    if ~isempty(ampl_v_lat_bpf)
        if strcmp(plot_axOrLatComponent,'lateral')
            plt_exp = plot(d_plotScaled, ampl_v_lat_bpf / norm_speed,...
                      markertype,'MarkerSize',markersize,'LineWidth',1,...
                      'Color',markercolor,'MarkerFaceColor',markerface);
        end
    end

    
    %%
    if ~isprop(plt_exp,'plot_axOrLatComponent') && ...
        ~isprop(plt_exp,'plot_axOrLatDistance') && ...
        ~isprop(plt_exp,'plot_osciOrAvg')
    addprop(plt_exp,'plot_axOrLatComponent');
    addprop(plt_exp,'plot_axOrLatDistance');
    addprop(plt_exp,'plot_osciOrAvg');
    end
    set(plt_exp,'plot_axOrLatComponent',plot_axOrLatComponent);
    set(plt_exp,'plot_axOrLatDistance' ,plot_axOrLatDistance);
    set(plt_exp,'plot_osciOrAvg'       ,'oscillatory');
    if ~isprop(plt_exp,'experiment')
        addprop(plt_exp,'experiment');
    end
    set(plt_exp,'experiment',experiment);

end
fclose(fileID);
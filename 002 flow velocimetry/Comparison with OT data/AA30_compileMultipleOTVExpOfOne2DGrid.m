clear all
papar_fdpth    = fullfile('C:','SURFdrive',...
                 '002 Academic writing',...
                 '190101 [Manuscript] for OTV-long');
PaperMaterial_fdpth = fullfile(papar_fdpth,'material');
cd(PaperMaterial_fdpth)
% experiments = {'280918c23g1','280918c23g2','280918c23g3',...
%                '280918c23g4','180918c23g5'};
% experiments   = {'190104c36g1','190104c36g2'};
experiments = {'190414c56g1','190414c56g2','190414c56g3',...
               '190414c56g4','190414c56g5'};


%% containers 
% array
temp_pos_info           = [];
temp_factor_x_list      = [];
temp_factor_y_list      = [];
temp_freqx_list         = [];
temp_freqy_list         = [];
temp_t_shift_list_x     = [];
temp_t_shift_list_y     = [];
temp_vx_shift_list      = [];
temp_vy_shift_list      = [];
temp_xgb_list           = [];
temp_ygb_list           = [];
temp_t_vid_start_list   = [];
temp_pt_list            = [];
fps_list                = [];

% cell
temp_t_vid_list         = {};
temp_U_list             = {};
temp_U_raw_list         = {};
temp_V_list             = {};
temp_V_raw_list         = {};
temp_vx_list            = {};
temp_vx_raw_list        = {};
temp_vy_list            = {};
temp_vy_raw_list        = {};
temp_marked_image_list_cell = {};
% NOTE, x y is adjusted to the cell reference, x is the axial and y is the
% lateral axis. Positive direction of the axial direction: to the front of
% the cell.

%%
for iiii = 1:numel(experiments)
    experiment = experiments{iiii};
    fprintf('Processing %s\n',experiment)
    %%
    AA05_experiment_based_parameter_setting;
    %%      
    load(compiledData_pth)
    load(fullfile(PaperMaterial_fdpth,'t_start_list.mat'),'t_start_list')
    load(fullfile(PaperMaterial_fdpth,'all_marked_list.mat'),...
        'marked_image_list_cell')
    t_vid_start_list = t_start_list;
    save(compiledData_pth,'t_vid_start_list','-append')
    
    %%
    % array
    fps_list                = vertcat(fps_list,...
                              fps*ones(numel(temp_pt_list),1));
    temp_pos_info           = vertcat(temp_pos_info,      pos_info(:,1:3));
    temp_factor_x_list      = vertcat(temp_factor_x_list, factor_x_list);
    temp_factor_y_list      = vertcat(temp_factor_y_list, factor_y_list);
    temp_freqx_list         = vertcat(temp_freqx_list,    freqx_list);
    temp_freqy_list         = vertcat(temp_freqx_list,    temp_freqx_list);
    temp_t_shift_list_x     = vertcat(temp_t_shift_list_x,t_shift_list_x);
    temp_t_shift_list_y     = vertcat(temp_t_shift_list_y,t_shift_list_y);
    temp_vx_shift_list      = vertcat(temp_vx_shift_list, vx_shift_list);
    temp_vy_shift_list      = vertcat(temp_vy_shift_list, vy_shift_list);
    temp_xgb_list           = vertcat(temp_xgb_list,      xgb_list);
    temp_ygb_list           = vertcat(temp_ygb_list,      ygb_list);
    temp_t_vid_start_list   = vertcat(temp_t_vid_start_list,...
                                      t_vid_start_list);
    temp_pt_list            = vertcat(temp_pt_list,       pt_list');
    % cell
    temp_t_vid_list         = vertcat(temp_t_vid_list,  t_vid_list);
    temp_U_list             = vertcat(temp_U_list,      U_list);
    temp_U_raw_list         = vertcat(temp_U_raw_list,  U_raw_list);
    temp_V_list             = vertcat(temp_V_list,      V_list);
    temp_V_raw_list         = vertcat(temp_V_raw_list,  V_raw_list);
    temp_vx_list            = vertcat(temp_vx_list,     vx_list);
    temp_vx_raw_list        = vertcat(temp_vx_raw_list, vx_raw_list);
    temp_vy_list            = vertcat(temp_vy_list,     vy_list);
    temp_vy_raw_list        = vertcat(temp_vy_raw_list, vy_raw_list);
    temp_marked_image_list_cell = vertcat(temp_marked_image_list_cell,...
                                  marked_image_list_cell);
    
end

pos_info           = temp_pos_info;
factor_x_list      = temp_factor_x_list;
factor_y_list      = temp_factor_y_list;
freqx_list         = temp_freqx_list;
freqy_list         = temp_freqx_list;
t_shift_list_x     = temp_t_shift_list_x;
t_shift_list_y     = temp_t_shift_list_y;
vx_shift_list      = temp_vx_shift_list;
vy_shift_list      = temp_vy_shift_list;
xgb_list           = temp_xgb_list;
ygb_list           = temp_ygb_list;
t_vid_start_list   = temp_t_vid_start_list;
pt_list            = temp_pt_list;
% cell
t_vid_list         = temp_t_vid_list;
marked_image_list_cell  = temp_marked_image_list_cell;
U_list             = temp_U_list;
U_raw_list         = temp_U_raw_list;
V_list             = temp_V_list;
V_raw_list         = temp_V_raw_list;
vx_list            = temp_vx_list;
vx_raw_list        = temp_vx_raw_list;
vy_list            = temp_vy_list;
vy_raw_list        = temp_vy_raw_list;

NoPos = numel(pt_list);
save(fullfile(PaperMaterial_fdpth,...
    [experiment(7:end-1),'_flowFieldDataCompilation.mat']),...
    'pos_info' ,'pt_list','xgb_list','ygb_list',...
    'vx_list'  ,    'vx_raw_list'   ,...
    'vy_list'  ,    'vy_raw_list'   ,...
    'freqx_list',   'freqy_list'    ,...
    'U_list'   ,    'U_raw_list'    ,...
    'V_list'   ,    'V_raw_list'    ,...
    'marked_image_list_cell',...
    't_vid_start_list',   't_vid_list'    ,...
    'factor_x_list'   ,   'factor_y_list' ,...
    't_shift_list_x'  ,   't_shift_list_y',...
    'vx_shift_list'   ,   'vy_shift_list',...
    'lb','ub','Fs','fps_list')     


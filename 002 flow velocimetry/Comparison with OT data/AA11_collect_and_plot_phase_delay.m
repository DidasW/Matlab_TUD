%% Addpath
% close all
% run(fullfile('D:','002 MATLAB codes','000 Routine',...
%     'subunit of img treatment routines','add_path_for_all.m'))

%% Control panel
% experiment = '281002c28a'
% plot_axOrLatComponent = 'axial';
% plot_axOrLatDistance  = 'axial';
% plot_osciOrAvg        = 'osci' 

lateralKeywords = {'Lateral','lateral','Lat','lat','L','l'};
axialKeywords   = {'Axial','axial','Ax','ax','A','a'};

clear('freqx_list', 'freqy_list', 'avg_period_list', 't_shift_list_x',...
      't_shift_list_y', 'xgb_list', 'ygb_list', 'pt_discard', 'pt_list')
AA05_experiment_based_parameter_setting;
load(compiledData_pth);


%% determine beating frequency for each case
if ~exist('avg_period_list','var')
    avg_period_list           = 1000./freqx_list;  % define a dummy
    freqx_list_NonZero        = freqx_list(freqx_list>0);
    freqy_list_NonZero        = freqy_list(freqy_list>0);
    freqx_list(freqx_list==0) = mean(freqx_list_NonZero);
    freqy_list(freqy_list==0) = mean(freqy_list_NonZero);
    freq_list                 = mean([freqx_list,freqy_list],2,'omitnan');
    period_list               = 1000./freq_list;
else
    period_list               = avg_period_list;
    freq_list                 = 1000./avg_period_list;
end
  
  
%% discard known trash data as it contains no signal 
switch plot_axOrLatComponent
    case axialKeywords  ;  AA98_discardPt_osciFlow_U;
    case lateralKeywords;  AA98_discardPt_osciFlow_V
end

idx_keep       = ~ismember(pt_list,pt_discard);
[freqx_list,freqy_list,freq_list,...  
 avg_period_list,period_list,...
 t_shift_list_x,t_shift_list_y,...
 ygb_list,xgb_list,pt_list       ] = takeTheseIndices(idx_keep,...
                                     freqx_list,freqy_list,freq_list,...  
                                     avg_period_list,period_list,...
                                     t_shift_list_x,t_shift_list_y,...
                                     ygb_list,xgb_list,pt_list     );       

%% Normalize phase shift and distance
Phshift_vax   = t_shift_list_x./period_list*2*pi; % [rad]
Phshift_vlat  = t_shift_list_y./period_list*2*pi; % [rad]

dist_lat_list = abs(ygb_list);
dist_ax_list  = abs(xgb_list);

dist_scale_list      = 1000*sqrt(0.9565./freq_list);        % [micron]
NormDist_lat_list    = dist_lat_list./dist_scale_list;
NormDist_ax_list     = dist_ax_list ./dist_scale_list;
NormDist_abs_list    = sqrt(NormDist_ax_list.^2+NormDist_lat_list.^2);

%% substract the intrinsic lag due to limited stiffness of the trap
avg_stiff            = (stiff_x+stiff_y)/2;                 % [pN/nm]
fc                   = avg_stiff/(5.6517e-5*beadsize);      % [Hz] 
PhLag_intrinsic_list = atan(freq_list./fc);
Phshift_vax          = Phshift_vax  - PhLag_intrinsic_list;
Phshift_vlat         = Phshift_vlat - PhLag_intrinsic_list;

%% make the final plotting data into a table
Phshift_table = table(pt_list',freq_list,ygb_list,NormDist_lat_list,...
                xgb_list,NormDist_ax_list,...
                t_shift_list_x,t_shift_list_y,Phshift_vax,Phshift_vlat,...
                'VariableNames',{'Position','Frequency',...
                'LateralDistance','ScaledLateralDistance',...
                'AxialDistance','ScaledAxialDistance',...
                'tDelayInAxialSpeed','tDelayInLateralSpeed',...
                'PhaseDelayInAxialSpeed','PhaseDelayInLateralSpeed'});
            
[fdpth_temp,~,~] = fileparts(compiledData_pth);
PhShiftSaveTo_pth = fullfile(fdpth_temp,[experiment,'_PhaseShift.dat']);
clear fdpth_temp
writetable(Phshift_table,PhShiftSaveTo_pth,'Delimiter','\t')

%% Plot
% figure()
hold on

switch plot_axOrLatDistance
    case axialKeywords  ; NormDist_list = NormDist_ax_list;
    case lateralKeywords; NormDist_list = NormDist_lat_list;
end


switch plot_axOrLatComponent
    case axialKeywords
        plt_exp = plot(NormDist_list,Phshift_vax ,'s',...
                  'MarkerSize',5,'MarkerFaceColor','r',...
                  'LineWidth',0.5,'Color','r');
    case lateralKeywords
        plt_exp = plot(NormDist_list,Phshift_vlat ,'s',...
                  'MarkerSize',5,'MarkerFaceColor','r',...
                  'LineWidth',0.5,'Color','r');
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
set(plt_exp,'plot_osciOrAvg'       ,plot_osciOrAvg);
if ~isprop(plt_exp,'experiment')
    addprop(plt_exp,'experiment');
end
set(plt_exp,'experiment',experiment);

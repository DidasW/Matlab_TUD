%% 
% Segmentize the experimental signal by the flagellar shape phase.
% Construct an average cycle for recordings at different distances.
% Extract and axial flow velocity corresponding to the same phase,
% compare the flow speed against distance.

% Approach 1: No BPF, raw addtion
% Approach 2: BPF + 0-frequency term of the added cycle

%% Load variables.
material_fdpth = 'D:\000 RAW DATA FILES\180328 flow inversion\c16l\material\';
experiment =  '171029c16l1';
AA05_experiment_based_parameter_setting;
cycleAveragedFlowByMarkedFlagellarShape = struct();

matfilestruct = dir([material_fdpth,'*.mat']);
for j = 1:length(matfilestruct)
    load([material_fdpth,matfilestruct(j).name])
end

[xgb_list,ygb_list] = BeadCoordsFromFile(beadcoords_pth,pt_list,experiment);
d_lat_list = abs(ygb_list);
if exist('vx_raw_list','var') 
    v_ax_raw_list = vx_raw_list;
end
[~,idx] = sort(d_lat_list);
pt_list                     = pt_list(idx);
xgb_list                    = xgb_list(idx);
ygb_list                    = ygb_list(idx);
v_ax_raw_list               = v_ax_raw_list(idx);
marked_image_list_cell      = marked_image_list_cell(idx);
t_start_list                = t_start_list(idx);
%%

NoPos = length(pt_list);
NoCyc = 15;
cycleAveragedFlow_list = cell (NoPos,1);



figure('defaulttextinterpreter','latex')
title(sprintf('$v_{ax}$, flagellar phase based averaging over %d cycles\n%s',...
    NoCyc,experiment))
hold on

v_axMostForwardReachingAtDifferetPos = zeros(NoPos,1);
v_axMostSideReachingAtDifferetPos    = zeros(NoPos,1);
v_axClosestToBodyAtDifferetPos       = zeros(NoPos,1);

for i = 1:NoPos
    d_lat = abs(ygb_list(i));
    
    v_ax_raw = v_ax_raw_list{i}; %#### APPROACH 1
%     v_ax_raw = mean(v_ax_raw) + AutoBPF_FlagSig_v2(v_ax_raw,Fs);%#### APPROACH 2
    t_PSD = make_time_series(v_ax_raw,Fs,'ms');
    
    % flagella show most forward reaching shapes were labelled
    markedImgIdx = marked_image_list_cell{i};
    markedImgIdx(NoCyc+2:end) = [];
    t_start = t_start_list(i); % time of frame 1
    markedImgIdxInTime  = t_start + (markedImgIdx - 1)*1000/fps; %[ms]  
    
    avg_period     = mean(diff(markedImgIdxInTime)) ;% unit ms
    t_phaseAvgCyc  = 0:1/Fs*1000:avg_period;
    N              = length(t_phaseAvgCyc);
    phaseCycle     = linspace(0,2*pi,N);
    v_axPhaseAvg   = zeros(N,1);
    
    for j = 1:(length(markedImgIdxInTime)-1)
        t_seg_start = markedImgIdxInTime(j);
        t_seg_end   = markedImgIdxInTime(j+1);
        t_seg       = linspace(t_seg_start,t_seg_end,N); 
        
        % t_win here will sample each period with the same number of points.
        % Resampled signal (vx, vy) will be added up to obtain an average.
        % This process is equivalent to rescale each period to the same
        % duration, which is the average period.
        v_axInterp  = interp1(t_PSD,v_ax_raw,t_seg);
        v_axPhaseAvg= v_axPhaseAvg + v_axInterp';
    end
    v_axPhaseAvg     = v_axPhaseAvg/NoCyc;
    cycleAveragedFlow_list{i} = v_axPhaseAvg;
    
    idx_tMostForwardReaching = find(t_phaseAvgCyc>0 & ...
                                    t_phaseAvgCyc<1000/fps);
    idx_tMostSideReaching    = find(t_phaseAvgCyc>6*1000/fps & ...
                                    t_phaseAvgCyc<7*1000/fps);
    idx_tClosestToBody       = find(t_phaseAvgCyc>12*1000/fps & ...
                                    t_phaseAvgCyc<13*1000/fps);
 
    idx_phaseMostForwardReaching = find(phaseCycle>0 & ...
                                    phaseCycle<1/20*2*pi);
    idx_phaseMostSideReaching    = find(phaseCycle>4/20*2*pi & ...
                                    phaseCycle<5/20*2*pi);
    idx_phaseClosestToBody       = find(phaseCycle>13/20*2*pi & ...
                                    phaseCycle<14/20*2*pi);

                                
    v_axMostForwardReachingAtDifferetPos(i) = mean(...
                                v_axPhaseAvg(idx_phaseMostForwardReaching));
    v_axMostSideReachingAtDifferetPos(i)    = mean(...
                                v_axPhaseAvg(idx_phaseMostSideReaching));
    v_axClosestToBodyAtDifferetPos(i)       = mean(...
                                v_axPhaseAvg(idx_phaseClosestToBody));
    
%     if mod(i-1,2) == 0
% if i <= 9
%         plot(phaseCycle,v_axPhaseAvg,'DisplayName',...
%              sprintf('%.1f micron, pt%d',d_lat,pt_list(i)),...
%              'LineWidth',2);
%     end    
%         plot(t_PSD,mean(v_ax_raw)+AutoBPF_FlagSig_v2(v_ax_raw,Fs),...
%             'DisplayName',sprintf('%.1f micron, pt%d',d_lat,pt_list(i)),...
%              'LineWidth',2);
% if i <=5
        plot(t_PSD,v_ax_raw,...
            'DisplayName',sprintf('%.1f micron, pt%d',d_lat,pt_list(i)),...
             'LineWidth',2);
% end
end
legend('show','location','southeast')
xlabel('Flagellar phase')
xticks([0,0.5*pi,pi,1.5*pi,2*pi])
xticklabels({'0','\pi/2','\pi','3/2\pi','2\pi'})
ylabel('Axial flow speed ($\mu$m/s)')
grid on 


%% 
% figure('defaulttextinterpreter','latex')
% hold on
% title(sprintf('$v_{ax}(\\phi_{flag})$, %s',experiment))
% plot(abs(ygb_list),v_axMostForwardReachingAtDifferetPos,'-o',...
%     'LineWidth',2,'DisplayName','Most forward reaching');
% plot(abs(ygb_list),v_axMostSideReachingAtDifferetPos,'-s',...
%     'LineWidth',2,'DisplayName','Most side reaching');
% plot(abs(ygb_list),v_axClosestToBodyAtDifferetPos,'-d',...
%     'LineWidth',2,'DisplayName','Closest to cell body');
% legend('show','location','southeast')
% 
% xlabel('Lateral distance $d_{lat}$ ($\mu$m)')
% ylabel('Axial flow speed ($\mu$m/s)')
% grid on 
% 
% cycleAveragedFlowByMarkedFlagellarShape.experiment = experiment;
% cycleAveragedFlowByMarkedFlagellarShape.NoPos      = NoPos;
% cycleAveragedFlowByMarkedFlagellarShape.NoCyc      = NoCyc;

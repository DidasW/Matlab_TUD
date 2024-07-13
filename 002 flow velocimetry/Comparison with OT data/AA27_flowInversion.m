%% 
% Segmentize the experimental signal by the flagellar shape phase.
% Construct an average cycle for recordings at different distances.
% Extract and axial flow velocity corresponding to the same phase,
% compare the flow speed against distance.

% Approach 1: No BPF, raw addtion
% clear all
close all
%% Load variables.
saveToPath = 'D:\000 RAW DATA FILES\180501 c17\003 flow inversion';
cd(saveToPath)
experiment =  '180419c17l';
AA05_experiment_based_parameter_setting;
cycleAveragedFlowByMarkedFlagellarShape = struct();

matfilestruct = dir([material_fdpth,'*.mat']);
for i_cyc = 1:length(matfilestruct)
    load([material_fdpth,matfilestruct(i_cyc).name])
end

[xgb_list,ygb_list] = BeadCoordsFromFile(beadcoords_pth,pt_list,experiment);
d_lat_list = abs(ygb_list);
if exist('vx_raw_list','var') 
    v_ax_raw_list = vx_raw_list;
end

[~,idx] = sort(d_lat_list);

if strcmp(experiment,'180419c17l')
    idx(1:2) = [];
end
% c17l, get rid of the two closest points, where cell touches the bead
% pos9 and pos31
pt_list                     = pt_list(idx);
xgb_list                    = xgb_list(idx);
ygb_list                    = ygb_list(idx);
v_ax_raw_list               = v_ax_raw_list(idx);
marked_image_list_cell      = marked_image_list_cell(idx);
t_start_list                = t_start_list(idx);
%%

NoPos = length(pt_list);
NoCyc = 40;
NoPhaseSeg=13;
makeGif = 1
saveFig = 1



flowForEachFlagPhase = cell(NoPos,NoPhaseSeg);

for i_Pos = 1:NoPos
    d_lat = abs(ygb_list(i_Pos));
    
    v_ax_raw = v_ax_raw_list{i_Pos}; 
    t_PSD = make_time_series(v_ax_raw,Fs,'ms');
    
    % flagella show most forward reaching shapes were labelled
    markedImgIdx = marked_image_list_cell{i_Pos};
    markedImgIdx(NoCyc+2:end) = [];
    t_start = t_start_list(i_Pos); % time of frame 1
    markedImgIdxInTime  = t_start + (markedImgIdx - 1)*1000/fps; %[ms]  
    
    avg_period     = mean(diff(markedImgIdxInTime)) ;% unit ms
    t_phaseAvgCyc  = 0:1/Fs*1000:avg_period;
    N              = length(t_phaseAvgCyc);
    phaseCycle     = linspace(0,2*pi,N);
    v_axCyclesForOnePos = zeros(N,NoCyc);
    for i_cyc = 1:(length(markedImgIdxInTime)-1)
        t_seg_start = markedImgIdxInTime(i_cyc);
        t_seg_end   = markedImgIdxInTime(i_cyc+1);
        t_seg       = linspace(t_seg_start,t_seg_end,N); 
        
        % t_win here will sample each period with the same number of points.
        % Resampled signal (vx, vy) will be added up to obtain an average.
        % This process is equivalent to rescale each period to the same
        % duration, which is the average period.
        v_axInterp  = interp1(t_PSD,v_ax_raw,t_seg);
        v_axCyclesForOnePos(:,i_cyc) = v_axInterp;
    end
%     if i_Pos <= 4
%         figure('defaulttextinterpreter','latex')
%         title(sprintf('$v_{ax}$ cycle at %.2f micron, %d cycles\n%s',...
%         d_lat,NoCyc,experiment));
%         hold on
%         plot(phaseCycle,v_axCyclesForOnePos','.','Color',[0.7,0.7,0.7])
%         plot(phaseCycle,mean(v_axCyclesForOnePos,2),'-','Color','red',...
%             'LineWidth',2,'DisplayName','Avg')
% %         legend('show','location','southeast')
%         xlabel('Flagellar phase')
%         xticks([0,0.5*pi,pi,1.5*pi,2*pi])
%         xticklabels({'0','\pi/2','\pi','3/2\pi','2\pi'})
%         ylabel('Axial flow speed ($\mu$m/s)')
%         grid on 
%     end
    
    for i_PhaseSeg = 1:NoPhaseSeg
        idx_thisPhase = find(phaseCycle>(i_PhaseSeg-1)/NoPhaseSeg*2*pi & ...
                             phaseCycle<= i_PhaseSeg  /NoPhaseSeg*2*pi );
        flowForEachFlagPhase(i_Pos,i_PhaseSeg)=...
                        {v_axCyclesForOnePos(idx_thisPhase,:)};
    end 
    

end

%%

for i_PhaseSeg = 1:NoPhaseSeg
    figure();
    set(gcf,'defaulttextinterpreter','latex','Units','inches',...
        'Position',[0.5,0.5,5,7])
    
    color = [1-0.5*sin(i_PhaseSeg/NoPhaseSeg*pi),...
             0,...
             0.5*sin(i_PhaseSeg/NoPhaseSeg*pi)];
    
    for i_Pos  = 1:NoPos
        
        v_axOnePhaseOnePos = flowForEachFlagPhase{i_Pos,i_PhaseSeg};
        v_axOnePhaseOnePos = v_axOnePhaseOnePos(:);
        
        avg = mean(v_axOnePhaseOnePos);
        stdev = std(v_axOnePhaseOnePos);
        med = median(v_axOnePhaseOnePos);
        prctile25 = prctile(v_axOnePhaseOnePos,25);
        prctile75 = prctile(v_axOnePhaseOnePos,75);
        
        d_lat = abs(ygb_list(i_Pos));
        d_latPlot = ones(size(v_axOnePhaseOnePos))*d_lat;
        
        subplot(2,1,1)
        title(sprintf('$v_{ax}$, Phase seg No.%d/%d over %d cycles\n%s',...
        i_PhaseSeg,NoPhaseSeg,NoCyc,experiment));
        set(gca,'defaulttextinterpreter','latex',...
        'TickLabelInterpreter','Latex')
        hold on
        plot(d_latPlot,v_axOnePhaseOnePos,'.','MarkerSize',3,...
            'Color',[color,0.2]);
        
        plot([0,1000],[0,0],':','LineWidth',1.5,'color',YingWuLv)
        
        xlabel('Lateral distance $d_{lat}$ ($\mu$m)')
        ylabel('Axial flow speed ($\mu$m/s)')
        xlim([0,150])
        ylim([-25,30])
        grid on 
        
        subplot(2,1,2)
        set(gca,'defaulttextinterpreter','latex',...
        'TickLabelInterpreter','Latex')
        hold on
        boxHalfWidth = 1.5;
        h_avg = plot(d_lat,avg,'s','MarkerSize',6,'Color',color,...
                    'LineWidth',1);
        h_err = errorbar(d_lat,avg,stdev,'Color',color,'LineWidth',0.5);
        h=fill([d_lat-boxHalfWidth,d_lat+boxHalfWidth,...
                d_lat+boxHalfWidth,d_lat-boxHalfWidth],...
               [prctile25,prctile25,prctile75,prctile75],color);
        h.FaceAlpha=0.2;
        
        plot([0,1000],[0,0],':','LineWidth',1.5,'color',YingWuLv)
        
        xlabel('Lateral distance $d_{lat}$ ($\mu$m)')
        ylabel('Axial flow speed ($\mu$m/s)')
        xlim([0,150])
        ylim([-25,30])
        grid on 
    end
    
    
    legend([h_avg,h_err,h],{'mean','std','25-75 percentile'},'Location',...
        'southeast','fontsize',8)
    
    if saveFig == 1
        print(gcf,['Phase Segment ',num2str(i_PhaseSeg),'.png'],...
                  '-dpng','-r300');
    end
    
    if makeGif == 1
        if i_PhaseSeg==1
            gif(['Flow inversion ',experiment,'.gif'],'frame',gcf,...
                'DelayTime',0.05)
            close(gcf)
        else
            gif('frame',gcf,'DelayTime',0.05)
            close(gcf)
        end
    end
    
end


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

% run(fullfile('C:','SurfDrive','008 MATLAB code backup','000 Routine',...
%     'subunit of img treatment routines','add_path_for_all.m'))
% addpath(fullfile('C:','SurfDrive','002 Academic writing',...
%     '170814 Manuscript for Optical Tweezers flow velocimetry','codes'))
% color_palette
%%
dataSource_fdpth = 'C:\SurfDrive\180424 c17 PTV\002 treated tracks\001 living cell PTV tracks';
cd(dataSource_fdpth);
beadcoords_pth = 'C:\SurfDrive\180424 c17 PTV\position\Position c17PTV_AfterRot_um.dat';
load('all_marked_list.mat')
saveFigTo_fdpth = 'C:\SurfDrive\180424 c17 PTV\003 results\phase delay';

pt_list = 1:27;
NoPos = numel(pt_list);
fps = 416;

%%
phaseDelay_list = [];
d_lat_list      = [];
valid_pt_list   = [];

for i_pos = [2:9,11:20]
    pt = pt_list(i_pos);
    [distanceX,distanceY] = BeadCoordsFromFile(beadcoords_pth,pt,'180419');
    d_lat = abs(distanceY);
    d_x   = abs(distanceX);
    %%
    
    findTrack = dir([num2str(pt,'%02d'),'_*.dat']);
    filename = findTrack.name;
    parseName = strsplit(filename,'_');
    startFrame = str2double(parseName{2});
    
    filefolder = findTrack.folder;
    track = dlmread(fullfile(filefolder,filename));
    [~,idx] = sort(track(:,1));
    track   = track(idx,:);
    idx     = find(track(:,1)>=startFrame);
    track_afterStart  = track(idx,:);
    
    frame = track_afterStart(:,1);
    x0 = track_afterStart(1,2)*0.107;
    x  = track_afterStart(:,2)*0.107 - x0;
    y0 = track_afterStart(1,3)*0.107;
    y  = -(track_afterStart(:,3)*0.107 - y0);
    %% Linear Fit
    P  = polyfit(frame,y,1);
    k  = P(1); b = P(2);
    
    %% bpf
    [y_bpf,~,freq,~,~,pow,f] = AutoBPF_FlagSig_v2(y,fps,40,60);
    
    %% Intermediate check figure
    figure()
    hold on, grid on, box on
    
    h_raw = plot(frame-startFrame,y,'o','MarkerSize',6);
    h_linFit = plot(frame-startFrame,frame*k+b,'--','LineWidth',1.5);
    h_CutLinFit = plot(frame-startFrame,y-(frame*k+b),'o-',...
        'MarkerSize',4,'LineWidth',0.5);
    h_BPF = plot(frame-startFrame,y_bpf,'-','LineWidth',1.5);
    
    legend([h_raw,h_linFit,h_CutLinFit,h_BPF],...
        {'raw','linear-fit','raw,subtract linear fit','BPF'},...
        'box','off','FontSize',8,'Location','northwest')
    
    title(sprintf('Pos%02d, lateral distance:%.2f microns',pt,d_lat));
    xlabel('Frame'); ylabel('Axial displacement [micron]');
    
    print(gcf,fullfile(saveFigTo_fdpth,...
        [num2str(pt,'%02d'),'_rawCompare.png']),'-dpng','-r200');
    
    %% Figure put on the beginnings of the cycles
    cycleStartFrame = marked_image_list_cell{i_pos};
    if ~isempty(cycleStartFrame)
        figure()
        hold on, grid on, box on
        
        h_CutLinFit = plot(frame-startFrame,y-(frame*k+b),'o-',...
                      'MarkerSize',4,'LineWidth',0.5);
        h_BPF = plot(frame-startFrame,y_bpf,'-','LineWidth',1.5);
        
        
        plot([cycleStartFrame-startFrame,...
              cycleStartFrame-startFrame],...
                  [-5,5],'--','Linewidth',0.5,...
                  'Color',[0.3,0.3,0.3])
        h_temp = findobj(gca,'linestyle','--');
        h_cycleStart = h_temp(1);
        
        legend([h_CutLinFit,h_BPF,h_cycleStart],...
        {'raw,subtract linear fit','BPF','cycle start'},...
        'box','on','FontSize',8,'Location','northeast')

        
        ylim([-1,1]);         xlim([0,100]);
        title(sprintf('Pos%02d, lateral distance:%.2f microns',pt,d_lat));
        xlabel('Frame'); ylabel('Oscillaotry displacement of the bead[micron]');

        print(gcf,fullfile(saveFigTo_fdpth,...
        [num2str(pt,'%02d'),'_segmentation.png']),'-dpng','-r300');
    
        %% Construct average cycle from BPF signal
        frame_zeroed = frame - startFrame;

        t_zeroed     = frame_zeroed/fps*1000; %[ms]
        t_interp     = t_zeroed(1):1/50:t_zeroed(end);%50kHz interp
        
        avg_y_cycle  = zeros(size(linspace(1,2*pi,1000)));
        
        cycleStartFrame = cycleStartFrame(cycleStartFrame>startFrame &...
                          cycleStartFrame<frame(end));
        for i_markedBegin = 1:numel(cycleStartFrame)-1
            startFrameThisCycle = cycleStartFrame(i_markedBegin);
            startFrameNextCycle = cycleStartFrame(i_markedBegin+1);
            
            t_start_thisCycle = t_zeroed(find(frame==startFrameThisCycle));
            t_start_nextCycle = t_zeroed(find(frame==startFrameNextCycle));
            t_seg = linspace(t_start_thisCycle,t_start_nextCycle,1000);
            
            y_bpf_seg = interp1(t_zeroed,y_bpf,t_seg,'spline');
            avg_y_cycle = avg_y_cycle + y_bpf_seg;
        end
        avg_y_cycle = avg_y_cycle/(numel(cycleStartFrame)-1);
        
        %% plot average cycle versus cycle starts
        figure()
        grid on, box on, hold on
        
        flagPhase = linspace(0,2*pi,1000);

        h_mark = plot([0,0],[-1,1],'-','Color',BaoLan,'LineWidth',1);
        h_avgCyc = plot(flagPhase,avg_y_cycle,'-',...
                   'LineWidth',1.5,'Color',YangHong);
        plot(flagPhase(751:end)-2*pi,avg_y_cycle(751:end),'-',...
             'LineWidth',1.5,'Color',[YangHong,0.3]);
        plot(flagPhase(1:250)+2*pi,avg_y_cycle(1:250),'-',...
             'LineWidth',1.5,'Color',[YangHong,0.3]);        
        
        legend([h_avgCyc,h_mark],{'Averaged cycle (time-stamped)',...
            'User-marked cycle starts'},'box','on',...
            'FontSize',8,'Location','southeast')
       
        [~,idx_minY] = min(avg_y_cycle);
        minY_phase   = flagPhase(idx_minY);
        plot([0,minY_phase],[mean(avg_y_cycle),mean(avg_y_cycle)],...
            ':','Color','k','LineWidth',1,...
            'DisplayName','Relative phase difference');
        plot([minY_phase,minY_phase],[-1,1],...
            '-','Color',[0.5,0.5,0.5],'LineWidth',1,...
            'DisplayName','Max displacement');
        text(0.2,mean(avg_y_cycle)+0.1*min(avg_y_cycle),...
            sprintf('\\theta=%.2f \\pi',minY_phase/pi))
        
        xlabel('flagellar phase ([rad]');
        ylabel('Oscillatory displacement [micron]');
        ylim([min(avg_y_cycle),max(avg_y_cycle)])
        set(gca,'TickLabelInterpreter','latex');
        xticks([-0.5*pi,0*pi,0.5*pi,1.0*pi,1.5*pi,2.0*pi,2.5*pi])
        xticklabels({'$-\frac{1}{2}\pi$','0','$\frac{1}{2}\pi$',...
            '$\pi$','$\frac{3}{2}\pi$','$2\pi$','$\frac{5}{2}\pi$'})
        
        print(gcf,fullfile(saveFigTo_fdpth,...
        [num2str(pt,'%02d'),'_phaseDelay.png']),'-dpng','-r300');
        %% register values
        phaseDelay_list = [phaseDelay_list,minY_phase]; %#ok<*AGROW>
        d_lat_list      = [d_lat_list,d_lat];
        valid_pt_list   = [valid_pt_list,pt];
    end
    close all
end
save('PTV_phase_delay_analysis.mat',...
     'phaseDelay_list','d_lat_list','valid_pt_list')


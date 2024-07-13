%%%%%%%%%%%%%%%%%%%%%%UNFINISHED%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
pt_list_c5g1       = [11:16,21:26,31:36,44:46];
pt_list_c5g2       = [41:43,53:56,63:67,73:77,82:87];
pt_list_c5g3       = [10 17 20 30 37 47 57];


pt = 76;
%% load 
color_palette
pt_str = num2str(pt);
if ismember(pt,pt_list_c5g1) 
    OT_fd = 'cell1b1grid_AF';
    uni_name = 'c5g1'; 
else
    if ismember(pt,pt_list_c5g2) 
        OT_fd = 'cell1b2grid_AF';
        uni_name = 'c5g2';
    else
        if ismember(pt,pt_list_c5g3)
        OT_fd = 'cell1b3grid_AF';
        uni_name = 'c5g3'; 
        else 
        error('pt not found')
        end
    end
end

% OT data
load(['D:\000 RAW DATA FILES\170502 grid\',OT_fd,'\',pt_str,'_AF_nm,ums,pN.mat']);

% shape of the flagellum, phase
case_fdpth = ['D:\004 FLOW VELOCIMETRY DATA\',uni_name,'\',pt_str,'\'];
cd(case_fdpth)
libfilestruct = dir(fullfile(case_fdpth,'lib*'));
libfile = libfilestruct.name;
load([case_fdpth,libfile]);
% flow solution
load([case_fdpth,'BEMsolution_',uni_name,'_position',pt_str,'.mat']);

%% Pretreatment
v_ax_raw  = - v_y;
v_lat_raw = - v_x;
[v_ax, pks_ax ,locs_ax,~,~]      = freq_filter_for_flagellar_signal(v_ax_raw,Fs);
[v_lat,pks_lat,locs_lat,~,~]    = freq_filter_for_flagellar_signal(v_lat_raw,Fs);

L = length(v_ax_raw);
nfft = 2^nextpow2(2*L);

Y = fft(v_ax_raw,nfft)/L;
const = Y(1);
v_ax = v_ax + const; 

Y = fft(v_lat_raw,nfft)/L;
const = Y(1);
v_lat = v_lat + const; 

t_psd = make_time_series(v_y,Fs,'ms');
t_vid = make_time_series(Uflowb,fps_real,'ms');


%%
% interpolation
t_vid_interp  = t_vid(1):1/Fs*1000:t_vid(end);
Uflowb_interp = interp1(t_vid,Uflowb,t_vid_interp,'spline');
Vflowb_interp = interp1(t_vid,Vflowb,t_vid_interp,'spline');


ph = atan2(  Bshape(:,1,2),Bshape(:,1,1));
% peak position (begin of the power stroke)
[pks,ph_pkidx] = findpeaks(ph,'MinPeakDistance',6);
ph_pkidx = ph_pkidx-1; % empirical

% zero position (end of power stroke)
ph_zeroidx = [];
for i = 1:length(ph)- 1
    if ph(i)*ph(i+1)<=0 && ph(i)>=0
        ph_zeroidx = [ph_zeroidx,i];
    end
end
clear i
for j = 1:length(ph_zeroidx)
    if abs(ph(ph_zeroidx(j)+1)) < abs(ph(ph_zeroidx(j)))
        ph_zeroidx(j) = ph_zeroidx(j)+1;
    end
end
clear j
    

% PS: power stroke
PSBegin_interp_idx = zeros(size(ph_pkidx));
for i = 1:length(ph_pkidx)
    [~,argmin] = min(abs(t_vid_interp - t_vid(ph_pkidx(i))));
    PSBegin_interp_idx(i) = argmin; 
end
clear i 
t_interp_PSBegin = t_vid_interp(PSBegin_interp_idx);

PSEnd_interp_idx = zeros(size(ph_zeroidx));
for i = 1:length(ph_zeroidx)
    [~,argmin] = min(abs(t_vid_interp - t_vid(ph_zeroidx(i))));
    PSEnd_interp_idx(i) = argmin;
end
clear i
t_interp_PSEnd = t_vid_interp(PSEnd_interp_idx);


% average position where power stroke ends
% find the starting point of the power stroke directly before it.
PSFraction = 0;
N_PSEnd = length(ph_zeroidx);
N_cyc_counted = 0;
for i = 1:N_PSEnd
    PSBegin_before_idx = find(t_interp_PSBegin<t_interp_PSEnd(i));
    PSBegin_after_idx  = find(t_interp_PSBegin>t_interp_PSEnd(i));
    if ~isempty(PSBegin_before_idx) && ~isempty(PSBegin_after_idx)
        t_last_PSbegin = t_interp_PSBegin(max(PSBegin_before_idx));
        t_next_PSbegin = t_interp_PSBegin(min(PSBegin_after_idx));
        this_cyc_length= t_next_PSbegin - t_last_PSbegin;
        PSFraction = PSFraction + (t_interp_PSEnd(i) - t_last_PSbegin)/this_cyc_length;
        N_cyc_counted  = N_cyc_counted + 1 ;
    end
end
PSFraction = PSFraction /  N_cyc_counted;
clear i


cyc            = diff(PSBegin_interp_idx)/ Fs * 1000 ; % ms
% get rid of slips
med_cyc        = median(cyc);
deviation_cyc  = median(abs(cyc - med_cyc));
idx_goodones   = find(abs(cyc-med_cyc)<0.5+3*deviation_cyc); 
avg_period     = mean(cyc(idx_goodones));  % ms

t_avg          = 0:1/Fs*1000:avg_period;
NoPts_avgCyc   = length(t_avg);         % No. of points for an avg. cyc
avg_v_ax       = zeros(NoPts_avgCyc,1); 
avg_v_lat      = zeros(NoPts_avgCyc,1);
avg_U          = zeros(NoPts_avgCyc,1);
avg_V          = zeros(NoPts_avgCyc,1);
TotNoCyc       = length(cyc);             % Total no. of cycles.
NoCyc          = length(idx_goodones);    % If no misrecog: 
                                          %   NoCyc = TotNoCyc

for i_cyc = 1:NoCyc
    % e.g. 7 local minima         ===> 6 cycles recog
    %   If there is no misrecog, NoCyc = NoLocalMin - 1         (1)
    %   the 2nd one is a misrecog ===> 5 good cycles
    %   idx_goodones = [1,3,4,5,6] 
    %   NoCyc        = 5,  idx_cyc = 1,2,3,4,5
    %   when j = 1: cyc is t(local_min(1)) to t(local_min(2))
    %        j = 3: cyc is t(local_min(3)) to t(local_min(4))
    %        ...
    %   condition (1) ensures that j+1 = NoCyc+1 would not exceed index
    %   limit.
    j          = idx_goodones(i_cyc);
    %% for EXP data
    t_seg_start = t_vid_interp(PSBegin_interp_idx(j));
    t_seg_end   = t_vid_interp(PSBegin_interp_idx(j+1));
    t_seg       = linspace(t_seg_start,t_seg_end,NoPts_avgCyc); 
    % t_seg here will re-sample each period with the SAME NO. of points.
    % Resampled signal (vx, vy) will be added up to obtain an average.
    % This process is equivalent to rescale each period to the same
    % duration, which calculates the average period.
    v_ax_interp  = interp1(t_psd,v_ax,t_seg);
    v_lat_interp = interp1(t_psd,v_lat,t_seg);
    avg_v_ax     = avg_v_ax  + v_ax_interp';
    avg_v_lat    = avg_v_lat + v_lat_interp';

    %% for CFD data
    t_seg_start = t_vid_interp(PSBegin_interp_idx(j));
    t_seg_end   = t_vid_interp(PSBegin_interp_idx(j+1));
    t_seg       = linspace(t_seg_start,t_seg_end,NoPts_avgCyc); 
    U_interp    = interp1(t_vid_interp,Uflowb_interp,t_seg);
    V_interp    = interp1(t_vid_interp,Vflowb_interp,t_seg);
    avg_U       = avg_U + U_interp';
    avg_V       = avg_V + V_interp';
end
avg_v_ax        = avg_v_ax/NoCyc;    avg_v_lat   = avg_v_lat/NoCyc;
avg_U           = avg_U/NoCyc;       avg_V       = avg_V/NoCyc;
t_avg_start     = t_vid_interp(PSBegin_interp_idx(1));


figure(4)
set(gcf,'defaulttextInterpreter','latex')
pltexp = plot(t_avg,avg_v_ax,'b-','LineWidth',2); hold on
pltcfd = plot(t_avg,avg_U,'-','LineWidth',2,'Color',orange);
t_EoPS = t_avg(end)*PSFraction;
up_y   = max(max(avg_v_ax),max(avg_U));
low_y  = min(min(avg_v_ax),min(avg_U));
ylim(1.2*[low_y,up_y])
plot([t_EoPS,t_EoPS],1.5*[low_y,up_y],'--','LineWidth',1);
h = text(t_EoPS,up_y,'~End of PS');
xlabel('Time (ms)')
ylabel('Flow speed($\mu$m/s)')
legend([pltexp,pltcfd],{'EXP, axial','CFD, axial'})
axes('Position',[0.7,0.1,0.2,0.2])
imshow(imread('1_0002.tif'))

figure(5)
set(gcf,'defaulttextInterpreter','latex')
pltexp = plot(t_avg,avg_v_lat,'b-','LineWidth',2); hold on
pltcfd = plot(t_avg,avg_V,'-','LineWidth',2,'Color',orange);
t_EoPS = t_avg(end)*PSFraction;
up_y   = max(max(avg_v_lat),max(avg_V));
low_y  = min(min(avg_v_lat),min(avg_V));
ylim(1.2*[low_y,up_y])
plot([t_EoPS,t_EoPS],1.5*[low_y,up_y],'--','LineWidth',1);
h = text(t_EoPS,up_y,'~End of PS');
xlabel('Time (ms)')
ylabel('Flow speed($\mu$m/s)')
legend([pltexp,pltcfd],{'EXP, lateral','CFD, lateral'})
axes('Position',[0.7,0.15,0.2,0.2])
imshow(imread('1_0002.tif'))

%%
beadcoords_pth = ['D:\000 RAW DATA FILES\170823 comparing delay c5-c9\000 positions\',...
                          'Position c5g_BeforeRot_um.dat'];
[xgb,ygb] = BeadCoordsFromFile(beadcoords_pth,pt,'170502c5g');
ampl_cfd_ax  = prctile(avg_U,95) - prctile(avg_U,5);
ampl_cfd_lat = prctile(avg_V,95) - prctile(avg_V,5);
ampl_exp_ax  = prctile(avg_v_ax,95) - prctile(avg_v_ax,5);
ampl_exp_lat = prctile(avg_v_lat,95) - prctile(avg_v_lat,5);
factor_ax    = ampl_exp_ax/ ampl_cfd_ax;
factor_lat   = ampl_exp_lat/ ampl_cfd_lat;

% fileID = fopen('D:\000 RAW DATA FILES\170926\AmplFactor.txt','at+');
% fprintf(fileID,'%02d\t%.2f\t%.2f\t%.2f\t%.2f\t\n',pt,xgb,ygb,factor_ax,factor_lat);
% fclose(fileID);
% print(4,['D:\000 RAW DATA FILES\170926\',pt_str,'_ax.png'],'-dpng','-r200')
% print(5,['D:\000 RAW DATA FILES\170926\',pt_str,'_lat.png'],'-dpng','-r200')
% print(3,['D:\000 RAW DATA FILES\170925\',pt_str,'_RawData.png'],'-dpng','-r300')
% close all

%% Store everything about the flow
% OT (EXP), optical trap (experimental)
FlowInfo.PosName      = num2str(pt,'%02d');
FlowInfo.BeadPos      = [xgb,ygb];  % Pos: Position, [micron]
FlowInfo.Fs           = Fs;         % Fs : PSD sampling rate [Hz]
FlowInfo.V_OTAxRaw    = v_ax_raw;   % *Ax*: Axial (cell ref frame) flow speed [um/s]
FlowInfo.V_OTLatRaw   = v_lat_raw;  % *Lat*: Lateral flow speed [um/s]
FlowInfo.V_OTAxFin    = v_ax;       % Raw: Untreated; Fin: Final, treated with filters
FlowInfo.V_OTLatFin   = v_lat;
FlowInfo.V_AvgOTAx    = avg_v_ax;
FlowInfo.V_AvgOTLat   = avg_v_lat;
FlowInfo.V_AxConstFull    = mean(v_ax);  
FlowInfo.V_LatConstFull   = mean(v_lat); 
FlowInfo.V_OTAxConstSameRange   = mean(v_ax(find(t_psd<t_vid(end))));  
FlowInfo.V_OTLatConstSameRange  = mean(v_lat(find(t_psd<t_vid(end))));  
FlowInfo.Ampl_VOTAx   = ampl_exp_ax;
FlowInfo.Ampl_VOTLat  = ampl_exp_lat;

% CAM (CFD), fast camera (computational fluid dynamic)
FlowInfo.NoFrames     = nframes;
FlowInfo.fps          = fps;        % fps: Camera sampling rate [Hz]
FlowInfo.fps_used     = fps_real;   % fps_used: ~99% of fps[Hz]
FlowInfo.V_CFDAx      = Uflowb;
FlowInfo.V_CFDLat     = Vflowb;
FlowInfo.T_Avg        = avg_period; % Average period
FlowInfo.V_AvgCFDAx   = avg_U;
FlowInfo.V_AvgCFDLat  = avg_V;
FlowInfo.AvgPowStrFrac= PSFraction; % Power stroke fraction
FlowInfo.Ampl_VCFDAx  = ampl_cfd_ax;
FlowInfo.Ampl_VCFDLat = ampl_cfd_lat;
FlowInfo.V_CFDAxConst = mean(Uflowb);  
FlowInfo.V_CFDLatConst= mean(Vflowb);  

% Flagellum recognition
FlowInfo.Flag1PCA     = Bshape(:,1,:); %1st idx: frame, 2nd: flag 
FlowInfo.Flag2PCA     = Bshape(:,2,:); %3rd : component order
FlowInfo.Flag1Phase   = atan2(Bshape(:,1,2),Bshape(:,1,1));
FlowInfo.Flag2Phase   = atan2(Bshape(:,2,2),Bshape(:,2,1));
% Comparison
FlowInfo.Factor_VAx   = factor_ax; % exp/cfd
FlowInfo.Factor_VLat  = factor_lat; % exp/cfd



close all
pt_list_c5g1       = [11:16,21:26,31:36,44:46];
pt_list_c5g2       = [41:43,53:56,63:67,73:77,82:87];
pt_list_c5g3       = [10 17 20 30 37 47 57];


pt =63;
%% load 

pt_str = num2str(pt);
if ismember(pt,pt_list_c5g1) 
    OT_fd = 'cell1b1grid_AF';
    uni_name = 'c5g1'; 
    experiment = '170502c5g1';
    AA05_experiment_based_parameter_setting; 
else
    if ismember(pt,pt_list_c5g2) 
        OT_fd = 'cell1b2grid_AF';
        uni_name = 'c5g2';
        experiment = '170502c5g2';
        AA05_experiment_based_parameter_setting; 
    else
        if ismember(pt,pt_list_c5g3)
        OT_fd = 'cell1b3grid_AF';
        uni_name = 'c5g3'; 
        experiment = '170502c5g3';
        AA05_experiment_based_parameter_setting; 
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
% [blp,alp] = butter(5,80/Fs*2,'low');
% v_ax = filtfilt(blp,alp,v_ax_raw);
% v_lat = filtfilt(blp,alp,v_lat_raw);
[v_ax, pks_ax ,locs_ax,~,~]     = freq_filter_for_flagellar_signal(v_ax_raw,Fs);
[v_lat,pks_lat,locs_lat,~,~]    = freq_filter_for_flagellar_signal(v_lat_raw,Fs);

L = length(v_ax_raw);
nfft = 2^nextpow2(2*L);
Y = fft(v_ax_raw,nfft)/L;
const = Y(1);
v_ax = v_ax + const; 


Y = fft(v_lat_raw,nfft)/L;
const = Y(1);
v_lat = v_lat + const; 

% v_ax  = smooth(v_ax_raw,199);
% v_lat = smooth(v_lat_raw,199);

t_psd = make_time_series(v_y,Fs,'ms');
t_vid = make_time_series(Uflowb,fps_real,'ms');

ph = atan2(  Bshape(:,1,2),Bshape(:,1,1));
% peak position
[pks,ph_pkidx] = findpeaks(ph,'MinPeakDistance',6);
ph_pkidx = ph_pkidx-1;
% zero position
ph_zeroidx = [];
for i = 1:length(ph)- 1
    if ph(i)*ph(i+1)<=0 && ph(i)>=0
        ph_zeroidx = [ph_zeroidx,i];
    end
end
for j = 1:length(ph_zeroidx)
    if abs(ph(ph_zeroidx(j)+1)) < abs(ph(ph_zeroidx(j)))
        ph_zeroidx(j) = ph_zeroidx(j)+1;
    end
end
%%
% Check bead center position
figure(1)
plot(t_psd,smooth(nmx,Fs*100/1000),'LineWidth',2) %avg over 100 ms
hold on 
plot(t_psd,smooth(nmy,Fs*100/1000),'LineWidth',2)
legend('horizontal bead pos','vertical bead pos')
xlabel('Time (ms)')
ylabel('Bead position (nm)')
ylim([-40,40])

% check the flagellar configuration
figure(2);
set(gcf,'Unit','Normalized','Position',[0.1,0.1,0.8,0.8])
ImgVec1 = [0.1, 0.75, 0.2, 0.2];   
ImgVec2 = [0.3, 0.75, 0.2, 0.2];   
ImgVec3 = [0.5, 0.75, 0.2, 0.2];   
ImgVec4 = [0.7, 0.75, 0.2, 0.2];
ImgVec5 = [0.2, 0.4, 0.6, 0.3];
ImgVec6 = [0.1, 0.05, 0.2, 0.2];   
ImgVec7 = [0.3, 0.05, 0.2, 0.2];   
ImgVec8 = [0.5, 0.05, 0.2, 0.2];   
ImgVec9 = [0.7, 0.05, 0.2, 0.2];
I1 = imread([case_fdpth,'1_',num2str(ph_pkidx(1),'%04d'),'.tif']);
I2 = imread([case_fdpth,'1_',num2str(ph_pkidx(2),'%04d'),'.tif']);
I3 = imread([case_fdpth,'1_',num2str(ph_pkidx(3),'%04d'),'.tif']);
I4 = imread([case_fdpth,'1_',num2str(ph_pkidx(4),'%04d'),'.tif']);

I6 = imread([case_fdpth,'1_',num2str(ph_zeroidx(1),'%04d'),'.tif']);
I7 = imread([case_fdpth,'1_',num2str(ph_zeroidx(2),'%04d'),'.tif']);
I8 = imread([case_fdpth,'1_',num2str(ph_zeroidx(3),'%04d'),'.tif']);
I9 = imread([case_fdpth,'1_',num2str(ph_zeroidx(4),'%04d'),'.tif']);
subplot('Position',ImgVec1);        imshow(I1);
subplot('Position',ImgVec2);        imshow(I2);
subplot('Position',ImgVec3);        imshow(I3);
subplot('Position',ImgVec4);        imshow(I4);
subplot('Position',ImgVec5);        
findpeaks(ph,'MinPeakDistance',6);
for j = 1:length(ph_zeroidx)
    hold on
    plot(ph_zeroidx(j),ph(ph_zeroidx(j)),'rv')
end
xlabel('Frame no.');                
ylabel('Phase (rad)')
subplot('Position',ImgVec6);        imshow(I6);
subplot('Position',ImgVec7);        imshow(I7);
subplot('Position',ImgVec8);        imshow(I8);
subplot('Position',ImgVec9);        imshow(I9);

% check oscillatory data
figure(3)
subplot(1,2,1)
hold on
plot(t_psd,v_ax_raw,'o','MarkerSize',3,'MarkerFaceColor',[0.8,0.8,0.8],'MarkerEdgeColor',[0.8,0.8,0.8])
plot(t_psd,v_ax,'b-','LineWidth',2)
plot(t_vid,Uflowb,'-o','LineWidth',2);
xlim([0,160])
% ylim(1.1*[-max(abs(v_ax)),abs(max(v_ax))])
ylim(1.1*[-max(abs(v_lat)),abs(max(v_lat))])
legend({'EXP raw','EXP smooth','CFD'})
title('Comparison in axial direction')
xlabel('Time (ms)')
ylabel('Flow speed (\mum/s)')
subplot(1,2,2)
hold on
plot(t_psd,v_lat_raw,'o','MarkerSize',3,'MarkerFaceColor',[0.8,0.8,0.8],'MarkerEdgeColor',[0.8,0.8,0.8])
plot(t_psd,v_lat,'b-','LineWidth',2)
plot(t_vid,Vflowb,'-o','LineWidth',2);
legend({'EXP raw','EXP smooth','CFD'})
title('Comparison in axial direction')
xlabel('Time (ms)')
ylabel('Flow speed (\mum/s)')
xlim([0,160])
ylim(1.1*[-max(abs(v_lat)),abs(max(v_lat))])

% %%
% beadcoords_pth = ['D:\000 RAW DATA FILES\170823 comparing delay c5-c9\000 positions\',...
%                           'Position c5g_BeforeRot_um.dat'];
% [xgb,ygb] = BeadCoordsFromFile(beadcoords_pth,pt,'170502c5g');
% fileID = fopen('D:\000 RAW DATA FILES\170925\CellBeatFreq.txt','at+');
% if ~isempty(locs_ax)
%     BeatFreq = locs_ax(1);
% else
%     BeatFreq = 0;
% end
% fprintf(fileID,'%02d\t%.2f\t%.2f\t%.2f\n',pt,xgb,ygb,BeatFreq);
% fclose(fileID);
% print(1,['D:\000 RAW DATA FILES\170925\',pt_str,'_OTpos.png'],'-dpng','-r300')
% print(2,['D:\000 RAW DATA FILES\170925\',pt_str,'_phase.png'],'-dpng','-r300')
% print(3,['D:\000 RAW DATA FILES\170925\',pt_str,'_RawData.png'],'-dpng','-r300')
% close all
% clear all
close all
%%
% experiment = '190104c36g2';
AA05_experiment_based_parameter_setting;
twoOverLappingFrame = [13,42];
% load(fullfile(material_fdpth,['FlowSpeedOTV_',uni_name,'_c23FlagShapes.mat']),...
%     'Uflowb','Vflowb')


%%


NoPt = length(pt_list);
NoFrame = length(Uflowb(:,1));
sig_modular_list = cell(NoPt,1);
Uflowb_modular_list = cell(NoPt,1);
Vflowb_modular_list = cell(NoPt,1);


frame1 = twoOverLappingFrame(1);
frame2 = twoOverLappingFrame(2);


for i = 1:NoPt
    sig = Vflowb(:,i);
    t_raw = (0:NoFrame-1)/fps*1000;
    sig_double = [sig(frame1:frame2-1);sig(frame1:frame2-1)];
    N_double   = length(sig_double);
    t_double   = [t_raw(frame1:frame2-1),...
                  t_raw(frame1:frame2-1)+t_raw(frame2)-t_raw(frame1)];
    t_final    = (0:frame2-frame1)/fps*1000+t_raw(frame1);
    sig_final  = sig_double(1:frame2-frame1+1);
    sig_modular_list{i} = sig_final;
    Vflowb_modular_list{i} = sig_final;
end

for i = 1:NoPt
    sig = Uflowb(:,i);
    t_raw = (0:NoFrame-1)/fps*1000;
    sig_double = [sig(frame1:frame2-1);sig(frame1:frame2-1)];
    N_double   = length(sig_double);
    t_double   = [t_raw(frame1:frame2-1),...
                  t_raw(frame1:frame2-1)+t_raw(frame2)-t_raw(frame1)];
    t_final    = (0:frame2-frame1)/fps*1000+t_raw(frame1);
    sig_final  = sig_double(1:frame2-frame1+1);
    sig_modular_list{i} = sig_final;
    Uflowb_modular_list{i} = sig_final;

end

%% Figure to check
figure()
[~,idx_maxAmpl] = max(max(Uflowb)-min(Uflowb));
sig = Uflowb(:,idx_maxAmpl);
t_raw = (0:NoFrame-1)/fps*1000;
sig_double = [sig(frame1:frame2-1);sig(frame1:frame2-1)];
N_double   = length(sig_double);
t_double   = [t_raw(frame1:frame2-1),...
              t_raw(frame1:frame2-1)+t_raw(frame2)-t_raw(frame1)];
t_final    = (0:frame2-frame1)/fps*1000+t_raw(frame1);
sig_final  = sig_double(1:frame2-frame1+1);
%
plot(t_raw,sig,'s','MarkerSize',5,'LineWidth',1,'Color','k',...
    'MarkerFaceColor','none','DisplayName','Manually clicked BEM');
grid on, box on, hold on
plot(t_raw([frame1,frame2]),sig([frame1,frame2]),'o','MarkerSize',8,...
    'LineWidth',1,'Color','r','MarkerFaceColor','none',...
    'DisplayName','Frame of phase 0');
plot(t_final,sig_final,'-o','MarkerSize',6,'LineWidth',1,...
    'Color',[0.2,0.3,1,0.7],'DisplayName','Standard cycle');
xlabel('Time (ms)')
ylabel('Axial flow, U (micron/s)')
title({'Genearating a standard cycle';['For experiment: ',experiment]})
set(gca,'Units','Normalized','Position',[0.18, 0.15, 0.7, 0.8],...
    'fontsize',10.9,'defaulttextinterpreter','Latex',...
    'TickLabelInterpreter','Latex')
legend('Location','northoutside','Orientation','horizontal')

%%
save([material_fdpth,'modular_flows_list.mat'],...
    'Uflowb_modular_list','Vflowb_modular_list')
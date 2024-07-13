cd('D:\002 MATLAB codes\000 Routine\000 img analysis\')
AB00_experimentalConditions;
AB00_importExperimentPathList
experiment_path_list  = keepExperimentListByDate(...
                        experiment_path_list,{'190319','190320'});
%%
saveToFdPath  = 'D:\000 RAW DATA FILES\181217 3 flow sync range for wt\';
plotFlowList  = {'Cis flow','Axial flow','Trans flow'};
N_flow        = numel(plotFlowList);
legend_list   = cell(N_flow,1);
MarkerList    = {'v-','s-','o-','x-'};
colorList     = {YangHong,ZiWeiHua,BaoLan,'k'};
TSyncFlowList =  cell(N_flow,1);

for i_cell = 1:numel(experiment_path_list)
    
    experiment_path   = experiment_path_list{i_cell};
    if experiment_path(end) == '\' || experiment_path(end) == '/'
        [temp,~,~]= fileparts(experiment_path(1:end-1)); 
    else
        [temp,~,~]= fileparts(experiment_path); 
    end
    [~,experiment,~] = fileparts(temp); clearvars temp        
    AB00_experimentalConditions;
    
    %%
    
    figure()
    set(gcf,'DefaultAxesFontSize',10,'DefaultAxesFontWeight','normal',...
        'DefaultAxesLineWidth',1.5,'unit','normalized',...
        'position',[0.2,0.2,0.27,0.6],'PaperPositionMode','auto',...
        'DefaultTextInterpreter','Latex')
    stitle = suptitle([experiment,', expCondition: ',expCondition]);
    stitle.FontSize = 10;
    
    flowNameInExpList = {cisTransFlow{1},'03Axial',cisTransFlow{2},...
                         '04Cross'};
    
    for i_flow = 1: N_flow
        flowNameInExp   =  flowNameInExpList{i_flow};
        matFilePath     =  fullfile(experiment_path,flowNameInExp,...
                                   'Synchronization.mat');                      
        load(matFilePath,'TSync1Ratio_list','TSync2Ratio_list',...
        'TSync1Ratio_IP_list','TSync2Ratio_IP_list',...    
        'freqList');
    
        if ~exist('TSync1Ratio_IP_list','var')
            TSyncFlowRatio = max([TSync1Ratio_list,...
                             TSync2Ratio_list],[],2); 
        else
            TSyncFlowRatio = max([TSync1Ratio_IP_list,...
                             TSync2Ratio_IP_list],[],2); 
        end
        
        subplot(N_flow,1,i_flow)
        [~,idxMaxSyc] = max(smooth(TSyncFlowRatio));
        h=plot(freqList,TSyncFlowRatio,MarkerList{i_flow},...
                'MarkerSize',6,'LineWidth',1.5,'Color',colorList{i_flow},...
                'MarkerFaceColor',colorList{i_flow},'MarkerEdgeColor','none');
        hold on, box on, grid on
        legend_list{i_flow} = h;    
        set(gca,'DefaultTextInterpreter','Latex')
        ylim([-0.05,1.05])
        xlim([freqList(idxMaxSyc)-10,freqList(idxMaxSyc)+10])
%         xticks(-6:2:6)
        ylabel('$(T_{sync})/T_{total}$')
    end
    xlabel('$f_{flow}$ (Hz)')
    legend([legend_list{:}],...
           plotFlowList,...
           'Location','northeast','fontsize',8,...
           'Box','off')
    
    
    figPath = fullfile(saveToFdPath,[experiment,' Sync range']);    
    print(gcf,figPath,'-dpng','-r300');
    savefig(gcf,figPath);
    if mod(i_cell,5)==0
        close all
    end
end
    
    
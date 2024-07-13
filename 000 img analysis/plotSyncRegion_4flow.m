cd('D:\002 MATLAB codes\000 Routine\000 img analysis\')
AB00_experimentalConditions;
experiment_path_list = {...  
%     'F:\181030 c01\c01_Chopped\',...
%     'F:\181030 c02\c02_Chopped\',...
%     'F:\181030 c03\c03_Chopped\',...
%     'F:\181030 c04\c04_Chopped\',...
%     'F:\181030 c05\c05_Chopped\',...
    'F:\181030 c06\c06_Chopped\',...
%     'F:\181030 c07\c07_Chopped\',...
%     'F:\181030 c08\c08_Chopped\',...
%     'F:\181030 c09\c09_Chopped\',...
    };

saveToFdPath  = 'D:\000 RAW DATA FILES\180700 Four flow sync range\';
plotFlowList  = {'Cis flow','Axial flow','Trans flow'};
N_flow        = numel(plotFlowList);
legend_list   = cell(N_flow,1);
MarkerList    = {'v--','s--','o--','x--'};
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
        'position',[0.2,0.2,0.37,0.6],'PaperPositionMode','auto',...
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
            TSyncFlowRatio = (TSync1Ratio_list+TSync1Ratio_list)/2; 
        else
            TSyncFlowRatio = (TSync1Ratio_IP_list+TSync2Ratio_IP_list)/2; 
        end
        
        subplot(N_flow,1,i_flow)
        h=plot(freqList-centralFreq,TSyncFlowRatio,MarkerList{i_flow},...
                'MarkerSize',8,'LineWidth',1.5,'Color',colorList{i_flow});
        hold on
        legend_list{i_flow} = h;    
        set(gca,'DefaultTextInterpreter','Latex')
        ylim([-0.05,1.05])
        xlim([-7,7])
        xticks(-6:2:6)
        ylabel('$(T_{sync})/T_{total}$')
    end
    xlabel('f-$f_0$ (Hz)')
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
    
    
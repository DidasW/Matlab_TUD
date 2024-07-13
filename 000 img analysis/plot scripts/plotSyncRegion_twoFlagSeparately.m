cd('D:\002 MATLAB codes\000 Routine\000 img analysis\')
AB00_experimentalConditions;
AB00_importExperimentPathList_oda1
color_palette_p5
% experiment_path_list  = keepExperimentListByDate(...
%                         experiment_path_list,{'190319','190320'});
%%
saveToFdPath  = 'O:\001 Analysis\190715 oda1 sync range\';
plotFlowList  = {'Cis flow','Axial flow','Trans flow'};
N_flow        = numel(plotFlowList);
MarkerList    = {'v-','s-','o-'};
colorList     = {c1_red,c5_purple,c4_blue};
TSyncFlowList =  cell(N_flow,1);

for i_cell = 1:numel(experiment_path_list)
    
    experiment_path   = experiment_path_list{i_cell};
    [experiment, rootFdpth] = parseExperimentPath(experiment_path);
    AB00_experimentalConditions;
    if ~exist(fullfile(experiment_path,'01XY'),'dir'); continue; end
    %%
    
    figure()
    set(gcf,'DefaultAxesFontSize',10,'DefaultAxesFontWeight','normal',...
        'DefaultAxesLineWidth',1.5,'unit','normalized',...
        'position',[0.2,0.2,0.27,0.6],'PaperPositionMode','auto',...
        'DefaultTextInterpreter','Latex')
    stitle = suptitle(experiment);
    stitle.FontSize = 10;
    
    flowNameInExpList = {cisTransFlow{1},'03Axial',cisTransFlow{2}};
    
    for i_flow = 1: N_flow
        flowNameInExp   =  flowNameInExpList{i_flow};
        matFilePath     =  fullfile(experiment_path,flowNameInExp,...
                                   'Synchronization.mat'); 
        if exist(matFilePath,'file')
            load(matFilePath,'TSync1Ratio_list','TSync2Ratio_list','freqList');
        else
            continue
        end
        
        switch eyespot
            case 'right'
                xi_c_list = TSync1Ratio_list;  
                xi_t_list = TSync2Ratio_list;
            case 'left'
                xi_c_list = TSync2Ratio_list;  
                xi_t_list = TSync1Ratio_list;
        end
        xi_ct_list = {xi_c_list,xi_t_list};
        
        subplot(N_flow,1,i_flow)
        set(gca,'DefaultTextInterpreter','Latex',...
            'tickLabelInterpreter','latex')
        hold on, box on, grid on  
        h_list = cell(2,1);  
        for i_ct = 1:2
            if i_ct==1
                c = colorList{i_flow}*0.6; mfc = c;
            else
                c = colorList{i_flow}; mfc ='None';
            end
            h=plot(freqList,xi_ct_list{i_ct},MarkerList{i_flow},...
                'MarkerSize',6,'LineWidth',1.5,'Color',c,...
                'MarkerFaceColor',mfc,...
                'MarkerEdgeColor',c);
            h_list{i_ct} = h;
        end
        ylim([-0.05,1.05])
        xlim([14,30])
        xticks(14:2:30)
        yticks(0:0.5:1)
        ylabel('$\xi_{cis,trans}$')
        xlabel('$f_{flow}$ (Hz)')
        legend([h_list{:}],{'$\xi_{cis}$','$\xi_{trans}$'},...
           'Location','northeast','fontsize',8,'Box','off',...
           'Interpreter','latex')
    end
    
    figPath = fullfile(saveToFdPath,[experiment,' Sync range']);    
    print(gcf,figPath,'-dpng','-r300');
    savefig(gcf,figPath);
    if mod(i_cell,5)==0
        close all
    end
end
    
    
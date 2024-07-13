cd('D:\002 MATLAB codes\000 Routine\000 img analysis\')
AB00_experimentalConditions;
experiment_path_list = {...
    'F:\181212 c1\c1\',...  
    'F:\181212 c2\c2\',...
    'F:\181212 c3\c3\',...
    'Q:\000 Fast Cam Data\181212 c4\c4\',...
    'P:\000 Fast Cam Data\181203 c1\c1\',...
    'P:\000 Fast Cam Data\181203 c2\c2\',...
    };

saveToFdPath  = 'D:\000 RAW DATA FILES\180700 Four flow sync range\';
plotFlowList  = {'Cis flow','Axial flow','Trans flow'};
N_subplot     = numel(plotFlowList);
legend_list   = cell(N_subplot,1);
MarkerList    = {'v','s','o'};
colorList     = {YangHong,YingWuLv,BaoLan};

for i_cell = 1:numel(experiment_path_list)
    
    experiment_path   = experiment_path_list{i_cell};
    if experiment_path(end) == '\' || experiment_path(end) == '/'
        [temp,~,~]= fileparts(experiment_path(1:end-1)); 
    else
        [temp,~,~]= fileparts(experiment_path); 
    end
    [~,experiment,~] = fileparts(temp); clearvars temp        
    AB00_experimentalConditions;
    
%     %%
%     
%     figure()
%     set(gcf,'DefaultAxesFontSize',10,'DefaultAxesFontWeight','normal',...
%         'DefaultAxesLineWidth',1.5,'unit','normalized',...
%         'position',[0.2,0.2,0.65,0.6],'PaperPositionMode','auto',...
%         'DefaultTextInterpreter','Latex')
%     stitle = suptitle([experiment,', expCondition: ',expCondition]);
%     stitle.FontSize = 9;
%     
    %%
    cisFlow = cisTransFlow{1}; 
    cisFlowStr = cisFlow(3:end); %e.g.: XY, MinXY
    switch cisFlowStr
        case 'XY'
            flowNameInExpList = {'06XY+Z','08Axial+Z','07MinXY+Z',...
                                 '01XY','03Axial','02MinXY',...
                                 '09XY-Z','11Axial-Z','10MinXY-Z'};
        case 'MinXY'
            flowNameInExpList = {'07MinXY+Z','08Axial+Z','06XY+Z',...
                                 '02MinXY','03Axial','01XY',...
                                 '10MinXY-Z','11Axial-Z','09XY-Z'};
    end
    %%
    
    FWHM_matrix = zeros(3,3);
    
    NoFlow = numel(flowNameInExpList);
    for i_flow = 1: NoFlow
        flowNameInExp   =  flowNameInExpList{i_flow};
        matFilePath     =  fullfile(experiment_path,flowNameInExp,...
                                   'Synchronization.mat');
        load(matFilePath,'TSync1Ratio_list','TSync2Ratio_list','freqList');
        plotIdx = mod(i_flow,N_subplot) ;
        plotIdx(plotIdx==0) = N_subplot ;
        ZIndex  = ceil(i_flow/N_subplot) ;
        
        %% Calc synchronous time fraction
        TSyncFlowRatio  = max([TSync1Ratio_list,TSync2Ratio_list],[],2);
        
        %% Measure epsilon
        freq_interp       = linspace(freqList(1),freqList(end),50);
        TSyncRatio_interp = interp1(freqList,TSyncFlowRatio,...
                                    freq_interp);
                                            
        % Sync ratio > 0.5 termed as Sync Range
        idx_syncRangeBegin = find(TSyncRatio_interp>0.5,1,'first');
        idx_syncRangeEnd   = find(TSyncRatio_interp>0.5,1,'last');
        existSyncRange     = ~isempty(idx_syncRangeBegin);
        findLowerBound     = idx_syncRangeBegin>  1;
        findUpperBound     = idx_syncRangeEnd  < length(TSyncRatio_interp);

        %%
        if ~existSyncRange
            FWHM = 0;
            FWHMNote = 'certain';
        elseif findLowerBound && ~findUpperBound
            FWHM     = freq_interp(end) - ...
                freq_interp(idx_syncRangeBegin);
            FWHMNote = '>';
            disp({'Cannot determine sync range for:';...
                ['the ',flowNameInExp,...
                ' of ',experiment];...
                'Due to upper bound missing'})
        elseif findUpperBound && ~findLowerBound
            FWHM     = freq_interp(idx_syncRangeEnd) - ...
                freq_interp(1);
            FWHMNote = '>';
            disp({'Cannot determine sync range for:';...
                ['the ',flowNameInExp,...
                ' of ',experiment];...
                'Due to lower bound missing'})
        elseif findUpperBound && findLowerBound
            FWHM     = freq_interp(idx_syncRangeEnd) -...
                freq_interp(idx_syncRangeBegin);
            FWHMNote = 'certain';
        end

        FWHM_matrix(ZIndex,plotIdx) = FWHM;
        %% Plot
        
%         subplot(N_subplot,3,i_flow);
        [~,idxMaxSyc] = max(smooth(TSyncFlowRatio));
%         h_ref =plot(freqList-freqList(idxMaxSyc),...
%             smooth(TSyncFlowRatio,3),...
%             ':','LineWidth',0.5,'Color',0.6*[1 1 1]);
%         hold on
%         h=plot(freqList-freqList(idxMaxSyc),...
%                TSyncFlowRatio,'-',...
%                'LineWidth',1.5,'MarkerEdgeColor','none',...
%                'Color',[colorList{plotIdx},1.2-ZIndex*0.25]);
%         h=scatter(freqList-freqList(idxMaxSyc),...
%                TSyncFlowRatio,20,colorList{plotIdx},...
%                'filled','Marker',MarkerList{plotIdx},...
%                'MarkerEdgeColor','none',...
%                'MarkerFaceAlpha',1.2-ZIndex*0.25);        

%         set(gca,'DefaultTextInterpreter','Latex')
%         ylim([-0.05,1.1])
%         xlim([-7,7])
%         xticks(-6:2:6)
%         if mod(i_flow,3) == 1
%             ylabel('$(T_{sync})/T_{total}$')
%         end
%         if i_flow >= 7
%             xlabel('f-$f_{0}$ (Hz)')
%         end
%         
%         switch mod(i_flow,3)
%             case 0
%                 description = 'trans-flow';
%             case 1
%                 description = 'cis-flow';
%             case 2
%                 description = 'axial-flow';
%         end
%         
%         if contains(flowNameInExp,'-Z')
%             description = [description,', downward'];
%         elseif contains(flowNameInExp,'+Z')
%             description = [description,', upward'];
%         else
%             description = [description,', in plane'];
%         end
%         legend([h],...
%             {description},...
%             'Location','northoutside','fontsize',8,...
%             'Box','off')
    end
    
    FWHM_table = array2table(FWHM_matrix,...
                 'VariableNames',{'e_cis','e_axial','e_trans'},...
                 'RowNames',{'downward','inPlane','upward'});
    figure(),bar(FWHM_matrix')
%     legend([legend_list{:}],...
%            plotFlowList,...
%            'Location','northeast','fontsize',8,...
%            'Box','off')
    
    
    figPath = fullfile(saveToFdPath,[experiment,' Sync range']);    
%     print(gcf,figPath,'-dpng','-r300');
%     savefig(gcf,figPath);
%     if mod(i_cell,5)==0
%         close all
%     end
end
    
    
cd('D:\002 MATLAB codes\000 Routine\000 img analysis\')
AB00_experimentalConditions;
saveToFdPath  = 'D:\000 RAW DATA FILES\180706 four flow sync range plot\';
legenList   = cell(N_expCondition,1);
varNames    = {'Date','CellNo','ExpCondition',...
               'SlipNo_before','SlipNo_after',...
               'SyncFWHM_Cis','SyncFWHM_Trans',...
               'SyncFWHM_Axial','SyncFWHM_Cross',...
               'SyncFWHM_CisNote','SyncFWHM_TransNote',...
               'SyncFWHM_AxialNote','SyncFWHM_CrossNote',...
               'PhaseDriftByPiezo','TotalNoSlipDuringPiezo',...
               };
resultTable = table;

%%
N_flow        = numel(plotFlowList);

%%
AB00_importMamaFolderPathList;
N_cell = numel(mama_folder_path_list);

%%
figure()
set(gcf,'DefaultAxesFontSize',10,'DefaultAxesFontWeight','normal',...
    'DefaultAxesLineWidth',1.5,'unit','normalized',...
    'position',[0.1,0.05,0.7,0.8],'PaperPositionMode','auto',...
    'DefaultTextInterpreter','Latex')


for i_cell = 1:N_cell
    %% Parse experiment name
    mama_folder_path   = mama_folder_path_list{i_cell};
    if mama_folder_path(end) == '\' || mama_folder_path(end) == '/'
        [temp,~,~]= fileparts(mama_folder_path(1:end-1)); 
    else
        [temp,~,~]= fileparts(mama_folder_path); 
    end
    [~,experiment,~] = fileparts(temp); clearvars temp   
    AB00_experimentalConditions;
    
    %% Parse date and cell
    temp = strsplit(experiment);
    expDate = temp{1};     cellNo  = temp{2};  clearvars temp
    
    %%
    flowNameFilePathList = {cisTransFlow{1},'03Axial',cisTransFlow{2},...
                            '04Cross'};
    FWHMList = zeros(N_flow,1);
    FWHMUncertainList = zeros(N_flow,1);
    for i_flow = 1:N_flow
        flowNameFilePath=  flowNameFilePathList{i_flow};
        matFilePath     =  fullfile(mama_folder_path,flowNameFilePath,...
                                   'Synchronization.mat');
        if exist(matFilePath,'file')                       
            load(matFilePath,'TSync1Ratio_list','TSync2Ratio_list',...
            'freqList');
            
            TSyncFlowRatio = (TSync1Ratio_list+TSync1Ratio_list)/2; 
            freq_interp = linspace(freqList(1),freqList(end),50);
            TSyncRatio_interp = interp1(freqList,TSyncFlowRatio,...
                                        freq_interp);
            %% Sync ratio > 0.5 termed as Sync Range 
            idx_syncRangeBegin = find(TSyncRatio_interp>0.5,1,'first');
            idx_syncRangeEnd   = find(TSyncRatio_interp>0.5,1,'last');
            existSyncRange     = ~isempty(idx_syncRangeBegin);
            findLowerBound     = idx_syncRangeBegin>  1;
            findUpperBound     = idx_syncRangeEnd  < length(TSyncRatio_interp);

            %%       
            if ~existSyncRange
                FWHM = 0;
                FWHMUncertain = NaN;
            elseif findLowerBound && ~findUpperBound
                FWHM = freq_interp(end) - freq_interp(idx_syncRangeBegin);
                FWHMUncertain = 1;
                disp({'Cannot determine sync range for:';...
                      ['the ',plotFlowList{i_flow},...
                      ' of ',experiment];...
                      'Due to upper bound missing'})
            elseif findUpperBound && ~findLowerBound
                FWHM = freq_interp(idx_syncRangeEnd) - freq_interp(1);
                FWHMUncertain = 1;
                disp({'Cannot determine sync range for:';...
                      ['the ',plotFlowList{i_flow},...
                      ' of ',experiment];...
                      'Due to lower bound missing'})
            elseif findUpperBound && findLowerBound
                FWHM = freq_interp(idx_syncRangeEnd) -...
                       freq_interp(idx_syncRangeBegin);
                FWHMUncertain = NaN;
            end
            FWHMUncertainList(i_flow) = FWHMUncertain;
            FWHMList(i_flow) = FWHM;
        
        else % this flow's data is unavailable
            FWHMUncertainList(i_flow) = NaN;
            FWHMList(i_flow)          = NaN;
        end
    end

    %%
    
    resultThisExp = {expDate,cellNo,FWHMList,FWHMUncertainList,...
                     expCondition};
    resultTable = [resultTable;resultThisExp]; %#ok<AGROW>

end


resultTable.Properties.VariableNames= varNames;
earliestDate = min(str2double(resultTable.Date));
latestDate   = max(str2double(resultTable.Date));
save(sprintf('F:/DirectionalFlowSynchrony_from%dto%d_%dCells.mat',...
     earliestDate,latestDate,N_cell),'resultTable')

%     for i_expCondi = 1:N_expCondition
%         relevantObjs = findobj(gca,...
%                       'Color',expColorSetting(expConditionSet{i_expCondi}));
%         relevantObj  = relevantObjs(1);
%         legenList{i_expCondi} = relevantObj;
%         clearvars relevantObjs relevantObj
%     end
%     legend([legenList{:}],expConditionSet{1:numel(legenList)})

    
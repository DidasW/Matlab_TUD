temp = dir('F:/DirectionalFlowSynchrony*.mat');
temp = temp(1);
matfilepath = fullfile(temp.folder,temp.name);
load(matfilepath)

AB00_experimentalConditions;

cellNoInEachCondition = zeros(N_expCondition,1);
avgSyncRange_allCondi = zeros(N_expCondition,4);
stdSyncRange_allCondi = zeros(N_expCondition,4);
figure()
hold on
for i_expCondi    = 1:N_expCondition
    expCondition  = expConditionSet{i_expCondi};
    idx_thisCondi = find(strcmp(resultTable.ExpCondition, expCondition));
    cellNoInEachCondition(i_expCondi) = numel(idx_thisCondi);
    flowSyncRange = cell2mat(resultTable(idx_thisCondi,:).SyncRange')';
    % each row is a cell, each column is one flow.
    avgSyncRange  = mean(flowSyncRange);
    stdSyncRange  = std(flowSyncRange);
    
    avgSyncRange_allCondi(i_expCondi,:) = avgSyncRange;
    stdSyncRange_allCondi(i_expCondi,:) = stdSyncRange;
end
for i = 1:4
    errorbar(1:N_expCondition,avgSyncRange_allCondi(:,i),stdSyncRange_allCondi(:,i))
end
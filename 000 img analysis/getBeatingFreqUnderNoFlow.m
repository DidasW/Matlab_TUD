      
%     %% determine beating freq. under no flow
%     NoFlowFdpth = fullfile(experiment_path,'00NoFlow');
%     if exist(fullfile(NoFlowFdpth,'Folder_before.mat'),'file')
%         load(fullfile(NoFlowFdpth,'Folder_before.mat'),...
%              'flag1_f','flag2_f','H_Ph1','H_Ph2')
%     elseif exist(fullfile(NoFlowFdpth,'Folder_after.mat' ),'file')
%         load(fullfile(NoFlowFdpth,'Folder_after.mat'),...
%              'flag1_f','flag2_f','H_Ph1','H_Ph2')
%     else
%         f0_default = centralFreq;
%     end
%     %% TODO 
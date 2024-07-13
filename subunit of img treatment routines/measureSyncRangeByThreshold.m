%% Doc
% This function measure the width of a slice along the axis of the 
% Arnold tongue. 
% TSyncRatioList: an array of fraction of the time during which the cell is 
%                 synchronized by the external flow.
% freqList: a corresponding array of the frequencies of the external flow
% threshold: above which the signal is considered synchronized.

%%

function [syncWidth,f_synRange,...
          note,reason] = measureSyncRangeByThreshold(...
                            TSyncRatioList,freqList,threshold)
    %% Sync ratio > threshold termed as Sync Range
    f_interp          = linspace(freqList(1),freqList(end),200);
    TSyncRatio_interp = interp1(freqList,smooth(TSyncRatioList,3),f_interp);
    idx_syncStart = find(TSyncRatio_interp>threshold,1,'first');
    idx_syncEnd   = find(TSyncRatio_interp>threshold,1,'last');
    existSyncRange     = ~isempty(idx_syncStart);
    findLowerBound     = idx_syncStart>  1;
    findUpperBound     = idx_syncEnd  < length(TSyncRatio_interp);
    
    %%
    f_synStart = f_interp(idx_syncStart);
    f_synEnd   = f_interp(idx_syncEnd);
    %%
    if ~existSyncRange
        f_synRange = [nan,nan];
        syncWidth = 0;
        note = 'certain';
        reason = '';
    elseif findLowerBound && ~findUpperBound
        f_synRange = [f_synStart,f_interp(end)];
        syncWidth   = f_interp(end) - f_synStart;
        note = '>';
        reason = 'missing upper bound';
    elseif findUpperBound && ~findLowerBound
        f_synRange = [f_interp(1),f_synEnd];
        syncWidth   = f_synEnd - f_interp(1);
        note = '>';
        reason = 'missing lower bound';
    elseif findUpperBound && findLowerBound
        f_synRange = [f_synStart,f_synEnd];
        syncWidth   = f_synEnd - f_synStart;
        note = 'certain';
        reason = '';
    end
end
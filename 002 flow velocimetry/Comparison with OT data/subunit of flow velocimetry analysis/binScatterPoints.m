%% Doc
% This function bins scattered points, outputs a cell whose element
% each contains a bin.
% x is the binning determinant. Y follows x.

function [binnedX,binnedY,binCenter] = binScatterPoints(x,y,binEdges,...
                                                        varargin)
    if numel(x) ~= numel(y)
        error('input x and y must be of the same size');
    end
    
    discardBinOutlier = 0;
    if ~isempty(varargin)
        temp = strcmp(varargin,'DiscardBinOutlier'); 
        if any(temp);  discardBinOutlier = 1;  end
    end
    
    binCenter = (binEdges(1:end-1)+binEdges(2:end))/2;
    %%
    N_Bin = numel(binEdges)-1;
    binnedX  = cell(N_Bin,1);
    binnedY  = cell(N_Bin,1);
    
    %%
    for i_bin = 1:N_Bin
        idx_thisBin    = find(x>=binEdges(i_bin) & x< binEdges(i_bin+1));
        x_thisBin = x(idx_thisBin);
        y_thisBin = y(idx_thisBin);
        if discardBinOutlier
            x_thisBin = x_thisBin(~isoutlier(y_thisBin));
            y_thisBin = y_thisBin(~isoutlier(y_thisBin));
        end
        binnedX{i_bin} = x_thisBin;
        binnedY{i_bin} = y_thisBin;
    end
end
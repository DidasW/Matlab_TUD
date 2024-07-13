%% Doc
% This computes the median and interquartile range for binned data output
% by "binScatterPoints.m"

function [med,prc_lb,prc_ub,...
          avgX,stdX,avgY,stdY,...
          binCenter_nonNaN  ] =  computeMedAndPrc2575ByBinnedPoints(...
                                 binnedX,binnedY,binCenter,varargin)
    % default: output interquartile range
    lb = 25;
    ub = 75;
   
    if nargin>3
        temp = strcmp(varargin,'PercentileLowerBound'); 
        if any(temp);  lb = varargin{find(temp)+1};  end
        temp = strcmp(varargin,'PercentileUpperBound'); 
        if any(temp);  ub = varargin{find(temp)+1};  end
    end
    
    if numel(binnedX) ~= numel(binnedY)
        error('input x and y must be of the same size');
    end
    %%
    N_Bin = numel(binnedX);
    med   = zeros(N_Bin,1); 
    prc_lb = zeros(N_Bin,1); prc_ub = zeros(N_Bin,1);
    avgX  = zeros(N_Bin,1); stdX  = zeros(N_Bin,1);
    avgY  = zeros(N_Bin,1); stdY  = zeros(N_Bin,1);
    
    %%
    for i_bin = 1:N_Bin
        med(i_bin)   = median(binnedY{i_bin},'omitnan');
        prc_lb(i_bin) = prctile(binnedY{i_bin},lb); 
        prc_ub(i_bin) = prctile(binnedY{i_bin},ub); 
        avgX(i_bin)  = mean(binnedX{i_bin},'omitnan');
        stdX(i_bin)  = std(binnedX{i_bin},'omitnan');
        avgY(i_bin)  = mean(binnedY{i_bin},'omitnan');
        stdY(i_bin)  = std(binnedY{i_bin},'omitnan');
    end
    
    idx_NonNaN = find(~isnan(med));
    [med,prc_lb,prc_ub,...
     avgX,stdX,avgY,stdY,...
     binCenter_nonNaN]            = takeTheseIndices(idx_NonNaN,...
                                             med,prc_lb,prc_ub,...
                                             avgX,stdX,avgY,stdY,...
                                             binCenter);
    
end
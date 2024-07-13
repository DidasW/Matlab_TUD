%% Doc
% This function plot a semi-transparent histogram on the current axis, 
% and draw also a solid line to delineate its boundary

function [pCount,bin_centers,...
           h_hist,h_boundary] = plot_histogram_with_boundary(...
                                    x,bin_edges,color,varargin)
    %% Check input
    ShowText = 0;
    AutoXYLimit = 0;
    ShowBoundary = 1;
    NoArgInExtra  =  nargin  - 3;
    alpha         = 0.25;
%     discard_empty_bins = false;  % todo
    if NoArgInExtra > 0
        temp = strcmp(varargin,'ShowText'); 
        if any(temp); ShowText    = varargin{find(temp)+1}; end
        temp = strcmp(varargin,'AutoXYLimit'); 
        if any(temp); AutoXYLimit = varargin{find(temp)+1}; end
        temp = strcmp(varargin,'ShowBoundary'); 
        if any(temp); ShowBoundary= varargin{find(temp)+1}; end
        temp = strcmp(varargin,'Alpha'); 
        if any(temp); alpha= varargin{find(temp)+1}; end
%         temp = strcmp(varargin,'DiscardEmptyBins'); 
%         if any(temp); discard_empty_bins= varargin{find(temp)+1}; end
    end
    
    if isempty(bin_edges)
       bin_edges = linspace(min(x),max(x),round(numel(x)/2)+1);
    end
    
    if isempty(color)
        color = 'r';
    end
    
    %% histogram 
    gca;
    
    h_hist     = histogram (x,bin_edges,'FaceAlpha',alpha,'EdgeAlpha',0.0,...
                    'Normalization', 'PDF', 'FaceColor', color);

    %% boundary, smoothed counts vs. binCenters
    [pCount,~] = histcounts(x,bin_edges,'Normalization','PDF');
%     pCount     = smooth(pCount,'sgolay',5);
    pCount     = smooth(pCount,5);
    bin_centers = (bin_edges(1:end-1) + bin_edges(2:end))/2;
    if ShowBoundary
        h_boundary = plot(bin_centers,pCount,'-','LineWidth',1,'color',color);
    end
    %% set X, Y limit
    if AutoXYLimit
        xrange = [bin_edges(1),bin_edges(end)];
        yrange = [0,max(pCount) + 0.2 ];
        xlim(xrange)
        ylim(yrange)
    end
    
    %% show mean +- std
    if ShowText
        textStr = sprintf('mean$\\pm$std: %.2f$\\pm$%.2f',mean(x),std(x));
        [maxPCount,idxMaxPCount] = max(pCount);
        textLocationX = bin_centers(idxMaxPCount);
        textLocationY = maxPCount;
        text(textLocationX,textLocationY,textStr,...
            'Interpreter','Latex',...
            'HorizontalAlignment','Center',...
            'VerticalAlignment','bottom',...
            'FontSize',10)
    end
end




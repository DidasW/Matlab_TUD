%% Doc
% This function is a generalized version of the plot_median_and_interquartile();
% Only variable names are changed, referring to any line with a shade.

function [h_line,h_range] = plot_line_and_range(x,cent,lb,ub,color,...
                                       varargin)
    alpha = 0.2;
    if isempty(x)
        x = linspace(0,2*pi,numel(cent));
    end
    
    if ~isempty(varargin)
        temp = strcmp(varargin,'Alpha'); 
        if any(temp) 
           alpha = varargin{find(temp)+1}; 
        end
    end
    %% standardize to 
    N = numel(x);
    x = reshape(x,1,N);
    cent = reshape(cent,1,N);
    lb = reshape(lb,1,N);
    ub = reshape(ub,1,N);
    %%
    gca;
    if isempty(color)
        color = 'r';
    end
    
    xDouble = [x,fliplr(x)];
    inBetweenRange = [lb,fliplr(ub)];
    
    h_range = fill(xDouble,inBetweenRange,color,...
                  'EdgeColor','None','FaceColor',color,...
                  'FaceAlpha',alpha);
    h_line = plot(x,cent,'-','Color',color,'LineWidth',2);
end
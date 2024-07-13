%% Doc
% This function plot the median-interquartile information by  
% a line + shaded area.

function [h_med,h_interquartile] = plot_median_and_interquartile(...
                                       x,med,prc25,prc75,color,...
                                       varargin)
    alpha = 0.2;
    if isempty(x)
        x = linspace(0,2*pi,numel(med));
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
    med = reshape(med,1,N);
    prc25 = reshape(prc25,1,N);
    prc75 = reshape(prc75,1,N);
    %%
    gca;
    if isempty(color)
        color = 'r';
    end
    
    xDouble = [x,fliplr(x)];
    inBetween25And75 = [prc25,fliplr(prc75)];
    
    h_interquartile = fill(xDouble,inBetween25And75,color,...
                  'EdgeColor','None','FaceColor',color,...
                  'FaceAlpha',alpha);
    h_med = plot(x,med,'-','Color',color,'LineWidth',1.5);
end
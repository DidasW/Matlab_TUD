%% Doc
% This function grabs all the scatter points, including those ploted in
% lines, combine them together and output.

function [allXData,allYData] = grabAllPointsFromFigure(varargin)
    switch nargin
        case 0
            ax = gca;
        case 1
            ax = varargin{1};
            if isempty(ax)
                ax = gca;
            end
        otherwise
            error('too many inputs')
    end
    h = findobj(ax,'type','line','-or','type','scatter',...
                '-or','type','ErrorBar');
    N_obj = numel(h);
    allXData = [];
    allYData = [];
    for i_obj = 1:N_obj
        allXData = horzcat(allXData,h(i_obj).XData);
        allYData = horzcat(allYData,h(i_obj).YData);
    end
end

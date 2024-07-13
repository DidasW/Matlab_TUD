%{
This functions gives a unique marker appearance 
%}

function [plotPropNames,...
          plotPropVals] = assignMarker(color, empty_marker, randInteger)
      
    %% initialize  
    plotPropNames = {'LineStyle','Color',...
                     'MarkerFaceColor',...
                     'Marker','LineWidth','MarkerSize'};
    % this is the sequence determination in this function
    plotPropVals  = cell(size(plotPropNames));
    
    %% determine properties 1-2
    plotPropVals{1} = 'None'; % only scatter point
    plotPropVals{2} = color;  % color of the scatter point
    
    %% determine propertie 3
    if empty_marker  % empty markers
        plotPropVals{3} = 'None';
        markerPool  = {'o','s','d','h','p','v',...'<','^','>',...
                       '*','+','x','.'}; 
        describePool  = {{'small','thin'},...
                         {'small','thick'},...
                         {'medium','thin'},...
                         {'big'  ,'thin'}};
    else                % filled markers
        plotPropVals{3} = color;
        markerPool  = {'o','s','d','h','p','v',};...'<','^','>'}; 
        describePool  = {'small','medium','big','extraBig'};     
    end
    
    %% determine properties 4, and prepare for 5-6
    N_mk          = numel(markerPool);
    N_describe    = numel(describePool);

    idx_marker   =  mod(randInteger,N_mk)+1;
    idx_describe =  mod(randInteger,N_describe)+1;       

    marker       = markerPool{idx_marker};
    description  = describePool{idx_describe};
    
    plotPropVals{4} = marker;
    
    %% determine properties 5, prepare for 6
    % for different marker, small/medium/big means 
    switch class(description)
        case 'cell'
            markerSize= description{1};
            thickness = description{2};
        case 'char'
            markerSize= description;
            thickness = 0.2; % filled point
    end
    
    switch thickness
        case 'thin'
            plotPropVals{5}=0.5;
        case 'thick'
            plotPropVals{5}=1.1;
        otherwise
            plotPropVals{5}=thickness;
    end
    
    %% determine propertie 4
    switch marker 
        case {'s','v','<','^','>'}
            switch markerSize
                case 'small'
                    plotPropVals{6} = 3;
                case 'medium'
                    plotPropVals{6} = 5;
                case 'big'
                    plotPropVals{6} = 6;
                case 'extraBig'    
                    plotPropVals{6} = 7;
            end
        case {'h','p','o','d'}
            switch markerSize
                case 'small'
                    plotPropVals{6} = 2;
                case 'medium'
                    plotPropVals{6} = 4;
                case 'big'
                    plotPropVals{6} = 5;
                case 'extraBig'    
                    plotPropVals{6} = 6;
            end
        case {'*','+','x'}
            switch markerSize
                case 'small'
                    plotPropVals{6} = 4;
                case 'medium'
                    plotPropVals{6} = 6;
                case 'big'
                    plotPropVals{6} = 8;
            end
        case '.'
            switch markerSize
                case 'small'
                    plotPropVals{6} = 4;
                case 'medium'
                    plotPropVals{6} = 7;
                case 'big'
                    plotPropVals{6} = 9;
            end
    end
end
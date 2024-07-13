% Doc
% This functions 2D coordinates of 4 points, which surround a triangular 
% area if being connected consecutively. Design for use in a log-log scale
% diagram
% Defining parameters are:
% rectanglePointCoords: [x0,y0]
% orientation: whether the rectangle points to southwest or northeast
% horizontalLength : length of the shorter edge
% slope  : absolute value of the slope in the log-log diagram

function [xCoords_4pts,yCoords_4pts] ...
           = generateTriangleCoords(horizontalLength,slope,...
                                    rectanglePointCoords,orientation)
    xCoords_4pts = zeros([4,1]);
    yCoords_4pts = zeros([4,1]);
    x0           = rectanglePointCoords(1);
    y0           = rectanglePointCoords(2);
    xCoords_4pts(1) = x0;
    xCoords_4pts(4) = x0;
    yCoords_4pts(1) = y0;
    yCoords_4pts(4) = y0;
    
    switch orientation
        case 'northeast'
            xCoords_4pts(2) = x0/horizontalLength;  
            yCoords_4pts(2) = y0;
            
            xCoords_4pts(3) = x0;  
            yCoords_4pts(3) = y0/(horizontalLength^slope);
        case 'southwest'
            xCoords_4pts(2) = x0 * horizontalLength;  
            yCoords_4pts(2) = y0;
            
            xCoords_4pts(3) = x0;  
            yCoords_4pts(3) = y0 * (horizontalLength^slope);
        otherwise
            error('undefined orientation')
    end
    
end
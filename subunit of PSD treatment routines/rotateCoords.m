%{
rotate an array of 2D coordinates CCW for an angle. x, y is assumed to be 
column vectors. Only when the it is obvious that x, y is each a row
vector (size(xy,2)>2), the function will generate newxy also as row vectors
%}
function newxy=rotateCoords(xy, angle, varargin)
unit = 'degree';
if ~isempty(varargin)
    temp = strcmp(varargin, 'Unit');
    if any(temp); unit = varargin{find(temp)+1}; end
end

if size(xy,2) > 2
    x=xy(1,:);
    y=xy(2,:);
else
    x=xy(:,1);
    y=xy(:,2);
end

switch unit
    case {'degree', 'Degree', 'degrees', 'Degrees'}
        newx=x*cos(deg2rad(angle))+y*sin(deg2rad(angle));
        newy=-x*sin(deg2rad(angle))+y*cos(deg2rad(angle));
    case {'Rad', 'rad'}
        newx=x*cos(angle)+y*sin(angle);
        newy=-x*sin(angle)+y*cos(angle);
end


if size(xy,2) > 2
    newxy(1,:)=newx;
    newxy(2,:)=newy;
else
    newxy(:,1)=newx;
    newxy(:,2)=newy;
end

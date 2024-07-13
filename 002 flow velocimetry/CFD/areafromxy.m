function [xhull,yhull,area] = areafromxy(x,y)
%AREAFROMXY Calculates the area of the polygon enclosing x and y
%%INPUTS
%x          Vector with x values of the polygon
%y          Vector with y values of the polygon
%%OUTPUTS
%xhull      Vector with x values of the enclosing polygon
%yhull      Vector with y values of the enclosing polygon
%area      	Area of enclosing polygon

%Make delaunay triangulation (unstructured triangular mesh)
xcol    = x(:);         ycol    = y(:);
xyun    = unique([xcol ycol],'rows'); 
xcol    = xyun(:,1);    ycol = xyun(:,2);   %Remove duplicate points
tri     = delaunay(xcol,ycol);

% figure,triplot(tri,xcol,ycol,'b'),hold on;

%Remove edges longer than 4*ds
ds      = sqrt((x(1,2)-x(1,1))^2+(y(1,2)-y(1,1))^2); %Distance between two adjacent nodes
indvec  = [2 3 1]; %Vector [1 2 3] with all indices shifted by 1
inddel  = [];   %Indices of triangles to remove
for kk=1:size(tri,1)
    for ll=1:3
        %Check length of each side of the triangle
        ind1    = ll;  ind2=indvec(ll);
        x1      = xcol(tri(kk,ind1));   
        x2      = xcol(tri(kk,ind2));
        y1      = ycol(tri(kk,ind1));   
        y2      = ycol(tri(kk,ind2));
        edgel   = sqrt((x2-x1)^2+(y2-y1)^2);
        if edgel > 4*ds
            inddel = [inddel; kk;];
            break
        end
    end
end
tri(inddel,:) = [];

% triplot(tri,xcol,ycol,'r');

%Eliminate edges that appear twice to get the border
edges = ([[tri(:,1) tri(:,2)];[tri(:,2) tri(:,3)];[tri(:,3) tri(:,1)];]);
[~,ia,~]    = intersect(edges,fliplr(edges),'rows');
edges(ia,:) = [];

%Make polygon from border points
npoints     = length(unique(edges(:)))+1;
ind         = zeros(npoints,1);
ind(1)      = edges(1,1);
ind(2)      = edges(1,2);
edges(1,:)  = [];
for ii=3:npoints-1
    nedges = size(edges,1);
    [ind1,ind2] = ind2sub([nedges;2;],find(edges == ind(ii-1),1,'first'));
    try
        if ind2 == 1
            ind(ii) = edges(ind1,2);
        else
            ind(ii) = edges(ind1,1);
        end
    catch ME
        switch ME.identifier
            case 'MATLAB:subsassignnumelmismatch'
                if ind(ii-1) == ind(1)
                   ind(ii:end) = []; 
                   break
                end
            otherwise
                rethrow(ME)
        end
    end
    edges(ind1,:) = [];
end
ind(end) = ind(1);

xouter      = xcol(ind);
youter      = ycol(ind);

% figure,fill(xouter,youter,'g')
xhull   = xouter;
yhull   = youter;
area    = polyarea(xouter,youter);
end


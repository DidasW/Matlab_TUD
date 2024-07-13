function newxy=rotate_mirror_Coords(oldxy,angle)

% due to the mirror operation, the angle is now define as the clockwise
% rotation to make two +y direction aligned, before mirror operation.
% 20170103: angle = 35
if length(oldxy(:,1))==2
    x=oldxy(1,:);
    y=oldxy(2,:);
else
    x=oldxy(:,1);
    y=oldxy(:,2);
end

newx=-x*cos(deg2rad(angle))-y*sin(deg2rad(angle));
newy=-x*sin(deg2rad(angle))+y*cos(deg2rad(angle));

if length(oldxy(:,1))==2
    newxy(1,:)=newx;
    newxy(2,:)=newy;
else
    newxy(:,1)=newx;
    newxy(:,2)=newy;
end

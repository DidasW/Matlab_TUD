%% from making limit cycle
% 170502 c5l

%Left and right flagellum are identified as seen from the organism!
list = 1:250;
fileformatstr = '%04d'; %Format of image numbers
colorf(1) = 1;          %Flagellum color left   0=dark, 1=bright
colorf(2) = 1;          %Flagellum color right  0=dark, 1=bright
colorb = 1;             %Cell body halo color   0=dark, 1=bright
scale = 9.35;           %Scale                  [px/micron]
lf0 = 12.62;               %Flagellum length       [micron]
orientation = 1.5*pi;        %Cell body angle: 0 angle is cell facing right, 
                        %anti-clockwise rotation direction
f0 = 53;                %Beat frequency         [Hz] (just an estimate)
fps= 493.18;                        


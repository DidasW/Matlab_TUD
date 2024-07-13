% Can you believe that I've just wasted 40 mins of my life on this stupid
% joke? However I had fud, screw it:)
% Da, 2016-09-30

function surprise_img = surprise_me_after_cropping(img,rect1)
if nargin == 0
    img = getImage(gcf);  %get current image
    rect1 = [size(img),0,0];
end
if rand(1)<0.05
    positions = [rect1(1:2)+[0 16];rect1(1:2)+[0 32]];
    texts     = {'NATIONAL';'GEOGRAPHIC'};
    surprise_img = insertText(img,positions,texts,...
                              'FontSize',14,...
                              'BoxOpacity',0,'TextColor','white',...
                              'AnchorPoint','CenterBottom');
else
    surprise_img = img;
end

end

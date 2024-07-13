%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%FLAGELLA DETECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This algorithm generates a best-fitting waveform using shapes
%based on Principal Component Analysis. The best fit is determined by a
%cost function with terms for the fit to the points from the scanning
%algorithm, total curvature and fit to a foreground image (flagellum black,
%rest white). Limit cycle shapes are used as initial guess for the
%optimization.

% nframes = endimg+1-beginimg;                        %Number of frames processed
% [xflag,yflag] = deal(zeros(nframes,2,nsteps+1));    %x/y coordinates of flagellum
% kappasave = zeros(nframes,2,nsteps+2);

qstr = 'Accept the current shape?';
astr1 = 'Yes, save it';
astr2 = 'No, I click myself';
astr3 = 'No, let me click again';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%START DETECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

fig = figure(4);
set(gcf,'Unit','normalized','Position',[0.1,0.1,0.8,0.8],...
    'NextPlot','replacechildren');

for image=firstimg:endimg; % use frames form the first two cycles to train
    disp(strcat('Processing image',{' '},num2str(image-firstimg),{' '},...
        'out of',{' '},num2str(endimg-firstimg)));  %Indicate progess in console
    %Open image
    n = num2str(list(image),fileformatstr); %Generate image string
    file = (['1_',n,'.tif']);           %First image
    Im = mat2gray(imread(file));            %Grayscale version of image
    Im = imadjust(Im,contradj);
    [Im,~] = wiener2(Im);                   %Apply Wiener filter for Gaussian noise removal
    F = griddedInterpolant(xnd,ynd,Im,'linear');  %Interpolation grid

    %Update standard gaussian background model
    calc_bg
    
    for lr=1:2 %left/right flagellum
        minimization_PCA
        %Plot shape, accept?
        %figure(4),clf
        clf
        imshow(Im,'InitialMagnification',screenmagnif), hold on
        plot(xbase,ybase,'b+') %Flagellar base
        if lr == 1
            plot(xtemp(2:end),ytemp(2:end),'r*','MarkerSize',3) %Left flagellum
        else
            plot(xtemp(2:end),ytemp(2:end),'g*','MarkerSize',3) %Right flagellum
        end
        title(strcat('Image ',num2str(image))), hold off; pause(eps)
        button = questdlg(qstr,qstr,astr1,astr2,astr1);
        switch button
            case astr1 %Save shape
                clickshape = 0;
                post_processing_initial
            case astr2 %Let user click himself
                stage = 0;
                userclickspoints_initial
        end
    end
    clc
end
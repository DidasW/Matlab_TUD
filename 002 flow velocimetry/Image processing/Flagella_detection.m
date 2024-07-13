%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%FLAGELLA DETECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Starting from the base, scan in a fan-like fashion. The darkest/lightest
%point encountered corresponds to the flagellum. If this algorithm fails 
%due to insufficient intensity difference, an different algorithm is
%started. This algorithm generates a best-fitting waveform using shapes
%based on Principal Component Analysis. The best fit is determined by a
%cost function with terms for the fit to the points from the scanning
%algorithm, total curvature and fit to a foreground image (flagellum black,
%rest white). Limit cycle shapes are used as initial guess for the
%optimization.

close all

%% %%%%%%%%%%%%%%%%%%%%%%%%%%START DETECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for image=beginimg:endimg;
    disp(strcat('Processing image',{' '},num2str(image-beginimg),{' '},...
        'out of',{' '},num2str(endimg-beginimg)));  %Indicate progess in console
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
        scanning_algorithm
        minimization_algorithm
        post_processing
    end
    
    %=======PLOT RESULT=======================================================%
    if plotshapes ~= 0 %Plot results
        figure(4),clf
        imshow(Im,'InitialMagnification',screenmagnif), hold on
        plot(xflag(image-beginimg+1,1,1),yflag(image-beginimg+1,1,1),'b+') %Flagellar base
        plot(squeeze(xflag(image-beginimg+1,1,2:end)),squeeze(yflag(image-beginimg+1,1,2:end)),'r*') %Left flagellum
        plot(squeeze(xflag(image-beginimg+1,2,2:end)),squeeze(yflag(image-beginimg+1,2,2:end)),'g*') %Right flagellum
        title(strcat('Image ',num2str(image))), hold off; pause%(eps)
    end
    if debugfmc == 0
        clc
    end
end

kappa_lib = kappasave;
filename = 'lib_final';
save(filename,'kappa_lib')
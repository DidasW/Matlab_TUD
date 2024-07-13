% cd('/Users/Jan/Documents/MEGA/WB/M2/Thesis/Matlab/Flagella tracking/movies')
cd('D:\004 FLOW VELOCIMETRY DATA\');
% path = ('./');                              %Path name
pause(eps) %Make sure all previous figures are generated
close all %Close all open figures to make sure nothing gets messed up
if makemovie ~= 0
    cd(strcat(supfld,num2str(pt,'%02d')));
    filename = strcat('Flagella_',num2str(pt,'%02d'),'_',datestr(datetime('now'),'yyyy-mm-dd_HHMM'));
    mkdir(filename);
    
    
%     cd(filename);  %Change current folder
%     frames(nframes) = struct('cdata',[],'colormap',[]); %Frames for movie
%     vid = VideoWriter([filename,'\',filename],'MPEG-4');
%     vid = VideoWriter(filename,'Uncompressed AVI');
%     vid.FrameRate = 5;
    
    
    f = figure('visible','off');
    a = axes('Parent',f);
    axis(a,[0 size(Im,2) 0 size(Im,1)]);
    set(a,'nextplot','replacechildren');
    for image=beginimg:endimg
        clc
        disp(strcat('Processing image',{' '},num2str(image-beginimg+1),{' '},...
        'out of',{' '},num2str(nframes)));  %Indicate progess in console
    
        n = num2str(list(image),fileformatstr);       %Generate image string
        file = (['1_',n,'.tif']);           %First image
        Im = mat2gray(imread(file));            %Grayscale version of image
    
        imshow(Im,'InitialMagnification',100), hold on
        ximg1 = squeeze(xflag(image+1-beginimg,1,:));
        yimg1 = squeeze(yflag(image+1-beginimg,1,:));
        ximg2 = squeeze(xflag(image+1-beginimg,2,:));
        yimg2 = squeeze(yflag(image+1-beginimg,2,:));
        
        plot(a,ximg1,yimg1,'r')
        plot(a,ximg2,yimg2,'g')
        if makemovie == 2
            quiver(a,squeeze(xflag(image+1-beginimg,1,:)),squeeze(yflag(image+1-beginimg,1,:)),...
                squeeze(velx(image+1-beginimg,1,:))./1000,...
                squeeze(vely(image+1-beginimg,1,:))./1000,'m')
            quiver(a,squeeze(xflag(image+1-beginimg,2,:)),squeeze(yflag(image+1-beginimg,2,:)),...
                squeeze(velx(image+1-beginimg,2,:))./1000,...
                squeeze(vely(image+1-beginimg,2,:))./1000,'m')
        end
        drawnow
        
        file = (['1_',n,'_done']);           %First image
%         export_fig( gcf, ...      % figure handle
%         file,... % name of output file without extension
%         '-painters', ...      % renderer
%         '-jpg', ...           % file format
%         '-r72' );             % resolution in dpi
        print([filename,'\',file],'-dtiff')
        
        if mod(image,50)==0
           close(f)
           f = figure('visible','off');
            a = axes('Parent',f);
            axis(a,[0 size(Im,2) 0 size(Im,1)]);
            set(a,'nextplot','replacechildren');
        end

%     frames(image-beginimg+1)=getframe;
    end
%     clc
%     open(vid)
%     writeVideo(vid,frames);
%     close(vid)
end
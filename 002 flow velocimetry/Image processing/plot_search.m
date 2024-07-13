if debugstep
%Plot fan search and intensity profile
figure
subplot(2,1,1)
    imshow(Im,'InitialMagnification',400)
    hold on
    plot(xline,yline,'g*')
    plot(xtemp(1:index+1),ytemp(1:index+1),'r-*')
    title(strcat('index=',num2str(index)))
subplot(2,1,2)
    hold on
    plot(theta,insty)
    grid on
    meanint = mean(insty);
    diffint = abs(insty-meanint);
    ind = find(diffint == max(diffint));
    try
        plot(theta(ind),insty(ind),'g*')
        axis([min(theta) max(theta) min(insty) max(insty)]);
        str = strcat('delta intensity:',num2str(maxtens-mintens),id);
        title(str)
    catch 
        %axis outside image so not min/max insty
    end
    pause(eps)
end
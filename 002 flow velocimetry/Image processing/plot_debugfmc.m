subplot(2,1,1)
    imshow(fg,'InitialMagnification',400), hold on
    plot(Ytot(:,2),Ytot(:,3),'r') 
    title(titstr);
subplot(2,1,2)
    imshow(Im,'InitialMagnification',400), hold on 
    plot(Ytot(:,2),Ytot(:,3),'r') 
pause(eps); 
%----------------------------------------------------------------------
% LIMIT CYCLES
%----------------------------------------------------------------------
%Calculate approximated limit cycles from data
for lr=1:2
    B{dd,lr} = squeeze(Bgen(:,lr,:)); %Shape scores
    for ii=1:nmodeslimit
        GIPB{dd,lr,ii} = griddedInterpolant(dataind{dd},B{dd,lr}(:,ii),'linear');
    end
    %Convert B and phi to equally spaced vectors
    [phisort,ind] = sort(mod(phicell{dd,lr},2*pi)); %Inverse phase to make positive (griddedInterpolant only works with increasing vectors)
    Bsort = B{dd,lr}(ind,:);
    %Remove duplicates
    ind = find(diff(phisort) ==  0,1,'first');
    while ~isempty(ind)
        phisort(ind) = [];
        Bsort(ind+1,:) = (Bsort(ind,:)+Bsort(ind+1,:))./2;
        Bsort(ind,:) = [];
        ind = find(diff(phisort) ==  0,1,'first');
    end
    %Create equidistant grid for DFT
    Beq = zeros(length(phi0),nmodeslimit);
    for ii=1:nmodeslimit
        GIP = griddedInterpolant(phisort,...
            smooth(phisort,Bsort(:,ii),7,'sgolay',3),'linear');
        Beq(:,ii) = GIP(phi0);                 %Shape scores on equally spaced grid
    end
%         figure,hold on,plot(phi0,Beq(:,1)),plot(mod(-phicell{dd,lr},2*pi),B{dd,lr}(:,1),'r.')
    N = length(phi0);              %Number of samples
    T = 2*pi/N;                     %Sample time    [Hz]
    k = 0:N-1;                      %Sample index
    Fs = 1/T;                       %Sampling frequency
    f = k.*Fs./N;                   %Recovered frequencies
    for ii=1:nmodeslimit
        YY(:,ii) = fft(Beq(:,ii));
        %Convert two-sided transform to one-sided transform
        P2(:,ii) = YY(:,ii)/N;
        P1(:,ii) = P2(1:N/2+1,ii);
        P1(2:end-1,ii) = 2*P1(2:end-1,ii);
    end
    Btemp = zeros(nlimit,nmodeslimit);
    %Inverse Fourier transform
    for ii=1:nmodeslimit
%         figure,hold on,plot(mod(phicell{dd,lr},2*pi),B{dd,lr}(:,ii),'k.')
        for k=1:nharmlimit
            Btemp(:,ii) = Btemp(:,ii) + real(P1(k,ii)).*cos(2*pi*f(k).*phi0') + ...
                imag(P1(k,ii)).*sin(2*pi*f(k).*phi0'); 
                plot(phi0,Btemp(:,ii),'r-')
        end
    end
    Blimit{dd,lr}=flipud(Btemp);
    for ii=1:nmodeslimit
        BlimitGIP{dd,lr,ii} = griddedInterpolant(phi0,Blimit{dd,lr}(:,ii),'linear');
    end
end
%Average limit cycle for both flagella
for ii=1:nmodeslimit
    BlimitGIPavg{dd,ii} = griddedInterpolant(phi0,0.5.*BlimitGIP{dd,1,ii}(phi0)+...
        0.5.*BlimitGIP{dd,2,ii}(phi0),'linear');
end
    
    %Figure: phase
    figure,subplot(2,1,1),hold on,plot(mod(phicell{dd,1},2*pi),'k')
    subplot(2,1,2),hold on,plot(mod(phicell{dd,2},2*pi),'k')

%     %Figure: phase speed    
%     figure,subplot(2,1,1),hold on,plot(omegacell{dd,1},'k')
%     subplot(2,1,2),hold on,plot(omegacell{dd,2},'k')
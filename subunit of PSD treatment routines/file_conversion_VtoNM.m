% This function convert PSD data files in unit of V to nm and save it as
% another file.
% Put empty string @ base_sig_pth: if it's not necessary or forgot to take
%                                  signal substrate;
% Put       1      @ show_fig    : if one wants to see a figure displaying 
%                                  the converted sinal 
% Put empty string @ to_fig_pth  : if one doesn't need to save the shown figure 
% 
% Abbr.                          :     pth - filepath
%                                :    coef - 5th-order polynomial coefficients

function file_conversion_VtoNM(from_pth,to_pth,coef_pth,base_sig_pth,...
                                  show_fig, to_fig_pth,Fs)
                              
filename = strsplit(from_pth,'\');
filename = char(filename(end));

rawDat=dlmread(from_pth);

if isempty(base_sig_pth)
    sig_base_col1 = 0;
    sig_base_col2 = 0;
else
    sig_base = dlmread(base_sig_pth);
    sig_base_col1 = mean(sig_base(:,1));
    sig_base_col2 = mean(sig_base(:,2));
end

rawDat(:,1) = rawDat(:,1) - sig_base_col1;
rawDat(:,2) = rawDat(:,2) - sig_base_col2;


rawnmdata=ConvertVtoNM(rawDat(:,1),rawDat(:,2),coef_pth);
%This comes out in AOD coordinates, must convert to PSD Coords
% rawnmdata(:,1:2)=rotateCoords(rawnmdata(:,1:2),0);
%Now in PSD Coordinates

if show_fig ==1

    %Plot distance vs time
    time = (1:length(rawDat))/Fs*1000.0; % unit: ms
    fig1 = figure('Name','Raw nm data','NumberTitle','off');
    plot(time,smooth(rawnmdata(:,1),99),'k.',time,smooth(rawnmdata(:,2),99),'b.','MarkerSize',4);
    xlim([0,500]);
    xlabel('time (ms)');
    ylabel('nm');
    grid on;
    title(sprintf('%s',filename));
    
    if ~isempty(to_fig_pth)
        saveas(fig1 , to_fig_pth,  'png');
    end
end
% %Save data
dlmwrite(to_pth,[rawnmdata(:,1),rawnmdata(:,2)]);

end
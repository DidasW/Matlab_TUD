% fig=figure('name','EFt','NumberTitle','off'); hold on
% axhandle = fig.Children; 
% 
% axis equal
exp=1;
phistep2 = pi/2;
 angplot2 = 0:phistep2:2*pi;
%Calculate cell body perimeter
rmindl  = Rcell(1,1)*1e6./11; 
rmajdl  = Rcell(1,2)*1e6./11;
theta = linspace(0,2*pi,100);
xcelldl = rmajdl + rmajdl.*cos(theta);
ycelldl = rmindl.*sin(theta);
greyclr = 0.95.*[230 230 240]./255;


indices = [79:162]; %which images 
phs_int=mod(phicell{1,1}(indices),2*pi) %convert from 2pi to 1

valdiff=zeros(length(angplot2),1);
ind_sel=zeros(length(angplot2),1);
phsel=zeros(length(angplot2),1);
for gg=1:length(angplot2)
    
[valdiff(gg) ind_sel(gg)]=min(abs(phs_int-angplot2(gg))) % pick the sample closer to the angle I want to plot
end

ph_sel=phs_int(ind_sel)
%looking at phase values over 3 cycles for example, find the phases that
%better approximate angplot and plot only those ones




IND=ind_sel+indices(1)-1;

 xpos=angplot2;
 ypos2=ypos;
for jj=1:length(angplot2)
    for kk=1:2
        xstrk(kk,:) = GIPxdl{exp,kk}({IND(jj),flaggriddl{exp}});
        ystrk(kk,:) = GIPydl{exp,kk}({IND(jj),flaggriddl{exp}});
    end
     
   plot(axhandle,xpos(jj)+0.02+0.9*ystrk(1,:),ypos2-ysize*xstrk(1,:),'r','linewidth',1.5)
   plot(axhandle,xpos(jj)-0.02+0.9*ystrk(2,:),ypos2-ysize*xstrk(2,:),'r','linewidth',1.5)
  plot(xpos(jj)+0.9*ycelldl,ypos-ysize*xcelldl,'k','LineWidth',1.5) %Plot cell body

end

exp = 1; %Experiment to analyze

ind(1)      = 1;   %First cycle to analyze
ind(2)      = 1;   %Last cycle to plot

%Calculate cell body perimeter
rmindl  = Rcell(exp,1)*1e6./lflag{exp}; 
rmajdl  = Rcell(exp,2)*1e6./lflag{exp};
theta = linspace(0,2*pi,100);
xcelldl = rmajdl + rmajdl.*cos(theta);
ycelldl = rmindl.*sin(theta);
greyclr = 0.95.*[230 230 240]./255;


ind1 = avgbeat{exp,1}.locs(ind(1));
ind2 = avgbeat{exp,1}.locs(ind(2)+1);
indices = [ind1 ceil(ind1):1:floor(ind2) ind2];

figure,hold on
cmap = plasma(length(phi0));
cinterp = griddedInterpolant({phi0,1:3},cmap);
plot(xcelldl,ycelldl,'k','LineWidth',1.5) %Plot cell body
% for ii=ind(1):ind(2)
% % h1=fill(avgbeat{exp,1}.xhull{ii},avgbeat{exp,1}.yhull{ii},greyclr); %Plot swept area
% % h2=fill(avgbeat{exp,2}.xhull{ii},avgbeat{exp,2}.yhull{ii},greyclr);
% h1.EdgeColor = 'none';      h2.EdgeColor = 'none';
% end
for jj=1:7
    for kk=1:2
        xstrk(kk,:) = GIPxdl{exp,kk}({indices(jj),flaggriddl{exp}});
        ystrk(kk,:) = GIPydl{exp,kk}({indices(jj),flaggriddl{exp}});
    end
   plot(xstrk(1,:),ystrk(1,:),'color',col{2},'LineWidth',1.5)
   plot(xstrk(2,:),ystrk(2,:),'color',col{2},'LineWidth',1.5)
end
axis equal,set(gca,'xlim',[-1 1],'xtick',-1:0.5:1,...
    'ylim',[-1 1],'ytick',-1:0.5:1), grid on
xlabel('$x/L$ [-]'),ylabel('$y/L$ [-]')
    saveas(gcf,'Basecase_stroke_pattern','epsc')
     title(name{exp})
     box on

set(0,'defaulttextinterpreter','latex')
set(0,'DefaultAxesFontSize',16)

clear all; close all; clc

x = 0:0.5:5;
noiseamp = 1.5;
y = x+noiseamp.*(rand(size(x))-0.5);

fitnode = round(length(x)/2);
span = 5;
nspan = (span-1)/2;
degree = 2;
yfilt = smooth(y,span,'sgolay',degree);
p = polyfit(x(fitnode-nspan:fitnode+nspan),y(fitnode-nspan:fitnode+nspan),2);

figure,hold on
scatter(x,y,'k')
scatter(x(fitnode-nspan:fitnode+nspan),y(fitnode-nspan:fitnode+nspan),'k','filled')
plot(x,y,'b')
plot(x,yfilt,'k')
plot(x,polyval(p,x),'r.-','MarkerSize',15)
xlabel('x'),ylabel('y'),grid on
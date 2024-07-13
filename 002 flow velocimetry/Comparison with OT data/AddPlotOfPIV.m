data = dlmread('D:\000 RAW DATA FILES\171031 quasi PIV\result\pure numbers, CellNo-NormDist-NormVax-AvgNormVax.dat');
figure(1)
hold on
NormDist_raw = data(:,2);
AvgNormVax_raw = data(:,5);
idx_nonzero    = find(AvgNormVax_raw~=0);
NormDist       = NormDist_raw(idx_nonzero);
AvgNormVax     = AvgNormVax_raw(idx_nonzero);
plt_PIV = plot(NormDist,AvgNormVax,':.','color',SanLv,'LineWidth',1.5,'MarkerFaceColor',SanLv,'Markersize',10)
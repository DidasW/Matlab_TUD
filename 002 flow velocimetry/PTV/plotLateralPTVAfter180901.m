plot_axOrLatComponent = 'axial';
plot_axOrLatDistance  = 'lateral';
% run(fullfile('D:','002 MATLAB codes','000 Routine',...
%     'subunit of img treatment routines','add_path_for_all.m'))
color_palette;

%%
if ~exist('plot_axOrLatDistance','var')
    plot_axOrLatDistance  = 'lateral';
end

figure(3);
grid on,box on, hold on
set(gcf,'Units','Inches','Position',[5 2 3.7000 3.7000],...
    'defaulttextinterpreter','LaTex')
set(gca,'Units','Normalized','Position',[0.22, 0.15, 0.7, 0.7],...
    'XScale','log','YScale','log','fontsize',10.9,...
    'defaulttextinterpreter','Latex','TickLabelInterpreter','Latex')

%%
fdpth = 'D:\OTV databank from D drive\181004 Lateral PTV after 180901\';
matfilestruct = dir([fdpth,'*.mat']);
NoFile        = length(matfilestruct);
gcf,hold on

plotIndexList = [4];
plotHandleList= cell(numel(plotIndexList),1);
legendList    = cell(numel(plotIndexList),1);
colormap = hsv(NoFile*2+1);
for i_plot = 1:numel(plotIndexList)
    i_file = plotIndexList(i_plot);
    filename    = matfilestruct(i_file).name 
    load(fullfile(fdpth,filename),...
        '-regexp',['^(?!(fdpth|i|',...
        'filename)$).']);    
    
    switch filename(1)
        case '1'
            pipettePointingTo     = 'down';
            dlat_list             = abs(xgb_list);
            dax_list              = abs(ygb_list);
            d_latScaled_list   = abs(NormXgb_list);
            d_axScaled_list    = abs(NormYgb_list);
        case '2'
            pipettePointingTo     = 'right';
            dlat_list             = abs(ygb_list);
            dax_list              = abs(xgb_list);
            d_latScaled_list   = abs(NormYgb_list);
            d_axScaled_list    = abs(NormXgb_list);
    end
    
    
    
    switch plot_axOrLatDistance
        case 'axial'
            [~,idx]         = sort(abs(dax_list));
        case 'lateral'
            [~,idx]         = sort(abs(dlat_list));
    end
    dlat_list        = dlat_list(idx);
    dax_list         = dax_list(idx);
    d_latScaled_list = d_latScaled_list(idx);
    d_axScaled_list  = d_axScaled_list(idx);
    Vax_list         = Vax_list(idx);
    Vlat_list        = Vlat_list(idx);
    NormVax_list     = NormVax_list(idx);
    NormVlat_list    = NormVlat_list(idx);   
    
    switch plot_axOrLatDistance
        case 'axial'
            d_plotScaled_list = d_axScaled_list;
        case 'lateral'
            d_plotScaled_list = d_latScaled_list;
    end   
    switch plot_axOrLatComponent
        case 'axial'
            v_plotScaled_list = -NormVax_list;
        case 'lateral'
            v_plotScaled_list = abs(NormVlat_list);
    end
    
    color = colormap(2*i_file+1,:);
    plt_PTV_line =  plot(d_plotScaled_list,v_plotScaled_list,'-',...
        'LineWidth',2,'Color',color);
%     plt_PTV_point = plot(d_plotScaled_list,v_plotScaled_list,'s',...
%         'LineWidth',1,'MarkerSize',5,'Color',...
%         color*0.8,'MarkerFaceColor',color);
    plotHandleList(i_plot) = {plt_PTV_line};
    parseStr               = strsplit(filename,'_'); 
    experiment             = parseStr{1}; clearvars parseStr
    legendList(i_plot)     = {experiment};
end

% legend([plotHandleList{:}],legendList,'box','off','FontSize',8)

xlabel('Scaled lateral distance ($y/\delta$)',...
       'FontSize',12,'FontWeight','bold')
ylabel('Scaled average flow ($U^{avg}/U_{scale}$)',...
       'FontSize',12,'FontWeight','bold')

xlim([0.06,1.3])
ylim([1e-3, 1 ])
xticks([0.1,1])
yticks([1e-2,1e-1])

function plot_dragForce(BEMSolutionFilePath)
    %%
    if ~exist('a','var')||~exist('b','var')
        a = 5; b = 5;
    end
    eta = 0.9544e-3; 
    YangHong     = [220,20,60]/255;
    BaoLan       = [31,54,150]/255;
    
    %% make canvas
  	gcf;
    set(gcf,'DefaultAxesFontSize',12,'DefaultAxesFontWeight','normal',...
        'DefaultAxesLineWidth',1.5,'Units','inches',...
        'position',[1,1,9,5],'PaperPositionMode','auto',...
        'DefaultTextInterpreter','Latex')
    set(gca,'DefaultTextInterpreter','Latex',...
        'TickLabelInterpreter','Latex')
    
    %% convert and calc
        
    [DragX1,DragY1,...
     DragX2,DragY2,...
     DragTot1,DragTot2] = extractFromBEM_dragForce(BEMSolutionFilePath);
    
    [P_visc_1,P_visc_2,...
     P_visc_tot       ] = extractFromBEM_viscousPower(BEMSolutionFilePath);
 
    
    [DragX1,DragY1,...
    DragX2,DragY2,...
    DragTot1,DragTot2,...
    P_visc_1,P_visc_2,...
    P_visc_tot        ] = fixSpikesFromBEM(DragX1,DragY1,...
                                           DragX2,DragY2,...
                                           DragTot1,DragTot2,...
                                           P_visc_1,P_visc_2,...
                                           P_visc_tot        );

 
    DragTot1 = smooth(DragTot1,5,'sgolay');
    DragTot2 = smooth(DragTot2,5,'sgolay');

    
    F0     = 6*pi*eta*110  *sqrt(a*b) * 1e-12; % N
    P0     = 6*pi*eta*110^2*sqrt(a*b) * 1e-18; % W
    
    %% plot
    subplot(2,1,1)
    hold on, grid on, box on
    plot(DragTot2/F0,'-','Color',YangHong,'LineWidth',1.5,...
         'DisplayName','Cis');
    plot(DragTot1/F0,'-','Color',BaoLan,'LineWidth',1.5,...
        'DisplayName','Trans');
    xlabel('Frame'); ylabel('Scaled force')
    ylim ([0,6]);
    
    subplot(2,1,2)
    hold on, grid on, box on
    plot(P_visc_2/P0,'-','Color',YangHong,'LineWidth',1.5,...
        'DisplayName','Cis');
    plot(P_visc_1/P0,'-','Color',BaoLan,'LineWidth',1.5,...
        'DisplayName','Trans');
    xlabel('Frame'); ylabel('Scaled power')
    ylim  ([-20,100]);
    
    legend()
end
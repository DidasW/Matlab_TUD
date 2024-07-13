clear variables;close all; clc;
addpath(genpath('./'))
% addpath('/Users/Jan/Documents/MEGA/WB/M2/Thesis/Matlab/Flagella tracking/movies/4-26/cal'); %path for the flagella signal
% set(0,'defaulttextinterpreter','latex')
set(0,'DefaultAxesFontSize',16)

scenario = 'Greta8';

%Which files to load for each scenario
load_filenames

%Load the stored limit cycle for the base case scenario
load Base_case_vars

%Physical variables
Ufs         = 110e-6;   %Free swimming velocity
cellshift   = 0;	%Cell phase at maximum flagella extension [rad] in point 6 5-12 cellshift=4

GIPmethod   = 'linear';

%Preallocate arrays
[Pv,Ee,Pe,Pt,Pvdl,Eedl,Pedl,Ptdl] = deal(cell(datasets,3));
[fx,fy,ft,fxdens,fydens,ftdens,fxdl,fydl,ftdl] = deal(cell(datasets,3));
[Mom] = deal(cell(datasets,3)); %momentum
[EFx,EFy,EFt,EFxdl,EFydl,EFtdl] = deal(cell(datasets,3));
[GIPEFx,GIPEFy,GIPEFt,GIPEFxdl,GIPEFydl,GIPEFtdl] = deal(cell(datasets,3));
[GIPPv,GIPEe,GIPPe,GIPPt,GIPPvdl,GIPEedl,GIPPedl,GIPPtdl,GIPphic,GIPphip] = ...
    deal(cell(datasets,3));
[xflagellum,yflagellum,GIPx,GIPy] = deal(cell(datasets,2));
[xflagellumdl,yflagellumdl,GIPxdl,GIPydl] = deal(cell(datasets,2));
[Fint_N,Fint_Q,Fint_R,Mint] = deal(cell(datasets,2));
[phiproto,phiPCA,phicell,omegacell,omegaproto]           = deal(cell(datasets,2));
Rcell       = zeros(datasets,3);
[flagcentroids,flaggrid,nflagnodes,dataind,datatime]     = deal(cell(datasets,1));
avgbeat     = cell(datasets,3);
thetabase   = zeros(datasets,3);
[facdlF,facdlP,facdlE] = deal(zeros(datasets,1));

%Limit cycle reconstruction
nmodeslimit = 3;    %Shape modes to calculate limit cycle for
nlimit      = 200;  %Number of limit cycle points
nharmlimit  = 5;    %Number of reconstruction harmonics
[GIPB,BlimitGIP] = deal(cell(datasets,2,nmodeslimit));
BlimitGIPavg = cell(datasets,nmodeslimit);
[B,Blimit]  = deal(cell(datasets,2));
phi0        = linspace(0,2*pi,nlimit);   %Equally spaced grid req. for DFT
flaginterpgrid = 0.2:0.025:1;
% 
if strcmp(scenario,'Greta8')==1
load('PhaseREFpt6.mat')
elseif strcmp(scenario,'Greta7')==1
load('PhaseREFpt5.mat')
elseif strcmp(scenario,'Greta5')==1
load('PhaseREFpt0.mat')
elseif strcmp(scenario,'Greta15')==1
load('PhaseREFpt0Chris.mat')

end
phFwrap=PhFunwRefSM-floor(PhFunwRefSM/(2*pi))*2*pi;


%% Load data
for dd=1:4
    load(filenames{dd})	
%     fprintf('dataset %d \n',dd) 
    
    %Load variables from data file into local cell array
    save_vars_to_cell2
    
    %Calculate cell phase
    cell_phase_edit



%     %Reconstruct limit cycle from data
    limit_cycles
%     
%     %Detect beat cycles, average variables over all cycles, calculate mean
%     %cycle
    cycle_averaging
    
    
    
%     
end


% save('Varpt0Chris.mat','Mint', 'macte', 'mactf','Rcell','phicell', 'GIPxdl','flaggriddl','GIPydl', 'EFt', 'EFx', 'EFy', 'Pv', 'Pe', 'Pt','beginimg','endimg','Cell')


% Calculate phase difference between cell and flow %only if you have flow
% flow_phase

% --------------------------------------------------------------------------
% %% Forces
% %--------------------------------------------------------------------------
% % Create matrix of forces with dimensions [phi0 points in cell phase; nnodes
% % in distance;];
% ft_interp = cell(datasets,2);       %Interpolated total force
% ftdens_interp = cell(datasets,2);   %Interpolated force density
% for dd=1:datasets
%     for lr=1:2
%         %Convert ft and phi to equally spaced vectors
%         [phisort,ind] = sort(mod(phicell{dd,lr},2*pi));
%         clear ftsort ftdenssort
%         ftsort = ft{dd,lr}(ind,:);
%         ftdenssort = ftdens{dd,lr}(ind,:);
%         %Remove duplicates
%         ind = find(diff(phisort) ==  0,1,'first');
%         while ~isempty(ind)
%             phisort(ind) = [];
%             ftsort(ind+1,:) = (ftsort(ind,:)+ftsort(ind+1,:))./2;
%             ftsort(ind,:) = [];
%             ftdenssort(ind+1,:) = (ftdenssort(ind,:)+ftdenssort(ind+1,:))./2;
%             ftdenssort(ind,:) = [];
%             ind = find(diff(phisort) ==  0,1,'first');
%         end
% %         figure,surf(flaggridsurfdl{dd},phisort,ftsort,'LineStyle','none')
% %         view([0 90]),colormap jet;colorbar,caxis([0 5e-9]);
%         GIP = griddedInterpolant({phisort,flagcentroidsdl{dd}},ftsort);
%         ft_interp{dd,lr} = GIP({phi0,flaginterpgrid}); 
%         GIP = griddedInterpolant({phisort,flagcentroidsdl{dd}},ftdenssort);
%         ftdens_interp{dd,lr} = GIP({phi0,flaginterpgrid});
%     end
% end
% 
% 
% 
% 
% 
% 
% 
% % % Total momentum WT
% % 
%  specific_base_case
%  plots_all_Greta
% 
% % Plot EFt total force along flag 1 flag and flag1+flag2
% % lr=1 indicates the right flagellum and lr=2 the left
% 
% figure,
% plot(Mtot{1,1},'g','Linewidth',2)
% hold on, plot(Mtot{2,1},'r','Linewidth',2)
% % hold on, plot(EFt{3,1},'k','Linewidth',1.5)
% % hold on, plot(EFt{4,1},'m','Linewidth',1.5)
% % hold on, plot(EFt{5,1},'m','Linewidth',1.5)
% % legend([p1 p2],'WT greta code','WT Chris code')
% legend(name{1},name{2})
% title('Total moment flag 1')
% xlabel('frame')
% ylabel('Total Momentum (N)')
% xlim([0 120])
% 
% 
% figure,
% plot(Mom{1,1}(:,2),'g','Linewidth',2)
% hold on, plot(Mom{1,1}(:,11),'k','Linewidth',1.5)
% hold on, plot(Mom{1,1}(:,20),'r','Linewidth',2)
% 
% % hold on, plot(EFt{4,1},'m','Linewidth',1.5)
% % hold on, plot(EFt{5,1},'m','Linewidth',1.5)
% % legend([p1 p2],'WT greta code','WT Chris code')
% legend('Point1','Point2','Point3')
% title('Total moment flag 1')
% xlabel('frame')
% ylabel('Total force (N)')
% xlim([0 120])
% 
% 
% 
% 
% figure,plot(EFt{1,2})
% hold on, plot(EFt{2,2},'r')
% legend('No flow','Flow')
% title('Left Flagellum')
% xlabel('frame')
% % ylabel('Total force (N)')
% % % 
% for dd=1:datasets
% figure,colormap jet,subplot(2,1,1),
%     surf(flaginterpgrid,phi0,ftdens_interp{dd,1},'LineStyle','none')
%     view([0 90]),colormap jet;colorbar,caxis([0 1e-2]);
%     xlabel('$s/L$ [-]'),ylabel('Cell angle [rad]')
%     set(gca,...
%      'xlim',[0 1],'xtick',0:0.2:1,...
%      'ylim',[0 2*pi],'ytick',0:pi/2:2*pi,...
%      'yticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'},...
%      'fontsize',14)
% subplot(2,1,2),
%     surf(flaginterpgrid,phi0,ftdens_interp{dd,2},'LineStyle','none')
%     view([0 90]),colormap jet;colorbar,caxis([0 1e-2]);
%     xlabel('$s/L$ [-]'),ylabel('Cell angle [rad]')
%     set(gca,...
%      'xlim',[0 1],'xtick',0:0.2:1,...
%      'ylim',[0 2*pi],'ytick',0:pi/2:2*pi,...
%      'yticklabel',{'0' '\pi/2' '\pi' '3\pi/2' '2\pi'},...
%      'fontsize',14)
% end
% % 
% 
% %% Case specific statistics
% switch scenario
%     case 'Base case'
%         specific_base_case
%     case 'Synchrony'
%         specific_synchrony
%     case 'NoSynchrony'
%         specific_nosync
% end
% % 
% %% Common figures
% plots_all
% % 
% %% Case specific figures
% switch scenario
%     case 'Base case'
%         plots_base_case
%     case 'Synchrony'
%         plots_synchrony
%     case 'Shift'
%         plots_shift
%     case 'NoSynchrony'
%         plots_nosynchrony
% end
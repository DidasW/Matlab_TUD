clear variables;close all; clc;
addpath(genpath('./'))
addpath('/Users/Jan/Documents/MEGA/WB/M2/Thesis/Matlab/Flagella tracking/movies/4-26/cal'); %path for the flagella signal
set(0,'defaulttextinterpreter','latex')
set(0,'DefaultAxesFontSize',16)

% scenario = 'Base case';
% scenario = 'Synchrony';
% scenario = 'Shift';
scenario = 'NoSynchrony';

%Which files to load for each scenario
load_filenames
%Load the stored limit cycle for the base case scenario
load Base_case_vars

%Physical variables
Ufs         = 110e-6;   %Free swimming velocity
cellshift   = -2.1632;	%Cell phase at maximum flagella extension [rad]

% GIPmethod   = 'linear';

%Preallocate arrays
[Pv,Ee,Pe,Pt,Pvdl,Eedl,Pedl,Ptdl] = deal(cell(datasets,3));
[fx,fy,ft,fxdens,fydens,ftdens,fxdl,fydl,ftdl] = deal(cell(datasets,3));
[EFx,EFy,EFt,EFxdl,EFydl,EFtdl] = deal(cell(datasets,3));
[GIPEFx,GIPEFy,GIPEFt,GIPEFxdl,GIPEFydl,GIPEFtdl] = deal(cell(datasets,3));
[GIPPv,GIPEe,GIPPe,GIPPt,GIPPvdl,GIPEedl,GIPPedl,GIPPtdl,GIPphic,GIPphip] = ...
    deal(cell(datasets,3));
[xflagellum,yflagellum,GIPx,GIPy] = deal(cell(datasets,2));
[xflagellumdl,yflagellumdl,GIPxdl,GIPydl] = deal(cell(datasets,2));
[Fint_N,Fint_Q,Fint_R,Mint] = deal(cell(datasets,2));
[phiproto,phiPCA,phicell,omegacell,omegaproto]    = deal(cell(datasets,2));
Rcell       = zeros(datasets,3);
[flagcentroids,flaggrid,nflagnodes,dataind,datatime]     = deal(cell(datasets,1));
avgbeat     = cell(datasets,3);
thetabase   = zeros(datasets,3);
[facdlF,facdlP,facdlE] = deal(zeros(datasets,1));

%Limit cycle reconstruction
nmodeslimit = 2;    %Shape modes to calculate limit cycle for
nlimit      = 200;  %Number of limit cycle points
nharmlimit  = 5;    %Number of reconstruction harmonics
[GIPB,BlimitGIP] = deal(cell(datasets,2,nmodeslimit));
BlimitGIPavg = cell(datasets,nmodeslimit);
[B,Blimit]  = deal(cell(datasets,2));
phi0        = linspace(0,2*pi,nlimit);   %Equally spaced grid req. for DFT
flaginterpgrid = 0.2:0.025:1;
%% Load data
for dd=1:datasets
    load(filenames{dd})	
    
    %Load variables from data file into local cell array
    save_vars_to_cell
    
    %Calculate cell phase
    cell_phase
        
    %Reconstruct limit cycle from data
    limit_cycles
    
    %Detect beat cycles, average variables over all cycles, calculate mean
    %cycle
    cycle_averaging
    
end

%Calculate phase difference between cell and flow
flow_phase

%--------------------------------------------------------------------------
%% Forces
%--------------------------------------------------------------------------
% Create matrix of forces with dimensions [phi0 points in cell phase; nnodes
% in distance;];
ft_interp = cell(datasets,2);       %Interpolated total force
ftdens_interp = cell(datasets,2);   %Interpolated force density
for dd=1:datasets
    for lr=1:2
        %Convert ft and phi to equally spaced vectors
        [phisort,ind] = sort(mod(phicell{dd,lr},2*pi));
        clear ftsort ftdenssort
        ftsort = ft{dd,lr}(ind,:);
        ftdenssort = ftdens{dd,lr}(ind,:);
        %Remove duplicates
        ind = find(diff(phisort) ==  0,1,'first');
        while ~isempty(ind)
            phisort(ind) = [];
            ftsort(ind+1,:) = (ftsort(ind,:)+ftsort(ind+1,:))./2;
            ftsort(ind,:) = [];
            ftdenssort(ind+1,:) = (ftdenssort(ind,:)+ftdenssort(ind+1,:))./2;
            ftdenssort(ind,:) = [];
            ind = find(diff(phisort) ==  0,1,'first');
        end
%         figure,surf(flaggridsurfdl{dd},phisort,ftsort,'LineStyle','none')
%         view([0 90]),colormap jet;colorbar,caxis([0 5e-9]);
        GIP = griddedInterpolant({phisort,flagcentroidsdl{dd}},ftsort);
        ft_interp{dd,lr} = GIP({phi0,flaginterpgrid}); 
        GIP = griddedInterpolant({phisort,flagcentroidsdl{dd}},ftdenssort);
        ftdens_interp{dd,lr} = GIP({phi0,flaginterpgrid});
    end
end
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


%% Case specific statistics
switch scenario
    case 'Base case'
        specific_base_case
    case 'Synchrony'
        specific_synchrony
    case 'NoSynchrony'
        specific_nosync
end

%% Common figures
plots_all

%% Case specific figures
switch scenario
    case 'Base case'
        plots_base_case
    case 'Synchrony'
        plots_synchrony
    case 'Shift'
        plots_shift
    case 'NoSynchrony'
        plots_nosynchrony
end
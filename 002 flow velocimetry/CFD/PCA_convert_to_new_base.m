%--------------------------------------------------------------------------
% PCA_new_base 
%--------------------------------------------------------------------------
%Calculates the variable Bgen, which represents the shape scores of an
%existing data set expressed in a different PCA base

%% Preliminaries
clear all
close all
clc

addpath(genpath('./'))
addpath(genpath('./src'));
set(0,'defaulttextinterpreter','latex')

savenew   	= 1;          %Save new data?

%Base case
filenm{1}     = 'Data/Base Case/4-25 cell1 1-750';
filenm{2}     = 'Data/Base Case/4-25 cell2 1-750';
filenm{3}     = 'Data/Base Case/4-25 cell3 1-750';
filenm{4}     = 'Data/Base Case/4-26 9 1-750';
%Synchrony
filenm{5}     = 'Data/Synchrony/4-26 19 2000-2750';
filenm{6}     = 'Data/Synchrony/4-26 32 2000-2750';
filenm{7}     = 'Data/Synchrony/4-26 45 2000-2750';
filenm{8}     = 'Data/Synchrony/4-26 58 2000-2750';
filenm{9}     = 'Data/Synchrony/4-26 73 2000-2750';
filenm{10}    = 'Data/Synchrony/4-26 88 2000-2750';
%No Synchrony
filenm{11}    = 'Data/No Synchrony/4-26 9 2000-2750';
filenm{12}    = 'Data/No Synchrony/4-26 17 2000-2750';
filenm{13}    = 'Data/No Synchrony/4-26 27 2000-2750';
filenm{14}    = 'Data/No Synchrony/4-26 40 2000-2750';
filenm{15}    = 'Data/No Synchrony/4-26 53 6000-6750';
filenm{16}    = 'Data/No Synchrony/4-26 68 3000-3750';
%Shift
filenm{17}    = 'Data/Shift/Shift 0';
filenm{18}    = 'Data/Shift/Shift 0.125 pi';
filenm{19}    = 'Data/Shift/Shift 0.250 pi';
filenm{20}    = 'Data/Shift/Shift 0.375 pi';
filenm{21}    = 'Data/Shift/Shift 0.500 pi';
filenm{22}    = 'Data/Shift/Shift 0.625 pi';
filenm{23}    = 'Data/Shift/Shift 0.750 pi';
filenm{24}    = 'Data/Shift/Shift 0.875 pi';
filenm{25}    = 'Data/Shift/Shift 1.000 pi';
filenm{26}    = 'Data/Shift/Shift 1.125 pi';
filenm{27}    = 'Data/Shift/Shift 1.250 pi';
filenm{28}    = 'Data/Shift/Shift 1.375 pi';
filenm{29}    = 'Data/Shift/Shift 1.500 pi';
filenm{30}    = 'Data/Shift/Shift 1.625 pi';
filenm{31}    = 'Data/Shift/Shift 1.750 pi';
filenm{32}    = 'Data/Shift/Shift 1.875 pi';

basename    = 'Blimit_general.mat';                         %Name of shape base filenm

for ff=17:32%1:length(filenm)
    filename    = [filenm{ff} ' corrected.mat'];
    filenamesol = [filenm{ff} ' corrected BEMsolution.mat'];
    
    if ff< 17
        load(filename);
    else
       load('Data/Shift/4-26 88 2000-2750 corrected.mat'); 
    end
    %Create one long vector with curvature values
    templ = []; tempr = [];
    for kk=1:size(kappasave,1)
        templk = [squeeze(kappasave(kk,1,1)); smooth(squeeze(kappasave(kk,1,2:end)),3)];
        temprk = [squeeze(kappasave(kk,2,1)); smooth(squeeze(kappasave(kk,2,2:end)),3)];
        templ = [templ; templk';];
        tempr = [tempr; temprk';];
    end
    curv = [templ; tempr;];

    samples = size(curv,1);     %Number of measurements
    nodes = size(curv,2);

    %% Fit principal components to data
    load(basename);
    %Calculate shape scores using linear least squares
%     curv0 = mean(curv,1);
    curv0 = repmat(curv0,[samples,1]);          %Mean of all samples
    d = curv-curv0;                             %Tangent angle minus mean
    Btmp = zeros(samples,nodes);                %Shape scores
    curv_tilde = zeros(size(curv));             %Approximate curvatures
    for ii=1:samples
        Btmp(ii,:) = lsqlin(C,d(ii,:),[],[]);
        curv_tilde(ii,:) = curv0(1,:) + (C*Btmp(ii,:)')';
    end
    Btmp = real(Btmp);
    Bgen = zeros(samples/2,2,nodes);
    %Switch left and right (difference in convention between image
    %processing and BEM code)
    Bgen(:,1,:) = Btmp(samples/2+1:end,:);
    Bgen(:,2,:) = Btmp(1:samples/2,:);
    phigen(:,1) = atan2(Bgen(:,1,2),Bgen(:,1,1));
    phigen(:,2) = atan2(Bgen(:,2,2),Bgen(:,2,1));

    % %Plots of reconstructed vs actual shapes
    % for i=1:1000:samples
    %     figure
    %     subplot(2,1,1)
    %     %Exact and approximated shapes
    %     hold on
    %         plot(curv(i,:))
    %         plot(curv_tilde(i,:))
    %         legend(strcat('\kappa_{',num2str(i),'}'),'\kappa_{PCA}')
    %         xlabel('Node number')
    %         ylabel('Shape mode curvature')
    %     hold off
    %     subplot(2,1,2)
    %     %Shape scores
    %         plot(abs(Bdata(i,:)))
    %         xlabel('Shape mode')
    %         ylabel('Absolute shape score')
    %     pause(1e-4)
    % end

    %% Store new shape base
    %Store limit cycle

    if savenew
        if exist(filename,'file')
           save(filename,'Bgen','phigen','-append'); 
        end
        if exist(filenamesol,'file')
           save(filenamesol,'Bgen','phigen','PCA_store','curv0','C','-append'); 
        end
    end
end
disp('Done')
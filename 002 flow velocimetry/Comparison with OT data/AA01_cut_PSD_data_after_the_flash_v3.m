%% Doc
%{
% This script read all the PSD.dat files in a given folder, recognize a 
% flash light of given duration, cut the data from the middle of the falling
% edge, and stored the cut data in given places. 
% Meanwhile, a diagram recording this process will be kept as a log.
% 
% In general, the way to find the flash is to sweep a window of the size of
% a flash duration through the signal. Supposedly the flash will induce a
% maximum/minimum of the signal. Based on the summation of the elements
% within the window, the max/min will be found and help to formulate a
% criterion.
%
% Conventions: 
%   * unless other wise stated, units used are [Hz],[um],[um/s],[ms]
% 
%  
% version: 3. 
% Date/Name:  20171129, Da Wei
% * wrap-up the flash-searching into a function
% * use also differetial method in addtion to convolution
% * use PSDx and PSDy stop using sumx and sumy
%
% version: 3.1 
% Date/Name:  20190226, Da Wei
% * if only one flash is find, use that one and report.
%

%}
clear all  %#ok<CLALL>
close all
%% Add paths
run(fullfile('D:','002 MATLAB codes','000 Routine',...
    'subunit of img treatment routines','add_path_for_all.m'))

%% Load settings
experiment   = '190414c56wvt';
AA05_experiment_based_parameter_setting;
if ~exist('RawPSD_fdpth','var')
    RawPSD_fdpth = '';
end
searchTheFirstXsec = 0;      % [s], 0 = global search

%% Prepare folder paths
from_fdpth = RawPSD_fdpth; cd(from_fdpth);
[~,FFdN,~] = fileparts(pwd); % from folder name
DFL        = dir('*.dat');   % Data file list
NoFile     = length(DFL);
cd ..
AFpsd_fdpth= [FFdN,'_AF/'];
to_fdpth   = AFpsd_fdpth;    % AF_: after flash
if ~exist(to_fdpth,'dir'); mkdir(to_fdpth); end

%% Interpolation frequency
if ~exist('Fs','var'); Fs = 50000 ; end
t_unit     = 1/Fs*1000; % [ms]

%%
for i_file = 1:NoFile
    %% Load data
    FN      = DFL(i_file).name;       %file name
    filepth = fullfile(from_fdpth,FN);
    rawdata = dlmread(filepth);
       
    [~,col_no] = size(rawdata);
    switch col_no
        case 4
            PSDx = rawdata(:,1);
            PSDy = rawdata(:,2);
            sumx = rawdata(:,3);
            sumy = rawdata(:,4);
        case 2
            PSDx = rawdata(:,1);
            PSDy = rawdata(:,2);
            sumx = PSDx;
            sumy = PSDy;
        otherwise
            error('Wrong format of the PSD data');
    end
    N  = length(PSDx);
    if searchTheFirstXsec ~= 0
        sig1 = PSDx(1:searchTheFirstXsec*Fs);
        sig2 = PSDy(1:searchTheFirstXsec*Fs);
    else
        sig1 = PSDx;        %#ok<*UNRCH>
        sig2 = PSDy;
    end
    
    t    = make_time_series(sig1,Fs,'ms');

    
    %% Find the flash    
    [~,~,~,idx_E1] = determine1flash_PSD(sig1,Fs,'differential');
    [~,~,~,idx_E2] = determine1flash_PSD(sig2,Fs,'differential');
    % idx_ : index of
    % E#   : end of sig#
    
    %% Resolve the flash center
    disp('====================================')
    if ~isnan(idx_E1) && ~isnan(idx_E2)
        t_E1  = t(idx_E1);
        t_E2  = t(idx_E2);
        mismatch = abs( t_E1- t_E2); % [ms]
        if mismatch >= 1   % >1 ms,usually means bad recognition
            warning([FN, ':flash center mismatch > 1ms in x,y'])
            fprintf('%s :flash center mismatch %.1f ms\n',FN, mismatch);
            sig1_temp = abs(sig1-mean(sig1)); sig2_temp = abs(sig2-mean(sig2));
            ampl_sig1 = max(sig1_temp) - min(sig1_temp);
            ampl_sig2 = max(sig2_temp) - min(sig2_temp);
            if ampl_sig1 >= ampl_sig2
                t_E  = t_E1;
            else 
                t_E  = t_E2;
            end
            clearvars sig1_temp sig2_temp
        else
            fprintf('%s :flash center mismatch %.1f ms\n',FN, mismatch);
            t_E      = (t_E1+t_E2)/2;
        end
        message = sprintf('%s :flash center mismatch %.1f ms\n',...
                  FN, mismatch);
    elseif ~isnan(idx_E1)
        fprintf('%s :find flash in one axis\n',FN);
        t_E      = t(idx_E1);
        message = sprintf('%s : find flash in one axis\n',FN);
    elseif ~isnan(idx_E2)
        fprintf('%s :find flash in one axis\n',FN);
        t_E      = t(idx_E2);
        message = sprintf('%s : find flash in one axis\n',FN);
    end
    
    idx      = find(t-t_E>0);
    pt_start = idx(1);         % signal will be cut from that pt (point),
                               % including that pt. e.g. Fs ~ 5000, each 
                               % pt ~ 0.2ms, hence the resolution 0.2 ms.

    pts_left = N - pt_start + 1;
%    t_start        = t(idx(1))-t_0;        % secondary mismatch  
    
    %% cut the signal, store
    data_cut = rawdata(pt_start:end,:);   
    save(fullfile(AFpsd_fdpth,[FN(1:end-4),'_AF.dat']),...
        'data_cut','-ascii','-tabs');
    
    %% generate a figure for checking
    fig = figure(i_file);
    set(gcf,'DefaultAxesFontSize',16,'DefaultAxesFontWeight','bold',...
            'DefaultAxesLineWidth',1.5,'unit','normalized',...
            'position',[0.1,0.1,0.8,0.6])
    
    subplot(1,2,1); hold on;
    ax11 = plot(t, sig1, 'b-','LineWidth',1.5);
    ax12 = plot(t, sig2, '-','LineWidth',1.5,'color',[1,0.6,0.2]);
    legend([ax11,ax12],{'PSDVx','PSDVy'});
    xlabel('Time (ms)')
    ylabel('Signal (V)')
    
    subplot(1,2,2)
    ax21 = plot(t, normalize_MaxToMin(sig1),'-o', 'MarkerSize',3,...
                'MarkerFaceColor','none','LineWidth',0.5,...
                'Color',[0 ,0, 1,0.3]); hold on;
    ax22 = plot(t, normalize_MaxToMin(sig2),'-o', 'MarkerSize',3,...
                'MarkerFaceColor', 'none','LineWidth',0.5,...
                'color',[1,0.6,0.2,0.3]);
    ax23 = plot([t_E,t_E],[-10,10],'--','LineWidth',1,'color','r');
    leg  = legend([ax21,ax22,ax23],{'norm(PSDVx)','norm(PSDVy)','flash end'},...
           'FontSize',8,'FontWeight','bold');
    note = text(t_E-19,1.11,sprintf('start pt=%d\nleft pt=%.d(%.3f s)\n%s',...
           pt_start,(N-pt_start),(N-pt_start)/Fs,message),...
           'FontSize',8,'FontWeight','normal','Interpreter','none');
    xlim([t_E-20,t_E+10]);
    ylim([-0.1,1.2])
    xlabel('Time (ms)')
    ylabel('Signal (V)')
    set(gcf,'PaperPositionMode','auto')
    print(fullfile(AFpsd_fdpth,[FN(1:end-4),'_AF_fig.png']),'-dpng','-r0')
    
    %% clean the screen regularly and report to user
    if mod(i_file,4)==0
        close all 
    end
    fprintf('%s DONE,\n %d/%d\n',FN,i_file,NoFile);
end

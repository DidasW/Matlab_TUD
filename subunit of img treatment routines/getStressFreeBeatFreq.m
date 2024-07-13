%% Doc 
%{
output: f0_mean, (f0_std, IPFraction, note)
input : experiment_path - under which should be the folder ..\00NoFlow 
        ('Strain'), 'wt' or 'ptx1'
%}

function [f0_mean,varargout] = getStressFreeBeatFreq(...
                               experiment_path,varargin)

    %% parse path
    [experiment,~] = parseExperimentPath(experiment_path);
        
    %% default
    strain = 'wt';
    
    %% check input
    if nargin>1
        temp = strcmp(varargin,'Strain'); 
        if any(temp) 
           strain = varargin{find(temp)+1}; 
        end
    end
   
    %%
    noFlowFdpth = fullfile(experiment_path,'00NoFlow');
    if exist(fullfile(noFlowFdpth,'Folder_before.mat'),'file')
        load(fullfile(noFlowFdpth,'Folder_before.mat'),...
            'flag1_f','flag2_f')
        note = 'Before applying flow';
    elseif exist(fullfile(noFlowFdpth,'Folder_after.mat'),'file')
        load(fullfile(noFlowFdpth,'Folder_after.mat'),...
            'flag1_f','flag2_f')
        note = 'After applying flow';
    else
        f0_mean = [];
        varargout = cell(nargout-1,1);
        note = 'Data unavailable';
        disp([experiment,':',note])
        return
    end
    
    %% 
    switch strain
        case 'wt'
            f0_mean = (mean(flag1_f)+mean(flag2_f))/2;
            f0_std  = (std(flag1_f)+std(flag2_f))/2;
            IPFraction = 1;
        case 'ptx1'
            %% find
            idx_IPbeating  = find(flag1_f < 60 & ...
                                  flag2_f < 60);
%             idx_APbeating  = find(flag1_f > 60 & ...
%                                   flag2_f > 60);
            %% treat
            flag1_f_IP = flag1_f(idx_IPbeating);
            flag2_f_IP = flag2_f(idx_IPbeating);
            freq_IP    = (flag1_f_IP + flag2_f_IP)/2;
%             flag1_f_AP = flag1_f(idx_APbeating);
%             flag2_f_AP = flag2_f(idx_APbeating);
%             freq_AP    = (flag1_f_AP + flag2_f_AP)/2;

            %% calc
            IPFraction = numel(idx_IPbeating)/numel(flag1_f);
%             APFraction = numel(idx_APbeating)/numel(flag1_f);

            avgFreq_IP = mean(freq_IP);
            stdFreq_IP = std(freq_IP);
% 
%             avgFreq_AP = mean(freq_AP);
%             stdFreq_AP = std(freq_AP);

            f0_mean = avgFreq_IP;
            f0_std  = stdFreq_IP;
    end      

    %% 
    switch nargout-1
        case 1
            varargout{1} = f0_std;
        case 2
            varargout{1} = f0_std;
            varargout{2} = IPFraction;
        case 3
            varargout{1} = f0_std;
            varargout{2} = IPFraction;
            varargout{3} = note;
    end
end

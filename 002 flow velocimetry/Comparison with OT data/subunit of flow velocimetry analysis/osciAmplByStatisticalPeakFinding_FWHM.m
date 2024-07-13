%% Doc
% output: [twoPeakDistance, handle_figure]
% input:  [signal,mode,plotOrNot,NoBins]
% NoBins: stands for number of bins. 
% plotOrNot: by default is 1, disable the figure output by setting it to 0
% mode: 'CFD' or 'EXP'

function [twoPeakDistance,h_fig,varargout]...
                                = osciAmplByStatisticalPeakFinding_FWHM(...
                                   signal,varargin)
    NoArgument = nargin;
    h_fig = [];
    
    sigRange = max(signal) - min(signal);
    lb   = min(signal) - sigRange/2;
    ub   = max(signal) + sigRange/2;
    switch NoArgument
        case 1
            mode =  'CFD';
            plotIt = 1;
            NoBin = 120;
        case 2
            mode =  varargin{1};
            plotIt = 1;
            NoBin = 120;
        case 3
            mode =  varargin{1};
            plotIt = varargin{2};
            NoBin = 120;
        case 4 
            mode =  varargin{1};
            plotIt = varargin{2};
            NoBin = varargin{3};
        otherwise
            error('Wrong number of inputs')
    end
    

    
    switch mode
        case 'CFD'
            MinPeakHeight = 0.01;
            MinPeakProminence = 0.005;
        case 'EXP'
            MinPeakHeight = 0.003;
            MinPeakProminence = 0.0005;
    end
    
    bin_edges   = linspace(lb,ub,NoBin);
    bin_centers = (bin_edges(1:end-1) + bin_edges(2:end))/2;
    [count_sig,~] = histcounts(signal,bin_edges,...
        'Normalization', 'probability');
    count_sig_smth = smooth(count_sig,6);
    [pks_sig,locs_sig] = findpeaks(count_sig_smth,bin_centers,...
        'MinPeakHeight',MinPeakHeight,...
        'MinPeakProminence',MinPeakProminence);
    
    %% obtain FWHM
    halfMaximum = max(count_sig_smth)/2;
    upperHalf = bin_centers(count_sig_smth>halfMaximum);
    
    
    if plotIt
%         h_fig = figure();
        h_fig = gcf;
        histogram(signal,bin_edges,'FaceAlpha',0.2,'EdgeAlpha',0.1,...
            'Normalization', 'probability'); 
        xlim([lb,ub]);
        ylabel('Probability (a.u.)'); xlabel('signal value');
        hold on 
        if length(locs_sig)>= 2
        plot([locs_sig(1),locs_sig(end)],[pks_sig(1),pks_sig(end)]*1.1,...
            'v','Color','b','MarkerFaceColor','b','MarkerSize',6);
        end
        plot(bin_centers,smooth(count_sig_smth,3),...
            '-','Color','b','LineWidth',1);
        plot([lb,ub],[halfMaximum,halfMaximum],'--')
    end
    %% Histogram as a check
    if length(locs_sig)>= 2
        twoPeakDistance     = upperHalf(end)-upperHalf(1);
        varargout{1} = locs_sig(1);
        varargout{2} = locs_sig(end);
    else
        twoPeakDistance     = [];
        varargout{1} = '';
        varargout{2} = '';
    end
end
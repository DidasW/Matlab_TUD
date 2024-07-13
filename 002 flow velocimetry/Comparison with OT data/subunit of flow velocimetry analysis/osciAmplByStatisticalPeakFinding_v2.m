%% Doc
% output: [twoPeakDistance, handle_figure]
% input:  [signal,mode,plotOrNot,NoBins]
% NoBins: stands for number of bins. 
% plotOrNot: by default is 1, disable the figure output by setting it to 0
% mode: 'CFD' or 'EXP'



function [osciAmpl,h_fig,varargout]...
                                = osciAmplByStatisticalPeakFinding_v2(...
                                   signal,Fs,varargin)
    message = '';
    h_fig = [];
    
    %% 
    NoOptArg = nargin-2;   
    sigRange = max(signal) - min(signal);
    lb   = min(signal) - sigRange/2;
    ub   = max(signal) + sigRange/2;
    switch NoOptArg
        case 0
            mode =  'CFD';
            plotIt = 1;
            NoBin = 120;
        case 1
            mode =  varargin{1};
            plotIt = 1;
            NoBin = 120;
        case 2
            mode =  varargin{1};
            plotIt = varargin{2};
            NoBin = 120;
        case 3 
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
            %% Fourier transformation and find the average frequency center
            NoP_smooth   =  12;
            [f,pow]      =  fft_mag(signal,Fs);
            pow_smooth   =  smooth(pow,NoP_smooth);
            [~,locs] = findpeaks(pow_smooth,f,'MinPeakProminence',0.4,...
                'MinPeakDistance',40);
            if isempty(locs)
                message = 'avg. sig. freq. not found';
            else
                avgFreq = locs(1);  % Hz
                avgPeriod = 1000/avgFreq; % ms
            end
            clear locs
            
            %% Find local max and min
            t_signal= make_time_series(signal,Fs,'ms');
            t_duration = t_signal(end)-t_signal(1);
            [localMax,~] = findpeaks(signal,t_signal,...
                'MinPeakDistance',avgPeriod*0.7);
            [localMin,~] = findpeaks(-signal,t_signal,...
                'MinPeakDistance',avgPeriod*0.7);
            localMin = -localMin;
            
            NoLocalMax  = numel(localMax);  
            NoLocalMin  = numel(localMin);
            NoCycExpected = t_duration/1000*avgFreq;
            allowRange = 0.03;
            
            if NoLocalMax/NoCycExpected <= 1+allowRange &&...
               NoLocalMax/NoCycExpected >= 1-allowRange &&...
               NoLocalMin/NoCycExpected <= 1+allowRange &&...
               NoLocalMin/NoCycExpected >= 1-allowRange 
                
                avgLocMax = mean(localMax);
                stdLocMax = std(localMax);
                avgLocMin = mean(localMin);
                stdLocMin = std(localMin);
                idx = 1:NoCycExpected*(0.1-allowRange);
                matrixForKWTest = ([localMax(idx),localMin(idx)]);
                p_KWtest = kruskalwallis(matrixForKWTest,[],'off');                if p_KWtest<0.001
                    osciAmpl = avgLocMax - avgLocMin;
                else
                    osciAmpl = [];
                end
            else 
                message = 'Num. of local min/max mismatch too much';
            end  
    end
    
    %% Plot it
    bin_edges   = linspace(lb,ub,NoBin);
    bin_centers = (bin_edges(1:end-1) + bin_edges(2:end))/2;
    [count_sig,~] = histcounts(signal,bin_edges,...
        'Normalization', 'probability');
    count_sig_smth = smooth(count_sig,6);
    [pks_sig,locs_sig] = findpeaks(count_sig_smth,bin_centers,...
        'MinPeakHeight',MinPeakHeight,...
        'MinPeakProminence',MinPeakProminence);
    if plotIt
%         h_fig = figure();
        h_fig = gcf;
        subplot(2,1,1)
        histogram(signal,bin_edges,'FaceAlpha',0.2,'EdgeAlpha',0.1,...
            'Normalization', 'probability');
        xlim([lb,ub]);
        hold on
        if length(locs_sig)>= 2
            plot([locs_sig(1),locs_sig(end)],[pks_sig(1),pks_sig(end)]*1.1,...
                'v','Color','b','MarkerFaceColor','b','MarkerSize',6);
            text(mean([locs_sig(1),locs_sig(end)]),...
                 mean([pks_sig(1),pks_sig(end)])*1.1,...
                 sprintf('peak distance %.2f',...
                         abs(locs_sig(1)-locs_sig(end))),...
                 'Fontsize',8);
        end
        plot(bin_centers,smooth(count_sig_smth,3),...
            '-','Color','b','LineWidth',1);
        subplot(2,1,2)
        histogram(localMax,'Normalization','probability',...
            'FaceAlpha',0.6,'EdgeColor','none'),hold on
        histogram(localMin,'Normalization','probability',...
            'FaceAlpha',0.6,'EdgeColor','none')
        text(avgLocMax,0.05,...
            {['N:',num2str(NoLocalMax)];...
             ['avg.:',num2str(avgLocMax,'%.2f')];...
             ['std.:',num2str(stdLocMax,'%.2f')]},...
             'Fontsize',8);
        text(avgLocMin,0.05,...
             {['N:',num2str(NoLocalMin)];...
             ['avg.:',num2str(avgLocMin,'%.2f')];...
             ['std.:',num2str(stdLocMin,'%.2f')]},...
             'Fontsize',8);
        yrange = get(gca,'ylim');
        text(0, yrange(2),...
             sprintf('peak distance %.2f',...
                     avgLocMax - avgLocMin),...
             'FontSize',8)
        xlim([lb,ub]);
        ylabel('Probability (a.u.)'); xlabel('signal value');
    end

    
    %% Histogram as a check
    if length(locs_sig)>= 2
        varargout{1} = locs_sig(1);
        varargout{2} = locs_sig(end);
        varargout{3} = p_KWtest;
        varargout{4} = message;
    else
        varargout{1} = '';
        varargout{2} = '';
        varargout{3} = p_KWtest;
        varargout{4} = message;
    end
end
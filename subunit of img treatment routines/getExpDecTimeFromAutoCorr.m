%% Doc
%{
This function takes any time series with given sampling frequency,
calculates its auto correlation, and fit an exponential decay function

Tip: 
    <samplingFreq_Hz> and <segmentSize_s> are a pair that together 
    determine how many elements will each segment contain. However, if
    other unit is needed, as long as they are a pair, it still works.
    e.g.: samplingFreq_kHz       -    segmentSize_ms
    e.g.: points per beat cycle  -    size of the segment in cycles.

Options:
    Two average options exist: median by default or mean. 
    e.g.: f(..,'AverageMethod','mean')

    Also, use can opt for plotting the fitting to a certain figure to see
    the fitting results.
    e.g.: f(..,'PlotTo','gca'/'New'/'No'); 'No' by default
%}
%% Function
function [A,tau,varargout] = getExpDecTimeFromAutoCorr(...
                             timeSeries,samplingFreq_Hz,...
                             segmentSize_s,varargin)
    %% Simplify variable names.
    sig     = timeSeries;
    N_sig   = numel(sig);
    sig     = reshape(sig,1,N_sig); % input made as a row vector
    Fs      = samplingFreq_Hz;
    tWin_s = segmentSize_s;
    

    method    = 'median';
    plotWhere = 'No';

    %% Configure options
    if nargin - 3 > 0
        temp = strcmp(varargin,'AverageMethod'); 
        if any(temp) 
           method = varargin{find(temp)+1}; 
        end
        
        temp = strcmp(varargin,'PlotTo'); 
        if any(temp) 
           plotWhere = varargin{find(temp)+1}; 
        end
    end
    
    %% Compute
    segSize    = tWin_s*Fs;          % how many element per segment(window)        
    segSize    = round(segSize/2)*2; % even number
    
    lb = [0,0]; 
    ub = [200, segSize/2];
    x0 = [30,1];
    
    NoSeg        = floor(N_sig/segSize);
    NoSeg_effect = NoSeg;
    
    corrMatrixForAllSeg = NaN(NoSeg,2*segSize-1);
    
    %% calc tau
    if NoSeg_effect > 0
        for i_seg = 1:NoSeg
            idx        = [(i_seg-1)*segSize+1  : i_seg*segSize];
            sample     = sig(idx);
            smoothSpan = max([5,round(0.1*Fs)]);
            sample_lpf = smooth(sample,smoothSpan);

            sample    = sample - mean(sample);
            [C,lag]   = xcorr(sample);
            t_lag     = lag/Fs;
            corrMatrixForAllSeg(i_seg,:) = C;
        end

        avg_corr   = mean  (corrMatrixForAllSeg,'omitnan');
        med_corr   = median(corrMatrixForAllSeg,'omitnan');
        
        t     = t_lag(t_lag>=0)';
        avgC  = avg_corr(t_lag>=0)';
        medC  = med_corr(t_lag>=0)';
        switch method
            case 'median'
                [A,tau,A95,tau95]   = expDecFit(t,medC/medC(1),lb,ub,x0);
                [A,A95] = deal( A * medC(1), A95 * medC(1));
                
            case 'mean'
                [A,tau,A95,tau95]   = expDecFit(t,avgC/avgC(1),lb,ub,x0);
                [A,A95] = deal( A * avgC(1), A95 * avgC(1));
            otherwise
                error('Wrong average option')
        end
    else
       [A,tau]       = deal(nan);
       [A95,tau95]   = deal(NaN(2,1));
       disp('Signal length < windowSize')
    end
    
    %% Return value   
    switch nargout
        case 3
            varargout{1} = NoSeg_effect;
        case 4
            varargout{1} = NoSeg_effect;
            varargout{2} = A95;
        case 5
            varargout{1} = NoSeg_effect;
            varargout{2} = A95;
            varargout{3} = tau95;
    end
    %% Plot
    switch plotWhere
        case {'No','no'}
        case {'gca','New','new'}
            if strcmp(plotWhere,'New') || strcmp(plotWhere,'new')
                figure();
                set(gcf,'DefaultAxesFontSize',6,...
                    'DefaultAxesFontWeight','normal',...
                    'DefaultAxesLineWidth',1.0,'Units','inches',...
                    'position',[1,2.5,3.7,3.7],...
                    'DefaultTextInterpreter','Latex');
            end
            set(gca,'defaulttextinterpreter','Latex',...
                'TickLabelInterpreter','Latex')
            hold on, grid on, box on
            
            title(sprintf('$N_{Seg}$=%d',NoSeg_effect));
            xlabel('t (s)')
            ylabel('Auto-correlation (a.u.)')
            
            if NoSeg_effect > 0
                for i_seg = 1:NoSeg
                    h_seg = plot(t_lag, corrMatrixForAllSeg(i_seg,:),'-',...
                        'color',[0.8,0.8,0.8],'LineWidth',0.5);
                end
                
                h_avg = plot(t,medC,'-o','color',[0.12, 0.21, 0.59],...
                    'MarkerFaceColor',[0.12, 0.21, 0.59],...
                    'MarkerEdgeColor','none',...
                    'LineWidth',1,'MarkerSize',2);

                h_fit = plot(t, A*exp(-t/tau),'--','LineWidth',1.5,...
                    'Color',[0.86, 0.08, 0.24]);

                legend([h_seg,h_avg,h_fit],{'Segments',method,...
                    ['$\tau$=',num2str(tau,'%.1f'),'s']},...
                    'Location','northeast','Box','off',...
                    'Interpreter','latex','FontSize',6)
                ylim  ([min(avgC),max(avgC)*1.5])
                xlim  ([0,max(t)]);
            end
    end
end
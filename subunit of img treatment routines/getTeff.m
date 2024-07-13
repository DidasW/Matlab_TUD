%% Doc
%{
This function takes any phase time series with given sampling frequency,
calculates its auto correlation, and fit an exponential decay function
to calculate the level of white noise, T_eff.

For details of the equations:
    PRL.103.168103; 
    Science vol.325, p487-490; esp. supplementary material pg.6-7;
For background knowledge: 
    Pikovsky, Synchronization, vol.II, chap. 9.1-2

Practicalities:
    The input phase time series may contain phase slips, so there is a
    threshold value to select those ones that do not contain slips. This
    threshold can also be used to select if there is entrainment at all.

    Auto-correaltion of each qualified segment will be calculated. The
    average over them will be used for exponential fitting.
    
Options:
    Setting threshold:
    e.g.: f(..,'Threshold',0.7*2*pi) 
    f is the function name; better pair it with unit specification.

    Two average options exist: median by default or mean. 
    e.g.: f(..,'AverageMethod','mean')

    Two possible phase units : [rad] by default or [1] (normalized by 2pi)
    e.g.: f(..,'PhaseUnit','1')

    Also, use can opt for plotting the fitting to a certain figure to see
    the fitting results.
    e.g.: f(..,'PlotTo','gca'/'New'/'No'); 'No' by default
%}
%% Function
function [A,tau,varargout] = getTeff(PhaseTimeSeries, SamplingFreq_Hz,...
                                     SegmentTime_ms,  varargin)
    %% Simplify variable names.
    sig     = PhaseTimeSeries;
    N_sig   = numel(sig);
    sig     = reshape(sig,1,N_sig); % input made as a row vector
    Fs      = SamplingFreq_Hz;
    tWin_ms = SegmentTime_ms;

    %% Configure options
    method    = 'median';
    plotWhere = 'No';
    threshold = 0.6*2*pi;
    unit      = '2pi';
    if ~isempty(varargin)
        temp = strcmp(varargin,'AverageMethod'); 
        if any(temp) 
           method = varargin{find(temp)+1}; 
        end
        
        temp = strcmp(varargin,'PlotTo'); 
        if any(temp) 
           plotWhere = varargin{find(temp)+1}; 
        end
        
        temp = strcmp(varargin,'PhaseUnit'); 
        if any(temp) 
           unit = varargin{find(temp)+1}; 
        end
        
        temp = strcmp(varargin,'Threshold'); 
        if any(temp) 
           threshold = varargin{find(temp)+1}; 
        end
    end
    
    if strcmp(unit,'1'); threshold = 0.7; end
    
    %% Compute
    segSize    = tWin_ms/1000*Fs;        
    segSize    = round(segSize/2)*2; % even number
    
    NoSeg        = floor(N_sig/segSize)-1;
    NoSeg_effect = NoSeg;
    
    corrMatrixForAllSeg = NaN(NoSeg,2*segSize-1);
    
    %% calc tau
    for i_seg = 1:NoSeg
        idx = segSize/2 +[(i_seg-1)*segSize+1  : i_seg*segSize];
        sample     = sig(idx);
        sample_lpf = smooth(sample,round(0.1*Fs));
        
        if max(sample_lpf)-min(sample_lpf) < threshold
            sample    = sample - mean(sample);
            [C,lag]   = xcorr(sample);
            t_lag     = lag/Fs*1000;
            corrMatrixForAllSeg(i_seg,:) = C/segSize;
        else
            NoSeg_effect = NoSeg_effect-1;
            continue
        end
    end

    if NoSeg_effect > 0
        avg_corr   = mean  (corrMatrixForAllSeg,'omitnan');
        med_corr   = median(corrMatrixForAllSeg,'omitnan');
        
        t     = t_lag(t_lag>=0)';
        avgC  = avg_corr(t_lag>=0)';
        medC  = med_corr(t_lag>=0)';
        
        switch method
            case 'median'
                meanC = medC;
            case 'mean'
                meanC = avgC;
            otherwise
                error('Wrong average option')
        end
        
        tau_expect = findCrossZero(meanC', t');
        if numel(tau_expect) >= 1
            tau_expect = tau_expect(1);
        else
            tau_expect = 20;
        end
        lb = [0.5,  0]; 
        ub = [1.5, 5*tau_expect];
        x0 = [1,    tau_expect];
        
        [A,tau,A95,tau95]   = expDecFit(t,meanC/max(meanC),lb,ub,x0);
        A = A * max(meanC);
        A95 = A95 * max(meanC);
    else
       [A,tau]       = deal(nan);
       [A95,tau95]   = deal(NaN(2,1));
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
                set(gcf,'DefaultAxesFontSize',8,...
                    'DefaultAxesFontWeight','normal',...
                    'DefaultAxesLineWidth',1.0,'Units','inches',...
                    'position',[1,2.5,3.7,3.7],...
                    'DefaultTextInterpreter','Latex');
            end
            set(gca,'defaulttextinterpreter','Latex',...
                'TickLabelInterpreter','Latex')
            hold on, grid on, box on
            
            if strcmp(unit,'1')
                unit_str = '($s^{-1}$)';
            else
                unit_str = '(rad$^2 s^{-1}$)';
            end
            title(sprintf('$N_{Seg}$=%d',NoSeg_effect));
            xlabel('t (ms)')
            ylabel(['Auto-correlation ', unit_str])
            
            if NoSeg_effect > 0
                for i_seg = 1:NoSeg
                    h_seg = plot(t_lag,...
                                 corrMatrixForAllSeg(i_seg,:),...
                                 '-','color',[0.8,0.8,0.8,0.4],'LineWidth',0.5);
                end
                
                h_avg = plot(t,meanC,'o','color',[0.12, 0.21, 0.59],...
                    'MarkerFaceColor',[0.12, 0.21, 0.59],...
                    'MarkerEdgeColor','none',...
                    'LineWidth',1,'MarkerSize',2);

                h_fit = plot(t, A*exp(-t/tau),'--','LineWidth',1.5,...
                    'Color',[0.86, 0.08, 0.24]);

                legend([h_seg,h_avg,h_fit],{'Segments',method,...
                    ['$\tau$=',num2str(tau,'%.1f'),'ms']},...
                    'Location','northeast','Box','off',...
                    'Interpreter','latex','FontSize',8)
                ylim([-max(avgC)*0.3,max(avgC)*1.5])
                xlim([0,max(t)*0.7]);
            end
    end
end
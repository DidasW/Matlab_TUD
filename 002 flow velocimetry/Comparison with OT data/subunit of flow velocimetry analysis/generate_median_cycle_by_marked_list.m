%% Doc
% Often, a median cycle with OTV signal based on time stamping of the
% synchronously taken image sequence is needed. This function take in the
% marked_list and OTV signal and output the median cycle and the
% corresponding interquatile range.

%%
function [medCyc,prc25,prc75] = generate_median_cycle_by_marked_list(...
                                    OTV_sig,marked_list,...
                                    t_1stFrame,fps,Fs,...
                                    NumCycSampled)
    if isempty(NumCycSampled)
        NoCyc = numel(marked_list)-1;
    else
        NoCyc = NumCycSampled;
    end
         
    %%
    t_OTV                = make_time_series(OTV_sig,Fs,'ms');
    t_start              = t_1stFrame; % time of frame 1 after flash
    
    %% flagella show most forward reaching shapes were labelled
    markedImgIdx = marked_list;
    markedImgIdx = sort(markedImgIdx);
    if length(markedImgIdx) - 1 <= NoCyc
        NoCyc = length(markedImgIdx) - 1;
    end
    markedImgIdx(NoCyc+2:end) = [];
    markedImgIdxInTime  = t_start + (markedImgIdx - 1)*1000/fps; %[ms]
    
    %% 
    avg_period      = median(diff(markedImgIdxInTime));
    t_phaseAvgCyc   = 0:1/Fs*1000:avg_period;
    N               = length(t_phaseAvgCyc);
    
    %% sample each marked cycle
    stampedCycles  = zeros(NoCyc,N);   
    for i_cyc  = 1:(length(markedImgIdxInTime)-1)
        t_seg_start = markedImgIdxInTime(i_cyc);
        t_seg_end   = markedImgIdxInTime(i_cyc+1);
        t_seg       = linspace(t_seg_start,t_seg_end,N); 
        OTV_sig_thisCyc     = interp1(t_OTV,OTV_sig,t_seg); 
        stampedCycles(i_cyc,:)  = OTV_sig_thisCyc;
    end
    
    %% compute median and interquartile.
    medCyc     = median(stampedCycles,1,'omitnan');
    prc25      = zeros(1,N);
    prc75      = zeros(1,N);
    for i_phase = 1:N
        prc25(i_phase) = prctile(stampedCycles(:,i_phase),25); 
        prc75(i_phase) = prctile(stampedCycles(:,i_phase),75);
    end                                                          
end

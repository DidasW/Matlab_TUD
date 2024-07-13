%% Doc
% previous version: phase_info_flow_chart.m
% * delete useless output, better function, improve BPF function
%   embed the function.
function H_Ph = calcHilbertPhase(periodicalSignal)

    sig       = periodicalSignal;
    
    %%
    flag      = smooth(smooth(sig,7,'lowess'),7);       
    % SOMEHOW THIS IS A VERY SIMPLE AND ROBUST TREATMENT BUT 
    % WORKS ALMOST OPTIMALLY. DON'T WASTE TIME PLAYING WITH IT
    % Da
    
    %%
    dif_flag  = diff(flag);   
    H1        = hilbert(dif_flag);   
    H_Ph      = angle(H1);       % Ph: Phase
end
% Compute the phase difference between the two flagella
% One may find e.g. slip, drift, or in-phase-to-anti-phase-pattern-transition 
% from the obtained phase difference.

% 2016-04-11, simplified the original code as the two input signals share
% the same sampling frequency.
% 2016-10-14, interpolation time interval is changed to 1 ms (1kHz)
 

function [t_interp,d_Ph_interp,...
            Ph_interp_1,Ph_interp_2]=compare_phase_between_flag(Ph1,Ph2,Fs)
    % signal1 and 2 are the input to extract phase
    % Fs: sampling frequency 
    t_unit = 1/Fs;
    t      = (0:length(Ph1)-1)  *  t_unit;
    t      = t';

    % Find the indices of crossing 'EVENT', in which the signal crosses x-axis
    %   from the negative side, for signal1 and 2

    idx_dif_sign_1    = find((Ph1(1:(end-1)).*Ph1(2:end)<0)); 
    idx_negative_1    = find(Ph1<0);
    idx_cross_1       = intersect(idx_dif_sign_1,idx_negative_1);

    idx_dif_sign_2  = find((Ph2(1:(end-1)).*Ph2(2:end)<0)); 
    idx_negative_2  = find(Ph2<0);
    idx_cross_2     = intersect(idx_dif_sign_2,idx_negative_2); 

    t_cross1 = t(idx_cross_1) - Ph1(idx_cross_1)*t_unit./(Ph1(idx_cross_1+1)-Ph1(idx_cross_1));
    t_cross2 = t(idx_cross_2) - Ph2(idx_cross_2)*t_unit./(Ph2(idx_cross_2+1)-Ph2(idx_cross_2));
    NoCross_1   = length(t_cross1);
    NoCross_2   = length(t_cross2);
    % NoCross-1: Number of cycles throughout the whole video
    Ph_flag_1   = 0:NoCross_1-1; %Phase flagella 
    Ph_flag_2   = 0:NoCross_2-1;

    t_interp    =  t_cross1(1):  1/1000:  t_cross1(end); %interpolate
    % t_interp is the unified time series of the two input signals
    
    Ph_interp_1   = interp1(t_cross1,Ph_flag_1,t_interp,'linear','extrap');
    Ph_interp_2   = interp1(t_cross2,Ph_flag_2,t_interp,'linear','extrap');
    d_Ph_interp = Ph_interp_1 - Ph_interp_2;
end
        
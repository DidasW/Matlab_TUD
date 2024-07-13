% Compute the phase difference between a flagellum and the background
% function interp1(t,Ph,t_finer) is used to interpolate differnt sets of
% time-phase signal (t,Ph), with a finer/unified time_scale t_finer
% 2016-10-14 modified the interpolation time scale to 1 ms  

%% Mathematical note 1 
% Together, the index means where the signal crosses the x-axis from the 
% negative side. Here we call it a "cross". Each cross event indicates the start 
% of a new cycle. t_EVENT is the linearly interpolated crossing time.


%% Mathematical note 2
% Formula simplified. Speed: ~twice, tested 20160408
% 
% Time_cross uses linear interpolate to determine a more accurate 
%   time point when EVENT happens
% For a line y = kx + b knowing that it go through (x1,y1),(x2,y2), time_cross 
%   asks to determine(x0,0) on the line, and x0 is expressed as:
%               x0 = x1 - y1(x2-x1)/(y2-y1)
% As the x2-x1 is a definite time interval, we here use a variable
%   time_interval


%% Mathematical note 3
% Since the 2nd time_cross element denotes the end of the 1st cycle
% and the 3rd the 2nd. It's easy to see that:
%              N Crosses => ( N- 1) periods
% Starting from 0, ends with (N-1), of the unit of 2pi; Phase_flag has the 
% same size as the vector t_cross, thus they can be interpolated


%% Computation
function [t_interp,d_Ph_interp,...
          Ph_flag_interp,Ph_imp_interp]= compare_with_imposed_phase(signal,Fs,f_imp)
% Signal: periodic signal resembling flagella motion
% Fs    : sampling frequency
% f_imp : imposed frequency 
% Ph    : Phase

t_unit   = 1/Fs; % time interval between two points
t_span   = (0:(length(signal)-1))  *  t_unit;
t_span   = t_span';

idx_dif_sign = find((signal(1:(end-1))...
                     .*signal(2:end)<0)); % where signal changes sign.
idx_negative = find(signal<0);            % idx: index
% See note 1
idx_cross    = intersect(idx_dif_sign,idx_negative);
t_cross      = t_span(idx_cross) - signal(idx_cross) * t_unit ./...
               (signal(idx_cross+1)-signal(idx_cross));
% See note 2
NoCross      = length(t_cross);           % NoCross: Number of Crosses
Ph_flag      = 0:NoCross-1;               % Phase flagella
% See note 3
t_imp             =     0     :(1/f_imp)  : t_cross(end)      ;
Ph_imp            =     0                 : (length(t_imp)-1) ;

t_interp          = t_cross(1):  1/1000.0 : t_cross(end)      ;

Ph_flag_interp    = interp1(t_cross, Ph_flag  ,t_interp,'linear','extrap');
Ph_imp_interp     = interp1(t_imp  , Ph_imp   ,t_interp,'linear','extrap');
d_Ph_interp       = Ph_flag_interp - Ph_imp_interp;
end


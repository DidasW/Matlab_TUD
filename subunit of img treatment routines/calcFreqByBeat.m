% Compute beating frequency as a function of cycle number

%% Computation
function [f_perCycle,cycle]= calcFreqByBeat(signal,fps)
% Signal: periodic signal resembling flagella motion
% fps   : frame rate of the signal [Hz]

t_unit   = 1/fps; % time interval between two points
t_span   = (0:(length(signal)-1))  *  t_unit;
t_span   = t_span';

idx_dif_sign = find((signal(1:(end-1))...
                     .*signal(2:end)<0)); % where signal changes sign.
idx_negative = find(signal<0);            % idx: index
% See note 1
idx_cross    = intersect(idx_dif_sign,idx_negative);
t_cross      = t_span(idx_cross) - signal(idx_cross) * t_unit ./...
               (signal(idx_cross+1)-signal(idx_cross));

t_perCycle   = t_cross(2:end) - t_cross(1:end-1); %[s]
f_perCycle   = 1./t_perCycle;                     %[Hz]
cycle        = 1:numel(f_perCycle);
           
           
end


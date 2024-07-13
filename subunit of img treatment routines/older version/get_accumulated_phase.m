% This function constructs a accumulated phase array based on the time
% series of phase.

function [accumulated_phase] = get_accumulated_phase(phase,threshold)
accumulated_phase = phase; 
dif_phase = diff(phase);
criterion = find(abs(dif_phase)>threshold);
for i = 1:length(criterion)
    accumulated_phase(criterion(i)+1:end) = accumulated_phase(criterion(i)+1:end)+ 2*pi;
end
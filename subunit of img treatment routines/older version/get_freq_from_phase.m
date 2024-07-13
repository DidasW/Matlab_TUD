% calculate instantaneous frequency based on an accumulated phase array.
% sampleing frequency of the image is needed to calculate the absolute
% frequency
% time_scale is the averging time window size to calculate "instantaneous frequncy"
function [instantaneous_frequency] = get_freq_from_phase(accu_phase,Fs,time_scale)
frame_scale = floor(time_scale/1000.0*Fs);
instantaneous_frequency = (accu_phase(1+10:end) - accu_phase(1:end-10))/(10/Fs)/(2*pi);

% calculate instantaneous frequency based on an accumulated phase array.
% sampleing frequency of the image is needed to calculate the absolute
% frequency
% time_scale is the averging time window size to calculate "instantaneous frequncy"
function [instantaneous_frequency] = get_freq_from_phase(accu_Ph,Fs,time_scale)
frame_scale = floor(time_scale/1000.0*Fs);
smoothed_accu_Ph = smooth(accu_Ph,frame_scale,'sgolay');
instantaneous_frequency = (smoothed_accu_Ph(1+frame_scale:end) -...
    smoothed_accu_Ph(1:end-frame_scale))/(frame_scale/Fs)/(2*pi);

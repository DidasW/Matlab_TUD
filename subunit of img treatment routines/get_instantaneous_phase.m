% This function constructs a parameter-free phase information based on a
% semi-periodic or periodic signal
% See reference:  Synchronization, appendix A2
%                 Estimating and Interpreting the Instantaneous Frequency
%                 of a Signal - Part1: Fundamentals, by Boualem Boashas.

function [instantaneous_phase] = get_instantaneous_phase(signal)
shifted_signal = signal-mean(signal); 
%without such subtraction the phase won't extend fully to [-pi,pi] 
H_signal = hilbert(shifted_signal);
composite_signal = shifted_signal + 1j*H_signal;
instantaneous_phase = angle(composite_signal);
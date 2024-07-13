%% Doc
%{
This function computes an absolute phase time series of the piezo stage.

After careful calibration, I found an empirical law of the piezo onset
after the flash light ends (mid-point of the falling edge),t_flashEnd:

       t_1stExtreme = t_flashEnd + 0.40 * T_piezo + t_onset

t_1stExtreme: the first maximum/minimum position in either axis that the 
    piezo reaches. Waveform starts from 0 displacement and reaches the 
    first extreme after 1/4 period

T_piezo     : period corresponds to the set frequency of the piezo. E.g.,
    set piezo to 50 Hz, T_piezo = 20 ms. The coefficient 0.40 is
    independent of direction of motion and frequency (see my journal)

t_onset     : the time piezo need to overcome its inertia before moving
    accordingly. t_onset = 4.0 ms +/- 0.9 ms, independent of direction of
    motion.

Note, all calibration are done for the flash box Arduino and LabView
software Roland developed. Till 2019-Feb-1, it is valid.

%%
t_1stExtreme is defined as the Absolute Phase Zero. 
Output:
    Ph_piezo, same shape as the input t_ref.
    It's in [rad] unit, ****NOT**** [pi] or [2pi] 
    Ph_piezo at t_1stExtreme is 0.
    After t_1stExtreme Ph_piezo linearly increase 2pi every T_piezo
    Before t_1stExtreme, Ph_piezo =0;
    
%}

function Ph_Piezo = generatePiezoPhase(t_ref,t_flashEnd,f_piezo)
     T_piezo        = 1000/f_piezo;                             % [ms]
     t_onset        = 4.0;
     t_1stExtreme   = t_flashEnd + 0.40 * T_piezo + t_onset;
     Ph_Piezo       = 2*pi*f_piezo*(t_ref - t_1stExtreme)/1000; % [rad]
     Ph_Piezo(Ph_Piezo<0) = 0;
end
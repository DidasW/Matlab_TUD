%% Doc
%{
This function generates background piezo flows of different directions. 
Time 0 is defined as the middle of the falling edge of the flash light, if
any.
Output U is compatible and tested for use in Flow_Around_Chlamy_v20190117.


CALIBRATION NOTE (same as in the function:  generatePiezoPhase.m)
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
%}

%% Function
function U = setup_piezo_flow_Da(flowDirection,flowFreq,peakSpeed,...
                                 nframes,fps)
    %% variable name simplification
    U = zeros(3,nframes);
    Ampl = peakSpeed;
    f    = flowFreq;
    
    %% calc the reference point.
    T_piezo                  = 1000/f;                        % [ms]
    t_onset                  = 4.0;                           % [ms]  
    t_1stExtremeInPosition   = 0.40 * T_piezo + t_onset;      % [ms]
    t1                       = t_1stExtremeInPosition;        % [ms]
    t                        = (0:(nframes-1))*1000/fps;      % [ms]
    % speed is zero at the first extreme in position, then oscillates
    % exactly at the set frequency
    %% NOTE
    %{
    After testing with Flow_Around_Chlamy_v20190117.m
    01XY flow: X and Y in the waveform that MCL-piezostage receives both
      oscillate as sin(2*pi*f*t). In the camera orientation that
      pipette enters from the top of the view and points down, piezostage
      first moves towards upperright, towards the cell.
    02MinXY flow: X oscillates as sin(2*pi*f*t), Y as -sin(2*pi*f*t). 
      stage motion at the beginning is towards the lowerright, away from
      the cell.
    03Axial flow: only Y oscillates as sin(2*pi*f*t), moves upwards, to
      the cell at the beginning
    04Cross flow: only X oscillates as sin(2*pi*f*t), moves to the right
      at the beginning
    
    Note: 
      Uflowb - axial   speed - speed in Y direction - relates to U(1,:)
      Vflowb - lateral speed - speed in X direction - relates to U(2,:)
    There is actually a XY inversion here.
    %}
    
    switch flowDirection
        case '00NoFlow'
            % U remains 0
        case '01XY'
            U(1,:) =  Ampl/sqrt(2) * sin(2*pi*f*(t-t1)/1000);
            U(2,:) = -Ampl/sqrt(2) * sin(2*pi*f*(t-t1)/1000);
        case '02MinXY'
            U(1,:) = -Ampl/sqrt(2) * sin(2*pi*f*(t-t1)/1000);
            U(2,:) = -Ampl/sqrt(2) * sin(2*pi*f*(t-t1)/1000);
        case '03Axial'
            U(1,:) =  Ampl         * sin(2*pi*f*(t-t1)/1000);
        case '04Cross'
            U(2,:) = -Ampl         * sin(2*pi*f*(t-t1)/1000);
        otherwise
            error('Wrong keywords for flowDirection')
    end
    
end
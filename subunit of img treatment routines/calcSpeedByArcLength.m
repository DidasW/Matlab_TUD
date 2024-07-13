%% Doc
%{
Input:
x_t, y_t: x,y coordinates of a cell's tracking. [micron]   
          N elements
Fs_Hz   : sampling rate of x,y coordinates.     [Hz]        
window_ms: the time span over which an instantaneous speed [ms]  
                                                
output:
v_t  :  instantaneous speed                     [micron/s]        
        N - round(window_ms*Fs_Hz/1000) elements
%}


function v_t = calcSpeedByArcLength(x_t,y_t,Fs_Hz,window_ms)
    N = numel(x_t);
    dt= 1000/Fs_Hz;                    % [ms]
    t = (0:N-1) * dt;                  % [ms]
    N_window   = round(window_ms/dt);
    
    %% instantaneous speed
    v_t        = zeros(N-N_window,1);
    for i = 1:N-N_window
        x_seg = x_t(i:i+N_window);
        y_seg = y_t(i:i+N_window);
        arcLen   = arclength(x_seg,y_seg);
        
        v_t(i,1) = arcLen/(N_window*dt)*1000;
    end
end
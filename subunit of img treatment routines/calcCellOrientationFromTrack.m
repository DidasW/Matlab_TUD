%% Doc
%{
Input:
x_t, y_t: x,y coordinates of a cell's tracking. [micron]   
          N elements
Fs_Hz   : sampling rate of x,y coordinates.     [Hz]        
window_ms: the time span over which an instantaneous speed [ms]  
                                                
output:

theta_t  : imagine cell as an arrow. It points from (x(t),y(t)) to
           (x(t+dt),y(t+dt)), theta_t = atan2   [rad]        
        
%}


function theta_t = calcCellOrientationFromTrack(x_t,y_t,...
                                            Fs_Hz,window_ms)
    N = numel(x_t);
    dt= 1000/Fs_Hz;                         % [ms]
        
    %% instantaneous orientation
    N_window   = round(window_ms/dt);
    theta_t        = zeros(N-N_window,1);
    
    for i = 1:N-N_window
        x0 = x_t(i);        
        y0 = y_t(i);
        x1 = x_t(i+N_window);
        y1 = y_t(i+N_window);
        theta_t(i,1) = atan2(y1-y0,x1-x0);  % [rad]
    end
    
end
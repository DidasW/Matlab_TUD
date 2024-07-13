%% Doc
%{
Input:
x_t, y_t: x,y coordinates of a cell's raw tracking. [micron]   
          N elements
Fs_Hz   : sampling rate of x,y coordinates.     [Hz]        
window_ms: the time span over which an instantaneous speed [ms]  
                                                
output:
v_vec_t: instantaneous speed                     [micron/s]        
         N - round(window_ms*Fs_Hz/1000) elements per column
         2 columns for x and y component.

%}


function v_vec_t = calcVelocity(x_t,y_t,Fs_Hz,window_ms,varargin)
    
    %% prepare constant                    
    N = numel(x_t);
    dt= 1000/Fs_Hz;                    % [ms]
    N_window   = round(window_ms/dt);
    
    %% pre-allocation
    v_vec_t     = zeros(N-N_window,2);
    for i = 1:N-N_window
        x0 = x_t(i);        
        y0 = y_t(i);
        x1 = x_t(i+N_window);
        y1 = y_t(i+N_window);
        v_vec_t(i,1) = (x1-x0)/(N_window*dt)*1000;
        v_vec_t(i,2) = (y1-y0)/(N_window*dt)*1000;
    end
    
end
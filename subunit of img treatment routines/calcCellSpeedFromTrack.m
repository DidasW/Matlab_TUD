%% Doc
%{
Input:
x_t, y_t: x,y coordinates of a cell's tracking. [micron]   
          N elements
Fs_Hz   : sampling rate of x,y coordinates.     [Hz]        
window_ms: the time span over which an instantaneous speed [ms]  
                                                
output:
v_bar:  average speed over the whole track      [micron/s]   
        1 element
v_t  :  instantaneous speed                     [micron/s]        
        N - round(window_ms*Fs_Hz/1000) elements
v_max:  peak instantaneous speed in v_t         [micron/s]  
        1 element
%}


function [v_bar,v_t,v_max] = calcCellSpeedFromTrack(x_t,y_t,...
                             Fs_Hz,window_ms)
    N = numel(x_t);
    dt= 1000/Fs_Hz;                    % [ms]
    t = (0:N-1) * dt;                  % [ms]
    
    %% average speed
    arcLen_tot = arclength(x_t,y_t,'spline');
    t_tot      = t(end);
    v_bar      = arcLen_tot/t_tot*1000;% [micron/s]
    
    %% instantaneous speed
    N_window   = round(window_ms/dt);
    v_t        = zeros(N-N_window,1);
    
    for i = 1:N-N_window
        x_seg = x_t(i:i+N_window);
        y_seg = y_t(i:i+N_window);
        arcLen   = arclength(x_seg,y_seg,'spline');
        
        v_t(i,1) = arcLen/(N_window*dt)*1000;
    end
     
    %% peak instantaneous speed
    v_max = prctile(v_t,95);
end
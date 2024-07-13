function [] = plot_ellipse(el, axis_handle, rot)
%FUNCTION PLOT_ELLIPSE Plots ellipse from fit_ellipse
%% INPUTS
%el             Ellipse structure from fit_ellipse
%axis_handle    The axis handle to plot the figure
%rot            Logical indicating whether to plot the normal (0) or
%               rotated (1) ellipse
%% CODE
    theta_r         = linspace(0,2*pi);
    
    % draw
    hold_state = get( axis_handle,'NextPlot' );
    set( axis_handle,'NextPlot','add' );
    
    if rot
        R = [ cos(el.phi) sin(el.phi); -sin(el.phi) cos(el.phi) ];
        
        ver_line        = [ [el.X0 el.X0]; el.Y0+el.b*[-1 1] ];
        horz_line       = [ el.X0+el.a*[-1 1]; [el.Y0 el.Y0] ];
        new_ver_line    = R*ver_line;
        new_horz_line   = R*horz_line;
        
        ellipse_x_r     = el.X0 + el.a*cos( theta_r );
        ellipse_y_r     = el.Y0 + el.b*sin( theta_r );
        rotated_ellipse = R * [ellipse_x_r;ellipse_y_r];
        
        plot( new_ver_line(1,:),new_ver_line(2,:),'r' );
        plot( new_horz_line(1,:),new_horz_line(2,:),'r' );
        plot( rotated_ellipse(1,:),rotated_ellipse(2,:),'r' );
    else
        ver_line        = [ [el.X0_in el.X0_in]; el.Y0_in+el.b*[-1 1] ];
        horz_line       = [ el.X0_in+el.a*[-1 1]; [el.Y0_in el.Y0_in] ];
        
        ellipse_x_0     = el.X0_in + + el.a*cos( theta_r );  
        ellipse_y_0     = el.Y0_in + el.b*sin( theta_r );
        
        plot( ver_line(1,:),ver_line(2,:),'r' );
        plot( horz_line(1,:),horz_line(2,:),'r' );
        plot( ellipse_x_0, ellipse_y_0,'r' );
    end
    set( axis_handle,'NextPlot',hold_state );
end


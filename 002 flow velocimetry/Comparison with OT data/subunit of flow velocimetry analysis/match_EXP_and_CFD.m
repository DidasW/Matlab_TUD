function  residual = match_EXP_and_CFD(fit_parameters,...
                                       sig_exp,t_exp,sig_simu,t_simu)
        factor = fit_parameters(1);
        t_shift= fit_parameters(2);
        y_shift= fit_parameters(3);
        % unit of time is always ms 
        % unit of sampling frequency is alway Hz
        % unless otherwise stated.
        t_simu_shift = t_simu + t_shift;
        t_lb         = max(min(t_exp),min(t_simu_shift));
        t_ub         = min(max(t_exp),max(t_simu_shift));
        
        % given one of the signal used in matching is limited at one end,
        % thus, when shifting them from each other to find the match of
        % the least square error, the total number of point in the valid
        % range may vary. The t_lb and t_ub are the lower and upper boudary
        % of the valid matching range.
        
        Fs           = 50000;

        t = t_lb:1/Fs*1000:t_ub; % t_ub may not be included
        N = length(t);

        sig_exp_interp = interp1(t_exp,sig_exp,t,'spline');
        sig_simu_interp= interp1(t_simu,sig_simu,t-t_shift,'spline');
        % the residual is defined as the average square residual per element 
        residual_array = (sig_exp_interp - sig_simu_interp.*factor - y_shift).^2;
        residual       = sum(residual_array)/N;
end

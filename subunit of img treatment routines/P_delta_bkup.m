%% Doc
%{
This function is derived from the pp.241 from the book Synchronization by
Pikovsky. The choise of unit is such that epsilon and niu directly have
units of Hz. Integration range is from psi-2pi to psi. The choice of the
"washboard" potential V, is:
            d_V(delta)/d_delta = nu - epsilon * sin(delta)
                    V(delta)   = nu*delta + epsilon*cos(delta)       
%}

function P = P_delta(N,T_eff,epsilon,nu,psi_0)
    psi = linspace(-pi,pi,N);
    P   = zeros(size(psi));
    [xgl,wgl] = GaussLaguerre(40,0);
    for i = 1:N
    psi_adj = psi(i) - psi_0; %_adj: adjust. 
    % This parameter centers the PDF around 0
    F1   = @(x) T_eff/nu * exp(epsilon/T_eff*(...
                cos(psi_adj - T_eff/nu*x)-cos(psi_adj)));
    P(i) = wgl'*F1(xgl);
    end
    P = P/trapz(psi,P);
end

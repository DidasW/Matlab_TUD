%% Doc
%{new P_delta function with reduced freedom in the parameter space   
%}

function P = P_delta2(N,T_eff,epsilon,nu)
    psi = linspace(-pi,pi,N);
    P   = zeros(size(psi));
    [xgl,wgl] = GaussLaguerre(40,0);
    for i = 1:N
    psi_adj = psi(i) - asin(nu/epsilon); %_adj: adjust. 
    % This parameter centers the PDF around 0
    F1   = @(x) T_eff/nu * exp(-epsilon/T_eff*(...
                cos(psi_adj + T_eff/nu*x)-cos(psi_adj)));
    P(i) = wgl'*F1(xgl);
    end
    P = P/trapz(psi,P);
end

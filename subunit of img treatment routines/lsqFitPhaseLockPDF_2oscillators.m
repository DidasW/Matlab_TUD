

%% Function

function r = lsqFitPhaseLockPDF_2oscillators(x,PhBinCenters,PDFexp)

    %% load parameters
    T_eff  = x(1);
    epsilon= x(2);
    nu     = x(3);
    
    %% calc a distribution
    % P will be normalized over [-pi,pi], with N bins
    N    = 200;
    psi  = linspace(-pi,pi,N);
    P    = P_delta2(N,T_eff,epsilon,nu);   

    %% calc the difference between
    psifit = PhBinCenters;
    Pfit   = interp1(psi,P,PhBinCenters,'spline');
    Pfit   = Pfit/trapz(psifit,Pfit);   % normalize

    squareResidual   = sum((Pfit-PDFexp).^2);
    r                = squareResidual;
end
%% Doc
%{
Return the sum of squared fitting residuals. 
1. Use the given parameters in x, 
2. Calculate theoretical phase distribution,
3. Then return the sum of residuals between the former and a given 
   experimental phase distribution.

% x: fit parameters
% x(1)      = T_eff     describes the strength of the white noise.
% x(2)      = epsilon   coupling strength of external stimuli
                        to the oscillator [Hz]
% x(3)      = f0        intrinsic/mean frequency of the oscillator [Hz]
% x(4)      = psi_0     this number is use to center the distribution to
                        phase 0
PhBinCenters :  bin centers, [-pi,pi], same size as PDFexpList
PDFexp       :  Probability Distribution Function of the experimental
                phase distribution during locking, or describing phase 
                attraction
f_imp        :  imposed frequency. The frequency of the other oscillator
                from other than f0. In our case, most often it's the piezo
                stage frequency. Will be used to calc detuning nu.
%}

%% Function

function r = lsqFitPhaseLockPDF_single(x,PhBinCenters,PDFexp,f_imp)

    %% load parameters
    T_eff  = x(1);
    epsilon= x(2);
    f0     = x(3);
    psi_0  = x(4);
    nu     = (f_imp-f0);
    
    %% calc a distribution
    % P will be normalized over [-pi,pi], with N elements
    N    = 200;
    psi  = linspace(-pi,pi,N);
    P    = P_delta(N,T_eff,epsilon,nu,psi_0);   

    %% calc the difference between
    psifit = PhBinCenters;
    Pfit   = interp1(psi,P,PhBinCenters,'spline');
    Pfit   = Pfit/trapz(psifit,Pfit);   % normalize

    squareResidual   = sum((Pfit-PDFexp).^2);
    r                = squareResidual;
end
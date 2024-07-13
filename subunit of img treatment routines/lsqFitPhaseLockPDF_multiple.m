%% Doc
%{
Return the sum of squared fitting residuals. 
1. Use the given parameters in x, 
2. Calculate A SERIES OF theoretical phase distributions
3. Return the sum of residuals between the former ones and MULTIPLE
   CORRESPONDING EXPERIMENTAL PHASE DISTRIBUTIONS

% x: fit parameters
% x(1)      = T_eff     describes the strength of the white noise.
% x(2)      = epsilon   coupling strength of external stimuli
                        to the oscillator [Hz]
% x(3)      = f0        intrinsic/mean frequency of the oscillator [Hz]
% x(4:end)  = psi_0     this number is use to center the all the input 
                        distribution around phase 0. Numel()

PhBinCenters :  bin centers, [-pi,pi], same size as PDFexpList
PDFexpList   :  Probability Distribution Functions of the experimental
                phase distributions. They share the same binEdges between 
                [-pi,pi]. format: cell
f_impList    :  imposed frequencies. format: array

See also lsqFitPhaseLockPDF_single.m for some info
%}


%% Function

function rSum = lsqFitPhaseLockPDF_multiple(...
                        x,PhBinCenters,PDFexpList,f_impList)
    %% load parameters.
    T_eff  = x(1);
    epsilon= x(2);
    f0     = x(3);
    psi_0  = x(4:end);
    
    %% calc corresponding distributions and return sum
    N    = 200;
    psi  = linspace(-pi,pi,N);
    squareResidual = 0;
    for  i = 1:numel(PDFexpList)
        nu     = (f_impList(i)-f0);
        P = P_delta(N,T_eff,epsilon,nu,psi_0(i));
        psifit = PhBinCenters;
        Pfit   = interp1(psi,P,PhBinCenters,'spline');
        Pfit   = Pfit/trapz(psifit,Pfit);   % normalize
        squareResidual = squareResidual + sum((Pfit-PDFexpList{i}).^2);
    end
    
    %%
    rSum = squareResidual; % Return the sum of residual over all 
                           % input experimental PDFs
end
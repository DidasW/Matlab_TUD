%% Doc
%{
This function wraps the fitting of y = A*exp(-x/tau) into a simpler format
Made for getting noise level from the phase fluctuation during entrainment.
%}

function [A,tau,varargout] = expDecFit(x,y,lb,ub,x0)
    
    if isempty(lb); lb = [0  ,0   ]; end
    if isempty(ub); ub = [200,1000]; end
    if isempty(x0); x0 = [30 ,10  ]; end

    fo = fitoptions('Method','NonlinearLeastSquares',...
                    'Lower',lb,'Upper',ub,...
                     'StartPoint',x0);
    ft = fittype('A*exp(-x/tau)','options',fo);
    fit_expDec = fit(x,y,ft);
    A      = fit_expDec.A;
    tau    = fit_expDec.tau;
    temp   = confint(fit_expDec);
    A_95ConfiRange   = temp(:,1); 
    tau_95ConfiRange = temp(:,2);
    clear temp
    
    switch nargout
        case 3
            varargout{1} = A_95ConfiRange;
        case 4
            varargout{1} = A_95ConfiRange;
            varargout{2} = tau_95ConfiRange;
    end
end
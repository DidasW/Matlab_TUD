function Ph_theory = calcTheoreticalPhaseByProtoPhase(Ph_proto)
    orderMax = 100;
    Ph_theory = zeros(size(Ph_proto));
    
    arrayToSum     = zeros(orderMax,1);
    for k = 1:numel(Ph_proto)
        for n = 1:orderMax
            [Sn,Sn_min]   =  calcFourierCoefOfProtophase(Ph_proto,n);
            expinTheta    = exp(1i*n*Ph_proto(k));
            arrayToSum(n) = (Sn+Sn_min/expinTheta)*(expinTheta-1)/(1i*n);
        end
        Ph_theory(k) = Ph_proto(k) + sum(arrayToSum);
    end


function [Sn,Sn_min] = calcFourierCoefOfProtophase(Ph_proto,n)
    Np               = numel(Ph_proto);
    expSeries_n      = exp(-1i*n*Ph_proto);
    expSeries_n_min  = 1./expSeries_n;
    Sn               = sum(expSeries_n)/Np;
    Sn_min           = sum(expSeries_n_min)/Np;
end
end
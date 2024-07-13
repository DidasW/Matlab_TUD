function [Sn,Sn_min] = calcFourierCoefOfProtophase(Ph_proto,n)
    Np               = numel(Ph_proto);
    expSeries_n      = exp(-1i*n*Ph_proto);
    expSeries_n_min  = 1./expSeries_n;
    Sn               = sum(expSeries_n)/Np;
    Sn_min           = sum(expSeries_n_min)/Np;
end
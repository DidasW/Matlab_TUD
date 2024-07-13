function Ph_theory = transformProtoPhase(Ph_proto)
    Np = numel(Ph_proto);
    Ph_theory = zeros(size(Ph_proto));
    for k = 1:Np
        Ph_theory(k) = Ph_proto(k)...
                    - real(sum(log(-exp(1i*Ph_proto)))/(Np*1i))...
                    + real(sum(log(-exp(1i*Ph_proto)*exp(-1i*Ph_proto(k))))/(Np*1i));
    end
end
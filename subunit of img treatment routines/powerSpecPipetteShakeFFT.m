function [f,pow] = powerSpecPipetteShakeFFT(u,v,fps,ROI)
    u  = expand_uv_from_cell(u);
    v  = expand_uv_from_cell(v);
    length_u = numel(u);
    freqSamlingRange = floor(0.2*fps:length_u-0.2*fps);
    [fu,powu] = fft_mag(u(freqSamlingRange),fps);
    [~ ,powv] = fft_mag(v(freqSamlingRange),fps);
    f = fu;pow = powu+powv;
    pow = pow(f>ROI(1)&f<ROI(2)); f = f(f>ROI(1)&f<ROI(2));
    pow = normalize_MaxToMin(pow);
end
%% Doc
%{
  Due to slight uncertainties in flagella recognition, and the rotation
  carried out by the BEM routine (Flow_Around_Chlamy_v******.m), the flow
  field and hence the force and viscous power sometimes explodes. This
  results in huge spikes usually 1-3 orders of magnitudes larger than the
  correct value

  To fix them, matlab functino isoutlier() is used. By default it looks for
  values that falls out of several times of std from the mean.

  These values are firstly identified and replaced by NaN.
  The NaNs are then replaced by interpolating from the original signal.

  The number of output will be the same as the number of inputs. Spikes in
  each Inputs will be independently fixed.
%}

%%
function varargout = fixSpikesFromBEM(varargin)
    for i_var = 1:numel(varargin)
        sig = varargin{i_var};
        N   = numel(sig);
        sizeOriginal = size(sig);
        sig = reshape(sig,N,1);
        
        
        sig(isoutlier(sig)) = NaN;
%         sig(isoutlier(abs(sig-medfilt1(sig,5)))) = NaN;
        warning off
        sig_noSpike         = interp1(1:numel(sig), sig ,...
                              1:numel(sig),'spline','extrap');
        warning on
        varargout{i_var}    = reshape(sig_noSpike,sizeOriginal);
    end
end
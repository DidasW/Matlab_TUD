function varargout = takeTheseIndices(idx_keep,varargin)
    if nargin-1 ~= nargout
        error('Input and output do not pair')
    else
        try
            for i_out = 1:nargout
                argIn = varargin{i_out};
                varargout{i_out} = argIn(idx_keep);
            end
        catch
            disp('something wrong during indexing the output')
        end
    end
end
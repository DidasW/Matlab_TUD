function mat = matrixCountFor2DScatterPoints(X,Y,xBinEdges,yBinEdges,...
                                             varargin)
    
    N_data      = numel(X);
    if N_data  ~= numel(Y)
        error('X,Y must have the same size')
    end
    
    mode = 'Count';
    if nargin > 4
        temp = strcmp(varargin,'Mode');
        if any(temp)
            mode = varargin{find(temp)+1};
        end
    end
    
    xBinCenters = (xBinEdges(1:end-1)+xBinEdges(2:end))/2;
    yBinCenters = (yBinEdges(1:end-1)+yBinEdges(2:end))/2;
    xBinSize    = xBinEdges(2) - xBinEdges(1);
    yBinSize    = yBinEdges(2) - yBinEdges(1);
    N_Bin       = numel(xBinCenters);
    mat_count   = zeros(N_Bin);  % N_Bin*N_Bin matrix
    
    for i = 1:N_data
       x  = X(i);
       y  = Y(i);
       if x == xBinEdges(1)
           idx_x = 1;
       else
           idx_x = ceil((x-xBinEdges(1))/xBinSize);
       end
       if y == yBinEdges(1)
           idx_y = 1;
       else
           idx_y = ceil((y-yBinEdges(1))/yBinSize);
       end
       
       if idx_x >= 1 && idx_x <= N_Bin &&...
          idx_y >= 1 && idx_y <= N_Bin     
           mat_count(idx_y,idx_x) = mat_count(idx_y,idx_x) + 1;
       end
    end
    
    N_dataBinned = sum(mat_count(:));
    fprintf('%.2f%% data binned\n',N_dataBinned/N_data*100);
    
    switch mode
        case {'Count','count'}
            mat = mat_count;
        case {'Probability','probability','prob'}
            mat = mat_count/N_dataBinned;
    end
end
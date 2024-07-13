function [x_patch,y_patch] = makePatch(x_low,y_low,x_high,y_high)
    
    N     = numel(x_low);

    %% shaping
    x_low = reshape(x_low,1,[]);
    y_low = reshape(y_low,1,[]);
    x_high = reshape(x_high,1,[]);
    y_high = reshape(y_high,1,[]);
    
    %% regroup to prevent crossing
    x_all = [x_low,x_high];
    y_all = [y_low,y_high];
    [~,idx_sort] = sort(y_all);
    
    y_low  = y_all(idx_sort(1:N));
    y_high = y_all(idx_sort(N+1:end));
    
    x_low  = x_all(idx_sort(1:N));
    x_high = x_all(idx_sort(N+1:end));
    
    
    %% sorting
    [~,idx_sort] = sort(x_low);
    x_low = x_low(idx_sort);
    y_low = y_low(idx_sort);

    [~,idx_sort] = sort(x_high);
    x_high = x_high(idx_sort);
    y_high = y_high(idx_sort);
    
    %% stichting
    x_patch = [x_low,fliplr(x_high)];
    y_patch = [y_low,fliplr(y_high)];

end    
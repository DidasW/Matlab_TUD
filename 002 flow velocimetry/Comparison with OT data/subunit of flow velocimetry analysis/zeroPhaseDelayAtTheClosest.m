function zeroPhaseDelayAtTheClosest(ax)
    h = findobj(ax,'type','line');
    h(~isprop(h,'experiment')) = [];
    experiments = {};
    cellCodes   = {};
    for i = 1:numel(h)
        exp_temp       = h(i).experiment;
        experiments{i} = exp_temp;
        if ~isletter(exp_temp(end)); exp_temp = exp_temp(1:end-1); end
        cellCodes{i}   = exp_temp(7:end); %#ok<*AGROW>
    end

    cellCodes = unique(cellCodes);
    NoCell    = numel(cellCodes);

    for i_cell = 1:NoCell
        cellCode = cellCodes{i_cell};
        idx_thisCell = find(contains(experiments,cellCode));
        if numel(idx_thisCell) == 1
            X = h(idx_thisCell).XData;
            Y = h(idx_thisCell).YData;
            [~,argmin] = min(X);
            [X0,Y0] = deal(X(argmin),Y(argmin));
            h(idx_thisCell).YData = Y - Y0;
            h(idx_thisCell).XData = X - X0;
        else
            X_all = [];
            Y_all = [];
            for j_exp = 1:numel(idx_thisCell)
                X_all = horzcat(X_all,h(idx_thisCell(j_exp)).XData);
                Y_all = horzcat(Y_all,h(idx_thisCell(j_exp)).YData);
            end

            [~,argmin] = min(X_all);
            [X0,Y0] = deal(X_all(argmin),Y_all(argmin));
            for j_exp = 1:numel(idx_thisCell)
                X = h(idx_thisCell(j_exp)).XData;
                Y = h(idx_thisCell(j_exp)).YData;
                h(idx_thisCell(j_exp)).XData = X - X0;
                h(idx_thisCell(j_exp)).YData = Y - Y0; 
            end
        end 
    end
end
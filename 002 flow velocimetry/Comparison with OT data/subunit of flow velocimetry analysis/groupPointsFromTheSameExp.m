h_temp = findobj(gca,'experiment',experiment);
if numel(h_temp) > 1
    X_temp = h_temp(1).XData;
    Y_temp = h_temp(1).YData;
    for j = 2:numel(h_temp)
        x_temp = h_temp(j).XData;
        y_temp = h_temp(j).YData;
        X_temp = horzcat(X_temp,x_temp);
        Y_temp = horzcat(Y_temp,y_temp);
        delete(h_temp(j));
    end
    h_temp(1).XData = X_temp;
    h_temp(1).YData = Y_temp;
end
clearvars h_temp j x_temp y_temp X_temp Y_temp
%% delete points in figure 4 with flow speed less than 2 micron/sec
threshold = 2.1e-3;
h = findobj(gca,'YData',['<',num2str(threshold)]);
N = length(h);
for i = 1:N
    N_thisobj = length(h(i).YData);
    if N_thisobj < 200 % means it is experiment
        if N_thisobj == 1
            if h(i).YData<threshold
                delete(h(i))
            end
        else 
            idx = find(h(i).YData>threshold);
            h(i).XData = h(i).XData(idx);
            h(i).YData = h(i).YData(idx);
        end
    end
end
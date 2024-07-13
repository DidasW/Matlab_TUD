%function to formulate a 2-line string, reporting the time consumption
function [report] = time_report(NoI,Fd_name,t_cost,key_word)
    report = {sprintf('%.3fs to %s %d img from Fd.:%s',...
                        t_cost, key_word, NoI, Fd_name);
              sprintf('per image: %.3fms',t_cost*1000/NoI)};
end
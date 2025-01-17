%% Doc
%{
This prepare the multiple PDFs fitting by the table generated by the
previous singlet fittings 

The table must have columns whose names are:
1.T_eff  2.epsilon 3.f0 4.psi_0  

The output will be:
x0: the initial values
lb: the lower bound 
ub: the upper bound
%}

%% Function
function[x0,lb,ub] = prepareFittingMultiplePDFs(fitSummaryTable)
    eList    = fitSummaryTable.epsilon;
    TeffList = fitSummaryTable.T_eff;
    f0List   = fitSummaryTable.f0;
    psi0List = fitSummaryTable.psi_0;
    N        = numel(psi0List); % How many fittings were there 
    
    x0   = [mean(TeffList),    mean(eList),        mean(f0List)     ]; 
    x0   = horzcat(x0,psi0List');
    
    lb   = [     0.001,          0.1,      mean(f0List)-std(f0List)];
    lb   = horzcat(lb,ones(1,N)*pi*-1);
    
    ub   = [      1.5      ,     5.5 ,     mean(f0List)+std(f0List)];
    ub   = horzcat(ub,ones(1,N)*pi   );
end
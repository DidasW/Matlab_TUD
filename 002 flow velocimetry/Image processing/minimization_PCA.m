%=========================================================================%
%---------------------------MINIMIZATION_PCA------------------------------% 
%=========================================================================%

%%%%%%%%%%%%%%%%%%%%%%%%%TRY LIMIT CYCLE SHAPES%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Principal Component Analysis is used to construct a limit cycle from
%shapes detected by the scanning algorithm only. A number of shapes
%representative for the limit cycle is tested first, the best fit serves
%as initial guess for the optimization.

%Shape scores are positive for both left and right flagella, so easy
%comparisons between phase can be made

cost_limit = zeros(length(samples));      %Vector with cost of each limit cycle shape
if debugfmc >= 1
   fprintf('Initial condition cost \n') 
end
x0 = xbase;    %x of first point
y0 = ybase;    %y of first point
for k=1:samples
    %Rotate and translate stored limit cycle shapes
    if lr == 1
        phi0 = -thetal;
        [xrot] = [xlimit(k,:); -ylimit(k,:);];
    else
        phi0 = -thetar;
        [xrot] = [xlimit(k,:); ylimit(k,:);];
    end
    xrot = R(phi0)*xrot + repmat([x0;y0;],1,nsteps+1);
    if (debugfmc >= 2) 
        if minimalgorithm == 1
%             figure(1), clf, imshow(Im,'InitialMagnification',400), hold on
%             plot(xtemp(1:index),ytemp(1:index),'bo')
            plot(xrot(1,:),xrot(2,:),'-','color',cmap(k,:)),pause(eps)
        elseif mod(k,10) == 0
            plot(xrot(1,:),xrot(2,:),'-','color',cmap(k,:)),pause(eps)
        end
    end
    if minimalgorithm == 1
        cost_limit(k) = cost_xylimit(Bdata(k,1:nmodes)',xrot,scale,lf0,...
            xlim,ylim,nmodes,princpts,ssc,FGinterp,...
            xperim_el,yperim_el,debugfmc); %Compute cost
    else
        cost_limit(k) = cost_xylimit(Blimit(k,1:nmodes)',xrot,scale,lf0,...
            xlim,ylim,nmodes,princpts,ssc,FGinterp,...
            xperim_el,yperim_el,debugfmc); %Compute cost
    end
end
ind = find(cost_limit == min(cost_limit),1,'first');

if minimalgorithm ==1
    B0 = Bdata(ind,1:nmodes)';     %Shape scores of initial guess
else
    B0 = Blimit(ind,1:nmodes)';     %Shape scores of initial guess
end
if lr == 1
    phi0 = thetal;
else
    phi0 = thetar;
end

if debugfmc ~= 0
    %Plot initial condition
    if lr == 1
        curv = -princpts(1,2:end)' - princpts(2:nmodes+1,2:end)'*B0;
        phiplot0 = thetal - princpts(1,1) - princpts(2:nmodes+1,1)'*B0;
    else
        curv = princpts(1,2:end)' + princpts(2:nmodes+1,2:end)'*B0;
        phiplot0 = thetar + princpts(1,1) + princpts(2:nmodes+1,1)'*B0;
    end
    Ytot = curv2xy_quick(curv,ssc,phiplot0,x0,y0);  %Integrate curvature to get xy

    %Plot initial condition and known points
    titstr = 'Initial condition';
    figure(2), clf, plot_debugfmc
    fprintf('Starting iterations \n')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PERFORM OPTIMIZATION%%%%%%%%%%%%%%%%%%%%%%%%%%
% Minimize (compute shape scores that minimize objective function)
% cstrt = @(B) constraint_fcn_minimization_PCA(B,scale,x0,y0,phi0,lf0,xperim_el,...
%     yperim_el,phi_body,lr,nmodes,princpts,ssc);
[Bf,fval,exitflag] = fmincon(@(B) minimize_fcn_PCA(B,...
    xlim,ylim,lf0,scale,x0,y0,phi0,xperim_el,yperim_el,phi_body,lr,nmodes,princpts,ssc,FGinterp,debugfmc)...
    ,B0,[],[],[],[],LB,UB,[],optsfmc);%cstrt,optsfmc);
%X          Variable to be manipulated: shape scores
%X0         Starting values
%A,B        Constraint: A*X =< B
%Aeq,Beq    Constraint: Aeq*X = Beq
%lb,ub      Constraint: lb =< X =< ub
%cstrt      Computes nonlinear (in)equality constraints: C(X) =< X, Ceq(X) = 0
%opts       Optimization options
%L          Minimized value of X
%fval       Value of objective function at solution X

%Display final result
if lr == 1
    curv = -princpts(1,2:end)' - princpts(2:nmodes+1,2:end)'*Bf;
    phiplot0 = thetal - princpts(1,1) - princpts(2:nmodes+1,1)'*Bf;
else
    curv = princpts(1,2:end)' + princpts(2:nmodes+1,2:end)'*Bf;
    phiplot0 = thetar  + princpts(1,1) + princpts(2:nmodes+1,1)'*Bf;
end
Ytot = curv2xy_quick(curv,ssc,phiplot0,x0,y0);  %Integrate curvature to get xy

if debugfmc ~= 0
    titstr = 'Improved fit';
    figure(3),clf, plot_debugfmc, pause
end

xtemp = Ytot(:,2);  %Write result to xtemp, ytemp
ytemp = Ytot(:,3);
stage = 1;
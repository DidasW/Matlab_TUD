function [deriv] = sg5der(vector,dtime)
%SG5DER Calculates time derivative of uniformly spaced vector "vector" with
%time step "dtime", using 5 point Savitzky-Golay differentiator

dertemp = zeros(size(vector));
dertemp(1:2) = (vector(2:3)-vector(1:2))./dtime;
dertemp(3:end-2) = (vector(4:end-1)-vector(2:end-3)+...
    2.*(vector(5:end)-vector(1:end-4)))./10./dtime;
dertemp(end-1:end) = (vector(end-1:end)-vector(end-2:end-1))./dtime;
deriv = dertemp;
end


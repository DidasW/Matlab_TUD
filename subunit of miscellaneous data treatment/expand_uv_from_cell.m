function u_array = expand_uv_from_cell(u)
if iscell(u)
    L = length(u);
    u_array = [];
    for i = 1:L
        u_temp = cell2mat(u(i));
        u_array= cat(2,u_array,u_temp);
    end
elseif ismatrix(u)
    u_array = u;
else
    u_array = [];
    disp('input is neither a cell nor an array')
end
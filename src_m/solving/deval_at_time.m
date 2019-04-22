function data = deval_at_time(solve,controls)

if solve.sol.x(end) < solve.tspan_ndim(2) - 1
    
    data.t = solve.sol.x;
    data.X = solve.sol.y;
    data.X_p = gradient(data.X);
    
else
    
    if ~isempty(controls.t_values)
        data.t = controls.t_values;
    else
        data.t = linspace(solve.tspan_ndim(1),solve.tspan_ndim(2),solve.n);
    end
    
    [data.X data.X_p] = deval(solve.sol,data.t);
    
end;

data.X = transpose(data.X);
data.X_p = transpose(data.X_p);

end
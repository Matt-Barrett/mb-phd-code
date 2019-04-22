function solve = solve_ODEs(solve,constants,params,controls)

solve.maxstep = controls.maxstep; % 0.1
solve.options_15i = odeset('maxstep',solve.maxstep);

solve.odefun = @(t,y,yp) ODEs_15i(t,y,yp,params,controls);

% for debugging
% k = ODEs_15i(solve.tspan_ndim(1),solve.X0_mod,solve.X_p0_mod,params,controls);
% solve.odefun(solve.tspan_ndim(1),solve.X0_mod,solve.X_p0_mod);

lastwarn(''); % clear last warning
s = warning('query', 'all');
warning off MATLAB:ode15i:IntegrationTolNotMet
warning off backtrace

solve.sol = ode15i(solve.odefun,solve.tspan_ndim,solve.X0_mod,solve.X_p0_mod,solve.options_15i);
% solve.sol = ode15i(solve.odefun,solve.tspan_ndim,solve.X0_mod,solve.X_p0_mod);

[lastmsg lastid] = lastwarn; % catch last warning

% try again with lower stepsize if tolerance not met
max_count = 10;
count = 1;
while ~isempty(lastid) && count<=max_count
    
    new_maxstep = solve.maxstep*2^-count; % 0.1
    solve.options_15i = odeset('maxstep',new_maxstep);
    lastwarn(''); % clear last warning
    
    if count == max_count
        warning(s);
    end;
    
    solve.sol = ode15i(solve.odefun,solve.tspan_ndim,solve.X0_mod,solve.X_p0_mod,solve.options_15i);
    
    [lastmsg lastid] = lastwarn; % catch last warning
    
    count = count+1;
    
end;

warning on backtrace
warning(s);

solve.n = controls.n_datapoints;

% if solve.sol.x(end) < solve.tspan_ndim(2) - 1
%     
%     data.t = solve.sol.x;
%     data.X = solve.sol.y;
%     data.X_p = gradient(data.X);
%     
% else
%     
%     if ~isempty(controls.t_values)
%         data.t = controls.t_values./constants.scaling.ts;
%     else
%         data.t = linspace(solve.tspan_ndim(1),solve.tspan_ndim(2),solve.n);
%     end
%     
%     [data.X data.X_p] = deval(solve.sol,data.t);
%     
% end;
% 
% data.X = transpose(data.X);
% data.X_p = transpose(data.X_p);

return;
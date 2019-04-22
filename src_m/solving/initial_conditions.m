function [constants params solve] = initial_conditions(constants,params,controls)

solve.tspan_dim = controls.tspan_dim;
solve.tspan_ndim = solve.tspan_dim/constants.scaling.ts;
ICs.t0 = solve.tspan_ndim(1);

ICs.V_guess = transpose(params.compliance.V_ss(1:3));
ICs.V_p_guess(1:3,1) = 0;

ICs.I_guess(1:4,1) = constants.ss.F_ss;
ICs.I_p_guess(1:4,1) = 0;

ICs.X0_guess = [ICs.I_guess; ICs.V_guess];
ICs.X_p0_guess = [ICs.I_p_guess; ICs.V_p_guess];

if controls.O2
    
    % Adjust for elevated baseline conditions, if necessary.
    doNewICs = ~any(isnan(constants.ss.cO2_raw2(1:end-1)));
    
    if ~doNewICs
        ICs.NO2_guess = transpose([constants.ss.cO2_raw(2:4) ...
            constants.ss.cO2_mean(end)].*[params.compliance.V_ss]);
    else
        ICs.NO2_guess = transpose([constants.ss.cO2_raw2(3:5) ...
            constants.ss.cO2_mean2(end)].*[params.compliance.V_ss]);
    end
    
    ICs.NO2_p_guess = zeros(size(ICs.NO2_guess));
    
    ICs.X0_guess = [ICs.X0_guess; ICs.NO2_guess];
    ICs.X_p0_guess = [ICs.X_p0_guess; ICs.NO2_p_guess];
    
end;

% fix any values/derivitives
ICs.fixed_X0 = zeros(size(ICs.X0_guess));
ICs.fixed_X_p0 = ones(size(ICs.X_p0_guess));

% find consistent I.C.s
ICs.test = ODEs_15i(ICs.t0,ICs.X0_guess,ICs.X_p0_guess,params,controls);

% Throw a warning when ICs are not consistent
isICsBad = max(abs(ICs.test(:))) > 1e-3;
if isICsBad
    warning('ODEs:BadICs','The initial conditions are inconsistent')
end

% An second test for consistent ICs
ICs.t0_2 = -8.5;
ICs.test2 = ODEs_15i(ICs.t0_2,ICs.X0_guess,ICs.X_p0_guess,params,controls);

% % this was changed because it sometimes gave a weird convergence error
% % for no apparent reason.  It shouldn't matter because I calculate the
% % initial conditions already.
[solve.X0_mod solve.X_p0_mod] = decic(@ODEs_15i,ICs.t0,ICs.X0_guess,...
    ICs.fixed_X0,ICs.X_p0_guess,ICs.fixed_X_p0,[],params,controls);
[solve.X0_mod solve.X_p0_mod] = deal(ICs.X0_guess,ICs.X_p0_guess);

return
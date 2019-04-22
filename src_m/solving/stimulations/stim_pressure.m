function params = stim_pressure(constants,params,controls)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%% PRESSURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch controls.pressure_type
    case 1
        params.pressure.fhandle = @smoothstep;
        params.pressure.t0 = params.pressure.t0/constants.scaling.ts;
        params.pressure.t_rise = params.pressure.t_rise/constants.scaling.ts;
%     otherwise
%         params.pressure.P_ss = params.pressure.P_ss; % mean of oscillitory pressure input (dimensionless)
end;

return;
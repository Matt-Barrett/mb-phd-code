function params = stim_vasodilation(constants,params,controls)

% %%%%%%%%%%%%%%%%%%%%%% VASODILATORY STIMULUS %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
switch controls.vasodilation_type
    case 1
        params.vasodilation.fhandle = @smoothstep;
        params.vasodilation.t0 = params.vasodilation.t0/constants.scaling.ts;
        params.vasodilation.t_rise = params.vasodilation.t_rise/constants.scaling.ts;
    case 2
        params.vasodilation.fhandle = @smoothpulse;
        params.vasodilation.t0 = params.vasodilation.t0/constants.scaling.ts;
        params.vasodilation.t_rise = params.vasodilation.t_rise/constants.scaling.ts;
        params.vasodilation.t_stim = params.vasodilation.t_stim/constants.scaling.ts;
    case 3
        params.vasodilation.fhandle = @smoothstepdownup;
        params.vasodilation.t0 = params.vasodilation.t0/constants.scaling.ts;
        params.vasodilation.t_rise = params.vasodilation.t_rise/constants.scaling.ts;
        params.vasodilation.t_diff = params.vasodilation.t_diff/constants.scaling.ts;
    case 4
        params.vasodilation.fhandle = @negexp;
        params.vasodilation.t0 = params.vasodilation.t0/constants.scaling.ts;
        params.vasodilation.t_stim = params.vasodilation.t_stim/constants.scaling.ts;
        params.vasodilation.tau = params.vasodilation.tau/constants.scaling.ts;
        params.vasodilation.t_rise = params.vasodilation.t_rise/constants.scaling.ts;
    case 5
        params.vasodilation.fhandle = @buxtonstim;
        params.vasodilation.t0 = params.vasodilation.t0/constants.scaling.ts;
        params.vasodilation.t_rise = params.vasodilation.t_rise/constants.scaling.ts;
        params.vasodilation.t_stim = params.vasodilation.t_stim/constants.scaling.ts;
        params.vasodilation.tau = params.vasodilation.tau/constants.scaling.ts;
    case 6
        params.vasodilation.fhandle = @levystim;
        params.vasodilation.t0 = params.vasodilation.t0/constants.scaling.ts;
        params.vasodilation.t_rise = params.vasodilation.t_rise/constants.scaling.ts;
        params.vasodilation.t_stim = params.vasodilation.t_stim/constants.scaling.ts;
        params.vasodilation.tau_active = params.vasodilation.tau_active/constants.scaling.ts;
        params.vasodilation.tau_passive = params.vasodilation.tau_passive/constants.scaling.ts;
        
        isFunA_peak = isa(params.vasodilation.A_peak,'function_handle');
        if isFunA_peak
            params.vasodilation.A_peak = params.vasodilation.A_peak(...
                params.vasodilation.A_ss);
        end
        
    case 7
        params.vasodilation.fhandle = @vazquez_stim;
        params.vasodilation.step.t0 = params.vasodilation.step.t0/constants.scaling.ts;
        params.vasodilation.step.t_rise = params.vasodilation.step.t_rise/constants.scaling.ts;
        params.vasodilation.levy.t0 = params.vasodilation.levy.t0/constants.scaling.ts;
        params.vasodilation.levy.t_rise = params.vasodilation.levy.t_rise/constants.scaling.ts;
        params.vasodilation.levy.t_stim = params.vasodilation.levy.t_stim/constants.scaling.ts;
        params.vasodilation.levy.tau_active = params.vasodilation.levy.tau_active/constants.scaling.ts;
        params.vasodilation.levy.tau_passive = params.vasodilation.levy.tau_passive/constants.scaling.ts;
    case 8
        params.vasodilation.fhandle = @devorstim;
        params.vasodilation.t0 = params.vasodilation.t0/constants.scaling.ts;
        params.vasodilation.t_stim = params.vasodilation.t_stim/constants.scaling.ts;
        params.vasodilation.tau_d = params.vasodilation.tau_d/constants.scaling.ts;
        params.vasodilation.tau_c = params.vasodilation.tau_c/constants.scaling.ts;
    case 9
        params.vasodilation.fhandle = @pulse_exp;
        params.vasodilation.t0 = params.vasodilation.t0/constants.scaling.ts;
        params.vasodilation.t_stim = params.vasodilation.t_stim/constants.scaling.ts;
        params.vasodilation.t_rise = params.vasodilation.t_rise/constants.scaling.ts;
        params.vasodilation.tau_passive = params.vasodilation.tau_passive/constants.scaling.ts;
end;

return;
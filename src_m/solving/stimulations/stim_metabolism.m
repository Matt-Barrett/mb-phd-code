function params = stim_metabolism(constants,params,controls)

% %%%%%%%%%%%%%%%%%%%%%% METABOLIC STIMULUS %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
switch controls.metabolism_type
    case 1
        params.metabolism.fhandle = @smoothstep;
        params.metabolism.t0 = params.metabolism.t0/constants.scaling.ts;
        params.metabolism.t_rise = params.metabolism.t_rise/constants.scaling.ts;
    case 2
        params.metabolism.fhandle = @smoothpulse;
        params.metabolism.t0 = params.metabolism.t0/constants.scaling.ts;
        params.metabolism.t_rise = params.metabolism.t_rise/constants.scaling.ts;
        params.metabolism.t_stim = params.metabolism.t_stim/constants.scaling.ts;
    case 3
        params.metabolism.fhandle = @smoothstepdownup;
        params.metabolism.t0 = params.metabolism.t0/constants.scaling.ts;
        params.metabolism.t_rise = params.metabolism.t_rise/constants.scaling.ts;
        params.metabolism.t_diff = params.metabolism.t_diff/constants.scaling.ts;
    case 6
        params.metabolism.fhandle = @levystim;
        params.metabolism.t0 = params.metabolism.t0/constants.scaling.ts;
        params.metabolism.t_rise = params.metabolism.t_rise/constants.scaling.ts;
        params.metabolism.t_stim = params.metabolism.t_stim/constants.scaling.ts;
        params.metabolism.tau_active = params.metabolism.tau_active/constants.scaling.ts;
        params.metabolism.tau_passive = params.metabolism.tau_passive/constants.scaling.ts;
        
        isFunA_peak = isa(params.metabolism.A_peak,'function_handle');
        if isFunA_peak
            params.metabolism.A_peak = params.metabolism.A_peak(...
                params.metabolism.A_ss);
        end
        
        hasScale = isfield(params.metabolism,'scale') && ...
            ~isempty(params.metabolism.scale);
        if hasScale
            
            params.metabolism.A_peak = params.metabolism.scale.*...
                params.metabolism.A_peak;
            params.metabolism.A_ss = params.metabolism.scale.*...
                params.metabolism.A_ss;
            
            % Clear the scale so it doesn't unscale later;
            params.metabolism.scale = [];
            
        end
        
    case 7
        params.metabolism.fhandle = @linearpulse;
        params.metabolism.t0 = params.metabolism.t0/constants.scaling.ts;
        params.metabolism.t_rise = params.metabolism.t_rise./constants.scaling.ts;
        params.metabolism.t_stim = params.metabolism.t_stim./constants.scaling.ts;
    case 9
        params.metabolism.fhandle = @pulse_exp;
        params.metabolism.t0 = params.metabolism.t0/constants.scaling.ts;
        params.metabolism.t_stim = params.metabolism.t_stim/constants.scaling.ts;
        params.metabolism.t_rise = params.metabolism.t_rise/constants.scaling.ts;
        params.metabolism.tau_passive = params.metabolism.tau_passive/constants.scaling.ts;
        
end;

return;
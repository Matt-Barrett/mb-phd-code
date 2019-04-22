function params = stim_o2concin(constants,params,controls)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%% PRESSURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch controls.o2concin_type
    case 1
        
        params.o2concin.fhandle = @smoothstep;       
        params.o2concin.t0 = params.o2concin.t0/constants.scaling.ts;
        params.o2concin.t_rise = params.o2concin.t_rise/constants.scaling.ts;
        
    case 2
        
        params.o2concin.fhandle = @smoothpulse;
        params.o2concin.t0 = params.o2concin.t0/constants.scaling.ts;
        params.o2concin.t_rise = params.o2concin.t_rise/constants.scaling.ts;
        params.o2concin.t_stim = params.o2concin.t_stim/constants.scaling.ts;
        
    otherwise
        
        params.o2concin.cO2_in = 1;
        
end;
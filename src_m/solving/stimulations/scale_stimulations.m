function params = scale_stimulations(dir,constants,params,controls)

switch dir
    case {'scale'}
        % do nothing, will scale by default
    case {'unscale'}
        % invert scaling constant to unscale
        constants.scaling.ts = 1/constants.scaling.ts;
    otherwise
        % no option specifed
end;

% (Non)dimensionalise stimulation times
params = stim_vasodilation(constants,params,controls);
params = stim_metabolism(constants,params,controls);
params = stim_pressure(constants,params,controls);
params = stim_o2concin(constants,params,controls);

end
function y = levystim(t,params)


doStepUp = true;
doActive = true;
doPassive = true;

isScalar = isscalar(t);
if isScalar
    
    if t < params.t0
        
        y = 0;
        return
        
    else
    
        doStepUp = (t >= params.t0) && (t < params.t0 + params.t_rise);

        doActive = (t >= params.t0 + params.t_rise) && ...
            (t < params.t0 + params.t_stim);

        doPassive = (t >= params.t0 + params.t_stim);
    
    end
    
end

doSkipActive = params.t_stim < params.t_rise;

%% Active decay

if doStepUp || doSkipActive
    
    step_up.t0 = params.t0;
    step_up.t_rise = params.t_rise;
    step_up.A = params.A_peak;
    
end

if doActive || doPassive || ~doSkipActive
    
    A_active = params.A_peak - params.A_ss;
    t0_active = params.t0 + params.t_rise;
    tau_active = params.tau_active;
    
end

if doSkipActive
    
    yf = smoothstep(params.t0+params.t_stim,step_up);
    maskStepUp = (t >= params.t0) & (t < params.t0 + params.t_stim);
    
else
    
    yf = decay(params.t0+params.t_stim,A_active,t0_active,tau_active) + ...
        params.A_ss;
    maskStepUp = (t >= params.t0) & (t < params.t0 + params.t_rise);
    
end
    
if doActive || doPassive
    
    maskActive = (t >= params.t0 + params.t_rise) & ...
        (t < params.t0 + params.t_stim);
    y_active = decay(t,A_active,t0_active,tau_active) + params.A_ss;
    y_active = y_active.*maskActive;
    
else
    
    y_active = zeros(size(t));
    
end

%% Step Up

if doStepUp
    
    y_step_up = smoothstep(t,step_up);
    y_step_up = y_step_up.*maskStepUp;
    
else
    
    y_step_up = zeros(size(t));
    
end

%% Passive Decay

if doPassive
    
    t0_passive = params.t0 + params.t_stim;
    tau_passive = params.tau_passive;
    
    % calculate then mask y_passive
    maskPassive = t >= params.t0+params.t_stim;
    y_passive = decay(t,yf,t0_passive,tau_passive);
    y_passive = y_passive.*maskPassive;
    
else
    
    y_passive = zeros(size(t));
    
end

%% Combine the three phases

y = y_step_up + y_active + y_passive;

end

function yDecay = decay(t,A,t0,tau)

% Exponential decay function that's reused in a few places
yDecay = A.*exp(-(t - t0)./tau);

end
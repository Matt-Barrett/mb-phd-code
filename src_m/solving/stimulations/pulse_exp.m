function y = pulse_exp(t,params)

% Do everything by default, unless overridden later
doStepUp = true;
doMiddle = true;
doDecay = true;

% Setup some dummy variables
t_peak = params.t0 + params.t_rise;
tf = params.t0 + params.t_stim;

% If the input is scalar, we can skip a bunch of unnecessary steps
isScalar = isscalar(t);
if isScalar
    
    if t < params.t0
        
        % We can skip everything if 
        y = 0;
        return
        
    else
        
        % Work out which steps we need to do
        doStepUp = (t >= params.t0) && (t < t_peak);
        doMiddle = (t >= params.t0 + params.t_rise) && (t < tf);
        doDecay = (t >= tf);
    
    end
    
end

% Create an empty value once to save function calls later
emptyVal = zeros(size(t));

%% Step up

if doStepUp
    
    % Setup the step up parameters
    step_up.t0 = params.t0;
    step_up.t_rise = params.t_rise;
    step_up.A = params.A_ss;
    
    % Calculate the error function based smooth step up
    yStepUp = smoothstep(t,step_up);
    
    % Mask out unwanted values, if necessary
    if ~isScalar
        tStop = min([t_peak,tf]);
        maskStepUp = (t >= params.t0) & (t < tStop);
        yStepUp = yStepUp.*maskStepUp;
    end
    
else
    
    yStepUp = emptyVal;
    
end


%% Middle Plateau

if doMiddle
        
    % Calculate the error function based smooth step up
    yMiddle = params.A_ss;
    
    % Mask out unwanted values, if necessary
    if ~isScalar
        maskMiddle = (t >= t_peak) & (t < tf);
        yMiddle = yMiddle.*maskMiddle;
    end
    
else
    
    yMiddle = emptyVal;
    
end

%% Passive Decay

if doDecay
    
    % Calculate the yf value required for the exponential decay
    doSkipMiddle = params.t_stim < params.t_rise;
    if ~doSkipMiddle
        yf = params.A_ss;
    else
        yf = smoothstep(params.t0+params.t_stim,step_up);
    end
    
    % Calculate passive exponential decay
    yDecay = yf.*exp(-(t - tf)./params.tau_passive);
    
    % Mask out unwanted values, if necessary
    if ~isScalar
        maskDecay = t >= tf;
        yDecay = yDecay.*maskDecay;
    end
    
else
    
    yDecay = emptyVal;
    
end

%% Combine the three phases

y = yStepUp + yMiddle + yDecay;

end
function params = calculate_gO2(constants,params)

%% Unwrap constants for ease of calculating
fss = constants.ss.F_ss;

c01 = constants.ss.cO2_raw(1);
c12 = constants.ss.cO2_raw(2);
c23 = constants.ss.cO2_raw(3);
c34 = constants.ss.cO2_raw(4);

p1 = constants.ss.pO2_mean(1);
p2 = constants.ss.pO2_mean(2);
p3 = constants.ss.pO2_mean(3);
pt = constants.ss.pO2_mean(4);

%% Determine the feasible range for GO2_shunt

maxGs = fss.*(c01-c12)./(p1-p3);

isPositive = p3-pt > 0;

if isPositive
    
    minGs = -fss.*(c23-c34)./(p1-p3);
    
    if minGs < 0
        
        minGs = 0;
        
    elseif minGs > maxGs
        
        maxGs = 0;
        minGs = 0;
        warning('CalculateGO2:NoShunt',['No feasible set of diffusion ' ...
            'constants exists.  Continuing with no shunt.'])
        
    end
    
else
    
    maxGs = min([maxGs -fss.*(c23-c34)./(p1-p3)]);
    minGs = 0;
    
    if maxGs < 0
        
        maxGs = 0;
        warning('CalculateGO2:NoShunt',['No feasible set of diffusion ' ...
            'constants exists.  Continuing with no shunt.'])
        
    end
    
end

rangeGs = maxGs-minGs;

%% Calculate the parameters
gs = minGs+constants.ss.normk*rangeGs;
params.main.gO2_shunt = gs;
params.main.gO2_shunt_range = [minGs maxGs];

params.main.gO2(1) = (fss.*(c01-c12) - gs*(p1 - p3))/(p1 - pt);
params.main.gO2(2) = fss.*(c12-c23)./(p2 - pt);
params.main.gO2(3) = (fss.*(c23-c34) + gs*(p1 - p3))/(p3 - pt);

%% Display warning for negative GO2 values
isNegativeG = [params.main.gO2 params.main.gO2_shunt] < 0;
if any(isNegativeG)
    warning('CalculateGO2:NegativeGO2',['One or more GO2 values is '...
        'negative.'])
end
    
end
function y = smoothstep(t,params)

% % input params
% params.t0 = 5;
% params.t_rise = 1;
% params.A = 0.5;

% calculate equation parameters
mu = params.t0 + 0.5*params.t_rise;
sigma = params.t_rise/8;

y = params.A*(0.5*(1 + erf((t - mu)/(sqrt(2)*sigma))));
    
return;
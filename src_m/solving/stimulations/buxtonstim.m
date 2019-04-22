% function y = buxtonstim(t,params)

% input parameters
params.t0 = 5;
params.t_rise = [1 1];
params.t_stim = 5;
params.tau = 2;
params.A_ss = 0.5;
params.A_peak = 1;

t = 0:0.1:15;

pulse.t0 = params.t0;
pulse.t_rise = params.t_rise;
pulse.t_stim = params.t_stim;
pulse.A = params.A_ss;

exp.t0 = params.t0;
exp.t_stim = params.t_stim;
exp.tau = params.tau;
exp.t_rise = params.t_rise;
exp.A = params.A_peak - params.A_ss;

y_pulse = smoothpulse(t,pulse);
y_negexp = negexp(t,exp);

y = y_pulse + y_negexp;

plot(t,y)

% return;
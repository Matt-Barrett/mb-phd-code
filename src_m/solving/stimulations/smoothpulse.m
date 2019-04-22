function y = smoothpulse(t,params)

% % input params
% params.t0 = 5;
% params.t_stim = 10;
% params.t_rise = 1;
% params.A = 0.6;

% up
up.t0 = params.t0;
up.t_rise = params.t_rise(1);
up.A = params.A;

% down
down.t0 = params.t0 + params.t_stim;
down.t_rise = params.t_rise(2);
down.A = -params.A;

y_up = smoothstep(t,up);
y_down = smoothstep(t,down);

y = y_up + y_down;

return;
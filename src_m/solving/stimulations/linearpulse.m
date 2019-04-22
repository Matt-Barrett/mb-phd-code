function y = linearpulse(t,params)

% params.t0 = 5;
% params.t_rise = [1 5];
% params.t_stim = 5;
% params.A = [1 2];

% up
up.t0 = params.t0;
up.t_rise = params.t_rise(1);
up.A = params.A(1);
y_up = smoothstep(t,up);

% linear
linear = @(t,m) m*t;
m = (params.A(2) - params.A(1))/(params.t_stim - params.t_rise(1));
y_linear = (t>=params.t0+params.t_rise(1) & t<params.t0+params.t_stim)...
    .*linear(t-params.t0-params.t_rise(1),m);

% down
down.t0 = params.t0 + params.t_stim;
down.t_rise = params.t_rise(2);
down.A = -params.A(2);
y_down = smoothstep(t,down) + (t>=params.t0+params.t_stim).*(params.A(2) - params.A(1));

y = y_up + y_linear + y_down;

% figure
% hold on
% plot(t,y,'k')
% plot(t,y_up,'r')
% plot(t,y_linear,'g')
% plot(t,y_down,'b')

return;
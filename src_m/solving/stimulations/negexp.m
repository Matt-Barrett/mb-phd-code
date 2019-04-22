function y = negexp(t,params)

% % input params
% params.t0 = 5;
% params.t_stim = 10;
% params.tau = 1;
% params.t_rise = 0.1;
% params.A = 2;

% t = 0:0.1:20;

tf = params.t0 + params.t_stim + params.t_rise;

eval_negexp = @(t) params.A.*(exp(-(t - params.t0-params.t_rise)/params.tau)-1);

up.t0 = params.t0;
up.t_rise = params.t_rise;
up.A = params.A;

down.t0 = params.t0+params.t_stim;
down.t_rise = params.t_rise;
down.A = -params.A - eval_negexp(down.t0);

y_up = (t>=params.t0 & t<=tf).*smoothstep(t,up);
y_negexp = (t>=params.t0+params.t_rise & t<down.t0).*eval_negexp(t);
y_down = (t>=down.t0 & t<=tf).*(smoothstep(t,down)+eval_negexp(down.t0));

y = y_up + y_negexp + y_down;

% figure, plot(t,y)

end



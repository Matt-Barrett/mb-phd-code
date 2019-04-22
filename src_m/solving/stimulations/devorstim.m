function y = devorstim(t,params)

% % input params
% clear all
% params.t0 = 0;
% params.t_stim = 30;
% t = -5:0.2:50;
% 
% params.tau_d = 0.5;
% params.tau_c = 3;
% params.A = 6;
% params.B = -3;

up = @(t,tau) 1 - exp(-(t-params.t0)./tau);
down =  @(t,tau) up(params.t_stim,tau).*exp(-(t-(params.t0+params.t_stim))./tau);

mask_up = (t>=params.t0 & t<(params.t0+params.t_stim));
mask_down = (t>=(params.t0+params.t_stim));

y_d = params.A.*(mask_up.*up(t,params.tau_d) + ...
    mask_down.*down(t,params.tau_d));
y_c = params.B.*(mask_up.*up(t,params.tau_c) + ...
    mask_down.*down(t,params.tau_c));

y = y_d + y_c;

% figure, hold on
% plot(t,y_d,'b')
% plot(t,y_c,'r')
% plot(t,y,'k')

end
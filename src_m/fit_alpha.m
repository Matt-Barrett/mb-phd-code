 function [alpha_data resnorm fit_data] = fit_alpha(fit_data,data)
        
warning off optim:fminunc:SwitchingMethod

alpha0 = 0.38;
%         global alpha_guess
alpha_data = zeros(1,size(fit_data.V_ss,1));
resnorm = zeros(size(alpha_data));
fit_data.V_grubb = zeros(size(fit_data.V_ss));
options = optimset('Display', 'off');

for i =1:size(fit_data.V_ss,1)

    % Create objective function
    find_residuals = @(alpha_var) fit_data.F_ss.^alpha_var - ...
        fit_data.V_ss(i,:)./data(1).V(1,i); % power law
%             find_residuals = @(alpha_var) (fit_data.F_ss-1).*alpha_var...
%                 + 1 - fit_data.V_ss(4,:); % linear

    % Optimise for alpha
    [alpha_data(i) resnorm(i)] = lsqnonlin(find_residuals,...
        alpha0,[],[],options);

    % Calculate best fit predictions
    fit_data.V_grubb(i,:) = fit_data.F_ss.^alpha_data(i); % power law
%             fit_data.V_grubb = (F_ss-1).*alpha+1; % linear

end;

warning on optim:fminunc:SwitchingMethod

end
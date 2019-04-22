function [default composite override] = process_optimal(history,problem,...
                                                        repeats,override)
    
%%%%%%%%%%%%%%%%% Sort out how this displays

% output 'composite' as per manipulate_nu_history
composite(:,1) = transpose([history.fval_opt]);
composite(:,2) = transpose([history.exitflag]);
composite(:,3) = transpose(1:length(composite(:,1)));
composite = [composite ...
    transpose(reshape([history.x_opt],[],size(composite,1)))];
% sort these by RMS
[temp order] = sort(composite(:,1)); clear temp
composite = composite(order,:);

% rewrite to ensure minimum fval from each run is the last value
% exclude non-finished or error simulations based on exitflag?
%     [temp idx] = min(); clear temp

disp(' ')
disp(['Best value for ' problem ' = ' num2str(composite(1,4:end))])
disp(['RMS = ' num2str(composite(1,1)) ', taken from run ' ...
    num2str(composite(1,3)) ' of ' num2str(repeats)])
disp(' ')

default = history(order(1)).default;

[override default] = assign_optimal(problem,history,composite,...
                                        default,override);
    
end
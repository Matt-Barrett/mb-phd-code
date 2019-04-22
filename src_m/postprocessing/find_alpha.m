function [StatsOpt StatsFull StatsStd StatsMean StatsMed] = find_alpha(...
                    Default,Data,Constants,Params,Controls)
             
% Assumes Default and Data are the correct (matching) sizes
nRuns = length(Default);

% Loop through all the runs as there's no 'vectorised' way of extracting 
% out the alpha values.
for kRun = 1:nRuns

%     % Produce the necessary structures from the appropriate
%     % default settings.
%     [Constants Params Controls] = setup_problem(Default(kRun),...
%                                                 'flow_volume_loop');

    % Extract the F-V data from the simulations
    [fit_data Data(kRun,1)] = extract_FV(Constants,Params,...
                                    Controls,Data(kRun,1));

    % Produce the alpha value.
    StatsFull.alpha(1,:,kRun) = fit_alpha(fit_data,Data(kRun,1));

end

[StatsOpt StatsFull StatsStd StatsMean StatsMed] = ...
                                                process_stats(StatsFull);

end
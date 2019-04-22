function y_diff = calculate_stim_bounds(flowRange,nSteps,...
                                            Constants,Params,Controls)

% The name of the relevant simulation as in setup_problem.
SIM = 'find_stim';

% Create new default structures for the find_stim simulation by calling
% setup_problem recursively.
[Constants Params Controls] = setup_problem(SIM,Constants,Params,Controls);

% Calculate the lower bound on the vasodilatory stimulus
S_bound(1) = find_stim_bound(flowRange(1),Constants,Params,Controls); 

% Calculate the upper bound on the vasodilatory stimulus
S_bound(2) = find_stim_bound(flowRange(2),Constants,Params,Controls); 

% Setup the flow volume loop vasodilatory stimulus by linearly spacing the
% correct number of jumps between the bounds just calculated above.
y_diff = abs(S_bound)./nSteps;

end


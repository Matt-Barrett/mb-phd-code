function [Constants Params Data Solve] = ...
                        solve_problem(Constants,Params,Controls,varargin)

% setup flag for solving
skipSolve =  ~isempty(varargin) && isstruct(varargin{1});

if ~skipSolve

    % determine steady states
    [Constants Params] = steady_state(Constants,Params,Controls);

    % define initial conditions
    [Constants Params Solve] = initial_conditions(Constants,Params,Controls);

    % solve problem
    Solve = solve_ODEs(Solve,Constants,Params,Controls);
    
else
    
    Solve = varargin{1};
    
end
    
% evaluate solution at desired times
Data = deval_at_time(Solve,Controls);

% perform calculations
[Params Data] = calculate_results(Data,Constants,Params,Controls);   

end
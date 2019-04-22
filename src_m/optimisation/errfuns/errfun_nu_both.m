function residuals = errfun_nu_both(vary,ObjData,Constants,Params,Controls)

% The variables we're using from the experimental data.
DATA_ORDER = {'F','V'};

% The column in the calculated data corresponding to the variable in
% DATA_ORDER.
IDX_ORDER = [5 4];

% Reformat/rename data passed in from base function.
DataObs = ObjData.data_obs;
scaling = ObjData.scaling;
vary = vary.*scaling;

[nSims nReps] = size(DataObs);

% Initialise residuals.
residuals = [];

% Loop through each simulation (i.e. Mandeville 6s and 30s)
for iSims = 1:nSims
    
    % setup/extract variable parameters
    Params(iSims).compliance.nu = vary(1:3);
    Params(iSims).vasodilation.tau_active = vary(4);
    Params(iSims).vasodilation.A_ss = vary(5);
    Params(iSims).vasodilation.A_peak = vary(6);

    % Setup tspan to solve simulations over.  This corresponds to the
    % maximum tspan that we have data for (either flow or volume) for each
    % simulation  that is being run.
    Controls(iSims).tspan_dim = [min([min(DataObs(iSims,1).t)...
                                        min(DataObs(iSims,2).t)]) ...
                                 max([max(DataObs(iSims,1).t)...
                                        max(DataObs(iSims,2).t)])];
    
    % Loop through each repeat for a given simulation (i.e. F and V)
    for jReps = 1:nReps
        
        % Setup tspan t-values to Solve simulations at
        Controls(iSims).t_values = DataObs(iSims,jReps).t./...
                                        Constants(iSims).scaling.ts;
        
        if jReps == 1
            
            % Go through full solution procedure for first run
            [Constants(iSims) Params(iSims)...
             DataPred(iSims,jReps) Solve(iSims)] = ...
                        solve_problem(Constants(iSims),...
                                      Params(iSims),Controls(iSims)); 
        
        else
            
            % Use the same simulation output, only changing the points
            % at which the results are evaluated for the second run.
            [Constants(iSims) Params(iSims) DataPred(iSims,jReps)] = ...
                        solve_problem(Constants(iSims),Params(iSims),...
                                      Controls(iSims),Solve(iSims));
            
        end;
                
        %
        try 
            
            % Calculate residuals, normalising them to ensure fair 
            % comparison between each simulation and flow and volume.
            residuals = [residuals; ...
                        (1+DataObs(iSims,jReps).(DATA_ORDER{jReps}) - ...
                            DataPred(iSims,jReps).(DATA_ORDER{jReps})...
                                (:,IDX_ORDER(jReps)))./...
                        (max(DataObs(iSims,jReps).(DATA_ORDER{jReps})) - ...
                            min(DataObs(iSims,jReps).(DATA_ORDER{jReps})))];
                        
        catch
            
            % Give the solver another opportunity to correct for a set of
            % parameters that caused the ODE solver to fail.
            residuals = [residuals; ...
                nan(size(DataObs(iSims,jReps).(DATA_ORDER{jReps})))];
            
        end
        
    end
end;

% Reduce the results to a scalar for fminsearch or fmincon
residuals = norm(residuals);

end
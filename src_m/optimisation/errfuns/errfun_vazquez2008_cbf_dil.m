function residuals = errfun_vazquez2008_cbf_baseline(vary,ObjData,...
                                                Constants,Params,Controls)

% Reformat/rename data passed in from base function.
vazquez2008 = ObjData.data_obs;
scaling = ObjData.scaling;
vary = vary.*scaling;

% FOR DEBUGGING ONLY
% vary = [7];

nSims = 2;
DataObs.F = vazquez2008.baseline.F;

% Initialise residuals.
residuals = [];

% Loop through each simulation (i.e. Mandeville 6s and 30s)
for iSims = 1:nSims
    
    % setup/extract variable parameters
    Params(iSims).vasodilation.step.A = vary(1);

    % Setup tspan to solve simulations over.  This corresponds to the
    % maximum tspan that we have data for (either flow or volume) for each
    % simulation  that is being run.
        
    % Vasodilated case
    Controls(iSims).t_values = Params.vasodilation.levy.t0;
    Controls(iSims).tspan_dim(2) = ...
        max(Controls(iSims).t_values);
        
        
    % Scale the t-values to solve simulations at.
    Controls(iSims).t_values = Controls(iSims).t_values./...
                                    Constants(iSims).scaling.ts;
            
    % Solve the simulation
    [Constants(iSims) Params(iSims) Data(iSims)] = ...
                solve_problem(Constants(iSims),Params(iSims),...
                              Controls(iSims));
            
    try 

        % Calculate residuals, normalising them to ensure fair 
        % comparison between each simulation and flow and volume.
        residuals = [residuals; DataPred(iSims).PO2 - ...
                        DataObs(iSims).PO2./...
                            Constants(iSims).reference.PO2_ref];

    catch ME

        % Give the solver another opportunity to correct for a set of
        % parameters that caused the ODE solver to fail.
        residuals = [residuals; nan(size(DataObs(iSims).PO2))];

    end
        
end;

% Reduce the results to a scalar for fminsearch or fmincon
residuals = norm(residuals);


end
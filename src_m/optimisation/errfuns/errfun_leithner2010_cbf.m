function residuals = errfun_leithner2010_cbf(vary,ObjData,...
                                                Constants,Params,Controls)

% Reformat/rename data passed in from base function.
Leithner2010 = ObjData.data_obs;
scaling = ObjData.scaling;
vary = vary.*scaling;
nSims = size(Constants,2);

% Initialise residuals.
residuals = [];

% Loop through each simulation (i.e. Mandeville 6s and 30s)
for iSims = 1:nSims
    
    DataObs(iSims).F = Leithner2010(ObjData.orderSims(iSims)).cbf;
    
    % setup/extract variable parameters
    Params(iSims).vasodilation.A_peak = vary(1);
    Params(iSims).vasodilation.A_ss = vary(2);
    Params(iSims).vasodilation.tau_active = vary(3);

    % Setup tspan to solve simulations over.  This corresponds to the
    % maximum tspan that we have data for (either flow or volume) for each
    % simulation  that is being run.
    if iSims == 1
        
        % Control case
        Controls(iSims).t_values = DataObs(iSims).F(:,1);
        Controls(iSims).tspan_dim = [min([Controls(iSims).t_values'...
            Controls(iSims).tspan_dim(1)]) max(Controls(iSims).t_values)];
        
    else
        
        % Vasodilated case
        Controls(iSims).t_values = DataObs(iSims).F(:,1);
        Controls(iSims).tspan_dim = [min([Controls(iSims).t_values'...
            Controls(iSims).tspan_dim(1)]) max(Controls(iSims).t_values)];
        
    end
        
    % Scale the t-values to Solve simulations at
    Controls(iSims).t_values = Controls(iSims).t_values./...
                                    Constants(iSims).scaling.ts;
            
    % Solve the equations over the t-values
    [Constants(iSims) Params(iSims) Data(iSims)] = ...
                solve_problem(Constants(iSims),Params(iSims),...
                              Controls(iSims));
                          
	[t0 idxt0] = min(abs(Data(iSims).t(Data(iSims).t<0)));
        
    DataPred(iSims).F = Data(iSims).F(:,5)./Data(iSims).F(idxt0,5);
            
    try 

        % Calculate residuals, normalising them to ensure fair 
        % comparison between each simulation and flow and volume.
        residualsNew = (DataPred(iSims).F - DataObs(iSims).F(:,2))./...
                            size(DataPred(iSims).F,1);
        residuals = [residuals; residualsNew];

    catch

        % Give the solver another opportunity to correct for a set of
        % parameters that caused the ODE solver to fail.
        residuals = [residuals; nan(size(DataObs(iSims).F(:,2)))];

    end
        
end;

% Reduce the results to a scalar for fminsearch or fmincon
% residuals = norm(residuals);

end
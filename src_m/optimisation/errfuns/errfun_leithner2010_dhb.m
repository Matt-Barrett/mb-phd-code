function residuals = errfun_leithner2010_dhb(vary,ObjData,...
                                                Constants,Params,Controls)

% Reformat/rename data passed in from base function.
Leithner2010 = ObjData.data_obs;
scaling = ObjData.scaling;
vary = vary.*scaling;

nSims = size(Constants,2);

% Put this in a different function (compare load_mandeville)
DataObs(1).dHb = Leithner2010(1).dhb(:,2);
DataObs(2).dHb = Leithner2010(2).dhb(:,2);

% Initialise residuals.
residuals = [];

% Loop through each simulation (i.e. Mandeville 6s and 30s)
for iSims = 1:nSims
    
    % setup/extract variable parameters
    Params(iSims).metabolism.A_peak = vary(1);
    Params(iSims).metabolism.A_ss = vary(2);
    Params(iSims).metabolism.t_rise = vary(3);
    Params(iSims).metabolism.tau_active = vary(4);
    Params(iSims).metabolism.tau_passive = vary(5);

    % Setup tspan to solve simulations over.  This corresponds to the
    % maximum tspan that we have data for (either flow or volume) for each
    % simulation  that is being run.
    if iSims == 1
        
        % Control case
        Controls(iSims).t_values = Leithner2010(iSims).dhb(:,1);
        Controls(iSims).tspan_dim = [min([Controls(iSims).t_values'...
            Controls(iSims).tspan_dim(1)]) max(Controls(iSims).t_values)];
        
    else
        
        % Vasodilated case
        Controls(iSims).t_values = Leithner2010(iSims).dhb(:,1);
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
            
    try 
        
        DataPred(iSims).dHb = Data(iSims).ndHb(:,4)./Data(iSims).ndHb(idxt0,4);

        % Calculate residuals, normalising them to ensure fair 
        % comparison between each simulation and flow and volume.
        residualsNew = (DataPred(iSims).dHb - DataObs(iSims).dHb)./...
                            length(DataPred(iSims).dHb);
        residuals = [residuals; residualsNew];

    catch

        % Give the solver another opportunity to correct for a set of
        % parameters that caused the ODE solver to fail.
        residuals = [residuals; nan(size(DataObs(iSims).dHb(:,2)))];

    end
        
end;

% Reduce the results to a scalar for fminsearch or fmincon
residuals = norm(residuals);

end
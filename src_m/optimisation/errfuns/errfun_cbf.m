function residuals = errfun_cbf(vary,ObjData,Constants,Params,Controls)

% Reformat/rename data passed in from base function.
scaling = ObjData.scaling;
vary = vary.*scaling;
nSims = size(Constants,2);

% Create the orderSims field if it doesn't exist yet
if ~(isfield(ObjData,'orderSims') && length(ObjData.orderSims)==nSims)
    ObjData.orderSims = 1:nSims;
end

% Initialise residuals.
residuals = [];

% % For debugging
% vary = [1      0.18    0.08      2      0.5];

% Loop through each simulation (i.e. Mandeville 6s and 30s)
for iSims = 1:nSims
    
    % Extract the observed data
    DataObs(iSims).F = ObjData.data_obs(ObjData.orderSims(iSims)).cbf;
    
    % Setup/extract variable parameters
    if Controls.vasodilation_type == 6
        
        % Normal Levystim
        Params(iSims).vasodilation.t_rise = vary(1);
        Params(iSims).vasodilation.A_peak = vary(2);
        Params(iSims).vasodilation.A_ss = vary(3);
        Params(iSims).vasodilation.tau_active = vary(4);
        Params(iSims).vasodilation.tau_passive = vary(5);
        
    elseif Controls.vasodilation_type == 7
        
        % Levystim with a step
        Params(iSims).vasodilation.levy.t_rise = vary(1);
        Params(iSims).vasodilation.levy.A_peak = vary(2);
        Params(iSims).vasodilation.levy.A_ss = vary(3);
        Params(iSims).vasodilation.levy.tau_active = vary(4);
        Params(iSims).vasodilation.levy.tau_passive = vary(5);
        
    end
    
    % There is no need to solve for oxygen here: speeds up the optimisation
    Controls(iSims).O2 = false;

    % Setup tspan to solve simulations over.  This corresponds to the
    % maximum tspan that we have data for (either flow or volume) for each
    % simulation  that is being run.
    Controls(iSims).t_values = DataObs(iSims).F(:,1);
    Controls(iSims).tspan_dim = [min([Controls(iSims).t_values'...
        Controls(iSims).tspan_dim(1)]) max(Controls(iSims).t_values)];
        
    % Scale the t-values to Solve simulations at
    Controls(iSims).t_values = Controls(iSims).t_values./...
                                    Constants(iSims).scaling.ts;
            
    % Solve the equations over the t-values
    [Constants(iSims) Params(iSims) Data(iSims)] = ...
                solve_problem(Constants(iSims),Params(iSims),...
                              Controls(iSims));
    
    % Extract the baseline time
	[t0 idxt0] = min(abs(Data(iSims).t(Data(iSims).t<Params(iSims).vasodilation.t0)));
        
    DataPred(iSims).F = Data(iSims).F(:,5)./Data(iSims).F(idxt0,5);
            
    try 

        % Calculate residuals, normalising them to ensure fair 
        % comparison between each simulation and flow and volume.
        residualsNew = (1 - DataPred(iSims).F./DataObs(iSims).F(:,2));
        residuals = [residuals; residualsNew];

    catch

        % Give the solver another opportunity to correct for a set of
        % parameters that caused the ODE solver to fail.
        residuals = [residuals; nan(size(DataObs(iSims).F(:,2)))];

    end
        
end;

% Keep the results as a vector for lsqnonlin, otherwise reduce the results
% to a scalar for fminsearch or fmincon
ST = dbstack;
funcNames = {ST(:).name};
doVector = strcmp('lsqnonlin',funcNames);
if ~doVector
    residuals = norm(residuals)/sqrt(size(residuals,1));
end

end
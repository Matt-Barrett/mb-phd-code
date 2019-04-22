function residuals = errfun_vazquez2008_cbf_baseline(vary,ObjData,...
                                                Constants,Params,Controls)

% Reformat/rename data passed in from base function.
vazquez2008 = ObjData.data_obs;
scaling = ObjData.scaling;
vary = vary.*scaling;

% FOR DEBUGGING ONLY
% vary = [7];

nSims = size(Params,2);
DataObs.F = vazquez2008.cbf;

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
%     Controls(iSims).t_values = Params(iSims).vasodilation.levy.t0;
%     Controls(iSims).tspan_dim(2) = ...
%         max(Controls(iSims).t_values);
        
        
%     % Scale the t-values to solve simulations at.
%     Controls(iSims).t_values = Controls(iSims).t_values./...
%                                     Constants(iSims).scaling.ts;
            
    % Solve the simulation
    [Constants(iSims) Params(iSims) DataPred(iSims)] = ...
                solve_problem(Constants(iSims),Params(iSims),...
                              Controls(iSims));
                          
    [t0(iSims) idxt0(iSims)] = min(abs(DataPred(iSims).t(...
                                        DataPred(iSims).t < 0)));
            
    try 

        % Calculate residuals, normalising them to ensure fair 
        % comparison between each simulation and flow and volume.
        residuals = [residuals; ...
                        DataPred(iSims).F(idxt0(iSims),end) - DataObs(iSims).F];

    catch ME

        % Give the solver another opportunity to correct for a set of
        % parameters that caused the ODE solver to fail.
        residuals = [residuals; nan(size(DataObs(iSims).F))];

    end
        
end;

% % Plot for debugging
% figure, hold on
% plot(DataPred.t,DataPred.F(:,5),'b-')
% plot(DataPred.t(idxt0),DataObs.F,'g+')
% plot(DataPred.t(idxt0),DataPred.F(idxt0,5),'r+')
% hold off

% Reduce the results to a scalar for fminsearch or fmincon
residuals = norm(residuals);

end
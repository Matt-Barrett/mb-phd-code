function residuals = errfun_devor2011_pto2(vary,ObjData,...
                                                Constants,Params,Controls)

% Reformat/rename data passed in from base function.
devor2011 = ObjData.data_obs;
scaling = ObjData.scaling;
vary = vary.*scaling;

nSims = length(Constants);
ptn_ss = devor2011.baseline.pto2./Constants(1).reference.PO2_ref;

% Put this in a different function (compare load_mandeville)
DataObs.PO2 = devor2011.pto2(:,2)./Constants(1).reference.PO2_ref;

% Initialise residuals.
DataPred.PO2_temp = [];

% Loop through each simulation (i.e. Mandeville 6s and 30s)
for iSims = 1:nSims
    
    % Check if the simulation has a p0 value above the ptn_ss
    doSim = Constants(iSims).ss.pO2_raw2(end) <= ptn_ss;
    
    if doSim
    
        % setup/extract variable parameters

%         % If adjusting metabolism
%         Params(iSims).metabolism.t_rise = vary(1);
%         Params(iSims).metabolism.A_peak = vary(2);
%         Params(iSims).metabolism.A_ss = vary(3);
%         Params(iSims).metabolism.tau_active = vary(4);
%         Params(iSims).metabolism.tau_passive = vary(5);

        % If adjusting flow
        Params(iSims).vasodilation.t_rise = vary(1);
        Params(iSims).vasodilation.A_peak = vary(2);
        Params(iSims).vasodilation.A_ss = vary(3);
        Params(iSims).vasodilation.tau_active = vary(4);
        Params(iSims).vasodilation.tau_passive = vary(5);
        
        % if adjusting flow
        

        % Setup tspan to solve simulations over.  This corresponds to the
        % maximum tspan that we have data for (either flow or volume) for each
        % simulation  that is being run.

        % Control case
        Controls(iSims).t_values = devor2011.pto2(:,1);
        Controls(iSims).tspan_dim = [min(Controls(iSims).t_values)...
            max(Controls(iSims).t_values)];


        % Scale the t-values to solve simulations at.
        Controls(iSims).t_values = Controls(iSims).t_values./...
                                        Constants(iSims).scaling.ts;
        
        % Solve the simulation
        [Constants(iSims) Params(iSims) Data(iSims)] = ...
                    solve_problem(Constants(iSims),Params(iSims),...
                                  Controls(iSims));

        [t0 idxt0] = min(abs(Data(iSims).t(Data(iSims).t<0)));

        % Transform the PO2 to the correct baseline value
        DataPred.PO2_temp(:,end+1) = calculate_ptn(ptn_ss,...
                    [Data(iSims).PO2(:,1:3) Data(iSims).PO2(:,end)],...
                    idxt0,Constants(iSims));
    
    end
        
end;

% Calculate the mean response
DataPred.PO2 = mean(DataPred.PO2_temp,2);

try 

    % Calculate residuals, normalising them to ensure fair 
    % comparison between each simulation and flow and volume.
    residuals = DataPred.PO2 - DataObs.PO2;

catch ME

    % Give the solver another opportunity to correct for a set of
    % parameters that caused the ODE solver to fail.
    residuals = nan(size(DataObs.PO2));

end

% % TEST PLOT FOR DEBUGGING
% figure, hold on
% plot(DataObs.PO2,'k')
% plot(DataPred.PO2,'c')
% hold off

% Reduce the results to a scalar for fminsearch or fmincon
residuals = norm(residuals);

end
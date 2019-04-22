function residuals = errfun_vazquez2008_pto2(vary,ObjData,...
                                                Constants,Params,Controls)

% Reformat/rename data passed in from base function.
vazquez2008 = ObjData.data_obs;
scaling = ObjData.scaling;
vary = vary.*scaling;

% FOR DEBUGGING ONLY
% vary = [0.33551      1.5384      14.594      1.9998];

nSims = 2;
baseline = vazquez2008.baseline.PO2;
ptn_ss = [baseline(1) baseline(1)];
% ptn_ss(1:2) = NaN;
doRemoveBaseline = [false true];

% Put this in a different function (compare load_mandeville)
DataObs(1).PO2 = vazquez2008.control;
DataObs(2).PO2 = vazquez2008.vasodilated;

% Initialise residuals.
residuals = [];

% Loop through each simulation (i.e. Mandeville 6s and 30s)
for iSims = 1:nSims
    
    % setup/extract variable parameters
    Params(iSims).metabolism.t_rise = vary(1);
    Params(iSims).metabolism.A_peak = vary(2);
    Params(iSims).metabolism.A_ss = vary(3);
    Params(iSims).metabolism.tau_active = vary(4);
    Params(iSims).metabolism.tau_passive = vary(5);
    
    % Clear any unwanted variables
    Params(iSims).metabolism.testK = nan(size(Params(iSims).metabolism.testK));
    
    % Assign the mechanism parameter
    doK = isfield(ObjData,'testKNum');
    if doK
        Params(iSims).metabolism.testK(ObjData.testKNum) = vary(end);
    end

    % Setup tspan to solve simulations over.  This corresponds to the
    % maximum tspan that we have data for (either flow or volume) for each
    % simulation  that is being run.
    if iSims == 1
        
        % Control case
        Controls(iSims).t_values = [Controls(iSims).tspan_dim(1); ...
            vazquez2008.time];
        Controls(iSims).tspan_dim = [min(Controls(iSims).t_values)...
            max(Controls(iSims).t_values)];
        
    else
        
        % Vasodilated case
        Controls(iSims).t_values = [Controls(iSims).tspan_dim(1); ...
            vazquez2008.time];
        Controls(iSims).tspan_dim(2) = ...
            max(Controls(iSims).t_values);
        
    end
        
    % Scale the t-values to solve simulations at.
    Controls(iSims).t_values = Controls(iSims).t_values./...
                                    Constants(iSims).scaling.ts;
            
    % Solve the simulation
    [Constants(iSims) Params(iSims) Data(iSims)] = ...
                solve_problem(Constants(iSims),Params(iSims),...
                              Controls(iSims));
                          
	[t0 idxt0] = min(abs(Data(iSims).t(Data(iSims).t<0)));
	
    % Transformt the PO2 to the correct baseline value
    ptn_ss(iSims) = ptn_ss(iSims)./Constants(iSims).reference.PO2_ref;
    
    DataPred(iSims).PO2 = calculate_ptn(ptn_ss(iSims),...
                [Data(iSims).PO2(:,1:3) Data(iSims).PO2(:,end)],...
                1,Constants(iSims));
            
    DataPred(iSims).PO2 = DataPred(iSims).PO2(2:end,end);
        
    if doRemoveBaseline(iSims)
        
        diffBaseline = Data(iSims).PO2(2,4) - ...
                        baseline(iSims)/Constants(iSims).reference.PO2_ref;
                    
        ptn_ss(iSims) = baseline(iSims)./Constants(iSims).reference.PO2_ref;
    
        DataPred(iSims).PO2 = calculate_ptn(ptn_ss(iSims),...
                    [Data(iSims).PO2(2:end,1:3) Data(iSims).PO2(2:end,end)],...
                    1,Constants(iSims));
        
%         DataPred(iSims).PO2 = DataPred(iSims).PO2 - diffBaseline;
        
    end
            
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

% % TEST PLOT FOR DEBUGGING
% figure, hold on
% plot(DataPred(1).PO2.*Constants(iSims).reference.PO2_ref,'k')
% plot(DataPred(2).PO2.*Constants(iSims).reference.PO2_ref,'c')
% hold off

% Keep the results as a vector for lsqnonlin, otherwise reduce the results
% to a scalar for fminsearch or fmincon
ST = dbstack;
funcNames = {ST(:).name};
doVector = strcmp('lsqnonlin',funcNames);
if ~doVector
    residuals = norm(residuals); % Not dividing by sqrt(n) here for 
    % consistency with the other simulations, even though it's better
end

end
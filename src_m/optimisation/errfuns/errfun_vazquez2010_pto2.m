function residuals = errfun_vazquez2010_pto2(vary,ObjData,...
                                                Constants,Params,Controls)

% Reformat/rename data passed in from base function.
vazquez2010 = ObjData.data_obs;
scaling = ObjData.scaling;
vary = vary.*scaling;

% FOR DEBUGGING ONLY
% vary = [14.2812    0.0578413    0.0157156      1.31758     0.443359];

nSims = 1;
baseline = vazquez2010.baseline.PtO2;
ptn_ss = baseline(1);

% Put this in a different function (compare load_mandeville)
DataObs(1).PO2 = vazquez2010.PtO2(:,2);

% Initialise residuals.
residuals = [];

% Loop through each simulation (i.e. Mandeville 6s and 30s)
for iSims = 1:nSims
    
    % setup/extract variable parameters
    
    doScale = length(vary) == 1;
    if doScale
        
        % Scale
        Params(iSims).metabolism.scale = vary(1);
        
    else
    
        % levystim
        Params(iSims).metabolism.t_rise = vary(1);
        Params(iSims).metabolism.A_peak = vary(2);
        Params(iSims).metabolism.A_ss = vary(3);
        Params(iSims).metabolism.tau_active = vary(4);
        Params(iSims).metabolism.tau_passive = vary(5);
        
    end

    % Setup tspan to solve simulations over.  This corresponds to the
    % maximum tspan that we have data for (either flow or volume) for each
    % simulation  that is being run.
        
    % Control case
    Controls(iSims).t_values = vazquez2010.PtO2(:,1);
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
	
%     % Transformt the PO2 to the correct baseline value
%     ptn_ss(iSims) = ptn_ss(iSims)./Constants(iSims).reference.PO2_ref;
%     
%     DataPred(iSims).PO2 = calculate_ptn(ptn_ss(iSims),...
%                 [Data(iSims).PO2(:,1:3) Data(iSims).PO2(:,end)],...
%                 1,Constants(iSims));
    
    DataPred(iSims).PO2 = Data(iSims).PO2_ss;
            
    DataPred(iSims).PO2 = DataPred(iSims).PO2./DataPred(iSims).PO2(1);
            
    try 

        % Calculate residuals, normalising them to ensure fair 
        % comparison between each simulation and flow and volume.
        residuals = [residuals; DataPred(iSims).PO2 - ...
                        DataObs(iSims).PO2];

    catch ME

        % Give the solver another opportunity to correct for a set of
        % parameters that caused the ODE solver to fail.
        residuals = [residuals; nan(size(DataObs(iSims).PO2))];

    end
        
end;

% % TEST PLOT FOR DEBUGGING
% figure, hold on
% plot(DataPred.PO2,'k')
% plot(DataObs.PO2,'c')
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
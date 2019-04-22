function residuals = errfun_kappa(vary,ObjData,...
                                        ConstantsIn,ParamsIn,ControlsIn)

% The maximum normalised change in kappa permitted before the function
% sets up the vasodilatory stimulus again (to normalise the flow range).
KAPPA_TOL = 0.05;

% Extract required data from structure.
alpha = ObjData.alpha;
freeKappa = ObjData.free_kappa;
simList = ObjData.simList;
default = ObjData.default;

% We only want to setup the structures fully a fraction of the time 
% because the values won't change very much and it takes too long.  The way
% I'm implementing this is to store the data in persistent variables 
persistent oldKappa Constants Params Controls

% Setup the variables for the first run
firstRun = isempty(Constants);
if firstRun
    [Constants Params Controls] = deal(ConstantsIn,ParamsIn,ControlsIn);
    oldKappa = Params.compliance.kappa(freeKappa);
end

% Vary only free params 
Params.compliance.kappa(freeKappa) = vary;

% Calculate how much Kappa has changed since we last setup the stimulus
changeKappa = norm((vary - oldKappa)./oldKappa);

% Setup simulations to ensure the flow range is the same, as required.
if changeKappa > KAPPA_TOL
    
    % Update the defaults to include the current value
    default.params.compliance.kappa(freeKappa) = vary;
    
    for iSim = 1:length(simList)
        [Constants(iSim) Params(iSim) Controls(iSim)] = ...
                                setup_problem(default,simList{iSim});
    end
                        
    % Also, update oldKappa to record the value that was used when the
    % stimulus was last setup.
    oldKappa = Params.compliance.kappa(freeKappa);
                        
end

% Run simulation and perform calculations
[Constants Params Data] = solve_problem(Constants,Params,Controls);

% Initialise the residuals
residuals = [];

try 
    % Extract steady state flow and volume values 
    [fit_data Data] = extract_FV(Constants,Params,Controls,Data);
catch
    % Give the solver another opportunity to correct for a set of
    % parameters that caused the ODE solver to fail.
    residuals = NaN;
    return
end
    

% Loop through the compartments
for iAlpha =1:size(fit_data.V_ss,1)
    
    % Skip out compartments we're not optimising for.
    skipAlpha = alpha(iAlpha) < 0;
    if skipAlpha, continue; end;
    
    try
        
        % Calculate residuals
        residuals = [residuals fit_data.F_ss.^alpha(iAlpha) - ...
                    fit_data.V_ss(iAlpha,:)./Data(1).V(1,iAlpha)];
                
    catch
        
        % Give the solver another opportunity to correct for a set of
        % parameters that caused the ODE solver to fail.
        residuals = [residuals; nan(size(fit_data.V_ss(iAlpha,:)))];
        
    end
            
end;

% Reduce the results to a scalar for fminsearch
residuals = norm(residuals);

end

function residuals = errfun_dhbhbo(vary,ObjData,Constants,Params,Controls)

% Reformat/rename data passed in from base function.
scaling = ObjData.scaling;
vary = vary.*scaling;
nSims = size(Constants,2);

% Initialise residuals.
residuals = [];

% % For debugging
% vary = [15.6205     0.194929     0.399566      5.47803      1.61754];
 
% Setup/extract variable parameters
nVary = length(vary);
switch nVary
    case 5
        Controls.metabolism_type = 6;
        Params.metabolism.t_rise = vary(1);
        Params.metabolism.A_peak = vary(2);
        Params.metabolism.A_ss = vary(3);
        Params.metabolism.tau_active = vary(4);
        Params.metabolism.tau_passive = vary(5);
    case 3
        Controls.metabolism_type = 9;
        Params.metabolism.t_rise = vary(1);
        Params.metabolism.A_ss = vary(2);
        Params.metabolism.tau_passive = vary(3);
    otherwise
        warning('Wrong number of variable parameters!')
end

% Set up some stuff for doing multiple simulations
nSims = 2;
simVars = {'HbO','dHb'};

% Make a duplicate set of Controls for the second set of time values
Controls = repmat(Controls,1,nSims);
Constants = repmat(Constants,1,nSims);
Params = repmat(Params,1,nSims);
DataObs = repmat(struct(),1,nSims);
DataPred = DataObs;

for iSim = 1:nSims
    
    % Extract the observed data
    DataObs(iSim).(simVars{iSim}) = ObjData.data_obs.(simVars{iSim});
    
    % Setup tspan to solve simulations over.  This corresponds to the
    % maximum tspan that we have data for (either flow or volume) for each
    % simulation  that is being run.
    Controls(iSim).t_values = DataObs(iSim).(simVars{iSim})(:,1);
    Controls(iSim).tspan_dim = [min([Controls(iSim).t_values'...
        Controls(iSim).tspan_dim(1)]) max(Controls(iSim).t_values)];

    % Scale the t-values to Solve simulations at
    Controls(iSim).t_values = Controls(iSim).t_values./...
                                    Constants(iSim).scaling.ts;

    % Solve the equations over the t-values
    [Constants(iSim) Params(iSim) Data(iSim)] = solve_problem(...
        Constants(iSim), Params(iSim), Controls(iSim));
                          
    % Extract the baseline time
	[t0 idxt0] = min(abs(Data(iSim).t(Data(iSim).t < ...
        Params(iSim).vasodilation.t0)));
    
    % Extract the correct spectroscopy data, depending on what mode
    useSpec = ObjData.useSpec;
    if useSpec
        
        hbVar = [simVars{iSim} '_spec'];
        DataPred(iSim).(simVars{iSim}) = 1 + Data(iSim).(hbVar);
    
    else
        
        hbVar = ['n' simVars{iSim}];
        DataPred(iSim).(simVars{iSim}) = Data(iSim).(hbVar)(:,end)./...
            Data(iSim).(hbVar)(idxt0,end);
        
    end
    
    try 

        % Calculate residuals, normalising them to ensure fair 
        % comparison between each simulation and flow and volume.
        residualsNew = (1 - DataPred(iSim).(simVars{iSim})./...
            DataObs(iSim).(simVars{iSim})(:,2));
        residuals = [residuals; residualsNew];

    catch ME1

        % Give the solver another opportunity to correct for a set of
        % parameters that caused the ODE solver to fail.
        residuals = [residuals; nan(size(...
            DataObs(iSim).(simVars{iSim})(:,2)))];

    end
    
end


% Keep the results as a vector for lsqnonlin, otherwise reduce the results
% to a scalar for fminsearch or fmincon
ST = dbstack;
funcNames = {ST(:).name};
doVector = strcmp('lsqnonlin',funcNames);
if ~doVector
    residuals = norm(residuals)/sqrt(size(residuals,1));
end

% % For debugging
% figure, hold on
% plot(Data(1).t,Data(1).F(:,5)./(Data(1).F(1,5)),'k-')
% plot(Data(1).t,Data(1).S(:,4)./(Data(1).S(1,4)),'g-')
% plot(DataObs(1).(simVars{1})(:,1),DataObs(1).(simVars{1})(:,2),'r--')
% plot(DataObs(1).(simVars{1})(:,1),DataPred(1).(simVars{1}),'r-')
% plot(DataObs(2).(simVars{2})(:,1),DataObs(2).(simVars{2})(:,2),'b--')
% plot(DataObs(2).(simVars{2})(:,1),DataPred(2).(simVars{2}),'b-')
% hold off

end
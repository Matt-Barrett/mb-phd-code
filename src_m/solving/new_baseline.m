function [constants params] = new_baseline(constants,params,controls)

mode = [];

%% New systemic arterial PO2
hasArtIn = ~isnan(constants.ss.pO2_raw2(1));

if hasArtIn

    % Calculate the new systemic arterial concentration
    constants.ss.cO2_raw2(1) = PressureContent(...
        constants.ss.pO2_raw2(1),[],{'pressure','blood'},...
        params.gas,controls);
    
    % Assign this concentration to 02concin function
    params.o2concin.cO2_in = constants.ss.cO2_raw2(1);
    
    % Calculate the new jump required to achieve the PO2
    if controls.o2concin_type > 0
        params.o2concin.A = PressureContent(params.o2concin.PO2_in,...
                    [],{'pressure','blood'},params.gas,controls) - ...
                    params.o2concin.cO2_in;
    end
    
else
    
    % A new baseline condition requires a new systemic artery PO2.  If none
    % is supplied, we can assume there is no need for a new baseline.
    % Changes that don't require a new baseline can be made elsewhere.
    return

end
%% New CMRO2 (to adjust for depth)
mode.hasCMRO2 = isa(constants.ss.cmro2_2,'function_handle');

if mode.hasCMRO2
    
    % Adjust for the new value of CMRO2
    [constants params] = adjust_cmro2(constants,params,controls);
    
end

% Calculate the new input arterial concentration and pressure
constants = calc_c01n(constants,params,controls);

%% New mean arterial PO2

mode.hasMeanArt = ~isnan(constants.ss.pO2_mean2(1));

if mode.hasMeanArt
    
    % Calculate c12 based on the mean artery pO2
    constants = calc_c12n(constants,params,controls);
    
end

%% Modified venous PO2 (leads to change in CMRO2_ss)
mode.hasVenOut = ~isnan(constants.ss.pO2_raw2(end-1));

if mode.hasVenOut

    % Calculate the new venous concentration from the pressure supplied
    constants.ss.cO2_raw2(end-1) = PressureContent(...
            constants.ss.pO2_raw2(end-1),[],{'pressure','blood'},...
            params.gas,controls);
    
    % Calculate the new CMRO2 value
    params.metabolism.CMRO2_ss = constants.ss.F_ss.* ...
        (constants.ss.cO2_raw2(2) - constants.ss.cO2_raw2(end-1));
        
    if mode.hasCMRO2
        
        % Adjust for the new value of CMRO2
        [constants params] = adjust_cmro2(constants,params,controls);
        
        % Calculate the new input arterial concentration and pressure
        constants = calc_c01n(constants,params,controls);
        
        % Calculate c12 based on the mean artery pO2
        constants = calc_c12n(constants,params,controls);
    
    end
    
    % Calculate the old venous concentration from the CMRO2
    constants.ss.cO2_raw(end-1) = constants.ss.cO2_raw(1) - ...
        params.metabolism.CMRO2_ss;
    constants.ss.pO2_raw(end-1) = PressureContent(...
            constants.ss.cO2_raw(end-1),[],{'content','blood'},...
            params.gas,controls);
        
    % Update the venous mean pO2 because of the modified c34
    constants.ss.pO2_mean(3) = mean(constants.ss.cO2_raw(3:4));
    
else
    
    % Calculate the new venous concentration from the CMRO2
    constants.ss.cO2_raw2(end-1) = constants.ss.cO2_raw2(2) - ...
        params.metabolism.CMRO2_ss;
    constants.ss.pO2_raw2(end-1) = PressureContent(...
            constants.ss.cO2_raw2(end-1),[],{'content','blood'},...
            params.gas,controls);
    
end

%% New mean venous PO2

mode.hasMeanVei = ~isnan(constants.ss.pO2_mean2(3));

if mode.hasMeanVei
    
    % Calculate c23 based on the mean venous pO2
    constants = calc_c23n(constants,params,controls);
    
end

%% Modified tissue PO2

mode.hasMeanTis = ~isnan(constants.ss.pO2_mean2(4));

if mode.hasMeanTis
        
    % Calculate the new tissue concentration
    constants.ss.cO2_mean2(4) = PressureContent(...
        constants.ss.pO2_mean2(4),[],{'pressure','tissue'},...
        params.gas,controls);
    
end

%% Modified tissue PO2_0

mode.hasTis0 = ~isnan(constants.ss.pO2_raw2(end));

if mode.hasMeanTis && mode.hasTis0
    
    warning('NewBaseline:PtandP0',['New values for mean tissue PO2 '...
        'and PO2_0 were both supplied.  This combination is currently '...
        'not possible.  Ignoring the PO2_0 value'])
    
    mode.hasTis0 = false;
    
end


%%  Setup initial conditions for fsolve

% The test configuration
mode.doOldEqs = mode.hasMeanArt | mode.hasVenOut | ...
                mode.hasMeanTis | mode.hasTis0 | mode.hasMeanVei;
mode.doCalcGO2 = mode.doOldEqs;
mode.doC1223 = mode.hasMeanArt | mode.hasVenOut | mode.hasMeanVei;

if mode.doCalcGO2

    % We don't need to see this warning in the optimisation
    wngState = warning('off','CalculateGO2:NegativeGO2');
    warning('off','CalculateGO2:NoShunt')

    % Calculate the new gO2 values
    params = calculate_gO2(constants,params);

    % Restore the warning state
    warning(wngState);
        
end

% c12n
c12n0 = constants.ss.cO2_raw2(2) - (constants.ss.cO2_raw(1) - ...
        constants.ss.cO2_raw(2));
if ~mode.hasMeanArt
    x0 = c12n0;
else
    x0 = [];
end

% c23n
if ~mode.hasMeanVei
    x0(end+1) = c12n0 - (constants.ss.cO2_raw(2) - constants.ss.cO2_raw(3));
end

% c12 and c23
if mode.doC1223
    x0(end+1:end+2) = constants.ss.cO2_raw(2:3);
end

% pt or ptn
x0(end+1) = constants.ss.pO2_mean(end);

%% Solve the equations to find the new initial conditions for the ODEs

% Add static arguments to objective function.
fun = @(x) new_baseline_errfun(x,mode,constants,params,controls);

% Setup the solving options (including some for debugging)
% options = optimset('Display','none');
% options = optimset('TolFun',1e-12);
% options = optimset('TolFun',1e-12,'Display','iter','MaxFunEvals',1000);
% options = optimset('TolFun',1e-12,'Display','notify','MaxFunEvals',1000);
options = optimset('TolFun',1e-12,'Display','none');

% Adjust for different matlab versions
doExtraOpts = verLessThan('matlab', '7.7') && ... % < Matlab r2008b
    (constants.ss.pO2_raw2(1) == 133/constants.reference.PO2_ref); % Vazquez
if doExtraOpts
    
    options = optimset(options,'LargeScale','on');
    
%     warning('NewBaseline:Compatibility',['The Vazquez2010 results are '...
%         'likely to be different from expected due to a compatibility '...
%         'issue.'])
    
end

% % For debugging
% test1 = fun(x0);

% Turn off this warning - I know the system may not be square
wngState = warning('off','optim:fsolve:NonSquareSystem');

% Solve the system
[xOpt,fval,exitflag] = fsolve(fun,x0,options); %#ok<ASGLU>

% Restore the warning state
warning(wngState);

% Throw a warning if exitflag is bad
if exitflag <= 0
    warning('NewBaseline:BadExitFSolve',['FSOLVE exited '...
        'with flag "%01.0f".'],exitflag)
end

% % For debugging
% test2 = fun(xOpt);

%% Assign the new values

if ~mode.hasMeanArt
    
    % Assign the new 12 O2 concentrations and pressures
    constants = assign_c12n(xOpt(1),constants,params,controls);
    xOpt = xOpt(2:end);
end

if ~mode.hasMeanVei

    % Assign the new 23 O2 concentrations and pressures
    constants = assign_c23n(xOpt(1),constants,params,controls);
    xOpt = xOpt(2:end);

end

if mode.doC1223
    
    % Assign the old 12 O2 concentrations and pressures and calculate the
    % updated mean values
    constants = assign_c1223(xOpt(1:2),constants,params,controls);
    xOpt = xOpt(3:end);
    
end

if ~mode.hasMeanTis && ~mode.hasTis0
    
    % Assign the ptn pressure and concentration, and calculate the new 
    % tissue p0 pressure and concentration
    constants = assign_ptn(xOpt(1),constants,params,controls);
    
else
    
    % Assign the old tissue O2 pressure and concentration and calculate the
    % old tissue p0 pressure and concentration
    constants = assign_pt(xOpt(1),constants,params,controls);
    
end

if mode.hasTis0
    constants = calc_pt(constants,params,controls);
end

if mode.doCalcGO2
    params = calculate_gO2(constants,params);
end

end

function [constants params] = adjust_cmro2(constants,params,controls)

% Calculate the actual value of the adjusted CMRO2
temp = constants.ss.cmro2_2(params.metabolism.CMRO2_ss,...
                                params.metabolism.depth);

% Assume that the change in CMRO2 is accouted for by the leak.  I.e.,
% if the CMRO2 is now lower, the leak must now be higher
params.main.c_leak = params.main.c_leak + ...
    (params.metabolism.CMRO2_ss - temp);

% Assign the new CMRO2
params.metabolism.CMRO2_ss = temp;

% Calculate the new input arterial concentration and pressure
constants.ss.cO2_raw(1) = 1 - params.main.c_leak;
constants.ss.pO2_raw(1) = PressureContent(...
    constants.ss.cO2_raw(1),[],{'content','blood'},...
    params.gas,controls);
    
end

function constants = calc_c01n(constants,params,controls)

% Calculate the new input arterial concentration and pressure
constants.ss.cO2_raw2(2) = constants.ss.cO2_raw2(1) - ...
                            params.main.c_leak;
constants.ss.pO2_raw2(2) = PressureContent(...
    constants.ss.cO2_raw2(2),[],{'content','blood'},...
    params.gas,controls);

end

function constants = calc_c12n(constants,params,controls)

constants.ss.pO2_raw2(3) = 2*constants.ss.pO2_mean2(1) - ...
                            constants.ss.pO2_raw2(2);
constants.ss.cO2_raw2(3) = PressureContent(constants.ss.pO2_raw2(3),...
    [],{'pressure','blood'},params.gas,controls);

end

function constants = calc_c23n(constants,params,controls)

constants.ss.pO2_raw2(4) = 2*constants.ss.pO2_mean2(3) - ...
                            constants.ss.pO2_raw2(5);
constants.ss.cO2_raw2(4) = PressureContent(constants.ss.pO2_raw2(4),...
    [],{'pressure','blood'},params.gas,controls);

end

function constants = assign_c12n(c12n,constants,params,controls)

% Assign the 12n O2 concentrations and pressures
constants.ss.cO2_raw2(3) = c12n;
constants.ss.pO2_raw2(3) = PressureContent(...
        constants.ss.cO2_raw2(3),[],{'content','blood'},...
        params.gas,controls);    
    
end

function constants = assign_c23n(c23n,constants,params,controls)

% Assign the 23n O2 concentrations and pressures
constants.ss.cO2_raw2(4) = c23n;
constants.ss.pO2_raw2(4) = PressureContent(...
        constants.ss.cO2_raw2(4),[],{'content','blood'},...
        params.gas,controls);
    
end

function constants = assign_c1223(c1223,constants,params,controls)

% Assign the 12n O2 concentrations and pressures
constants.ss.cO2_raw(2:3) = c1223;
constants.ss.pO2_raw(2:3) = PressureContent(...
        constants.ss.cO2_raw(2:3),[],{'content','blood'},...
        params.gas,controls);
    
% Calculate the updated mean values
constants.ss.pO2_mean(1) = mean(constants.ss.pO2_raw(1:2));
constants.ss.pO2_mean(2) = mean(constants.ss.pO2_raw(2:3));
constants.ss.pO2_mean(3) = mean(constants.ss.pO2_raw(3:4));
    
end

function constants = assign_ptn(ptn,constants,params,controls)

% Assign the new tissue O2 pressure and concentration
constants.ss.pO2_mean2(4) = ptn;
constants.ss.cO2_mean2(4) = PressureContent(...
    constants.ss.pO2_mean2(4),[],{'pressure',...
    'tissue'},params.gas,controls);

% Calculate the new tissue p0 pressure and concentration
constants.ss.pO2_raw2(end) = calculate_p0(constants.ss.pO2_mean2,...
                                    constants.ss.wMean,constants.ss.wPO2);
constants.ss.cO2_raw2(end) = PressureContent(...
    constants.ss.pO2_raw2(end),[],{'pressure',...
    'tissue'},params.gas,controls);

end

function constants = assign_pt(pt,constants,params,controls)

% Assign the old tissue O2 pressure and concentration
constants.ss.pO2_mean(4) = pt;
constants.ss.cO2_mean(end) = PressureContent(...
    constants.ss.pO2_mean(end),[],{'pressure',...
    'tissue'},params.gas,controls);

% Calculate the old tissue p0 pressure and concentration
constants.ss.pO2_raw(end) = calculate_p0(constants.ss.pO2_mean,...
                                    constants.ss.wMean,constants.ss.wPO2);
constants.ss.cO2_raw(end) = PressureContent(...
    constants.ss.pO2_raw(end),[],{'pressure',...
    'tissue'},params.gas,controls);

end

function constants = calc_pt(constants,params,controls)

constants.ss.pO2_mean2(1) = mean(constants.ss.pO2_raw2(2:3));
constants.ss.pO2_mean2(2) = mean(constants.ss.pO2_raw2(3:4));
constants.ss.pO2_mean2(3) = mean(constants.ss.pO2_raw2(4:5));

constants.ss.pO2_mean2(4) = calculate_pt(constants.ss.pO2_mean2(1:3),...
    constants.ss.pO2_raw2(end),constants.ss.wMean,constants.ss.wPO2);
constants.ss.cO2_mean2(4) = PressureContent(...
    constants.ss.pO2_mean2(4),[],{'pressure',...
    'tissue'},params.gas,controls);

end


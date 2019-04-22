function [constants params] = steady_state(constants,params,controls)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%% SCALE PARAMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

params = scale_stimulations('scale',constants,params,controls);

%% %%%%%%%%%%%%%%%%%%%%%%%%% PROCESS CONSTANTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constants.reference.O2_conc_ref = constants.physical.conc_max...
    ./(1 + (constants.physical.PO2_50./constants.reference.PO2_ref)...
    .^params.gas.hill.h); % mL(O2) mL(Blood)^-1
params.gas.zeta_O2_tissue = constants.reference.O2_conc_ref...
    /(constants.reference.PO2_ref*constants.physical.sigma_O2);
params.gas.hill.phi = constants.physical.PO2_50...
    /constants.reference.PO2_ref;
params.gas.hill.chi = constants.physical.conc_max...
    /constants.reference.O2_conc_ref;
params.gas.convert_SO2 = constants.reference.O2_conc_ref...
    /constants.physical.conc_max;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FLOW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate normalised flow, ...
%  
constants.ss.F_ss = sum(constants.ss.R_ss)*params.pressure.P_ss;

% ... lengths, ...
params.main.l = (constants.ss.R_ss.*(params.compliance.V_ss(1:3).^2)).^(1/3);
                        
% ... pressures, ...
constants.ss.P_ss(1) = params.pressure.P_ss;
constants.ss.P_ss(2) = constants.ss.P_ss(1) - ...
                            constants.ss.F_ss*constants.ss.R_ss(1);
constants.ss.P_ss(3) = constants.ss.P_ss(2) - ...
                            constants.ss.F_ss*constants.ss.R_ss(2);

% ... and compliances.
params.compliance.C_ss = params.compliance.V_ss(1:3)./(constants.ss.P_ss ...
    - 0.5.*constants.ss.R_ss.*constants.ss.F_ss);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%% GAS EXCHANGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if controls.O2
    
    % Calculate average PO2 in compartments, ...
    constants.ss.pO2_mean(1) = mean(constants.ss.pO2_raw(1:2));
    constants.ss.pO2_mean(2) = mean(constants.ss.pO2_raw(2:3));
    constants.ss.pO2_mean(3) = mean(constants.ss.pO2_raw(3:4));
    
    % ... Average tissue PO2, ...
    constants.ss.pO2_mean(4) = calculate_pt(constants.ss.pO2_mean(1:3),...
        constants.ss.pO2_raw(end),constants.ss.wMean,constants.ss.wPO2);
    
    % ... O2 concentrations, ...
    constants.ss.cO2_raw = PressureContent(constants.ss.pO2_raw,[],...
                {'pressure','all'},params.gas,controls);
    constants.ss.cO2_mean = PressureContent(constants.ss.pO2_mean,[],...
                {'pressure','all'},params.gas,controls);
    
    % ... CMRO2, ...
    params.metabolism.CMRO2_ss = constants.ss.F_ss.* ...
                    (constants.ss.cO2_raw(1) - constants.ss.cO2_raw(end-1));
                            
    % ... the flux lost before reaching the arteries, ...
    params.main.c_leak = params.o2concin.cO2_in - constants.ss.cO2_raw(1);    
                    
    % ... capillary O2 diffusion constants, ...
%     params.main.gO2(2) = constants.ss.F_ss.* ...
%         (constants.ss.cO2_raw(2) - constants.ss.cO2_raw(3))./...
%         (constants.ss.PO2_cap - constants.ss.PO2_tis);
    
    params = calculate_gO2(constants,params);

% %     % ... O2 diffusion constants (assuming no shunt), ...
%     temp.gO2 = (constants.ss.pO2_mean(1:3) - constants.ss.pO2_mean(4));
%     params.main.gO2(1) = (1./temp.gO2(1)).*constants.ss.F_ss.* ...
%         (constants.ss.cO2_raw(1) - constants.ss.cO2_raw(2));
%     params.main.gO2(2) = (1./temp.gO2(2)).*constants.ss.F_ss.* ...
%         (constants.ss.cO2_raw(2) - constants.ss.cO2_raw(3));
%     params.main.gO2(3) = (1./temp.gO2(3)).*constants.ss.F_ss.* ...
%         (constants.ss.cO2_raw(3) - constants.ss.cO2_raw(4));

    % Adjust for modified baseline conditions, if necessary.  Only use the
    % new baseline v2 equations if the conditions match perfectly
    maskRaw2 = [1 0 0 0 1 0];
    maskMean2 = [0 0 1 0];
    doNew = all(xor(maskRaw2, isnan(constants.ss.pO2_raw2))) && ...
        all(xor(maskMean2, isnan(constants.ss.pO2_mean2)));
    if ~doNew
        
        % Warn if the conditions are anything outside what this set of
        % equations can handle
        maskWarnRaw2 = [1 0 0 0 0 0];
        maskWarnMean2 = [0 0 0 0];
        doWarn = ~all(xor(maskWarnRaw2, isnan(constants.ss.pO2_raw2))) && ...
            ~all(xor(maskWarnMean2, isnan(constants.ss.pO2_mean2)));
        if doWarn
            warning('NewBaseline:BadInputs',['The combination of inputs ' ...
                'specified to adjust the baseline conditions is ' ...
                'probably not supported.  Check outputs thoroughly'])
        end
        
        % This function is most likely wrong and probably needs to be
        % updated/rewritten for most cases
        [constants params] = new_baseline(constants,params,controls);
        
    else
        
        % Use the new baseline equations developed for Masamoto 2008 and
        % Vazquez 2010
        [constants params] = new_baseline_v2(constants,params,controls);
        
    end

    % % For debugging - this is just to test that they're the same.
    % CMRO2_ss_test = sum(params.main.gO2.*temp.gO2);
    
    if controls.o2concin_type > 0
        params.o2concin.A = PressureContent(params.o2concin.PO2_in,[],...
                        {'pressure','blood'},params.gas,controls) - ...
                        params.o2concin.cO2_in;
    else
        params.o2concin.PO2_in = PressureContent(params.o2concin.cO2_in,...
                    [],{'content','blood'},params.gas,controls);
    end
        
end         
            

end
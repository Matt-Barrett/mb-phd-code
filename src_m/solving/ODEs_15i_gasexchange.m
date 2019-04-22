function k = ODEs_15i_gasexchange(t,X,Xp,params,controls)

%%

% Unbundle variables and derivatives
F = transpose(X(1:4,1));
V = transpose(X(5:7,1));
% cO2_01 = transpose(X(8,1));
NO2 = transpose(X(8:11,1));

% F_p = transpose(Xp(1:4,1));
% V_p = transpose(Xp(5:7,1));
% cO2_01p = transpose(Xp(8,1));
NO2_p = transpose(Xp(8:11,1));

% O2 Input Adjustment
doOxygen = (controls.o2concin_type > 0) && (t >= params.o2concin.t0);
if doOxygen
    
    cO2_in = params.o2concin.cO2_in + ...
        params.o2concin.fhandle(t,params.o2concin);
    
    % Adjust P50 based on input O2 (to simulate CO2 stimulus)
    doK6 = (length(params.metabolism.testK) > 4) && ...
        ~isnan(params.metabolism.testK(6)) && ...
        (params.metabolism.testK(6) > 0);
    if doK6
        params.gas.hill.phi = params.gas.hill.phi.*(1 + ...
            params.metabolism.testK(6).*(cO2_in./params.o2concin.cO2_in - 1));
    end
    
else
    cO2_in = params.o2concin.cO2_in;
end

% Metabolism Stimulus
doMetabolism = (controls.metabolism_type > 0) && (t >= params.metabolism.t0);
if doMetabolism
    deltaCMRO2 = params.metabolism.fhandle(t,params.metabolism);
    CMRO2 = params.metabolism.CMRO2_ss*(1 + deltaCMRO2);
else
    deltaCMRO2 = 0;
    CMRO2 = params.metabolism.CMRO2_ss;
end;

% Whether or not to change O2 conductivity based on surface area
if controls.surface_area
    gO2 = params.main.gO2.*((V./params.compliance.V_ss(1:3)).^(0.5));
else
    gO2 = params.main.gO2;
end;

%% Tests

% test increasing input O2 via reduction in leak
doK1 = ~isnan(params.metabolism.testK(1)) && (params.metabolism.testK(1) > 0);
if doK1
    scaleFactor = (1 - params.metabolism.testK(1).*(F(1)-1));
    if scaleFactor >= 0
        params.main.c_leak = params.main.c_leak.*scaleFactor;
    else
        params.main.c_leak = 0;
    end
end

% test increasing the p50 of the O2-hbo2 saturation curve
doK2 = ~isnan(params.metabolism.testK(2)) && (params.metabolism.testK(2) > 0);
if doK2
    params.gas.hill.phi = params.gas.hill.phi.*(1 + ...
        params.metabolism.testK(2)*deltaCMRO2);
end

% test increasing capillary permeability
doK3 = ~isnan(params.metabolism.testK(3)) && (params.metabolism.testK(3) > 0);
if doK3
    gO2(2) = gO2(2).*(1+params.metabolism.testK(3).*(F(1)-1));
end
    
% test increasing all permeability 
doK4 = ~isnan(params.metabolism.testK(4)) && (params.metabolism.testK(4) > 0);
if doK4
    gO2 = gO2.*(1+params.metabolism.testK(4).*(F(1)-1));
end

% Adjust shunt conduction coefficient down
doK5 = (length(params.metabolism.testK) > 4) && ...
    ~isnan(params.metabolism.testK(5)) && ...
    (params.metabolism.testK(5) > 0);
if doK5
    params.main.gO2_shunt = params.main.gO2_shunt.*...
        (1 - params.metabolism.testK(5).*(F(1)-1));
    % Check to ensure the shunt is within the feasible range
    if params.main.gO2_shunt < params.main.gO2_shunt_range(1)
        params.main.gO2_shunt = params.main.gO2_shunt_range(1);
    end
end

% See above in "Input O2 adjustment" for K6

%%

% Calculate oxygen partial pressures
cO2_01 = cO2_in - params.main.c_leak;

PO2 = PressureContent([cO2_01 NO2./[V params.compliance.V_ss(4)]],...
        [],{'content','all'},params.gas,controls);

PO2_art = mean(PO2(1:2));
PO2_cap = mean(PO2(2:3));
PO2_vei = mean(PO2(3:4));

J_Shunt = params.main.gO2_shunt.*(PO2_art - PO2_vei);

J_AT = gO2(1).*(PO2_art - PO2(end));
J_CT = gO2(2).*(PO2_cap - PO2(end));
J_VT = gO2(3).*(PO2_vei - PO2(end));

k(1,1) = -NO2_p(1)...
            + F(1).*cO2_01 ...
            - F(2).*NO2(1)/V(1) ...
            - J_AT ...
            - J_Shunt;

k(2,1) = -NO2_p(2)...
            + F(2).*NO2(1)/V(1) ...
            - F(3)*NO2(2)/V(2)...
            - J_CT;

k(3,1) = -NO2_p(3)...
            + F(3)*NO2(2)/V(2)...
            - F(4)*NO2(3)/V(3)...
            - J_VT...
            + J_Shunt;

k(4,1) = -NO2_p(4)...
            + J_AT...
            + J_CT...
            + J_VT...
            - CMRO2;

end
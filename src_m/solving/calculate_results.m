function [params data] = calculate_results(data,constants,params,controls)

%%

% Determine which index to use for the baseline assuming zero is baseline
[t0 idxt0] = min(abs(data.t(data.t<=0)));

% Extract direct variables from ODE solver
data.F = data.X(:,1:4);
data.F_p = data.X_p(:,1:4);
data.V = data.X(:,5:7);
data.V_p = data.X_p(:,5:7);

if controls.O2
    data.CO2(:,1) = data.X(:,8);
%     data.CO2p(:,1) = data.X_p(:,8);
    data.NO2 = data.X(:,8:11);
    data.NO2_p = data.X_p(:,8:11);
end

% Initialise remaining variables
nT = length(data.t);
data.A = zeros(nT,constants.n_comp);
data.C = zeros(nT,constants.n_comp+1);
data.D = zeros(nT,constants.n_comp);
data.P = zeros(nT,constants.n_comp);
data.R = zeros(nT,constants.n_comp+1);
data.S = zeros(nT,constants.n_comp+1);
data.T_T = zeros(nT,constants.n_comp);
data.U = zeros(nT,constants.n_comp);

if controls.O2
    data.CO2(:,2:constants.n_comp+2) = zeros(nT,constants.n_comp+1);
    data.JO2 = zeros(nT,constants.n_comp+2);
    data.PO2_raw = data.JO2;
    data.PO2 = data.JO2;
    data.SO2 = zeros(nT,constants.n_comp+1);
    data.nHbT = data.SO2;
    data.nHbO = data.SO2;
    data.ndHb = data.SO2;
    data.cHbT = data.SO2;
    data.cHbO = data.SO2;
    data.cdHb = data.SO2;
end

%%

% Pressure Stimulus
if controls.pressure_type > 0
    data.P(:,constants.n_comp+1) = params.pressure.P_ss + ...
        params.pressure.fhandle(data.t,params.pressure);
else
    data.P(:,constants.n_comp+1) = params.pressure.P_ss;
end;

% Vasodilatory Stimulus
if controls.vasodilation_type > 0
    data.S(:,1) = params.vasodilation.fhandle(data.t,params.vasodilation);
end;


if controls.O2
    
    % CMRO2 Stimulus
    if controls.metabolism_type > 0
        data.S(:,4) = params.metabolism.CMRO2_ss*(1 + ...
            params.metabolism.fhandle(data.t,params.metabolism));
    else
        data.S(:,4) = params.metabolism.CMRO2_ss.*ones(nT,1);
    end;
    
    doK6 = (length(params.metabolism.testK) > 5) && ...
        ~isnan(params.metabolism.testK(6)) && ...
        (params.metabolism.testK(6) > 0);

    % CO2 Stimulus
    if controls.o2concin_type > 0
        
        data.CO2(:,1) = params.o2concin.cO2_in + ...
            params.o2concin.fhandle(data.t,params.o2concin) - ...
            params.main.c_leak;
        
        % Adjust P50 based on input O2 (to simulate CO2 stimulus)
        if doK6
            old_phi = params.gas.hill.phi;
            params.gas.hill.phi = params.gas.hill.phi.*(1 + ...
                params.metabolism.testK(5).*((data.CO2(:,1) + ...
                params.main.c_leak)./params.o2concin.cO2_in - 1));
        end
        
    else
        data.CO2(:,1) = params.o2concin.cO2_in.*ones(nT,1) - ...
            params.main.c_leak;
    end;

end

%% Calculate any totals that need to exist before the main loop

% Calculate the "total" flow, weighted by the instantaneous volume in each
% compartment
data.F(:,end+1) = (data.F(:,1).*0.5.*(data.V(:,1))...
        + data.F(:,2).*0.5.*(data.V(:,1) + data.V(:,2))...
        + data.F(:,3).*0.5.*(data.V(:,2) + data.V(:,3))...
        + data.F(:,3).*0.5.*(data.V(:,3)))./...
    sum(data.V(:,1:constants.n_comp),2);

if controls.O2
    
    % Tissue O2 content and partial pressure
    data.CO2(:,end) = data.NO2(:,end)./params.compliance.V_ss(4);
    data.PO2(:,constants.n_comp+1) = PressureContent(data.CO2(:,end),[],...
        {'content','tissue'},params.gas,controls);
    
end

%%
% Calculate remaining data
for i = 1:constants.n_comp + 2

    if i <= constants.n_comp
        
        data.R(:,i) = (params.main.l(i)^3)./(data.V(:,i).^2);
        data.A(:,i) = (params.main.l(i).*data.V(:,i)).^(0.5);
        
        % Transform compliance into individual structures
        temp.C_ind.C_ss = params.compliance.C_ss(i);
        temp.C_ind.V_ss = params.compliance.V_ss(i);
        temp.C_ind.kappa = params.compliance.kappa(i);
        
        temp.C_ind.nu = params.compliance.nu(i);
        temp.controls_ind.volume_dep = controls.volume_dep(i);
        temp.controls_ind.visco = controls.visco(i);
        
        data.C(:,i) = linear_compliance(data.V(:,i),data.V_p(:,i),...
            data.S(:,i),temp.C_ind,temp.controls_ind);
        
        data.P(:,i) = data.V(:,i)./data.C(:,i);
        
        data.T_T(:,i) = (data.V(:,i))./(0.5*(data.F(:,i)+data.F(:,i+1)));
        data.U(:,i) = params.main.l(i)./data.T_T(:,i);
        data.D(:,i) = sqrt((4.*data.V(:,i).*params.main.l(i))./pi);
        
        if controls.O2
            
            data.CO2(:,i+1) = data.NO2(:,i)./data.V(:,i);
            
            % Account for the fact that we've already got the first CO2
            % and catch up so we can calculate the mean PO2 in this loop.
            if i == 1, jCol = [i i+1];
            else jCol = i+1;       
            end
            
            % Calculate the raw PO2 (entering a compartment)
            for jLoop = jCol
                data.PO2_raw(:,jLoop) = PressureContent(data.CO2(:,jLoop),...
                    [],{'content','blood'},params.gas,controls);
            end
                       
            % Calculate the mean PO2 in a compartment
            data.PO2(:,i) = mean([data.PO2_raw(:,i) data.PO2_raw(:,i+1)],2);
            
            % And the saturation that it corresponds to
            data.SO2(:,i) = PressureContent(data.PO2(:,i),...
                    [],{'pressure','blood'},params.gas,controls)./...
                    params.gas.hill.chi;
            % Alternatives/equivalents
            % data.SO2(:,i) = 1./(1+(constants.physical.PO2_50./...
            %         (constants.reference.PO2_ref.*data.PO2(:,i))).^ ...
            %     params.gas.hill.h);
            % data.SO2(:,i) = data.CO2(:,i).*params.gas.convert_SO2;
            
            % Reset the PO2_50 once we've finished
            doResetP50 = doK6 && (i == constants.n_comp);
            if doResetP50
                params.gas.hill.phi = old_phi;
            end
            
            % Calculate the hemoglobin parameters
            data.nHbT(:,i) = data.V(:,i);
            data.nHbO(:,i) = data.V(:,i).*data.SO2(:,i);
            data.ndHb(:,i) = data.V(:,i).*(1-data.SO2(:,i));
            
            % Concentration of Hb in the compartment
            data.cHbT(:,i) = data.nHbT(:,i)./data.V(:,i);
            data.cHbO(:,i) = data.nHbO(:,i)./data.V(:,i);
            data.cdHb(:,i) = data.ndHb(:,i)./data.V(:,i);
            
            % Calculate the O2 flux to tissue
            
            data.JO2(:,i) = data.F(:,i).*data.CO2(:,i) - ...
                data.F(:,i+1).*data.CO2(:,i+1) - data.NO2_p(:,i);
            testJO2(:,i) = params.main.gO2(i).* ...
                        (data.PO2(:,i) - data.PO2(:,constants.n_comp+1));
            
        end;

    elseif i == constants.n_comp + 1
        
        % Totals
        data.R(:,i) = sum(data.R(:,1:constants.n_comp),2);
        data.C(:,i) = 1./(sum(1./data.C(:,1:constants.n_comp),2));
        data.V(:,i) = sum(data.V(:,1:constants.n_comp),2);
        
        data.T_T(:,i) = (data.V(:,i))./(0.5*(data.F(:,1)+data.F(:,end)));
        
        if controls.O2
            
            data.NO2(:,end+1) = sum(data.NO2(:,1:constants.n_comp),2);
            data.JO2(:,i) = sum(data.JO2(:,1:constants.n_comp),2);
            
            data.ndHb(:,i) = sum(data.ndHb(:,1:constants.n_comp),2);
            data.nHbO(:,i) = sum(data.nHbO(:,1:constants.n_comp),2);
            data.nHbT(:,i) = sum(data.nHbT(:,1:constants.n_comp),2);
            
            data.cHbT(:,i) = data.nHbT(:,i)./data.V(:,i);
            data.cHbO(:,i) = data.nHbO(:,i)./data.V(:,i);
            data.cdHb(:,i) = data.ndHb(:,i)./data.V(:,i);
            
            data.SO2(:,i) = (sum(data.NO2(:,1:constants.n_comp),2)./...
                    data.V(:,i))./params.gas.hill.chi;
                
            % Calculate the correction factors for the wrong baseline 
            % in spectroscopy
            if ~constants.ss.SO2_assumed
                
                correctHbO = 1/data.SO2(idxt0,4);
                correctdHb = 1/(1-data.SO2(idxt0,4));
                correctHbT = 1;
                
            else
                
%                 % Option 1 - Correcting for total hemoglobin differences
%                 correctHbO = 1/(constants.ss.cHb_assumed.*constants.ss.SO2_assumed);
%                 correctdHb = 1/(constants.ss.cHb_assumed.*(1-constants.ss.SO2_assumed));
%                 correctHbT = 1/(constants.ss.cHb_assumed);
                
                % Option 2 - Correcting only for saturation differences
                correctHbO = 1/constants.ss.SO2_assumed;
                correctdHb = 1/(1-constants.ss.SO2_assumed);
                correctHbT = 1;
                
            end
            
            % Change the weighting of different compartments
            correctWeight = constants.ss.specWeight./params.compliance.V_ss(1:3);
            
            % Calculate the hemoglobin signal seen from spectroscopy
            dHb_spec(:,1:constants.n_comp) = (1/1).*bsxfun(...
                @times,data.ndHb(:,1:constants.n_comp),correctWeight);
            HbO_spec(:,1:constants.n_comp) = (1/1).*bsxfun(...
                @times,data.nHbO(:,1:constants.n_comp),correctWeight);
            HbT_spec(:,1:constants.n_comp) = ...
                dHb_spec(:,1:constants.n_comp) + ...
                HbO_spec(:,1:constants.n_comp);
            
            data.dHb_spec = (sum(dHb_spec(:,1:constants.n_comp),2) - ...
                            sum(dHb_spec(idxt0,1:constants.n_comp))).* ...
                            correctdHb;
            data.HbO_spec = (sum(HbO_spec(:,1:constants.n_comp),2) - ...
                            sum(HbO_spec(idxt0,1:constants.n_comp))).* ...
                            correctHbO;
            data.HbT_spec = (sum(HbT_spec(:,1:constants.n_comp),2) - ...
                            sum(HbT_spec(idxt0,1:constants.n_comp))).* ...
                            correctHbT;
            
            % Flux accross shunt
            data.JO2(:,i+1) = params.main.gO2_shunt.* ...
                                (data.PO2(:,1) - data.PO2(:,3));
                            
            % Correct the individual compartment fluxes for the shunt flux
            data.JO2(:,1) = data.JO2(:,1) - data.JO2(:,i+1);
            data.JO2(:,constants.n_comp) = data.JO2(:,i+1) + ...
                data.JO2(:,constants.n_comp);
                            
            % Calculate the PO2_0   
            data.PO2(:,end) = calculate_p0(data.PO2,constants.ss.wMean,...
                                                constants.ss.wPO2);
                                            
            % Calculate the alterative cmro2 (currently assumes first data
            % point is the baseline)
%             gammaR = 1;
%             gammaT = 1;
%             data.cmro2_pred(:,1) = (data.F(:,end)./data.F(1,end)).*...
%                 (gammaR.*(data.ndHb(:,end)./data.ndHb(1,end)-1) + 1)./...
%                 (gammaT.*(data.nHbT(:,end)./data.nHbT(1,end)-1) + 1);
%             data.cmro2_pred(:,1) = (data.F(:,end)./data.F(1,end)).*...
%                 (1 - data.CO2(:,4))./(1 - data.CO2(1,4));
            data.cmro2_pred(:,1) = 1*((data.F(:,end)./data.F(1,end)).*...
                (data.ndHb(:,3)./data.ndHb(1,3))-1) + 1;
%             data.cmro2_pred(:,1) = (data.F(:,end)./data.F(1,end)).*...
%                 (data.ndHb(:,3)./data.ndHb(1,3))./...
%                 (data.nHbT(:,3)./data.nHbT(1,3));
%             data.cmro2_pred(:,1) = ((data.F(:,end)./data.F(1,end)).*...
%                 ((data.CO2(:,1) - data.CO2(:,4))./...
%                 (data.CO2(1,1) - data.CO2(1,4))));
%             data.cmro2_pred(:,1) = ((data.F(:,1).*data.CO2(:,1)) - ...
%                 (data.F(:,4).*data.CO2(:,4)))./(...
%                 (data.F(1,1).*data.CO2(1,1)) - (data.F(1,4).*data.CO2(1,4)));
            
        end
        
    end
    
end

if controls.O2
    
    %% Adjust PO2 values
    nSS = size(controls.PO2_ss,1);
    if nSS > 0
        
        data.PO2_ss = zeros(nT,nSS);
        
        for iSS = 1:nSS
            
            t0 = controls.PO2_ss(iSS,2);
            [junk idxt0] =  min(abs(data.t(data.t <= -t0)- t0));
            
            data.PO2_ss(:,iSS) = calculate_ptn(controls.PO2_ss(iSS,1),...
                [data.PO2(:,1:3) data.PO2(:,end)],idxt0,constants);
            
        end
        
    else
        
        data.PO2_ss = [];
        
    end
    
    %% BOLD 

%     % Stephan et al (2007)
%     data.B(:,1) = constants.BOLD.k(1).*(1 - data.ndHb(:,4));
%     data.B(:,2) = constants.BOLD.k(2).*(1 - data.ndHb(:,4)./data.V(:,4));
%     data.B(:,3) = constants.BOLD.k(3).*(1 - data.V(:,4));
%     data.B(:,4) = sum(data.B(:,1:3),2);

    % Buxton et al (2004) - hemoglobin/volume method
    data.B(:,1) = constants.BOLD.k(1).*(1 - (data.ndHb(:,4)./data.ndHb(1,4)));
    data.B(:,2) = constants.BOLD.k(2).*(1 - ((data.ndHb(:,4)./data.ndHb(1,4))./data.V(:,4)));
    data.B(:,3) = constants.BOLD.k(3).*(1 - data.V(:,4));
    data.B(:,4) = sum(data.B(:,1:3),2);
    data.B = (sum(params.compliance.V_ss(1:3))/sum(params.compliance.V_ss))*data.B;

end;

% Always unscale time and parameters.
data.t = data.t.*constants.scaling.ts;
params = scale_stimulations('unscale',constants,params,controls);

% Unscale data if desired.
if controls.dimensional
    data.F = data.F.*constants.Fs;
    data.P = data.P.*constants.Ps;
    data.V = data.V.*constants.Vs;
    data.R = data.R.*constants.Rs;
    data.C = data.C.*constants.Cs;
    % fill in the rest here
end

end
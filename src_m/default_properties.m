% function [constants params controls] = default_properties
function default = default_properties


%% Controls

controls = struct(...
    'tspan_dim',[-10 70],...
    't_values',[],...
    'n_datapoints',3001,...
    'volume_dep',[true true false],...
    'visco',[true true true],...
    'dimensional',false,...
    'O2',true,...
    'surface_area',false,...
    'vasodilation_type',6,...
    'metabolism_type',6,...
    'pressure_type',0,...
    'o2concin_type',0,...
    'maxstep',8,...
    'PO2_ss',[]);

%% Constants

constants.n_comp = 3;

% Physical Constants
constants.convert_units.P = 7.5006e-3; % convert pressure (mmHg/Pa)
constants.convert_units.length = 100; % convert length (cm/m)

%% Flow

constants.physical.mu = 0.00422*constants.convert_units.P;
    % viscosity of blood (mmHg s) =
    % (mmHg/Pa)*(Pa s [ = N s m^-2 = kg s m^-4])
constants.physical.rho = 1060*constants.convert_units.P*...
    (constants.convert_units.length^-2);
    % density of blood (mmHg s^2 cm^-2) = 
    % (mmHg/Pa)*(cm/m)^-2*(Pa s^2 m^-2 [ = N s^2 m^-4 = kg m^-3])

% Reference Constants %%%%% CHECK THESE AND REFERENCE THEM
constants.reference.u_ref = 1.5; % cm s^-1 (Zweifach1974)
% constants.reference.delta_P_ref = 77; % mmHg original
constants.reference.delta_P_ref = 69; % mmHg (Zweifach1974: art-ven)
constants.reference.r_ref = 2.8*10^-3; % cm = 280um (Zweifach1974)

constants.ss.R_ss = [0.74 0.08 0.18];
params.compliance = struct(...
        'V_ss',[0.288 0.445 0.267 34.79],...
        'kappa',[1.29 1.5139 1000],... 
        'nu',[30.988 163.3384 122.1663],...
        'alpha',[0.62 -1 -1 0.34 0.21]);

% params.compliance.V_ss = [0.238 0.545 0.217 34.79]; % permutation
% params.compliance.kappa = [1.29 1.5139 1000]; % test
% params.compliance.kappa = [1.14 1.001 1.001]; % no dilation
% params.compliance.nu = [32.43041 110.8333 324.3695];  % test

if params.compliance.kappa(3) <= 1.5
    controls.volume_dep(3) = true;
end

% params.compliance.alpha = [0.62 -1 -1 0.34 0.21];

%% Oxygen

% Reference Oxygen partial pressure
constants.reference.PO2_ref = 85.6; % mmHg (Vovenko 1999)

% Normalised ratio of tissue to vasculature.  This value is the average of 
% multiple data sets.  See "Lit Details.xls" in dilation_paper directory
params.compliance.V_ss(4) =  34.79;
% params.compliance.V_ss(4) =  20; % test

% Solubility of O2 in Tissue: mL(O2) mL(Blood)^-1 mmHg^-1
constants.physical.sigma_O2 = 3.249*10^(-5); % Calculated from Dash 2004
% 3.249*10^(-5) = 22.256 mL(O2) mL(Blood)^-1 M^-1 x 1.46*10^-6 M mmHg^-1
     
% Maximum oxygen concentration: mL(O2) mL(Blood)^-1
constants.physical.conc_max = 0.206; % Cartheuser (1993)
% constants.physical.conc_max = 0.2074; % Calculated from Dash 2004

% temp.PO2_50 = 38; % mmHg (38 is standard) Gray Steadman
constants.physical.PO2_50 = 36; % Cartheuser (1993)

% params.gas.hill.h = 2.73; % Hill equation exponent Dash Bass
params.gas.hill.h = 2.6; % Cartheuser (1993)

% Normalised Steady State Partial Pressures
constants.ss.pO2_raw = [81.2 59.7 39.55 41.3 NaN]./...
    constants.reference.PO2_ref; % Vovenko - See oxygen tests and working
% constants.ss.pO2_raw = [81.2 59.7 39.55 40 NaN]./...
%     constants.reference.PO2_ref; % For playing with

% Radii for pO2 profile
constants.ss.r1 = 15; % default
% constants.ss.r1 = 10; % %%%%%%%% TEST VALUE
constants.ss.r2 = 120 + constants.ss.r1; % default
% constants.ss.r2 = 135 + constants.ss.r1; % %%%%%%%% TEST VALUE

% The weight function used in the equation: ptx = wMean*px + (1-wMean)*p0
% constants.ss.wMean = 1/3; % quadratic profile in 2D
% constants.ss.wMean = 1/6; % quadratic profile in 3D
constants.ss.wMean = calc_wmean(constants); % krogh profile in 3D

% This is the p0 value determined via optimisation from Vovenko (or Devor?)
doKrogh = true;
p0 = find_p0_vovenko(constants,doKrogh);
% % for debugging
% doPlot = true; 
% p0 = find_p0_vovenko(constants,doKrogh,doPlot);
% p0 = 12.27;
constants.ss.pO2_raw(5) = p0./constants.reference.PO2_ref;

% The weights used to calculate the average in different compartments
constants.ss.wPO2 = params.compliance.V_ss(1:3);

% The percentage of the allowable range for the shunt to use as g_shunt.
% constants.ss.normk = 0.9;
constants.ss.normk = 0.5;
% constants.ss.normk = 0.1;

% The depth of the cortex (to use when simulating depth)
constants.ss.corticalDepth = 1300; % micrometers, from Diamond (1975)
params.metabolism.depth = 0;

% The amount to scale the metabolism by in the Devor optimisation.  This
% isn't the best place to put it but it'll do for now.
params.metabolism.scaleMod = 0;

% Account for modified baseline conditions
constants.ss.pO2_mean = nan(1,4);
constants.ss.cO2_mean = constants.ss.pO2_mean;

constants.ss.pO2_raw2 = nan(size([1 constants.ss.pO2_raw]));
constants.ss.cO2_raw2 = constants.ss.pO2_raw2;

constants.ss.pO2_mean2 = nan(size(constants.ss.pO2_mean));
constants.ss.cO2_mean2 = constants.ss.pO2_mean2;

constants.ss.cmro2_2 = false;

% Set this here to ensure the structures are all the same
params.metabolism.CMRO2_ss = [];

%% Test variables

params.metabolism.testK(1) = NaN; % reduced O2 leakage
params.metabolism.testK(2) = NaN; % increased p50
params.metabolism.testK(3) = NaN; % increased cap permeability
params.metabolism.testK(4) = NaN; % increased global permeability
params.metabolism.testK(5) = NaN; % reduced shunt permeability

% % Vazquez2008
% % 1
% test = [1.6294    0.054491     0.11188      19.754      5.4406      3.9908]; % RMS 0.549242
% Params.metabolism.testK(1) = test(end);
% % 2
% test = [2.5109      0.2132    0.094674      14.097      3.1726     0.60885]; % RMS 0.670463
% Params.metabolism.testK(2) = test(end);
% % 3
test = [3.7869     0.13281     0.15189      7.0062      5.2559     0.65843];
% test = [2.2645    0.083903     0.30565      19.319      5.0139     0.64338]; % RMS 0.434821
params.metabolism.testK(3) = test(end);
% % 4
% test = [9.6548     0.14208     0.26313      9.9161      4.3785     0.44715];
% test = [3.6516     0.15498    0.012656      19.719      7.4389     0.61018]; % RMS 0.452655
% Params.metabolism.testK(4) = test(end);


%% Haemoglobin and Spectroscopy

% The hematocrit (RBC volume fraction)
constants.physical.hct = 0.45; % TEST VALUE - NEEDS TO BE REFERENCED
% Concentration of hemoglobin in whole blood (millimolar)
constants.physical.concHb = 2.33*10^3; % uM TEST VALUE - NEEDS TO BE REFERENCED

% The weighting given to the different compartment in the spectroscopic
% measurement model
constants.ss.specWeight = params.compliance.V_ss(1:3);
% The baseline saturation assumed in calculating the concentration changes
% from spectroscopy
constants.ss.cHb_assumed = 1; % dimensionless; typically 100 uM
constants.ss.SO2_assumed = 0.50;

%% BOLD

% V0 = 1;
% v0 = 1;
% E0 = 0.4;
% TE = 50/1000;
% epsilon = 1.43;
% r0 = 25;
% 
% constants.BOLD.k(1) = 4.3*v0*E0*TE;
% constants.BOLD.k(2) = epsilon*r0*E0*TE;
% constants.BOLD.k(3) = 1- epsilon;

% BOLD Signal - Stephan et al. (2007)
constants.BOLD.k(1) = 1;
constants.BOLD.k(2) = 0.0572;
constants.BOLD.k(3) = -0.43;

scaleV0 = 13;
constants.BOLD.k = scaleV0*constants.BOLD.k;

% % BOLD Signal - Buxton et al. (2004) deoxyHb/volume
% constants.BOLD.k(1) = 3.4;
% constants.BOLD.k(2) = 0.0;
% constants.BOLD.k(3) = -1;

%% Scaling

constants.scaling.ts = (constants.reference.delta_P_ref*constants.reference.r_ref^2)/...
    (8*constants.physical.mu*constants.reference.u_ref); % s
constants.scaling.Fs = (pi*constants.reference.r_ref^2*constants.reference.u_ref)*10e3; % ul s^-1
constants.scaling.Ps = (constants.reference.delta_P_ref); % mmHg
constants.scaling.Vs = (pi*constants.reference.delta_P_ref*constants.reference.r_ref^4)/...
    (8*constants.physical.mu*constants.reference.u_ref^2)*10e3; % ul
constants.scaling.Rs = (constants.reference.delta_P_ref)/...
    (pi*constants.reference.r_ref^2*constants.reference.u_ref*10e3); % mmHg s uL^-1
constants.scaling.Ls = (constants.physical.rho*constants.reference.delta_P_ref)/...
    (8*pi*constants.physical.mu*constants.reference.u_ref*10e3); % mmHg s^2 mL^-1
constants.scaling.Cs = (pi*constants.reference.r_ref^4)/...
    (8*constants.physical.mu*constants.reference.u_ref^2)*10e3; % uL mmHg^-1
% NO2s
% NCO2s
% ks
% Js / CMRO2s
% PO2s

%% Vasodilation

% Optimised to Mandeville 1999 - see paper
params.vasodilation.t0 = 0;
params.vasodilation.t_stim = 30;

params.vasodilation.t_rise = 1;
params.vasodilation.tau_active = 1.0418;
params.vasodilation.tau_passive = 0.25;
params.vasodilation.A_peak = 2.8786;
params.vasodilation.A_ss = 1.5641;

% % % % FOR DEBUGGING ONLY - TEST
% % params.vasodilation.t0 = 0;
% % params.vasodilation.t_rise = 1;
% params.vasodilation.tau_active = 0.6030557;
% % params.vasodilation.tau_passive = 1;
% params.vasodilation.A_peak = 3.615191;
% params.vasodilation.A_ss = 1.632854;

%% Metabolism

params.metabolism.t0 = params.vasodilation.t0;
params.metabolism.t_stim = params.vasodilation.t_stim;
        
params.metabolism.t_rise = test(1);
params.metabolism.A_peak = test(2);
params.metabolism.A_ss = test(3);
params.metabolism.tau_active = test(4);
params.metabolism.tau_passive = test(5);

%% Pressure

params.pressure.P_ss = 1; % mean of oscillitory pressure input (dimensionless)

%% O2 concentration in

params.o2concin.cO2_in = 1; % Input O2 - by definition
params.o2concin.PO2_in = 1; 

%% Misc

doAddMain = ~isfield(params,'main');
if doAddMain
    params.main = struct;
end

[default.constants default.params default.controls] = ...
                                    deal(constants,params,controls);

end
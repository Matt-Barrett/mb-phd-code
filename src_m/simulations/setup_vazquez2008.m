function [Constants Params Controls] = setup_vazquez2008(sim,Constants,...
                                                 Params,Controls,Override)
                                             
tspanMinDil = -200;

switch sim
    case {'vazquez2008_control'}
        
        Controls.tspan_dim = [-50 70];
        
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(1)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_0',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2',...
                                            Constants, Params, Controls, Override);
    case {'vazquez2008_control_cap'}
        
        Controls.tspan_dim = [-50 70];
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(1)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_0',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2_cap',...
                                            Constants, Params, Controls, Override);
                                        
    case {'vazquez2008_control_leak'}
        
        Controls.tspan_dim = [-50 70];
        
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(1)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_0',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2_leak',...
                                            Constants, Params, Controls, Override);
                                        
    case {'vazquez2008_control_p50'}
        
        Controls.tspan_dim = [-50 70];
        
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(1)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_0',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2_p50',...
                                            Constants, Params, Controls, Override);
                                        
    case {'vazquez2008_control_all'}
        
        Controls.tspan_dim = [-50 70];
        
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(1)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_0',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2_all',...
                                            Constants, Params, Controls, Override);
                                        
	case {'vazquez2008_control_shunt'}
        
        Controls.tspan_dim = [-50 70];
        
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(1)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_0',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2_shunt',...
                                            Constants, Params, Controls, Override);
                                        
    case {'vazquez2008_vasodilated'}
        
        Controls.tspan_dim = [tspanMinDil 70];
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(2)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_1',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2',...
                                            Constants, Params, Controls, Override);
                                        
    case {'vazquez2008_vasodilated_cap'}
        
        Controls.tspan_dim = [tspanMinDil 70];
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(2)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_1',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2_cap',...
                                            Constants, Params, Controls, Override);
                                        
    case {'vazquez2008_vasodilated_leak'}
        
        Controls.tspan_dim = [tspanMinDil 70];
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(2)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_1',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2_leak',...
                                            Constants, Params, Controls, Override);
                                        
    case {'vazquez2008_vasodilated_p50'}
        
        Controls.tspan_dim = [tspanMinDil 70];
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(2)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_1',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2_p50',...
                                            Constants, Params, Controls, Override);
                                        
    case {'vazquez2008_vasodilated_all'}
        
        Controls.tspan_dim = [tspanMinDil 70];
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(2)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_1',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2_all',...
                                            Constants, Params, Controls, Override);
                                        
	case {'vazquez2008_vasodilated_shunt'}
        
        Controls.tspan_dim = [tspanMinDil 70];
        load vazquez2008
        Controls.PO2_ss = [vazquez2008.baseline.PO2(2)./ ...
                                Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_O2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_dil_1',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2_shunt',...
                                            Constants, Params, Controls, Override);
        
    case {'vazquez2008_o2'}
               
        Controls.maxstep = 2;
        
        % O2 In
        Controls.o2concin_type = 0;
        Params.o2concin.PO2_in = 114./Constants.reference.PO2_ref;
        Params.o2concin.P_ss = 1;
%         Params.o2concin.t0 =  Controls.tspan_dim(1);
%         Params.o2concin.t_rise = -Controls.tspan_dim(1).*0.8;
        
        % Adjusted baseline conditions
        Constants.ss.pO2_raw2(1) = 114./Constants.reference.PO2_ref; % art
%         Constants.ss.pO2_raw2(end-1) = 36.9./Constants.reference.PO2_ref; % vei
%         Constants.ss.pO2_mean2(4) = 33/Constants.reference.PO2_ref; % tis

% %         For testing
%         [Constants Params Controls] = setup_problem(...
%                 'vazquez2010_o2',Constants, Params, Controls, Override);
%         [Constants Params Controls] = setup_problem(...
%                 'yaseen2011_o2',Constants, Params, Controls, Override);
        
    case {'vazquez2008_dil_0'} 
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = 10;
        
        % optVals = [1.5704      2.0839       1.066      3.3283      2.0001]; % RMS 0.000456672
%         optVals = [1.5287      1.9851       0.5019     8.4222      2.3467]; % v4_002
        optVals = [0.8120014370165193      1.642180997790527     0.5486306426684375      16.99186452167519      2.119230700541975];

        Params.vasodilation.t_rise = optVals(1);
        Params.vasodilation.A_peak = optVals(2);
        Params.vasodilation.A_ss = optVals(3);
        Params.vasodilation.tau_active = optVals(4);
        Params.vasodilation.tau_passive = optVals(5);
        
        
    case {'vazquez2008_dil_1'}
        
        % Vasodilation
        Controls.vasodilation_type = 7;
        Params.vasodilation.levy.t0 = 0;
        Params.vasodilation.levy.t_stim = 10;
        
        % step
        Params.vasodilation.step.t0 = tspanMinDil;
        Params.vasodilation.step.t_rise = abs(tspanMinDil*0.6);
%         Params.vasodilation.step.t0 = min([Controls.tspan_dim(1) -200]);
%         Params.vasodilation.step.t_rise = abs(Params.vasodilation.step.t0*0.6);
        
        % optVals = [3.2234     0.30095     0.22472      46.705      13.995]; % RMS 0.000190359
        optVals = [2.6727     0.2729     0.4338      41.6088      13.3517]; % v4_002
        
        % levystim
        Params.vasodilation.levy.t_rise = optVals(1);
        Params.vasodilation.levy.A_peak = optVals(2);
        Params.vasodilation.levy.A_ss = optVals(3);
        Params.vasodilation.levy.tau_active = optVals(4);
        Params.vasodilation.levy.tau_passive = optVals(5);
        
%         Params.vasodilation.levy.A_peak = 1; % low pressure
%         Params.vasodilation.levy.A_peak = 0.3; % mid pressure
%         Params.vasodilation.levy.A_peak = 0.15; % very low pressure
%         Params.vasodilation.levy.A_ss = 0.5; % low pressure
%         Params.vasodilation.levy.A_ss = 0.03; % mid pressure
        
        % Pressure
        Controls.pressure_type = 1;
        Params.pressure.P_ss = 1;
        Params.pressure.t0 =  tspanMinDil;
        Params.pressure.t_rise = abs(tspanMinDil*0.6);
        
        % Very low pressure - doesn't work
%         Params.vasodilation.step.A = 70;  % was 9.65
%         Params.pressure.A = -0.70; % very low pressure

        % Low pressure
%         optVal_step = 7.21; % original
        optVal_step = 7.1872; % v4_002
        Params.vasodilation.step.A = optVal_step; 
        Params.pressure.A = -0.5; % low pressure
%           
%         % Mid pressure
%         Params.vasodilation.step.A = 3.52; 
%         Params.pressure.A = -0.17; % mid pressure
        
    case {'vazquez2008_cmro2_cap'}
        
        % Metabolism
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0.75;
        Params.metabolism.t_stim = 10;
        
        Params.metabolism.testK = nan(size(Params.metabolism.testK));
                
%         % 3
        test = [3.7869     0.13281     0.15189      7.0062      5.2559     0.65843];
%         test = [2.2645    0.083903     0.30565      19.319      5.0139     0.64338]; % RMS 0.434821
        Params.metabolism.testK(3) = test(end);
        
        Params.metabolism.t_rise = test(1);
        Params.metabolism.A_peak = test(2);
        Params.metabolism.A_ss = test(3);
        Params.metabolism.tau_active = test(4);
        Params.metabolism.tau_passive = test(5);
        
    case {'vazquez2008_cmro2'}
        
        % Levystim
%         test = [3.7869     0.13281     0.15189      7.0062      5.2559     0];
%         test = [3.061    0.052948     0.02358      9.9406      10.747           0];
        test = [1.4086    0.034191    0.073162      19.024      6.3231           0]; % RMS 0.676546
        
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0.75;
        Params.metabolism.t_stim = 10;
        
        Params.metabolism.t_rise = test(1);
        Params.metabolism.A_peak = test(2);
        Params.metabolism.A_ss = test(3);
        Params.metabolism.tau_active = test(4);
        Params.metabolism.tau_passive = test(5);
        
        Params.metabolism.testK = nan(size(Params.metabolism.testK));
%         Params.metabolism.testK(6) = 2; %%%% Test only
        
    case {'vazquez2008_cmro2_leak'}
        
        % Metabolism
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0.75;
        Params.metabolism.t_stim = 10;
        
        Params.metabolism.testK = nan(size(Params.metabolism.testK));
        
        % 1
        test = [1.6294    0.054491     0.11188      19.754      5.4406      3.9908]; % RMS 0.549242
        Params.metabolism.testK(1) = test(end);
        
        Params.metabolism.t_rise = test(1);
        Params.metabolism.A_peak = test(2);
        Params.metabolism.A_ss = test(3);
        Params.metabolism.tau_active = test(4);
        Params.metabolism.tau_passive = test(5);
        
    case {'vazquez2008_cmro2_p50'}
        
        % Metabolism
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0.75;
        Params.metabolism.t_stim = 10;
        
        Params.metabolism.testK = nan(size(Params.metabolism.testK));
        
        % 2
        test = [2.5109      0.2132    0.094674      14.097      3.1726     0.60885];
        Params.metabolism.testK(2) = test(end);
        
        Params.metabolism.t_rise = test(1);
        Params.metabolism.A_peak = test(2);
        Params.metabolism.A_ss = test(3);
        Params.metabolism.tau_active = test(4);
        Params.metabolism.tau_passive = test(5);
        
    case {'vazquez2008_cmro2_all'}
        
        % Metabolism
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0.75;
        Params.metabolism.t_stim = 10;
        
        Params.metabolism.testK = nan(size(Params.metabolism.testK));
        
        % 4
        % test = [9.6548     0.14208     0.26313      9.9161      4.3785     0.44715];
        test = [3.6516     0.15498    0.012656      19.719      7.4389     0.61018]; % RMS 0.452655
        Params.metabolism.testK(4) = test(end);
        
        Params.metabolism.t_rise = test(1);
        Params.metabolism.A_peak = test(2);
        Params.metabolism.A_ss = test(3);
        Params.metabolism.tau_active = test(4);
        Params.metabolism.tau_passive = test(5);
        
	case {'vazquez2008_cmro2_shunt'}
        
        % Metabolism
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0.75;
        Params.metabolism.t_stim = 10;
        
        Params.metabolism.testK = nan(size(Params.metabolism.testK));
        
        % 4
        % test = [9.6548     0.14208     0.26313      9.9161      4.3785     0.44715];
        test = [3.6516     0.15498    0.012656      19.719      7.4389     0.61018]; % RMS 0.452655
        Params.metabolism.testK(5) = test(end);
        
        Params.metabolism.t_rise = test(1);
        Params.metabolism.A_peak = test(2);
        Params.metabolism.A_ss = test(3);
        Params.metabolism.tau_active = test(4);
        Params.metabolism.tau_passive = test(5);
        
    otherwise
        
        
        
end

end
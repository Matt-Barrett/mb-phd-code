function [Constants Params Controls] = setup_vazquez2010(sim,Constants,...
                                                 Params,Controls,Override)

switch sim
    case {'vazquez2010_cap'}
        
        % Basic
        Controls.tspan_dim = [-10 70];
        Controls.maxstep = 2;
        
        Controls.PO2_ss = [38./Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_o2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_dil',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_cmro2_cap',...
                                            Constants, Params, Controls, Override);
                                        
    case {'vazquez2010'}
        
        % Basic
        Controls.tspan_dim = [-10 70];
        Controls.maxstep = 2;
        
        Controls.PO2_ss = [38./Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_o2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_dil',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_cmro2',...
                                            Constants, Params, Controls, Override);
                                        
	case {'vazquez2010_leak'}
        
        % Basic
        Controls.tspan_dim = [-10 70];
        Controls.maxstep = 2;
        
        Controls.PO2_ss = [38./Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_o2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_dil',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_cmro2_leak',...
                                            Constants, Params, Controls, Override);
                                        
    case {'vazquez2010_p50'}
        
        % Basic
        Controls.tspan_dim = [-10 70];
        Controls.maxstep = 2;
        
        Controls.PO2_ss = [38./Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_o2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_dil',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_cmro2_p50',...
                                            Constants, Params, Controls, Override);
                                        
	case {'vazquez2010_all'}
        
        % Basic
        Controls.tspan_dim = [-10 70];
        Controls.maxstep = 2;
        
        Controls.PO2_ss = [38./Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_o2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_dil',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_cmro2_all',...
                                            Constants, Params, Controls, Override);
                                        
	case {'vazquez2010_shunt'}
        
        % Basic
        Controls.tspan_dim = [-10 70];
        Controls.maxstep = 2;
        
        Controls.PO2_ss = [38./Constants.reference.PO2_ref 0];
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_o2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_dil',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2010_cmro2_shunt',...
                                            Constants, Params, Controls, Override);
        
    case {'vazquez2010_dil'}
        
        % 1.2759      1.5777     0.37533      21.489       4.687 % RMS 0.000317024
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = 20;
        Params.vasodilation.t_rise = 1.2759;
        Params.vasodilation.A_peak = 1.5777;
        Params.vasodilation.A_ss = 0.37533;
        Params.vasodilation.tau_active = 21.489;
        Params.vasodilation.tau_passive = 4.687;
        
    case {'vazquez2010_dil1'}
        
        %  Vasodilation
        Controls.vasodilation_type = 0;
        
    case {'vazquez2010_cmro2_cap'}
        
        [Constants Params Controls] = setup_problem('vazquez2008_cmro2_cap',...
                                    Constants, Params, Controls, Override);
                                
        Params.metabolism.t0 = 0.75;     
        Params.metabolism.t_stim = 20;
%         Params.metabolism.scale = 0.7;
%         Params.metabolism.scale = 0.5727;

        test = [10     0.045    0.03      5.      1];
%         test = [2.2645    0.083903     0.30565      19.319      5.0139
%         0.64338]; % RMS 0.434821
        
        Params.metabolism.t_rise = test(1);
        Params.metabolism.A_peak = test(2);
        Params.metabolism.A_ss = test(3);
        Params.metabolism.tau_active = test(4);
        Params.metabolism.tau_passive = test(5);
        
    case {'vazquez2010_cmro2_leak'}
        
        [Constants Params Controls] = setup_problem('vazquez2008_cmro2_leak',...
                                    Constants, Params, Controls, Override);
                                        
        Params.metabolism.t_stim = 20;
%         Params.metabolism.scale = 0.7;
%         Params.metabolism.scale = 0.5727;
        
    case {'vazquez2010_cmro2_p50'}
        
        [Constants Params Controls] = setup_problem('vazquez2008_cmro2_p50',...
                                    Constants, Params, Controls, Override);
                                        
        Params.metabolism.t_stim = 20;
%         Params.metabolism.scale = 0.7;
%         Params.metabolism.scale = 0.5727;
        
    case {'vazquez2010_cmro2_all'}
        
        [Constants Params Controls] = setup_problem('vazquez2008_cmro2_all',...
                                    Constants, Params, Controls, Override);
                                        
        Params.metabolism.t_stim = 20;
%         Params.metabolism.scale = 0.7;
%         Params.metabolism.scale = 0.5727;
        
    case {'vazquez2010_cmro2_shunt'}
        
        [Constants Params Controls] = setup_problem('vazquez2008_cmro2_shunt',...
                                    Constants, Params, Controls, Override);
                                        
        Params.metabolism.t_stim = 20;
%         Params.metabolism.scale = 0.5727;
        
    case {'vazquez2010_cmro2'}
        
        [Constants Params Controls] = setup_problem('vazquez2008_cmro2',...
                                    Constants, Params, Controls, Override);
                                        
        Params.metabolism.t_stim = 20;
%         Params.metabolism.scale = 0;
%         Params.metabolism.scale = 6.0902e-09;
%         Params.metabolism.testK(6) = 2; %%%% Test only
        
    case {'vazquez2010_o2'}
        
        % O2 In
        Controls.o2concin_type = 0;
%         Controls.o2concin_type = 1;
        Params.o2concin.PO2_in = 133./Constants.reference.PO2_ref; % Vazquez2010
        Params.o2concin.P_ss = 1;
        Params.o2concin.t0 =  Controls.tspan_dim(1);
        Params.o2concin.t_rise = -Controls.tspan_dim(1).*0.8;

        % Adjusted baseline conditions
% %         Constants.ss.pO2_raw2(1) = 140./Constants.reference.PO2_ref; % devor2011
        Constants.ss.pO2_raw2(1) = 133./Constants.reference.PO2_ref; % systemic art
% %         Constants.ss.cmro2_2 = @(cmro2_ss) 0.85*cmro2_ss; % modified CMRO2
% %         Constants.ss.pO2_mean2(1) = 55./Constants.reference.PO2_ref; % mean art
%         Constants.ss.pO2_mean2(3) = 35.1/Constants.reference.PO2_ref; % vei
%         Constants.ss.pO2_raw2(end-1) = 36.9./Constants.reference.PO2_ref; % vei
% %         Constants.ss.pO2_raw2(end-1) = 20./Constants.reference.PO2_ref; % vei
% %         Constants.ss.pO2_mean2(4) = 38/Constants.reference.PO2_ref; % tis
% %         Constants.ss.pO2_raw2(end) = 10./Constants.reference.PO2_ref; % p0
%         % tissue must be <=45 ish to be lower than capillary
        
        % Adjusted baseline conditions
        Constants.ss.pO2_mean2(3) = 37.8/Constants.reference.PO2_ref; % vei
        Constants.ss.pO2_raw2(end-1) = 40.3./Constants.reference.PO2_ref; % vei
        
end

end
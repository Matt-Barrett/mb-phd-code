function [Constants Params Controls] = setup_devor2011(sim,Constants,...
                                                 Params,Controls,Override)

switch sim
    case {'devor2011_surface'}
        
        Controls.tspan_dim = [-50 45];
        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_vasodilation',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_cmro2',...
                                            Constants, Params, Controls, Override);
        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_o2_surface',...
                                            Constants, Params, Controls, Override);
                                        
    case {'devor2011_mid'}
        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_surface',...
                                            Constants, Params, Controls, Override);
        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_o2_mid',...
                                            Constants, Params, Controls, Override);
                                        
    case {'devor2011_deep'}
        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_surface',...
                                            Constants, Params, Controls, Override);
        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_o2_deep',...
                                            Constants, Params, Controls, Override);
                                        
    case {'devor2011_surface1'}
        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_surface',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_vasodilation1',...
                                            Constants, Params, Controls, Override);
                                        
	case {'devor2011_mid1'}
        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_mid',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_vasodilation1',...
                                            Constants, Params, Controls, Override);
                                        
	case {'devor2011_deep1'}
        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_deep',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'devor2011_vasodilation1',...
                                            Constants, Params, Controls, Override);
    
    case {'devor2011_vasodilation'}
        
        test = [1.2063     0.45611     0.10219       21.66      1.0033]; % RMS 0.161001
        
%         test = 
%         Params.metabolism.scale = 0.15;
        
        Params.vasodilation.t_rise = test(1);
        Params.vasodilation.A_peak = test(2);
        Params.vasodilation.A_ss = test(3);
        Params.vasodilation.tau_active = test(4);
        Params.vasodilation.tau_passive = test(5);
                                        
        %  Vasodilation
        Controls.vasodilation_type = 6;
%         Params.vasodilation.A_peak = @(A_ss) A_ss*2.1228;
        Params.vasodilation.t_stim = 20;
        Params.vasodilation.t0 = 0;
        
    case {'devor2011_vasodilation1'}
                                        
        %  Vasodilation
        Controls.vasodilation_type = 0;
                                        
    case {'devor2011_cmro2'}
        
        [Constants Params Controls] = setup_problem(...
                                            'vazquez2008_cmro2',...
                                            Constants, Params, Controls, Override);
                                        
        Params.metabolism.t_stim = 20;
        
        Params.metabolism.scale = 0.225;
        
        % 
        Params.metabolism.scaleMod = 0;
                                        
    case {'devor2011_o2_surface'}
        
        % O2 In
%         Controls.o2concin_type = 0;
%         Params.o2concin.PO2_in = 140./Constants.reference.PO2_ref;
%         Params.o2concin.P_ss = 1;
%         Params.o2concin.t0 =  Controls.tspan_dim(1);
%         Params.o2concin.t_rise = -Controls.tspan_dim(1).*0.8;
        
        % Adjusted baseline conditions
        Constants.ss.pO2_raw2(1) = 140./Constants.reference.PO2_ref; % art 1
%         Constants.ss.cmro2_2 = @(cmro2_ss) 0.95*cmro2_ss; % modified CMRO2
        Constants.ss.pO2_mean2(1) = 90./Constants.reference.PO2_ref; % mean art
        Constants.ss.pO2_mean2(3) = 27/Constants.reference.PO2_ref; % vei
%         Constants.ss.pO2_mean2(4) = 20/Constants.reference.PO2_ref; % tis 1
        Constants.ss.pO2_raw2(end-1) = 29./Constants.reference.PO2_ref; % vei
        Constants.ss.pO2_raw2(end) = 14./Constants.reference.PO2_ref; % p0
        
        
    case {'devor2011_o2_mid'}
        
        % Adjusted baseline conditions
        Params.metabolism.depth = 100;
        Constants.ss.cmro2_2 = @(cmro2_ss,depth) (1 - ...
            (depth./Constants.ss.corticalDepth))*cmro2_ss;
%         Constants.ss.pO2_mean2(1) = NaN; % art 2
        Constants.ss.pO2_mean2(1) = 67./Constants.reference.PO2_ref; % art 2
%         Constants.ss.pO2_mean2(3) = 25/Constants.reference.PO2_ref; % vei
%         Constants.ss.pO2_raw2(end-1) = 34./Constants.reference.PO2_ref; % vei 2
%         Constants.ss.pO2_mean2(4) = 18/Constants.reference.PO2_ref; % tis 2
        Constants.ss.pO2_raw2(end-1) = 28./Constants.reference.PO2_ref; % vei
        Constants.ss.pO2_raw2(end) = 11.5./Constants.reference.PO2_ref; % p0
        
    case {'devor2011_o2_deep'}
        
        % Adjusted baseline conditions
        Params.metabolism.depth = 200;
        Constants.ss.cmro2_2 = @(cmro2_ss,depth) (1 - ...
            (depth./Constants.ss.corticalDepth))*cmro2_ss;
        Constants.ss.pO2_mean2(1) = 55./Constants.reference.PO2_ref; % art 3
%         Constants.ss.pO2_mean2(3) = 25/Constants.reference.PO2_ref; % vei
%         Constants.ss.pO2_raw2(end-1) = 30./Constants.reference.PO2_ref; % vei 3
%         Constants.ss.pO2_mean2(4) = 16/Constants.reference.PO2_ref; % tis 3
        Constants.ss.pO2_raw2(end-1) = 25./Constants.reference.PO2_ref; % vei
        Constants.ss.pO2_raw2(end) = 9.99./Constants.reference.PO2_ref; % p0
        
end

end
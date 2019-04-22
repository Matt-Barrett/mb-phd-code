function [Constants Params Controls] = setup_leithner2010(sim,Constants,...
                                                 Params,Controls,Override)

switch sim
    case {'leithner2010_baseline'}
        
        Controls.tspan_dim = [-50 45];
        
        % 4.2206      2.7653      1.4452
        % 3.6533      2.3525      7.5446
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        % Params.vasodilation.A_peak = @(A_ss) A_ss*2.1228;
        Params.vasodilation.A_peak = 2.5;
        Params.vasodilation.A_ss = 1.4;
        Params.vasodilation.tau_active = 1.4452;
        Params.vasodilation.t_stim = 16;
        
        [Constants Params Controls] = setup_problem(...
                                            'leithner2010_o2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'leithner2010_cmro2',...
                                            Constants, Params, Controls, Override);                                        
                                        
    case {'leithner2010_inhibited'}
        
        Controls.tspan_dim = [-50 45];
        
        % 1.2168     0.26518       9.974
        % 1.2676     0.15606       10.39
        % 1.3       0.7     2
        
        % 1.3428     0.13401      14.284
        
        %  Vasodilation
        Params.vasodilation.A_peak = 0.6;
        Params.vasodilation.A_ss = 0.07;
        Params.vasodilation.tau_active = 14.284;
        
        Controls.vasodilation_type = 6;
        Params.vasodilation.t_stim = 16;
        
        [Constants Params Controls] = setup_problem(...
                                            'leithner2010_o2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'leithner2010_cmro2',...
                                            Constants, Params, Controls, Override);
                                        
    case {'leithner2010_inhibited2'}
        
        Controls.tspan_dim = [-50 45];
        
        Controls.vasodilation_type = 0;
        
        [Constants Params Controls] = setup_problem(...
                                            'leithner2010_o2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants Params Controls] = setup_problem(...
                                            'leithner2010_cmro2',...
                                            Constants, Params, Controls, Override);
                                        
    case {'leithner2010_cmro2'}
        
        % Metabolism
        
        % 0.18215      0.1753      5.7137      13.651      1.2728
        % 0.17805     0.10528      1.4191      14.445      9.1445
        % 0.17999     0.10608      3.0526      19.523      9.3428
        % 0.17436      0.1336      4.5073      19.739      7.7966
        
        % Levystim
        % Params.metabolism.A_peak =  0.17436;
        % Params.metabolism.A_ss = 0.23; %0.1336;
        Params.metabolism.A_peak =  0.11;
        Params.metabolism.A_ss = 0.15; %0.1336;
        Params.metabolism.t_rise = 4.5;
        Params.metabolism.tau_active = 19;
        Params.metabolism.tau_passive = 7.8;
        
        Controls.metabolism_type = 0;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = 16;
        
%         % Smoothpulse
%         Controls.metabolism_type = 2;
%         Params.metabolism.t0 = 0;
%         Params.metabolism.t_stim = 16;
%         Params.metabolism.t_rise = [5 1.5];
%         Params.metabolism.A = 0.2;
                                        
    case {'leithner2010_o2'}
        
        % O2 In
        Controls.o2concin_type = 0;
        Params.o2concin.PO2_in = 132./Constants.reference.PO2_ref;
        Params.o2concin.P_ss = 1;
        Params.o2concin.t0 =  Controls.tspan_dim(1);
        Params.o2concin.t_rise = -Controls.tspan_dim(1).*0.8;
        
        % Adjusted baseline conditions
        Constants.ss.pO2_raw2(1) = 132./Constants.reference.PO2_ref; % art
%         Constants.ss.pO2_raw2(end-1) = 36.9./Constants.reference.PO2_ref; % vei
%         Constants.ss.pO2_mean2(4) = 30/Constants.reference.PO2_ref; % tis
        
        % This is a guess for testing
        Constants.ss.cHb_assumed = 80; % uM

end

end
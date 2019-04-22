function [Constants, Params, Controls] = setup_misc(sim,Constants,...
                                                Params,Controls,Override)

switch sim
    case {'1_second'}
        
        Controls.tspan_dim = [-5 100];
        Controls.maxstep = 1.2;
        Params.vasodilation.t_stim = 1;
        
        Controls.O2 = false;
    
    case {'10_seconds'}
        
        Controls.tspan_dim = [-5 100];
        Controls.maxstep = 10;
        Params.vasodilation.t_stim = 10;
        
        Controls.O2 = false;
        
    case {'30_seconds'}
        
        Controls.tspan_dim = [-5 100];
        Controls.maxstep = 10;
        Params.vasodilation.t_stim = 30;
        
        Controls.O2 = false;
        
    case 'calcinaghi2011'
        
        Controls.tspan_dim = [-5 50];
        
        load calcinaghi2011
        
        baseline_HbT = Calcinaghi2011.baseline_dHb + ...
            Calcinaghi2011.baseline_HbO;
        Constants.ss.SO2_assumed = Calcinaghi2011.baseline_HbO./...
            baseline_HbT;
%         Constants.ss.specWeight = [0.3 0.3 0.4];
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
%         Params.vasodilation.A_peak = @(A_ss) A_ss*2.1228;
        Params.vasodilation.A_peak = 0.8;
        Params.vasodilation.A_ss = 0.03;
        Params.vasodilation.tau_active = 0.4;
        Params.vasodilation.tau_passive = 2;
        Params.vasodilation.t_stim = Calcinaghi2011.stim_duration;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_rise = 1;
        
        % O2 In
        Params.o2concin.PO2_in = Calcinaghi2011.baseline_PO2./...
            Constants.reference.PO2_ref;
        Constants.ss.pO2_raw2(1) = Params.o2concin.PO2_in;
    
        % Levystim
        Params.metabolism.A_peak =  0.001;
        Params.metabolism.A_ss = 0.03; %0.1336;
        Params.metabolism.t_rise = 4.5;
        Params.metabolism.tau_active = 2;
        Params.metabolism.tau_passive = 7.8;
        
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Calcinaghi2011.stim_duration;
        
    case 'cmro2_phase'
        
        Controls.metabolism_type = 9;
        Params.metabolism.t_stim = 20;
        
        optVals = [12    0.08      20];
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case {'find_stim'}        
        
        Controls.tspan_dim = [0 100];
        Controls.maxstep = 30;
        Params.compliance.nu = [10 10 10];
        Controls.vasodilation_type = 1;
        Params.vasodilation.t_rise = 30;
        Params.vasodilation.A = -0.5;
        
        Controls.O2 = false;
        
    case {'flow_volume_loop'}
        
        Controls.tspan_dim = [0 750];
        Controls.maxstep = 10;
        
        % Set this viscoelasticity value lower so that the simulations
        % don't take forever to run.
        Params.compliance.nu = [5 5 5];
        
        % Vasodilation
        Controls.vasodilation_type = 3;
        Params.vasodilation.t_rise = 15;
        Params.vasodilation.t_diff = 30;
        
        % The flow range to plot F-V loop over. These numbers were the 
        % approximate average of the experimental papers I'm comparing to.
        FLOW_RANGE = [0.5 3];
        
        % Ensure the vasodilatory stimulus changes are equispaced.
        Params.vasodilation.n = [4 16]; 
        
        Controls.O2 = false;
        
        % Set bounds for Flow-Volume loop
        Params.vasodilation.y_diff = calculate_stim_bounds(FLOW_RANGE,...
                        Params.vasodilation.n,Constants,Params,Controls);
    
    case {'hb_step'}
        
        Controls.tspan_dim = [-1 30];
        Controls.maxstep = 1;
        
        % Reduce viscoelasticity so we converge faster?
%         Params.compliance.nu = [10 10 10];
        
%         %  Vasodilation - Smoothstep
%         Controls.vasodilation_type = 1;
%         Params.vasodilation.A = 1;
%         Params.vasodilation.t0 = 0;
%         Params.vasodilation.t_rise = 10;
        
        %  Vasodilation - Levystim
%         Controls.vasodilation_type = 6;
%         Params.vasodilation.A_ss = 2.6;
        Params.vasodilation.A_peak = @(A_ss) A_ss*2.1228;
%         Params.vasodilation.tau_active = 1.4452;
%         Params.vasodilation.t_stim = 30;
        
%         %  Metabolism - Smoothstep
%         Controls.metabolism_type = 1;
%         Params.metabolism.A = 1;
%         Params.metabolism.t0 = 0;
%         Params.metabolism.t_rise = 10;
        
        % Metabolism - Levystim
        Controls.metabolism_type = 6;
%         Params.metabolism.A_peak =  0.17999;
        Params.metabolism.A_peak = @(A_ss) A_ss*1.01;
%         Params.metabolism.A_peak = @(A_ss) A_ss*1.6967;
        Params.metabolism.A_ss = 0.10608;
        Params.metabolism.t_rise = 1;
%         Params.metabolism.t_rise = 3.0526;
        Params.metabolism.tau_active = 19.523;
        Params.metabolism.tau_passive = 9.3428;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = 30;
        
        % Adjusted baseline conditions
        Controls.o2concin_type = 0;
        Constants.ss.pO2_raw2(1) = 100./Constants.reference.PO2_ref; % art
        
    case {'inertia_base'}
        
        Controls.O2 = false;
        Controls.tspan_dim = [0 200];
        
        Controls.inertia = true; % 8*10^-12;
        
        % Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_rise = 1.5;  % was 1.8
        Params.vasodilation.t_stim = 1;
        Params.vasodilation.tau_active = 1; % was 0.3
        Params.vasodilation.tau_passive = 0.3;
        Params.vasodilation.A_peak = 1.4; % was 1.7
        Params.vasodilation.A_ss = 0.6;
        
    case {'loop_cbf'}
        
        [Constants, Params, Controls] = setup_problem('jones2002_o2',...
                                    Constants, Params, Controls, Override);
                                
        Controls.metabolism_type = 0;
        Controls.tspan_dim = [0 750];
%         Controls.maxstep = 1;

        Controls.PO2_ss = [30./Constants.reference.PO2_ref 0];
        
        % Set this viscoelasticity value lower so that the simulations
        % don't take forever to run.
        Params.compliance.nu = [5 5 5];
        
        % Vasodilation
        Controls.vasodilation_type = 3;
        Params.vasodilation.t_rise = 15;
        Params.vasodilation.t_diff = 30;
        
        % The flow range to plot loop over.
        FLOW_RANGE = [0.6 1.8];
        
        % Ensure the vasodilatory stimulus changes are equispaced.
        Params.vasodilation.n = [5 10]; 
        
        % Set bounds for Flow loop
        Params.vasodilation.y_diff = calculate_stim_bounds(FLOW_RANGE,...
                        Params.vasodilation.n,Constants,Params,Controls);
                    
    case {'loop_cmro2'}
        
        Controls.vasodilation_type = 0;
        Controls.tspan_dim = [0 750];
%         Controls.maxstep = 1;

        Controls.PO2_ss = [30./Constants.reference.PO2_ref 0];
        
        % Set this viscoelasticity value lower so that the simulations
        % don't take forever to run.
        Params.compliance.nu = [5 5 5];
        
        % Vasodilation
        Controls.metabolism_type = 3;
        Params.metabolism.t_rise = 15;
        Params.metabolism.t_diff = 30;
        
        % The flow range to plot loop over.
        CMRO2_RANGE = [0.8 1.4];
        
        % Ensure the vasodilatory stimulus changes are equispaced.
        Params.metabolism.n = [5 10]; 
        
        % Set bounds for CMRO2 loop
        Params.metabolism.y_diff = abs((1 - CMRO2_RANGE)./...
            (Params.metabolism.n));
        
    case {'mandeville1999_6s'}
        
        Controls.tspan_dim = [-10 70];
        Controls.maxstep = 5;
        Params.vasodilation.t_stim = 6;
        
        Controls.O2 = false;
        
    case {'mandeville1999_30s'}
        
        Controls.tspan_dim = [-10 70];
        Controls.maxstep = 5;
        Params.vasodilation.t_stim = 30;
        
        Controls.O2 = false;
        
    case 'royl2008'
        
        Controls.tspan_dim = [-5 50];
        
        load royl2008
        
        baseline_HbT = Royl2008.baseline_dHb + ...
            Royl2008.baseline_HbO;
        Constants.ss.SO2_assumed = Royl2008.baseline_HbO./...
            baseline_HbT;
%         Constants.ss.specWeight = [0.3 0.3 0.4];
        % This is a guess for testing
        Constants.ss.cHb_assumed = 80; % uM
        
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
%         Params.vasodilation.A_peak = @(A_ss) A_ss*2.1228;
        Params.vasodilation.A_peak = 0.7;
        Params.vasodilation.A_ss = 0.05;
        Params.vasodilation.tau_active = 0.6;
        Params.vasodilation.tau_passive = 3;
        Params.vasodilation.t_stim = Royl2008.stim_duration;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_rise = 3;
        
        % O2 In
        Params.o2concin.PO2_in = Royl2008.baseline_PO2./...
            Constants.reference.PO2_ref;
        Constants.ss.pO2_raw2(1) = Params.o2concin.PO2_in;
    
        % Levystim
        Params.metabolism.A_peak =  0.05;
        Params.metabolism.A_ss = 0.1; %0.1336;
        Params.metabolism.t_rise = 4.5;
        Params.metabolism.tau_active = 2;
        Params.metabolism.tau_passive = 7.8;
        
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Royl2008.stim_duration;
        
    
        
    case 'test_dil'
        
        [Constants, Params, Controls] = setup_problem('test_o2', ...
            Constants, Params, Controls, Override);
        
        [Constants, Params, Controls] = setup_problem('test_cbf',...
            Constants, Params, Controls, Override);
                                
        Controls.metabolism_type = 0;
        
    case 'test_metab'
        
        [Constants, Params, Controls] = setup_problem('test_o2', ...
            Constants, Params, Controls, Override);
        
        
        
        [Constants, Params, Controls] = setup_problem('test_cmro2',...
            Constants, Params, Controls, Override); 
                                
        Controls.vasodilation_type = 0;
        
    case 'test_dil_metab'
        
        [Constants, Params, Controls] = setup_problem('test_o2', ...
            Constants, Params, Controls, Override);
        
        [Constants, Params, Controls] = setup_problem('test_cbf',...
            Constants, Params, Controls, Override);
        
        [Constants, Params, Controls] = setup_problem('test_cmro2',...
            Constants, Params, Controls, Override);
        
	case 'test_o2'
        
        Controls.PO2_ss = [30./Constants.reference.PO2_ref 0];
        [Constants, Params, Controls] = setup_problem('jones2002_o2', ...
            Constants, Params, Controls, Override);
        
%         load vazquez2008
%         Controls.PO2_ss = [vazquez2008.baseline.PO2(1)./ ...
%                                 Constants.reference.PO2_ref 0];
%         [Constants, Params, Controls] = setup_problem('vazquez2008_O2', ...
%             Constants, Params, Controls, Override);

%         Controls.PO2_ss = [38./Constants.reference.PO2_ref 0];
%         [Constants, Params, Controls] = setup_problem('vazquez2010_o2', ...
%             Constants, Params, Controls, Override);

%         % Offenhauser 2005
%         Controls.PO2_ss = [38.4./Constants.reference.PO2_ref 0];
%         Constants.ss.pO2_raw2(1) = 123.9./Constants.reference.PO2_ref;
        
%         % 100% Saturation
%         Constants.ss.pO2_raw2(1) = 185./Constants.reference.PO2_ref;
        
    case 'test_cbf'
        
        Controls.vasodilation_type = 6;
        Params.vasodilation.t_stim = 20;
        optVals = [1     2    1.25      1     0.25];
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
%         [Constants, Params, Controls] = setup_problem('vazquez2008_dil_0',...
%             Constants, Params, Controls, Override);

%         [Constants, Params, Controls] = setup_problem('vazquez2010_dil',...
%             Constants, Params, Controls, Override);
        
%         % Offenhauser 2005
%         Controls.vasodilation_type = 6;
%         Params.vasodilation.t_stim = 15;
%         optVals = [5     0.2    1.45      3     10];
%         Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
%             optVals,Params.vasodilation);
        
    case 'test_cmro2'
        
        Controls.metabolism_type = 9;
        Params.metabolism.t_stim = 20;
        optVals = [4    0.12      5];
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
%         [Constants, Params, Controls] = setup_problem('vazquez2008_cmro2_cap',...
%             Constants, Params, Controls, Override);
        
%         [Constants, Params, Controls] = setup_problem('vazquez2010_cmro2_cap',...
%             Constants, Params, Controls, Override);
        
%         % Offenhauser 2005
%         Controls.metabolism_type = 6;
%         Params.metabolism.t_stim = 15;
%         optVals = [1    0.01    0.35	10   20];
%         Params.metabolism = assign_optvals(Controls.metabolism_type,...
%             optVals,Params.metabolism);
        
    case {'vovenko1999'}
        
        % Use the default properties
        
    case {'yaseen2011'}
        
        % Basic
        Controls.tspan_dim = [-60 70];
        Controls.maxstep = 5;

        [Constants, Params, Controls] = setup_problem(...
                                            'yaseen2011_o2',...
                                            Constants, Params, Controls, Override);
                                        
        [Constants, Params, Controls] = setup_problem(...
                                            'yaseen2011_dil',...
                                            Constants, Params, Controls, Override);

    case 'yaseen2011_o2'
        
        % O2 In
        Controls.o2concin_type = 0;
        Params.o2concin.PO2_in = 108.25./Constants.reference.PO2_ref; % Yaseen2011
%         Params.o2concin.P_ss = 1;
%         Params.o2concin.t0 =  Controls.tspan_dim(1);
%         Params.o2concin.t_rise = -Controls.tspan_dim(1).*0.8;

        % Adjusted baseline conditions
        Constants.ss.pO2_raw2(1) = 108.25./Constants.reference.PO2_ref; % systemic art
%         Constants.ss.pO2_mean2(1) = 80./Constants.reference.PO2_ref; % mean art
        Constants.ss.pO2_raw2(end-1) = 54.4./Constants.reference.PO2_ref; % vei 
        Constants.ss.pO2_mean2(3) = 52.25/Constants.reference.PO2_ref; % tis
%         Constants.ss.pO2_raw2(end) = 30./Constants.reference.PO2_ref; %
%         tissue 
        
    case 'yaseen2011_dil'
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 3;
        Params.vasodilation.t_stim = 4;
        Params.vasodilation.t_rise = 1.5011;
        Params.vasodilation.A_peak = 0.8; % .84
        Params.vasodilation.A_ss = 0.4; % 0.395
        Params.vasodilation.tau_active = 5;
        Params.vasodilation.tau_passive = 1; % 3.5
        
    otherwise
        
        warning('SetupProblem:NoMatchingSim', ['No matching simulations'...
            ' were found.  Continuing with default parameters.'])

end

end
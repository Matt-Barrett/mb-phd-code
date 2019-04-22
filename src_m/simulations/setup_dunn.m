function [Constants Params Controls] = setup_dunn(sim,Constants,...
                                                Params,Controls,Override)

switch sim
    case 'dunn2003'
        
        Controls.tspan_dim = [0 10];
        Controls.maxstep = 2;
        
        [Constants Params Controls] = setup_problem('dunn2003_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('dunn2003_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('dunn2003_cmro2_raw',...
                                    Constants, Params, Controls, Override);
        
    case 'dunn2003_cbf'
        
        [Dunn2003 idxCtrl] = load_dunn2003('control');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Dunn2003(idxCtrl).stim_duration;
        
        optVals = [2 0.4 0.1 0.6 2]; % original
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
    case 'dunn2003_cmro2_raw'
        
        [Dunn2003 idxCtrl] = load_dunn2003('control');
        
        % Metabolism
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Dunn2003(idxCtrl).stim_duration;
        
        Params.metabolism.A_peak =  0.001;
        Params.metabolism.A_ss = 0.04;
        Params.metabolism.t_rise = 4.5;
        Params.metabolism.tau_active = 2;
        Params.metabolism.tau_passive = 7.8;
        
    case 'dunn2003_o2'
        
        [Dunn2003 idxCtrl] = load_dunn2003('control');
        
        % O2 Params
        Params.o2concin.PO2_in = Dunn2003(idxCtrl).baseline_PO2./...
            Constants.reference.PO2_ref;
        Constants.ss.pO2_raw2(1) = Params.o2concin.PO2_in;
        
        % Hemoglobin Params
        baseline_HbT = Dunn2003(idxCtrl).baseline_dHb + ...
            Dunn2003(idxCtrl).baseline_HbO;
        Constants.ss.SO2_assumed = Dunn2003(idxCtrl).baseline_HbO./...
            baseline_HbT;
        
    case 'dunn2005_fp_adj'
        
        Controls.tspan_dim = [-5 50];
        
        [Constants Params Controls] = setup_problem('dunn2005_fp_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('dunn2005_fp_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('dunn2005_fp_cmro2_adj',...
                                    Constants, Params, Controls, Override);
                                
    case 'dunn2005_fp_raw'
                                
        Controls.tspan_dim = [-5 50];
        
        [Constants Params Controls] = setup_problem('dunn2005_fp_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('dunn2005_fp_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('dunn2005_fp_cmro2_raw',...
                                    Constants, Params, Controls, Override);
                                
    case 'dunn2005_fp_cbf'
        
        [Dunn2005 idxFP] = load_dunn2005('forepaw');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Dunn2005(idxFP).stim_duration;
        
        % optVals = [1.6 1.1 0.15 0.6 10]; % original
        optVals = [1.6546      1.1464    0.095576     0.50088 1.9643]; % RMS 0.0062512
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
    case 'dunn2005_fp_cmro2_adj'
        
        [Dunn2005 idxFP] = load_dunn2005('forepaw');
        
        % Metabolism
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Dunn2005(idxFP).stim_duration;
        
        % optVals = [4.5 0.001 0.04 2 7.8]; % original
        optVals = [18.006     0.000     0.398    14.018    13.229]; % RMS 0.0046621
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case 'dunn2005_fp_cmro2_raw'
        
        [Dunn2005 idxFP] = load_dunn2005('forepaw');
        
        % Metabolism
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Dunn2005(idxFP).stim_duration;
        
        % optVals = [4.5 0.001 0.04 2 7.8]; % original
        optVals = [9.90817    0.0211291  4.73345e-05      13.9865      1.00004]; % RMS 0.00922823
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case 'dunn2005_fp_o2'
        
        [Dunn2005 idxFP] = load_dunn2005('forepaw');
        
        % O2 Params
        Params.o2concin.PO2_in = Dunn2005(idxFP).baseline_PO2./...
            Constants.reference.PO2_ref;
        Constants.ss.pO2_raw2(1) = Params.o2concin.PO2_in;
        
        % Hemoglobin Params
        baseline_HbT = Dunn2005(idxFP).baseline_dHb + ...
            Dunn2005(idxFP).baseline_HbO;
        Constants.ss.SO2_assumed = Dunn2005(idxFP).baseline_HbO./...
            baseline_HbT;
        
    case 'dunn2005_w_adj'
        
        Controls.tspan_dim = [-5 50];
        
        [Constants Params Controls] = setup_problem('dunn2005_w_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('dunn2005_w_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('dunn2005_w_cmro2_adj',...
                                    Constants, Params, Controls, Override);
                                
	case 'dunn2005_w_raw'
        
        Controls.tspan_dim = [-5 50];
        
        [Constants Params Controls] = setup_problem('dunn2005_w_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('dunn2005_w_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('dunn2005_w_cmro2_raw',...
                                    Constants, Params, Controls, Override);
                                
    case 'dunn2005_w_cbf'
        
        [Dunn2005 idxW] = load_dunn2005('whisker');
        
        % Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Dunn2005(idxW).stim_duration;
        
        % optVals = [1.3 0.6 0.07 0.6 10]; % original
        optVals = [1.1767     0.551486    0.0692772     0.400256      19.7894]; % RMS 0.0052775
        % optVals = [1.25     0.6    0.0692772     0.5 15]; % test
        % optVals = [1.2984      0.5195    0.066242     0.51463      1.8069]; % RMS 0.0054438
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
    case 'dunn2005_w_cmro2_adj'
        
        [Dunn2005 idxW] = load_dunn2005('whisker');
        
        % Metabolism
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Dunn2005(idxW).stim_duration;
        
        % optVals = [4.5 0.001 0.03 2 7.8]; % original
        optVals = [9.4415    0.0277454     0.372668      11.1368 4.29421]; % RMS 0.00579982
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);
        
    case 'dunn2005_w_cmro2_raw'
        
        [Dunn2005 idxW] = load_dunn2005('whisker');
        
        % Metabolism
        Controls.metabolism_type = 6;
        Params.metabolism.t0 = 0;
        Params.metabolism.t_stim = Dunn2005(idxW).stim_duration;
        
        % optVals = [4.5 0.001 0.03 2 7.8]; % original
        optVals = [2.86886  1.62273e-08     0.027592     0.695451 11.7999]; % RMS 0.00602292
        
        Params.metabolism = assign_optvals(Controls.metabolism_type,...
            optVals,Params.metabolism);       
        
    case 'dunn2005_w_o2'
        
        [Dunn2005 idxW] = load_dunn2005('whisker');
        
        % O2 Params
        Params.o2concin.PO2_in = Dunn2005(idxW).baseline_PO2./...
            Constants.reference.PO2_ref;
        Constants.ss.pO2_raw2(1) = Params.o2concin.PO2_in;
        
        % Hemoglobin Params
        baseline_HbT = Dunn2005(idxW).baseline_dHb + ...
            Dunn2005(idxW).baseline_HbO;
        Constants.ss.SO2_assumed = Dunn2005(idxW).baseline_HbO./...
            baseline_HbT;
        
end

end

function [Dunn2003 idx] = load_dunn2003(name)

load dunn2003
idx = find(strcmp({Dunn2003(:).name}, name)); %#ok<NODEF>

end

function [Dunn2005 idx] = load_dunn2005(name)

load dunn2005
idx = find(strcmp({Dunn2005(:).name}, name)); %#ok<NODEF>

end
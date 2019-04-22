function [Constants Params Controls] = setup_hoge(sim,Constants,...
                                                Params,Controls,Override)
                                            
switch sim
    case 'hoge1999_01_ghc_top'
        
        Controls.tspan_dim = [-30 300];
        
        [Constants Params Controls] = setup_problem('hoge1999_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_01_ghc_top_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_no_cmro2',...
                                    Constants, Params, Controls, Override);
                                
    case 'hoge1999_01_ghc_top_cbf'
        
        [Hoge1999 idx01_top_ghc] = load_hoge1999('hoge1999_01_ghc_top');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Hoge1999(idx01_top_ghc).stim_duration;
        
        optVals = [10    0.12    0.12    1.4452  30];
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
    case 'hoge1999_02_ghc_top'
        
        Controls.tspan_dim = [-30 300];
        
        [Constants Params Controls] = setup_problem('hoge1999_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_02_ghc_top_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_no_cmro2',...
                                    Constants, Params, Controls, Override);
                                
    case 'hoge1999_02_ghc_top_cbf'
        
        [Hoge1999 idx01_top_ghc] = load_hoge1999('hoge1999_02_ghc_top');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Hoge1999(idx01_top_ghc).stim_duration;
        
        optVals = [10    0.2    0.2    1.4452  30];
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
    case 'hoge1999_03_ghc_top'
        
        Controls.tspan_dim = [-30 300];
        
        [Constants Params Controls] = setup_problem('hoge1999_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_03_ghc_top_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_no_cmro2',...
                                    Constants, Params, Controls, Override);
                                
    case 'hoge1999_03_ghc_top_cbf'
        
        [Hoge1999 idx01_top_ghc] = load_hoge1999('hoge1999_03_ghc_top');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Hoge1999(idx01_top_ghc).stim_duration;
        
        optVals = [10    0.2    0.2    1.4452  30];
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
    case 'hoge1999_04_ghc_top'
        
        Controls.tspan_dim = [-30 300];
        
        [Constants Params Controls] = setup_problem('hoge1999_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_04_ghc_top_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_no_cmro2',...
                                    Constants, Params, Controls, Override);
                                
    case 'hoge1999_04_ghc_top_cbf'
        
        [Hoge1999 idx01_top_ghc] = load_hoge1999('hoge1999_03_ghc_top');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Hoge1999(idx01_top_ghc).stim_duration;
        
        optVals = [10    0.5    0.5    1.4452  30];
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
    case 'hoge1999_02_ghc_bottom'
        
        Controls.tspan_dim = [-30 300];
        
        [Constants Params Controls] = setup_problem('hoge1999_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_02_ghc_bottom_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_no_cmro2',...
                                    Constants, Params, Controls, Override);
        
    case 'hoge1999_02_ghc_bottom_cbf'
        
        [Hoge1999 idx02_bottom_ghc] = load_hoge1999('hoge1999_02_ghc_bottom');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Hoge1999(idx02_bottom_ghc).stim_duration;
        
        optVals = [10    0.15    0.15    1.4452  30];
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
    case 'hoge1999_04_ghc_bottom'
        
        Controls.tspan_dim = [-30 300];
        
        [Constants Params Controls] = setup_problem('hoge1999_o2',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_04_ghc_bottom_cbf',...
                                    Constants, Params, Controls, Override);
                                
        [Constants Params Controls] = setup_problem('hoge1999_no_cmro2',...
                                    Constants, Params, Controls, Override);
        
    case 'hoge1999_04_ghc_bottom_cbf'
        
        [Hoge1999 idx02_bottom_ghc] = load_hoge1999('hoge1999_04_ghc_bottom');
        
        %  Vasodilation
        Controls.vasodilation_type = 6;
        Params.vasodilation.t0 = 0;
        Params.vasodilation.t_stim = Hoge1999(idx02_bottom_ghc).stim_duration;
        
        optVals = [10    0.3    0.3    1.4452  30];
        
        Params.vasodilation = assign_optvals(Controls.vasodilation_type,...
            optVals,Params.vasodilation);
        
        
    case 'hoge1999_no_cmro2'
        
        Controls.metabolism_type = 0;
        
    case 'hoge1999_o2'
        
        % O2 Params - NEED TO SEE IF THIS IS A VALID ASSUMPTION
        Constants.ss.pO2_raw2(1) = 100./Constants.reference.PO2_ref;
        
end

end

function [Hoge1999 idx] = load_hoge1999(name)

load hoge1999
idx = find(strcmp({Hoge1999(:).name}, name)); %#ok<NODEF>

end
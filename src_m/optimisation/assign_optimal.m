function [override default] = assign_optimal(problem,history,composite,...
                                                default,override)

switch problem
    case 'devor2011_pto2'
        
        override = assign_cbf(override,history,composite,...
            'devor2011_vasodilation');
        
    case 'dunn2005_fp_cbf'
        
        override = assign_cbf(override,history,composite,'dunn2005_fp_cbf');
        
    case 'dunn2005_fp_hb_adj'
        
        override = assign_hb(override,history,composite,'dunn2005_fp_cmro2_adj');
        
	case 'dunn2005_fp_hb_raw'
        
        override = assign_hb(override,history,composite,'dunn2005_fp_cmro2_raw');
        
    case 'dunn2005_w_cbf'
        
        override = assign_cbf(override,history,composite,'dunn2005_w_cbf');
        
    case 'dunn2005_w_hb_adj'
        
        override = assign_hb(override,history,composite,'dunn2005_w_cmro2_adj');
        
	case 'dunn2005_w_hb_raw'
        
        override = assign_hb(override,history,composite,'dunn2005_w_cmro2_raw');
        
    case 'jones2002_04_cbf'
        
        override = assign_cbf(override,history,composite,'jones2002_04_cbf');
        
    case 'jones2002_04_hb_adj'
        
        override = assign_hb(override,history,composite,'jones2002_04_cmro2_adj');
        
	case 'jones2002_04_hb_raw'
        
        override = assign_hb(override,history,composite,'jones2002_04_cmro2_raw');
        
    case 'jones2002_08_cbf'
        
        override = assign_cbf(override,history,composite,'jones2002_08_cbf');
        
    case 'jones2002_08_hb_adj'
        
        override = assign_hb(override,history,composite,'jones2002_08_cmro2_adj');
        
	case 'jones2002_08_hb_raw'
        
        override = assign_hb(override,history,composite,'jones2002_08_cmro2_raw');
        
    case 'jones2002_12_cbf'
        
        override = assign_cbf(override,history,composite,'jones2002_12_cbf');
        
    case 'jones2002_12_hb_adj'
        
        override = assign_hb(override,history,composite,'jones2002_12_cmro2_adj');
        
	case 'jones2002_12_hb_raw'
        
        override = assign_hb(override,history,composite,'jones2002_12_cmro2_raw');

    case 'jones2002_16_cbf'
        
        override = assign_cbf(override,history,composite,'jones2002_16_cbf');
        
    case 'jones2002_16_hb_adj'
        
        override = assign_hb(override,history,composite,'jones2002_16_cmro2_adj');
        
	case 'jones2002_16_hb_raw'
        
        override = assign_hb(override,history,composite,'jones2002_16_cmro2_raw');
        
    case 'jones2002_co2_5_cbf'
        
        override = assign_cbf(override,history,composite,'jones2002_co2_5_cbf');
        
    case 'jones2002_co2_10_cbf'
        
        override = assign_cbf(override,history,composite,'jones2002_co2_10_cbf');

    case 'kappa'

        default.params.compliance.kappa(2) = history(composite(1,3)).x_opt;

    case 'nu_flow'

        default.params.compliance.nu(1) = history(composite(1,3)).x_opt(1);
        default.params.vasodilation.tau_active = history(composite(1,3)).x_opt(2);
        default.params.vasodilation.A_ss = history(composite(1,3)).x_opt(3);
        default.params.vasodilation.A_peak = history(composite(1,3)).x_opt(4);

    case 'nu_volume'

        default.params.compliance.nu(2:3) = history(composite(1,3)).x_opt;

    case 'nu_both'

        default.params.compliance.nu = history(composite(1,3)).x_opt(1:3);
        default.params.vasodilation.tau_active = history(composite(1,3)).x_opt(4);
        default.params.vasodilation.A_ss = history(composite(1,3)).x_opt(5);
        default.params.vasodilation.A_peak = history(composite(1,3)).x_opt(6);

    case 'nu_dilcon'

        default.params.compliance.nu = history(composite(1,3)).x_opt(1:3);
        default.params.vasodilation.tau_d = history(composite(1,3)).x_opt(4);
        default.params.vasodilation.tau_c = history(composite(1,3)).x_opt(5);
        default.params.vasodilation.A = history(composite(1,3)).x_opt(6);
        default.params.vasodilation.B = history(composite(1,3)).x_opt(7);

    case 'vazquez2008_cbf_baseline'

        override.vazquez2008_dil_1.vasodilation.step.A = ...
            history(composite(1,3)).x_opt(1);

    case 'vazquez2008_cbf_control'
        
        override = assign_cbf(override,history,composite,...
            'vazquez2008_dil_0');

    case 'vazquez2008_cbf_dilated'

        override.vazquez2008_dil_1.vasodilation.levy.t_rise = ...
            history(composite(1,3)).x_opt(1);
        override.vazquez2008_dil_1.vasodilation.levy.A_peak = ...
            history(composite(1,3)).x_opt(2);
        override.vazquez2008_dil_1.vasodilation.levy.A_ss = ...
            history(composite(1,3)).x_opt(3);
        override.vazquez2008_dil_1.vasodilation.levy.tau_active = ...
            history(composite(1,3)).x_opt(4);
        override.vazquez2008_dil_1.vasodilation.levy.tau_passive = ...
            history(composite(1,3)).x_opt(5);

    case 'vazquez2008_pto2_cap'
        
        override = assign_cmro2(default,override,history,composite,...
            'vazquez2008_cmro2_cap');

    case 'vazquez2008_pto2_nomech'

        override.vazquez2008_cmro2.metabolism.t_rise = ...
            history(composite(1,3)).x_opt(1);
        override.vazquez2008_cmro2.metabolism.A_peak = ...
            history(composite(1,3)).x_opt(2);
        override.vazquez2008_cmro2.metabolism.A_ss = ...
            history(composite(1,3)).x_opt(3);
        override.vazquez2008_cmro2.metabolism.tau_active = ...
            history(composite(1,3)).x_opt(4);
        override.vazquez2008_cmro2.metabolism.tau_passive = ...
            history(composite(1,3)).x_opt(5);

    case 'vazquez2008_pto2_leak'
        
        override = assign_cmro2(default,override,history,composite,...
            'vazquez2008_cmro2_leak');

    case 'vazquez2008_pto2_p50'
        
        override = assign_cmro2(default,override,history,composite,...
            'vazquez2008_cmro2_p50');

    case 'vazquez2008_pto2_all'
        
        override = assign_cmro2(default,override,history,composite,...
            'vazquez2008_cmro2_all');
        
	case 'vazquez2008_pto2_shunt'
        
        override = assign_cmro2(default,override,history,composite,...
            'vazquez2008_cmro2_shunt');

    case 'vazquez2010_cbf'
        
        override = assign_cbf(override,history,composite,...
            'vazquez2010_dil');

    case 'vazquez2010_pto2_cap'
        
        doScale = length(history(composite(1,3)).x_opt) == 1;
        if doScale
            override.vazquez2010_cmro2_cap.metabolism.scale = ...
                history(composite(1,3)).x_opt(1);
        else
            override = assign_cmro2(default,override,history,composite,...
                'vazquez2010_cmro2_cap');
        end

    case 'vazquez2010_pto2_nomech'
        
        doScale = length(history(composite(1,3)).x_opt) == 1;
        if doScale
            override.vazquez2010_cmro2.metabolism.scale = ...
                history(composite(1,3)).x_opt(1);
        else
            override = assign_cmro2(default,override,history,composite,...
                'vazquez2010_cmro2');
        end
        
    case 'vazquez2010_pto2_leak'
        
        doScale = length(history(composite(1,3)).x_opt) == 1;
        if doScale
            override.vazquez2010_cmro2_leak.metabolism.scale = ...
                history(composite(1,3)).x_opt(1);
        else
            override = assign_cmro2(default,override,history,composite,...
                'vazquez2010_cmro2_leak');
        end
        
    case 'vazquez2010_pto2_p50'
        
        doScale = length(history(composite(1,3)).x_opt) == 1;
        if doScale
            override.vazquez2010_cmro2_p50.metabolism.scale = ...
                history(composite(1,3)).x_opt(1);
        else
            override = assign_cmro2(default,override,history,composite,...
                'vazquez2010_cmro2_p50');
        end
        
    case 'vazquez2010_pto2_all'
        
        doScale = length(history(composite(1,3)).x_opt) == 1;
        if doScale
            override.vazquez2010_cmro2_all.metabolism.scale = ...
                history(composite(1,3)).x_opt(1);
        else
            override = assign_cmro2(default,override,history,composite,...
                'vazquez2010_cmro2_all');
        end
        
	case 'vazquez2010_pto2_shunt'
        
        doScale = length(history(composite(1,3)).x_opt) == 1;
        if doScale
            override.vazquez2010_cmro2_shunt.metabolism.scale = ...
                history(composite(1,3)).x_opt(1);
        else
            override = assign_cmro2(default,override,history,composite,...
                'vazquez2010_cmro2_shunt');
        end
        
    otherwise
        
        warning('AssignOptimal:NothinAssigned',['No optimal variables '...
            'were assigned to Default or Override structures as no '...
            'matching case was found.'])
            
end
    
end

function override = assign_cbf(override,history,composite,simName)

override.(simName).vasodilation.t_rise = ...
    history(composite(1,3)).x_opt(1);
override.(simName).vasodilation.A_peak = ...
    history(composite(1,3)).x_opt(2);
override.(simName).vasodilation.A_ss = ...
    history(composite(1,3)).x_opt(3);
override.(simName).vasodilation.tau_active = ...
    history(composite(1,3)).x_opt(4);
override.(simName).vasodilation.tau_passive = ...
    history(composite(1,3)).x_opt(5);

end

function override = assign_cmro2(default,override,history,composite,simName)

override.(simName).metabolism.t_rise = ...
    history(composite(1,3)).x_opt(1);
override.(simName).metabolism.A_peak = ...
    history(composite(1,3)).x_opt(2);
override.(simName).metabolism.A_ss = ...
    history(composite(1,3)).x_opt(3);
override.(simName).metabolism.tau_active = ...
    history(composite(1,3)).x_opt(4);
override.(simName).metabolism.tau_passive = ...
    history(composite(1,3)).x_opt(5);

doK  = isfield(history(composite(1,3)).obj_data, 'testKNum');
if doK
    numK = history(composite(1,3)).obj_data.testKNum;
    override.(simName).metabolism.testK = nan(size(...
        default.params.metabolism.testK));
    override.(simName).metabolism.testK(numK) = ...
        history(composite(1,3)).x_opt(6);
end

end

function override = assign_hb(override,history,composite,simName)

nOptVars = length(history(composite(1,3)).x_opt);

switch nOptVars
    case 3
        
        override.(simName).metabolism.t_rise = ...
            history(composite(1,3)).x_opt(1);
        override.(simName).metabolism.A_ss = ...
            history(composite(1,3)).x_opt(2);
        override.(simName).metabolism.tau_passive = ...
            history(composite(1,3)).x_opt(3);
        
    case 5
        
        override.(simName).metabolism.t_rise = ...
            history(composite(1,3)).x_opt(1);
        override.(simName).metabolism.A_peak = ...
            history(composite(1,3)).x_opt(2);
        override.(simName).metabolism.A_ss = ...
            history(composite(1,3)).x_opt(3);
        override.(simName).metabolism.tau_active = ...
            history(composite(1,3)).x_opt(4);
        override.(simName).metabolism.tau_passive = ...
            history(composite(1,3)).x_opt(5);
        
end

end
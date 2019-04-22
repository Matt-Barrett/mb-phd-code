function [sim_list errfun_empty history fn_multiplier] = ...
                                        setupopt_vazquez2008(history)

switch history.problem
    case 'vazquez2008_cbf_baseline'
        
        % Simulations required for this optimisation
        sim_list = {'vazquez2008_vasodilated'};
        % Objective function to use
        errfun_empty = @errfun_vazquez2008_cbf_baseline;
        
        % specific optimisation options
        history.lb = 2;
        history.ub = 15;
        history.options = [];
%         history.options = optimset('LargeScale','off','LevenbergMarquardt','off');
%         history.options = optimset(...
%                 'TolFun',1e-3,...
%                 'TolX',1e-3,...
%                 'MaxFunEvals',500 ...
%                 );        
            
        % specific variables for objective function
        load vazquez2008
        history.obj_data.data_obs.cbf = vazquez2008.baseline.F(2);
        history.obj_data.scaling = ones(size(history.lb));
        
        % other variables
        fn_multiplier = 1000;
        
    case 'vazquez2008_cbf_control'
        
        % Simulations required for this optimisation
        sim_list = {'vazquez2008_control'};
        % Objective function to use
        errfun_empty = @errfun_cbf;
        
        % specific optimisation options
        history.lb = [0.5 0.5 0.5 0.1 1];
        history.ub = [10  5   4   30 10];
%         history.options = [];
%         history.options = optimset('LargeScale','off','LevenbergMarquardt','off');
        history.options = optimset(...
                'TolFun',1e-3,...
                'TolX',1e-3,...
                'MaxFunEvals',500 ...
                );
            
%         history.useLSQ = true;
            
        % specific variables for objective function
        load vazquez2008
        history.obj_data.data_obs.cbf(:,1) = linspace(-5,70,1000)';
        method = 'pchip';
        history.obj_data.data_obs.cbf(:,2) = interp1(...
            vazquez2008.F.control(:,1),vazquez2008.F.control(:,2),...
            history.obj_data.data_obs.cbf(:,1),method);
%         history.obj_data.data_obs = vazquez2008.F.control;
        history.obj_data.scaling = [1 1 1 1 1];
        history.obj_data.orderSims = 1;
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 1000;
        
    case 'vazquez2008_cbf_dilated'
        
        % Simulations required for this optimisation
        sim_list = {'vazquez2008_vasodilated'};
        % Objective function to use
        errfun_empty = @errfun_cbf;
        
        % specific optimisation options
        history.lb = [1  0.1 0.1 0.5  5 ];
        history.ub = [10 1   3   50   20];
%         history.options = [];
%         history.options = optimset('LargeScale','off','LevenbergMarquardt','off');
        history.options = optimset(...
                'TolFun',1e-3,...
                'TolX',1e-3,...
                'MaxFunEvals',500 ...
                );
            
        % specific variables for objective function
        load vazquez2008
        history.obj_data.data_obs.cbf(:,1) = linspace(-5,70,1000)';
        method = 'pchip';
        history.obj_data.data_obs.cbf(:,2) = interp1(...
            vazquez2008.F.vasodilated(:,1),...
            vazquez2008.F.vasodilated(:,2)./(1.7/1.2),...
            history.obj_data.data_obs.cbf(:,1),method);
%         history.obj_data.data_obs = vazquez2008.F.control;
        history.obj_data.scaling = [1 1 1 1 1];
        history.obj_data.orderSims = 1;
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 1000;
        
    case 'vazquez2008_pto2'
        
        % Simulations required for this optimisation
        sim_list = {'vazquez2008_control','vazquez2008_vasodilated'};
        % Objective function to use
        errfun_empty = @errfun_vazquez2008_pto2;
        
        % specific optimisation options
        
        % levystim
%         test = [5 0.11 0.1 0.3 20 0.642249];
        history.lb = [0.3 0   0   0.3 0.5 0];
        history.ub = [10  0.5 0.5 20  20  2];
        
%         history.options = [];
        history.options = optimset(...
                'TolFun',1e-3,...
                'TolX',1e-3,...
                'MaxFunEvals',500 ...
                );
%         history.useLSQ = true;
        
        % specific variables for objective function
        load vazquez2008
        history.obj_data.data_obs.time = linspace(-5,70,1000)';
        method = 'pchip';
        history.obj_data.data_obs.control = interp1(...
            vazquez2008.PO2.control(:,1),vazquez2008.PO2.control(:,2),...
            history.obj_data.data_obs.time,method);
        history.obj_data.data_obs.vasodilated = interp1(...
            vazquez2008.PO2.vasodilated(:,1),vazquez2008.PO2.vasodilated(:,2),...
            history.obj_data.data_obs.time,method);
        history.obj_data.data_obs.baseline = vazquez2008.baseline;

        history.obj_data.scaling = ones(size(history.lb));
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 10000;
        
    case 'vazquez2008_pto2_leak'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'vazquez2008_pto2';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'vazquez2008_control_leak',...
            'vazquez2008_vasodilated_leak'};
        
        % Modify optimisation options from the other simulations
        history.lb(end) = 0;
        history.ub(end) = 4;
        history.obj_data.testKNum = 1;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'vazquez2008_pto2_p50'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'vazquez2008_pto2';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'vazquez2008_control_p50',...
            'vazquez2008_vasodilated_p50'};
        
        % Modify optimisation options from the other simulations
        history.lb(end) = 0;
        history.ub(end) = 3;
        history.obj_data.testKNum = 2;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'vazquez2008_pto2_cap'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'vazquez2008_pto2';
        [sim_list errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'vazquez2008_control_cap',...
            'vazquez2008_vasodilated_cap'};
        
        % Modify optimisation options from the other simulations
        history.lb = [1 0.05 0   5  1  0.3];
        history.ub = [5 0.3  0.4 25 15 1.5];
        history.obj_data.testKNum = 3;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
    
    case 'vazquez2008_pto2_all'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'vazquez2008_pto2';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'vazquez2008_control_all',...
            'vazquez2008_vasodilated_all'};
        
        % Modify optimisation options from the other simulations
        history.lb(end) = 0;
        history.ub(end) = 2;
        history.obj_data.testKNum = 4;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
	case 'vazquez2008_pto2_shunt'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'vazquez2008_pto2';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'vazquez2008_control_shunt',...
            'vazquez2008_vasodilated_shunt'};
        
        % Modify optimisation options from the other simulations
        history.lb(end) = 0;
        history.ub(end) = 5;
        history.obj_data.testKNum = 5;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'vazquez2008_pto2_nomech'
        
        % Recursively call this function to grab the same params as the
        % unblocked case
        history_in = history;
        history_in.problem = 'vazquez2008_pto2';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
                                    
        sim_list = {'vazquez2008_control','vazquez2008_vasodilated'};
        
        % Modify optimisation options from the regular nu_both simulations
        history.lb = [2  0    0 2  1];
        history.ub = [10 0.15 1 30 10];
        history.obj_data.scaling = ones(size(history.lb));
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    otherwise
        
        error('SetupOpt:InvalidProblemIn',...
            'Invalid optimisation problem "%s"',history.problem)
        
        
end

end
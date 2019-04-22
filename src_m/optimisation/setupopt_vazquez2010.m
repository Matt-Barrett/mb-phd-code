function [sim_list errfun_empty history fn_multiplier] = ...
                                        setupopt_vazquez2010(history)

switch history.problem
    case 'vazquez2010_cbf'
        
        % Simulations required for this optimisation
        sim_list = {'vazquez2010'};
        % Objective function to use
        errfun_empty = @errfun_cbf;
        
        % specific optimisation options
        history.lb = [0.8 0.1 0.05 1   1 ];
        history.ub = [3   4   3    40  10];
        history.options = [];
%         history.options = optimset('LargeScale','off','LevenbergMarquardt','off');
        history.options = optimset(...
                'TolFun',1e-3,...
                'TolX',1e-3,...
                'MaxFunEvals',500 ...
                );
            
%         history.useLSQ = true;
            
        % specific variables for objective function
        load vazquez2010
        history.obj_data.data_obs.cbf(:,1) = linspace(-5,65,1000)';
        method = 'pchip';
        history.obj_data.data_obs.cbf(:,2) = interp1(...
            Vazquez2010.LDF(:,1),Vazquez2010.LDF(:,2),...
            history.obj_data.data_obs.cbf(:,1),method);
%         history.obj_data.data_obs = vazquez2008.F.control;
        history.obj_data.scaling = [1 1 1 1 1];
        history.obj_data.orderSims = 1;
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 1000;
        
    case 'vazquez2010_pto2_cap'
        
        % Simulations required for this optimisation
        sim_list = {'vazquez2010_cap'};
        % Objective function to use
        errfun_empty = @errfun_vazquez2010_pto2;
        
        % specific optimisation options
%         history.lb = 0;
%         history.ub = 1;
        history.lb = [1   0   0   0.3 0.3];
        history.ub = [20  0.3 0.2 30  40];

%         history.options = [];
        history.options = optimset(...
                'MaxFunEvals',500 ...
                );
%                 'TolFun',1e-4,...
%                 'TolX',1e-4,...

%         history.useLSQ = true;
        
        % specific variables for objective function
        load vazquez2010
        history.obj_data.data_obs = Vazquez2010;

        history.obj_data.scaling = ones(size(history.lb));
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 10000;
        
    case 'vazquez2010_pto2_nomech'
        
        % Recursively call this function to grab the same params as the
        % unblocked case
        history_in = history;
        history_in.problem = 'vazquez2010_pto2_cap';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'vazquez2010'};
        
%         history.lb = 0;
%         history.ub = 1;
        history.lb = [1   0   0   0.3 0.3];
        history.ub = [20  0.3 0.2 30  40];
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
	case 'vazquez2010_pto2_leak'
        
        % Recursively call this function to grab the same params as the
        % unblocked case
        history_in = history;
        history_in.problem = 'vazquez2010_pto2_cap';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'vazquez2010_leak'};
        
%         history.lb = 0;
%         history.ub = 1;
        history.lb = [1   0   0   0.3 0.3];
        history.ub = [20  0.3 0.2 30  40];
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'vazquez2010_pto2_p50'
        
        % Recursively call this function to grab the same params as the
        % unblocked case
        history_in = history;
        history_in.problem = 'vazquez2010_pto2_cap';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'vazquez2010_p50'};
        
%         history.lb = 0;
%         history.ub = 1;
        history.lb = [1   0   0   0.3 0.3];
        history.ub = [20  0.3 0.2 30  40];
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
	case 'vazquez2010_pto2_all'
        
        % Recursively call this function to grab the same params as the
        % unblocked case
        history_in = history;
        history_in.problem = 'vazquez2010_pto2_cap';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'vazquez2010_all'};
        
%         history.lb = 0;
%         history.ub = 1;
        history.lb = [1   0   0   0.3 0.3];
        history.ub = [20  0.3 0.2 30  40];
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
	case 'vazquez2010_pto2_shunt'
        
        % Recursively call this function to grab the same params as the
        % unblocked case
        history_in = history;
        history_in.problem = 'vazquez2010_pto2_cap';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'vazquez2010_shunt'};
        
%         history.lb = 0;
%         history.ub = 1;
        history.lb = [1   0   0   0.3 0.3];
        history.ub = [20  0.3 0.2 30  40];
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    otherwise
        
        error('SetupOpt:InvalidProblemIn',...
            'Invalid optimisation problem "%s"',history.problem)
        
end
        
end
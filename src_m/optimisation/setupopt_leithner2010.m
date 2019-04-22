function [sim_list errfun_empty history fn_multiplier] = ...
                                        setupopt_leithner2010(history)

switch history.problem
    case 'leithner2010_dhb'
        
        % Simulations required for this optimisation
        sim_list = {'leithner2010_baseline','leithner2010_inhibited'};
        % Objective function to use
        errfun_empty = @errfun_leithner2010_dhb;
        
        % specific optimisation options
        history.lb = [0.1 0.1 0.1 1 1];
        history.ub = [0.5 0.4 15 20 20];
%         history.options = [];
        history.options = optimset(...
                'TolFun',1e-3,...
                'TolX',1e-3,...
                'MaxFunEvals',500 ...
                );
        % specific variables for objective function
        load leithner2010
        history.obj_data.data_obs = Leithner2010;
        history.obj_data.scaling = [1 1 1 1 1];
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 10000;
        
    case 'leithner2010_cbf_baseline'
        
        history_in = history;
        history_in.problem = 'leithner2010_cbf';
        
        [sim_list errfun_empty history fn_multiplier] = ...
                                            setup_optimisation(history_in);
                                        
        
        sim_list = {'leithner2010_baseline'};
        history.obj_data.orderSims = 1;
        
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'leithner2010_cbf_inhibited'
        
        history_in = history;
        history_in.problem = 'leithner2010_cbf';
        
        [sim_list errfun_empty history fn_multiplier] = ...
                                            setup_optimisation(history_in);
                                        
        
        sim_list = {'leithner2010_inhibited'};
        history.obj_data.orderSims = 2;
        
        history.lb = [0 0 0.1];
        history.ub = [4 3 15];
        
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'leithner2010_cbf'
        
        % Simulations required for this optimisation
        sim_list = {'leithner2010_baseline'};
        % Objective function to use
        errfun_empty = @errfun_leithner2010_cbf;
        
        % specific optimisation options
        history.lb = [1 1 0.1];
        history.ub = [4 3 15];
        history.options = [];
        history.options = optimset('LargeScale','off','LevenbergMarquardt','off');
%         history.options = optimset(...
%                 'TolFun',1e-3,...
%                 'TolX',1e-3,...
%                 'MaxFunEvals',500 ...
%                 );
            
        % specific variables for objective function
        load leithner2010
        history.obj_data.data_obs = Leithner2010;
        history.obj_data.scaling = [1 1 1];
        history.obj_data.orderSims = 1;
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 1000;
        
    otherwise
        
        error('SetupOpt:InvalidProblemIn',...
            'Invalid optimisation problem "%s"',history.problem)
        
end

end
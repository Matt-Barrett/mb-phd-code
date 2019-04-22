function [sim_list errfun_empty history fn_multiplier] = ...
                                        setupopt_cbfcbv(history)

switch history.problem
    case 'kappa'
        
        % Simulations required for this optimisation
        sim_list = {'flow_volume_loop'};
        % Objective function to use
        errfun_empty = @errfun_kappa;
        % specific optimisation options
        history.lb = 1.01;
        history.ub = 3;
        history.options = optimset(...
                'TolFun',1e-5,...
                'TolX',1e-5...
                );
        % specific variables for objective function
        history.obj_data.alpha = history.default.params.compliance.alpha;
        history.obj_data.free_kappa = 2; % value(s) I am optimising for
        history.lb = history.lb.*ones(1,length(history.obj_data.free_kappa));
        history.ub = history.ub.*ones(1,length(history.obj_data.free_kappa));
        history.obj_data.scaling = 1;
        history.obj_data.simList = sim_list;
        history.obj_data.default = history.default;
        % specific variables for myoutput function
        history.alpha_data = [];
        
        % other variables
        fn_multiplier = 1000;     
        
    case 'nu_flow'
        
        % Simulations required for this optimisation
        sim_list = {'mandeville1999_6s','mandeville1999_30s'};
        % Objective function to use
        errfun_empty = @errfun_nu_flow;
        % specific optimisation options
        history.lb = [0.1 0.1 0.22 0.3]; history.ub = [0.8 1 0.35 0.6];
        history.options = optimset(...
                'TolFun',5e-4,...
                'TolX',5e-4...
                );
        % specific variables for objective function
        history.obj_data.data_obs = load_mandeville;
        history.obj_data.scaling = [100 5 10 10];
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 10000;

    case 'nu_volume'
        
        % Simulations required for this optimisation
        sim_list = {'mandeville1999_6s','mandeville1999_30s'};
        % Objective function to use
        errfun_empty = @errfun_nu_volume;
        % specific optimisation options
        history.lb = [0.5 0.5]; history.ub = [4 5];
        history.options = optimset(...
                'TolFun',1e-3,...
                'TolX',1e-3...
                );
        % specific variables for objective function
        history.obj_data.data_obs = load_mandeville;
        history.obj_data.scaling = [100 100];
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 1000;
        
    case 'nu_both'
        
        % Simulations required for this optimisation
        sim_list = {'mandeville1999_6s','mandeville1999_30s'};
        % Objective function to use
        errfun_empty = @errfun_nu_both;
        % specific optimisation options
        history.lb = [0.1 0.05 0.05 0.05 0.1 0.2];
        history.ub = [0.8 0.7 0.8 1 0.3 0.6];
        history.options = optimset(...
                'TolFun',7e-3,...
                'TolX',7e-3,...
                'MaxFunEvals',500 ...
                );
        % specific variables for objective function
        history.obj_data.data_obs = load_mandeville;
        history.obj_data.scaling = [100 1000 1000 6 10 10];
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 10000;
        
    case 'nu_both_blocked'
        
        % Recursively call this function to grab the same params as the
        % unblocked case
        history_in = history;
        history_in.problem = 'nu_both';
        [sim_list errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        
        % Modify optimisation options from the regular nu_both simulations
        history.lb(2:3) = [0.1 0.1];
        history.ub = [0.99 0.1 0.1 0.8 0.4 0.8];
        history.options = optimset(...
                'TolFun',7e-3,...
                'TolX',7e-3,...
                'MaxFunEvals',500 ...
                );
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'nu_dilcon'
        
        % Simulations required for this optimisation
        sim_list = {'mandeville1999_6s','mandeville1999_30s'};
        % Objective function to use
        errfun_empty = @errfun_nu_dilcon;
        % specific optimisation options
        history.lb = [0.1 0.05 0.05 0.02 0.05 0.2 0.01];
        history.ub = [0.8 0.7  0.9  0.5  1    1   0.8];
        history.options = optimset(...
                'TolFun',1e-3,...
                'TolX',1e-3,...
                'MaxFunEvals',500 ...
                );
        % specific variables for objective function
        history.obj_data.data_obs = load_mandeville;
        history.obj_data.scaling = [100 1000 1000 10 10 10 -10];
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 10000;
        
    otherwise
        
        error('SetupOpt:InvalidProblemIn',...
            'Invalid optimisation problem "%s"',history.problem)
        
end


end

function DataObs = load_mandeville()

% This function converts the Mandeville data from what its raw state into
% something more useable by the optimiser.

mandeville1999 = load('mandeville1999');
mandeville1999 = mandeville1999.mandeville1999;

field = {'F','V'};
sim = {'6s','30s'};

for iSim = 1:length(sim)
    for jField = 1:length(field)

        fieldName = ['rCB' field{jField} '_' sim{iSim}];

        [DataObs(iSim,jField).t ...
         DataObs(iSim,jField).(field{jField})] = ...
                            deal(mandeville1999.(fieldName)(:,1),...
                                 mandeville1999.(fieldName)(:,2));

    end
end
    
end
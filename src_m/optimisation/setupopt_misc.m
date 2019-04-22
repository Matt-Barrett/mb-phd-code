function [sim_list errfun_empty history fn_multiplier] = ...
                                        setupopt_misc(history)

switch history.problem       
    case 'n_Buxton'
        
        % Simulations required for this optimisation
        sim_list = {'hb_step'};
        % Objective function to use
        errfun_empty = @errfun_n;
        
        % specific optimisation options
        history.lb = 1;
        history.ub = 8;
%         history.options = [];
        history.options = optimset(...
                'TolFun',1e-3,...
                'TolX',1e-3,...
                'MaxFunEvals',500 ...
                );
            
        % specific variables for objective function
        load hbdata
        
        nSims = length(HbData.cbf);
        stim = zeros(1,nSims);
        mode = 'max';
        
        % Setup Simulation
        [Constants Params Controls] = setup_problem(sim_list{:},...
                                                    default_properties);
        % Determine what steady state dilation is necessary to achieve
        % the (measured) peak value
        for iSim = 1:nSims
            
            Params.vasodilation.t_stim = HbData.duration(iSim);
            Controls.tspan_dim(2) = Params.vasodilation.t_stim+2;
            F_bound = HbData.cbf(iSim)+1;
            
            stim(iSim) = find_stim_bound(F_bound,Constants,Params,...
                                        Controls,mode);
            
        end
        
        history.obj_data.stim = stim;
        history.obj_data.data_obs = HbData;
        history.obj_data.scaling = 1;
        
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 1000;

    otherwise
        
        error('SetupOpt:InvalidProblemIn',...
            'Invalid optimisation problem "%s"',history.problem)
        
end

end
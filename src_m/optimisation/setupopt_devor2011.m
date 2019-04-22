function [sim_list errfun_empty history fn_multiplier] = ...
                                        setupopt_devor2011(history)

                                    
switch history.problem
    case 'devor2011_pto2'
        
        % Simulations required for this optimisation
        sim_list = {'devor2011_surface','devor2011_mid','devor2011_deep'};
        % Objective function to use
        errfun_empty = @errfun_devor2011_pto2;
        
        % specific optimisation options
        % levystim
%         test = [5 0.11 0.1 0.3 20 0.642249];
%         history.lb = [0.3 0   0   0.3 0.5];
%         history.ub = [10  0.5 0.5 10  20];
        history.lb = [0.5 0.2 0.05 0.5 0.5];
        history.ub = [5   1.5 1    30  15];
        
%         history.options = [];
        history.options = optimset(...
                'TolFun',1e-3,...
                'TolX',1e-3,...
                'MaxFunEvals',600 ...
                );

        % Calculate the correct scale factor for this simulation based
        % on the two Vazquez simulations
        history.obj_data.scalesRaw = calc_devor_scales(...
                                        history.default,history.override);
                                    
%         history.default.params.metabolism.scaleMod = -2;
                                    
        meanScale = mean(history.obj_data.scalesRaw);
        
        doAdjScale = isfield(history.default.params.metabolism,'scaleMod') && ...
            ~isempty(history.default.params.metabolism.scaleMod) && ...
            (history.default.params.metabolism.scaleMod ~= 0);
        
        if ~doAdjScale
            history.override.devor2011_cmro2.metabolism.scale = meanScale;
        else
            
            scaleMod = history.default.params.metabolism.scaleMod;
            rangeScale = max(history.obj_data.scalesRaw) - meanScale;
            
            scaleMult = (scaleMod/abs(scaleMod))*(2*(abs(scaleMod) - 1) + 1);
            
            history.override.devor2011_cmro2.metabolism.scale = ...
                meanScale + scaleMult.*rangeScale;
            
        end
        
        % specific variables for objective function
        load devor2011
        history.obj_data.data_obs.pto2(:,1) = linspace(-3,40,1000)';
        method = 'pchip';
        history.obj_data.data_obs.pto2(:,2) = interp1(...
            devor2011.mean(:,1),devor2011.mean(:,2),...
            history.obj_data.data_obs.pto2(:,1),method);
        history.obj_data.data_obs.baseline.pto2 = devor2011.baseline.pto2;

        history.obj_data.scaling = ones(size(history.lb));
        % specific variables for myoutput function
        
        % other variables
        fn_multiplier = 10000;
        
%     case 'devor2011_pto2_lo_1'
%         
%         % Recursively call this function
%         history_in = history;
%         history_in.problem = 'devor2011_pto2';
%         [sim_list errfun_empty history fn_multiplier] = ...
%                                         setup_optimisation(history_in);
%         
%         % Modify optimisation options from the other simulations
%         meanScale = mean(history.obj_data.scalesRaw);
%         rangeScale = max(history.obj_data.scalesRaw) - meanScale;
%             
%         history.override.devor2011_cmro2.metabolism.scale = ...
%                                                 meanScale - rangeScale;
%             
%         % Reset filename to what it originally was
%         history.filename = history_in.filename;
%         
%     case 'devor2011_pto2_lo_2'
%         
%         % Recursively call this function
%         history_in = history;
%         history_in.problem = 'devor2011_pto2';
%         [sim_list errfun_empty history fn_multiplier] = ...
%                                         setup_optimisation(history_in);
%         
%         % Modify optimisation options from the other simulations
%         meanScale = mean(history.obj_data.scalesRaw);
%         rangeScale = max(history.obj_data.scalesRaw) - meanScale;
%             
%         history.override.devor2011_cmro2.metabolism.scale = ...
%                                                 meanScale - 3*rangeScale;
%             
%         % Reset filename to what it originally was
%         history.filename = history_in.filename;
%         
%     case 'devor2011_pto2_hi_1'
%         
%         % Recursively call this function
%         history_in = history;
%         history_in.problem = 'devor2011_pto2';
%         [sim_list errfun_empty history fn_multiplier] = ...
%                                         setup_optimisation(history_in);
%         
%         % Modify optimisation options from the other simulations
%         meanScale = mean(history.obj_data.scalesRaw);
%         rangeScale = max(history.obj_data.scalesRaw) - meanScale;
%             
%         history.override.devor2011_cmro2.metabolism.scale = ...
%                                                 meanScale + rangeScale;
%             
%         % Reset filename to what it originally was
%         history.filename = history_in.filename;
%         
%     case 'devor2011_pto2_hi_2'
%         
%         % Recursively call this function
%         history_in = history;
%         history_in.problem = 'devor2011_pto2';
%         [sim_list errfun_empty history fn_multiplier] = ...
%                                         setup_optimisation(history_in);
%         
%         % Modify optimisation options from the other simulations
%         meanScale = mean(history.obj_data.scalesRaw);
%         rangeScale = max(history.obj_data.scalesRaw) - meanScale;
%             
%         history.override.devor2011_cmro2.metabolism.scale = ...
%                                                 meanScale + 3*rangeScale;
%             
%         % Reset filename to what it originally was
%         history.filename = history_in.filename;

    otherwise
        
        error('SetupOpt:InvalidProblemIn',...
            'Invalid optimisation problem "%s"',history.problem)

end
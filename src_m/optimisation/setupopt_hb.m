function [sim_list errfun_empty history fn_multiplier] = ...
                                        setupopt_hb(history)
                                    
% These are default values, override if necessary
history.options = [];
fn_multiplier = 1000;
history.obj_data.orderSims = 1;

switch history.problem
    case 'dunn2005_fp_cbf'
        
        % Simulations required for this optimisation
        sim_list = {'dunn2005_fp_adj'};
        
        % specific optimisation options
        history.lb = [0.5 0 0 0.3 1];
        history.ub = [5 3 2 1 20];
        
        % Assign the objective function
        errfun_empty = @errfun_cbf;
            
        % specific variables for objective function
        dataVar = 'dunn2005';
        simName = 'forepaw';
        varName = {'cbf', 'raw_CBF'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.useLSQ = true;
        
    case 'dunn2005_fp_hb_adj'
        
        % Simulations required for this optimisation
        sim_list = {'dunn2005_fp_adj'};
        
        % specific optimisation options
        history.lb = [0.5 0 0 0.5 1];
        history.ub = [10 0.4 0.4 15 20];
        
        % Assign the objective function
        errfun_empty = @errfun_dhbhbo;
            
        % specific variables for objective function
        dataVar = 'dunn2005';
        simName = 'forepaw';
        varName(1,:) = {'HbO', 'raw_HbO'};
        varName(2,:) = {'dHb', 'raw_dHb'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.obj_data.useSpec = true;
        
    case 'dunn2005_fp_hb_raw'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'dunn2005_fp_hb_adj';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'dunn2005_fp_raw'};
        
        % Modify optimisation options from the other simulations
        history.obj_data.useSpec = false;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'dunn2005_w_cbf'
        
        % Simulations required for this optimisation
        sim_list = {'dunn2005_w_adj'};
        
        % specific optimisation options
        history.lb = [0.5 0 0 0.3 1];
        history.ub = [5 3 2 15 20];
        
        % Assign the objective function
        errfun_empty = @errfun_cbf;
            
        % specific variables for objective function
        dataVar = 'dunn2005';
        simName = 'whisker';
        varName = {'cbf', 'raw_CBF'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.useLSQ = true;
        
    case 'dunn2005_w_hb_adj'
        
        % Simulations required for this optimisation
        sim_list = {'dunn2005_w_adj'};
        
        % specific optimisation options
        history.lb = [0.5 0 0 0.5 1];
        history.ub = [10 0.4 0.4 15 20];
        
        % Assign the objective function
        errfun_empty = @errfun_dhbhbo;
            
        % specific variables for objective function
        dataVar = 'dunn2005';
        simName = 'whisker';
        varName(1,:) = {'HbO', 'raw_HbO'};
        varName(2,:) = {'dHb', 'raw_dHb'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.obj_data.useSpec = true;
        
    case 'dunn2005_w_hb_raw'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'dunn2005_w_hb_adj';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'dunn2005_w_raw'};
        
        % Modify optimisation options from the other simulations
        history.obj_data.useSpec = false;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'jones2002_04_cbf'
        
        % Simulations required for this optimisation
        sim_list = {'jones2002_04_adj'};
        
        % specific optimisation options
        history.lb = [0.5   0.0 0.0 0.5 0.5];
        history.ub = [3     2   1   10  5];
        
        % Assign the objective function
        errfun_empty = @errfun_cbf;
            
        % specific variables for objective function
        dataVar = 'jones2002';
        simName = '0.4mA';
        varName = {'cbf', 'raw_CBF'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.useLSQ = true;
        
    case 'jones2002_04_hb_adj'
        
        % Simulations required for this optimisation
        sim_list = {'jones2002_04_adj'};
        
%         % specific optimisation options
%         history.lb = [0.5 0 0 1 1];
%         history.ub = [20 0.1 0.1 25 40];
        
        % specific optimisation options
        history.lb = [0.5   0       1];
        history.ub = [20    0.1     40];
        
        % Assign the objective function
        errfun_empty = @errfun_dhbhbo;
            
        % specific variables for objective function
        dataVar = 'jones2002';
        simName = '0.4mA';
        varName(1,:) = {'HbO', 'raw_HbO'};
        varName(2,:) = {'dHb', 'raw_dHb'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.obj_data.useSpec = true;
        
    case 'jones2002_04_hb_raw'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'jones2002_04_hb_adj';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'jones2002_04_raw'};
        
        % Modify optimisation options from the other simulations
        history.obj_data.useSpec = false;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'jones2002_08_cbf'
        
        % Simulations required for this optimisation
        sim_list = {'jones2002_08_adj'};
        
        % specific optimisation options
        history.lb = [0.5 0.2 0.1 0.5 1];
        history.ub = [5 3 2 15 20];
        
        % Assign the objective function
        errfun_empty = @errfun_cbf;
            
        % specific variables for objective function
        dataVar = 'jones2002';
        simName = '0.8mA';
        varName = {'cbf', 'raw_CBF'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.useLSQ = true;
        
    case 'jones2002_08_hb_adj'
        
        % Simulations required for this optimisation
        sim_list = {'jones2002_08_adj'};
        
%         % specific optimisation options
%         history.lb = [0.5 0 0 0.5 1];
%         history.ub = [20 0.2 0.2 25 40];
        
        % specific optimisation options
        history.lb = [0.5   0       1];
        history.ub = [20    0.2     40];
        
        % Assign the objective function
        errfun_empty = @errfun_dhbhbo;
            
        % specific variables for objective function
        dataVar = 'jones2002';
        simName = '0.8mA';
        varName(1,:) = {'HbO', 'raw_HbO'};
        varName(2,:) = {'dHb', 'raw_dHb'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.obj_data.useSpec = true;
        
    case 'jones2002_08_hb_raw'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'jones2002_08_hb_adj';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'jones2002_08_raw'};
        
        % Modify optimisation options from the other simulations
        history.obj_data.useSpec = false;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'jones2002_12_cbf'
        
        % Simulations required for this optimisation
        sim_list = {'jones2002_12_adj'};
        
        % specific optimisation options
        history.lb = [0.5 0.5 0.2 0.5 1];
        history.ub = [5 3 1.5 15 20];
        
        % Assign the objective function
        errfun_empty = @errfun_cbf;
            
        % specific variables for objective function
        dataVar = 'jones2002';
        simName = '1.2mA';
        varName = {'cbf', 'raw_CBF'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.useLSQ = true;
        
    case 'jones2002_12_hb_adj'
        
        % Simulations required for this optimisation
        sim_list = {'jones2002_12_adj'};
        
%         % specific optimisation options
%         history.lb = [0.5 0 0 0.5 1];
%         history.ub = [20 0.3 0.3 25 40];
        
        % specific optimisation options
        history.lb = [0.5   0       1];
        history.ub = [20    0.3     40];
        
        % Assign the objective function
        errfun_empty = @errfun_dhbhbo;
            
        % specific variables for objective function
        dataVar = 'jones2002';
        simName = '1.2mA';
        varName(1,:) = {'HbO', 'raw_HbO'};
        varName(2,:) = {'dHb', 'raw_dHb'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.obj_data.useSpec = true;
        
    case 'jones2002_12_hb_raw'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'jones2002_12_hb_adj';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'jones2002_12_raw'};
        
        % Modify optimisation options from the other simulations
        history.obj_data.useSpec = false;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'jones2002_16_cbf'
        
        % Simulations required for this optimisation
        sim_list = {'jones2002_12_adj'};
        
        % specific optimisation options
        history.lb = [1 1.5 1 0.5 1];
        history.ub = [5 5 3 15 20];
        
        % Assign the objective function
        errfun_empty = @errfun_cbf;
            
        % specific variables for objective function
        dataVar = 'jones2002';
        simName = '1.6mA';
        varName = {'cbf', 'raw_CBF'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.useLSQ = true;
        
    case 'jones2002_16_hb_adj'
        
        % Simulations required for this optimisation
        sim_list = {'jones2002_16_adj'};
        
%         % specific optimisation options
%         history.lb = [0.5 0 0 0.5 1];
%         history.ub = [20 0.4 0.4 25 40];
        
        % specific optimisation options
        history.lb = [0.5   0       1];
        history.ub = [20    0.4     40];
        
        % Assign the objective function
        errfun_empty = @errfun_dhbhbo;
            
        % specific variables for objective function
        dataVar = 'jones2002';
        simName = '1.6mA';
        varName(1,:) = {'HbO', 'raw_HbO'};
        varName(2,:) = {'dHb', 'raw_dHb'};
        history = assign_hbdata(history,dataVar,simName,varName);
        
        history.obj_data.useSpec = true;
        
    case 'jones2002_16_hb_raw'
        
        % Recursively call this function
        history_in = history;
        history_in.problem = 'jones2002_16_hb_adj';
        [junk errfun_empty history fn_multiplier] = ...
                                        setup_optimisation(history_in);
        sim_list = {'jones2002_16_raw'};
        
        % Modify optimisation options from the other simulations
        history.obj_data.useSpec = false;
            
        % Reset filename to what it originally was
        history.filename = history_in.filename;
        
    case 'jones2002_co2_5_cbf'
        
        % Simulations required for this optimisation
        sim_list = {'jones2002_co2_5'};
        
        % specific optimisation options
        history.lb = [2     0   0   2   2];
        history.ub = [20    5   3   40  40];
        
        % Assign the objective function
        errfun_empty = @errfun_cbf;
            
        % specific variables for objective function
        dataVar = 'jones2002';
        simName = 'co2_5';
        varName = {'cbf', 'raw_CBF'};
        T_DIFF = 0.2;
        history = assign_hbdata(history,dataVar,simName,varName,T_DIFF);
        
        history.useLSQ = true;
        
    case 'jones2002_co2_10_cbf'
        
        % Simulations required for this optimisation
        sim_list = {'jones2002_co2_10'};
        
        % specific optimisation options
        history.lb = [2     0   0   2   2];
        history.ub = [20    5   5   50  40];
        
        % Assign the objective function
        errfun_empty = @errfun_cbf;
            
        % specific variables for objective function
        dataVar = 'jones2002';
        simName = 'co2_10';
        varName = {'cbf', 'raw_CBF'};
        T_DIFF = 0.2;
        history = assign_hbdata(history,dataVar,simName,varName,T_DIFF);
        
        history.useLSQ = true;
        
    otherwise
        
        error('SetupOpt:InvalidProblemIn',...
            'Invalid optimisation problem "%s"',history.problem)
        
end

history.obj_data.scaling = ones(size(history.lb));

end

function history = assign_hbdata(history,dataVar,simName,varName,varargin)

% Setup the (default) timespacing and method to interpolate the hb data
T_DIFF = 0.05; % seconds
validT_Diff = (nargin > 4) && ~isempty(varargin{1}) && ...
    isscalar(varargin{1}) && isnumeric(varargin{1}) && (varargin{1} > 0);
if validT_Diff
    T_DIFF = varargin{1};
end

METHOD = 'pchip';

% Load in the .mat data file
Data = load(dataVar);
dataVar = [upper(dataVar(1)) dataVar(2:end)];

nVars = size(varName,1);

for iVar = 1:nVars

    % Setup the new timebase
    idxSim = find(strcmp({Data.(dataVar)(:).name}, simName),1,'first'); 
    history.obj_data.data_obs.(varName{iVar,1})(:,1) = ...
        (min(Data.(dataVar)(idxSim).(varName{iVar,2})(:,1)):T_DIFF:...
        max(Data.(dataVar)(idxSim).(varName{iVar,2})(:,1)))';

    % Interpolate the data onto the new timebase
    history.obj_data.data_obs.(varName{iVar,1})(:,2) = interp1(...
        Data.(dataVar)(idxSim).(varName{iVar,2})(:,1),...
        Data.(dataVar)(idxSim).(varName{iVar,2})(:,2),...
        history.obj_data.data_obs.(varName{iVar,1})(:,1),METHOD);

    % Rescale this to make it easier for inside the objective function
    history.obj_data.data_obs.(varName{iVar,1})(:,2) = 1 + ...
        history.obj_data.data_obs.(varName{iVar,1})(:,2)./100;

end

end
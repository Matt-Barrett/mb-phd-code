function varargout = default_simulations(varargin)

% varargin(1)   Default
% varargin(2)   sim_list
% varargin(3)   fig_list
% varargin(4)   figFormats
% varargin(5)   figNames
% varargin(6)   Override
%
% varargout(1)  Data
% varargout(2)  Constants
% varargout(3)  Params
% varargout(4)  Controls

% Add the path if it doesn't exist already
add_src_path('./src_m');
add_src_path('./data');

% Validate input arguments.
[default sim_list fig_list figFormats figNames Override] = validate_args(varargin);

% Loop through each of the simulations and
for i = 1:length(sim_list)
    
    % Setup specific Constants/Params/Controls for each simulation.
    [Constants(i) Params(i) Controls(i)] = ...
                            setup_problem(sim_list{i},default,Override);
    
    % Run the simulation(s) and perform calculations.
    [Constants(i) Params(i) Data(i)] = ...
                solve_problem(Constants(i),Params(i),Controls(i)); 
                        
end;

% Loop through and plot each of the figures.
if ~isempty(fig_list)
    for iFig = 1:length(fig_list)
        isValidFig = ~isempty(figNames) && iscell(figNames(iFig));
        if isValidFig
            figNameIn = figNames{iFig};
        else
            figNameIn = [];
        end
        plot_results(Constants,Params,Controls,Data,fig_list{iFig},...
                        sim_list,figFormats,figNameIn);
    end;
end

% Pass output argument(s) through, if required.
if nargout > 0, varargout(1) = {Data};
    if nargout > 1, varargout(2) = {Constants};
        if nargout > 2, varargout(3) = {Params};
            if nargout > 3, varargout(4) = {Controls}; end
        end
    end
end

end

function [default sim_list fig_list figFormats figNames Override] = ...
                                                    validate_args(argsIn)

% Default values                                  
sim_list = {}; 
fig_list = {};
figFormats = [];
figNames = [];
Override = [];

nArgs = length(argsIn);

if nArgs > 0 
    if ~isempty(argsIn{1})
        default = argsIn{1};
    else
        default = default_properties;
    end
    
else
    default = default_properties;
end

if nArgs > 1
    if ~isempty(argsIn{2})
        sim_list = argsIn{2};
    end
end

if nArgs > 2
    if ~isempty(argsIn{3})
        fig_list = argsIn{3};
    end
end

if nArgs > 3
    figFormats = argsIn{4};
end

if nArgs > 4
    figNames = argsIn{5};
end

if nArgs > 5
    Override = argsIn{6};
end
    
end

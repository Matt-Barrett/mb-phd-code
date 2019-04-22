function [Constants Params Controls] = setup_problem(sim,varargin)

% This function takes the default Constants, Params, and Controls and
% customises them for the particular simulation specified as input.

%% Process input arguments

sim = lower(sim);

Override = [];
nArgs = length(varargin);
hasDefaults = nArgs < 3;

switch nArgs
    case  1
        
        Defaults = varargin{1};
                                   
    case 2
        
        [Defaults Override] = deal(varargin{:});
    
    case 3
    
        [Constants Params Controls] = deal(varargin{:});
    
    case 4
        
        [Constants Params Controls Override] = deal(varargin{:});
    
    otherwise
    
        error('setup_problem:wrongnumargs',...
            'Wrong number of arguments supplied')
    
end

if hasDefaults

    % Setup the structures from the defaults.
    [Constants Params Controls] = deal(Defaults.constants,...
                                       Defaults.params,...
                                       Defaults.controls);

end

%% List of simulations (and partial simulations)

strRoot = regexpi(sim, '_', 'split','once');

validStrRoot = iscell(strRoot) && ~isempty(strRoot);
if ~validStrRoot
    
    
end

% Modify default Constants/Params/Controls for specific problem
switch strRoot{1}
    case 'devor2011'
        
        [Constants Params Controls] = setup_devor2011(sim,Constants,...
                                                 Params,Controls,Override);
                                             
    case {'dunn2003','dunn2005'}
        
        [Constants Params Controls] = setup_dunn(sim,Constants,Params,...
                                                    Controls,Override);
        
    case 'jones2002'
        
        [Constants Params Controls] = setup_jones(sim,Constants,Params,...
                                                    Controls,Override);
                                                
    case 'hoge1999'
        
        [Constants Params Controls] = setup_hoge(sim,Constants,Params,...
                                                    Controls,Override);
                                                     
    case 'leithner2010'
        
        [Constants Params Controls] = setup_leithner2010(sim,Constants,...
                                                 Params,Controls,Override);
        
    case 'vazquez2008'
        
        [Constants Params Controls] = setup_vazquez2008(sim,Constants,...
                                                 Params,Controls,Override);
                                                     
     case 'vazquez2010'
        
        [Constants Params Controls] = setup_vazquez2010(sim,Constants,...
                                                 Params,Controls,Override);
        
    otherwise
        
        [Constants Params Controls] = setup_misc(sim,Constants,...
                                                 Params,Controls,Override);
end

% Override any parameters or constants
FIELDS_PARAMS = fieldnames(Params);
Params = assign_override(Params,sim,Override,FIELDS_PARAMS);

FIELDS_CONSTANTS = fieldnames(Constants);
Constants = assign_override(Constants,sim,Override,FIELDS_CONSTANTS);

end


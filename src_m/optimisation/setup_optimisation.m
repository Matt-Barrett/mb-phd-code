function [sim_list errfun_empty history fn_multiplier] = ...
                                            setup_optimisation(history)
                                        
% Split the problem string so we can use the root to determine which
% function contains the appropriate parameters
strRoot = regexpi(history.problem, '_', 'split','once');

validStrRoot = iscell(strRoot) && ~isempty(strRoot);
if ~validStrRoot
    error('SetupOpt:BadSplit',['There was a problem splitting the '...
        ''])
end

% Determine which function contains the parameters for this problem
switch lower(strRoot{1})
    case 'devor2011'
        optParamFun = @setupopt_devor2011;
    case {'kappa','nu'}
        optParamFun = @setupopt_cbfcbv;
    case {'calcinaghi2011','jones2002','dunn2005','royl2008'}
        optParamFun = @setupopt_hb;
    case 'leithner2010'
        optParamFun = @setupopt_leithner2010;
    case 'vazquez2008'
        optParamFun = @setupopt_vazquez2008;
    case 'vazquez2010'
        optParamFun = @setupopt_vazquez2010;
    otherwise
        optParamFun = @setupopt_misc;
end

% Generate the optimisation parameters/options
[sim_list errfun_empty history fn_multiplier] = optParamFun(history);

% initialise variables for myoutput function
history.x = [];
history.fval = [];

% randomise start point between bounds;
history.x0 = history.lb + (history.ub-history.lb).*rand(size(history.lb));

% initialise filename
for i = 1:length(history.x0)
    history.filename = [history.filename '_' ...
                            num2str(round(fn_multiplier*history.x0(i)))];
end;

end

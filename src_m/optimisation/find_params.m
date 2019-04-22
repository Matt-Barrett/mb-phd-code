function varargout = find_params(varargin)

% varargin(1)   problem - kappa/nu_flow/nu_volume etc
% varargin(2)   default
% varargin(3)   filename
% varargin(4)   override
%
% varargout(1)  history

% Validate the input arguments.
if nargin==0
    
    % Select which problem to solve.
    history.problem = [...
        'vazquez2008_cbf_control'
        ];
    
    % Use the default default properties
    history.default = default_properties;
    
    % Use the default default properties
    history.override = [];
    
    % Save the file to a temp/unfiled directory.
    history.filename = ['./simulations/unfiled/' history.problem];
    
    doDebug = false;
    
else
    
    % Validate the input arguments using the subfunction below.
    [history doDebug] = validate_args(varargin{:});
       
end

% Warn if debug mode is enabled
warn_debug(dbstack,mfilename,doDebug)

% Setup the optimization details for this problem.
[sim_list errfun_empty history] = setup_optimisation(history);

% Setup Constants/Params/Controls
for i = 1:length(sim_list)
    [constants(i) params(i) controls(i)] = ...
                setup_problem(sim_list{i},history.default,history.override);
end

% Re-anonymise errfun to fill it up with the relevant parameters.
errfun = @(x) errfun_empty(x,history.obj_data,constants,params,controls);

% Set generic optimisation options.
history.options = optimset(history.options,...
    'Display','iter'); % 'OutputFcn',@myoutput...

% Reduce the maximum number of iterations so that we can debug other code.
if doDebug
    history.options = optimset(history.options,'MaxFunEvals',10);
end

% Pre-optimisation disp/save.
fnPre = [history.filename '_pre'];
fnPre = checkfilename(fnPre);
save(fnPre,'history')
disp(['saved ' fnPre])

% % For debugging
% test = errfun(history.x0);

try
    
    % initialise (ensures these exist if optimisation fails)
    history.x_opt = inf(size(history.obj_data.scaling));
    history.fval_opt = inf;
    history.exception = [];
    
    % Optimise, using the appropriate solver
    doLSQ = isfield(history,'useLSQ') && history.useLSQ;
    if ~doLSQ
        [history.x_opt, history.fval_opt history.exitflag] = ...
            fminsearchbnd(errfun,history.x0,history.lb,history.ub,...
                history.options);
    else
        [history.x_opt, history.fval_opt, junk, history.exitflag] = ...
            lsqnonlin(errfun,history.x0,history.lb,history.ub,...
                history.options);
    end

    % % For debugging
    % test2 = errfun(history.x_opt);
    
    % unscale optimised parameters
    history.x_opt=history.x_opt.*history.obj_data.scaling;
    
    % Display results.
    numFormat = repmat(' %9.3f',1,length(history.x_opt));
    fprintf(['\nOptimal value = ' numFormat '\n\n'],history.x_opt);
    
    fnPost = [history.filename '_post'];
    fnPost = checkfilename(fnPost);
    save(fnPost,'history')
    fprintf('saved %s\n', fnPost)

    delete(fnPre)
    fprintf('deleted %s\n\n',fnPre);
    
catch exception
    
    % Capture exception and record exitflag. 
    history.exitflag = -2;
    history.exception = exception;
    
    % Display error details.
    fprintf('\n***** Error occured in %s *****\n',fnPre);
    fprintf('%s\n',exception.message);
    fnError = [history.filename '_error'];
    fnError = checkfilename(fnError);
    save(fnError,'history')
    fprintf('saved %s\n', fnError);
    delete(fnPre)
    fprintf('deleted %s\n\n',fnPre);
    
end


% Output function
function stop = myoutput(x,optimvalues,state)
    
    stop = false;
    
    switch state            
        case 'iter'
            history.x = [history.x; x];
            
            if isfield(optimvalues,'fval')
                % for scalar optimisation
                history.fval = [history.fval, optimvalues.fval];
            elseif isfield(optimvalues,'fval')
                % for vector optimisation
                history.fval = [history.fval, optimvalues.resnorm];
            end
            
            save([history.filename '_mid.mat'],'history')
    end
end

% Setup output arguments.
if nargout > 0
    varargout(1) = {history};
end

end

function [history doDebug] = validate_args(varargin)

hasProblem = (nargin > 0) && ~isempty(varargin{1});
if hasProblem
    history.problem = varargin{1};
else
    error('FindParams:BadProblem','No or bad variable "problem" supplied')
end

hasDefault = (nargin > 1) && ~isempty(varargin{2});
if hasDefault
    history.default = default_properties;
else
    error('FindParams:BadProblem','No or bad variable "Default" supplied')
end

history.filename = ['./simulations/unfiled/' history.problem];
hasFilename = (nargin > 2) && ~ isempty(varargin{3});
if hasFilename
    history.filename = varargin{3};
end

history.override = [];
hasOverride = (nargin > 3) && ~isempty(varargin{4});
if hasOverride
    history.override = varargin{4};
end

doDebug = false;
hasDoDebug = (nargin > 4) && ~isempty(varargin{5});
if hasDoDebug
    doDebug = varargin{5};
end
    
end
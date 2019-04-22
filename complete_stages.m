function [DefaultOut Override] = complete_stages(sol,Default,Override,varargin)

% Add the path if it doesn't exist already
add_src_path('./src_m');

% -------------------------- Input Processing --------------------------- %

filename = 'complete_stages_test';
hasFilename = (nargin > 1) && ~isempty(varargin{1}) && ischar(varargin{1});
if hasFilename
    filename = varargin{1};
end

startFrom = 1;
hasStartFrom = (nargin > 2) && ~isempty(varargin{2}) && ...
    isnumeric(varargin{2}) && isscalar(varargin{2});
if hasStartFrom
    startFrom = varargin{2};
end

doDebug = false;
hasDoDebug = (nargin > 3) && ~isempty(varargin{3}) && ...
    islogical(varargin{3}) && isscalar(varargin{2});
if hasDoDebug
    doDebug = varargin{3};
end

% ------------------------ Main part of function ------------------------ %

% Warn if debug mode is enabled
warn_debug(dbstack,mfilename,doDebug)

% Ensure the startFrom variable is reasonable
nStages = size(sol,2);
if startFrom > nStages
    warning('CompleteStages:StartFromTooBig',['The stage to start from '...
        'is larger than the total number of stages.  Optimising the '...
        'last stage only.'])
    startFrom = nStages;
end

% Loop through the stages
for iStage = startFrom:nStages
    
    % Set the number of repeats to 2 when debugging
    if ~doDebug
        repeats = sol(iStage).repeats;
    else
        nProblems = length(sol(iStage).problem);
        repeats = repmat({2},1,nProblems);
    end
    
    % Do each stage of optimisation
    idxDefault = length(sol(iStage).problem)+1;
    [Default(:,end+1:end+idxDefault)...
     Override history{iStage}...
     composite{iStage}] = full_run(sol(iStage).problem,repeats,...
                                    Default(end),Override,...
                                    sol(iStage).filename,...
                                    sol(iStage).sim_list,...
                                    sol(iStage).fig_list,doDebug);
    
	% Check filename here in case I'm running multiple simulations and a
	% file is created between when I start this file and when this file
	% saves the first stage of results.
    if iStage == 1
        filename = checkfilename(filename);
    end
    save(filename)
    fprintf('\nSaved %s after Stage %1.0d\n\n',filename,iStage);
    
end

DefaultOut = Default(end);

end
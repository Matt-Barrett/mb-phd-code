function rms = load_rms(optName, sensName, dirSens, varargin)

isO2 = true;
validIsO2 = (nargin > 3) && isscalar(varargin{1}) && islogical(varargin{1});
if validIsO2
    isO2 = varargin{1};
end

if isO2
    % For Oxygen
    nStages = 3;
    nProblems = 5;
    order = [1 2 5 3 4];
else    
    % For Hb
    nStages = 3;
    nProblems = 4;
    order = 1:4;
end

varsToLoad = {'composite','history'};

%% Create a list of files to load

% Read in a list of mat files in the directory
tempList = what(dirSens);
filenames = tempList.mat;

% Find the indexes of the files that match the optimal file appropriately
% (e.g. oxygen_v3_001_sens002_1_1_1_1.mat)
token = [sensName '[a-z]?_\d+_\d+_\d+_\d+.mat'];
test = regexp(filenames,token);
idxs = find(~cellfun(@isempty,test));

% Add the optimal file
fnOpt = {optName};
filenames = [fnOpt ;filenames];
idxs = [1; idxs+1];

%% loop through files 

nCombs = length(idxs);

rms = nan(nCombs,nStages,nProblems);

for iComb = 1:nCombs
    
    % Load the file
    load(filenames{idxs(iComb)},varsToLoad{:});
    
    startFrom = find(~cellfun(@isempty,composite),1);
    if startFrom == 1 && isO2
        startFrom = 2;
    end

    % loop through the stage
    for jStage = startFrom:nStages
        
        % loop through the errfuns
        for kProblem = 1:nProblems
            
            % Find out which was the chosen simulation
            optSim = composite{jStage}{kProblem}(1,3);
            
            % Extract the RMS
            rms(iComb,jStage,kProblem) = ...
                history{jStage}{kProblem}(optSim).fval_opt;

            
        end
        
    end

end

% Re-order RMS to match the order of the simulations
rms = rms(:,:,order);

end
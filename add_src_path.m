function add_src_path(pathRoot)

% Searches for the root path and, if it's not found, adds it and all 
% directories below it to the matlab search path.

pathListChar = path;

idxStr = strfind(pathListChar, pathRoot);

hasPath = ~isempty(idxStr);
if ~hasPath
    
    % Generate the raw path
    pathCharRaw = genpath(pathRoot);
    
    % Remove all the .svn directories
    dirExcludeToken = [filesep '.svn'];
    pathToAdd = remove_dirs(pathCharRaw,dirExcludeToken);
    
    % Add the list of directories to the search path
    addpath(pathToAdd);
    
end

end

function pathToAdd = remove_dirs(pathCharRaw,dirExcludeToken)

% Split the path into a cell array
splitToken = ':';
pathCellRaw = regexp(pathCharRaw, splitToken, 'split');

% Find those paths that don't contain
maskKeep = cellfun(@isempty,regexp(pathCellRaw, dirExcludeToken));

pathCell = pathCellRaw(maskKeep);
nPaths = length(pathCell);
cellSplitter(1:nPaths) = {splitToken};

cellTemp = [pathCell; cellSplitter];
pathToAdd = [cellTemp{:}];
% pathToAdd = pathToAdd(1:end-2); % matlab?
pathToAdd = pathToAdd(1:end-1); % octave?
    
end
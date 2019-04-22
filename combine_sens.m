function combine_sens(fnSensRoot, sensDir, nStages)

tokenSuffix = '_\d_\d_\d.mat';
varsToLoad = {'Default', 'Override'};

% Work out the home directory for this machine
if ispc
    userHome = getenv('USERPROFILE');
else
    userHome = getenv('HOME');
end

% Work 
dirSens = [userHome filesep sensDir];
fileStruct = what(dirSens);
matFiles = fileStruct.mat;

% Create a list of the 'summary' files we want to load, in stages
fileList = cell(1, nStages);
for iStage = 1:nStages
    
    fprintf('\nProcessing stage %1.0d ... \n', iStage)
    
    token = [fnSensRoot '_' num2str(iStage) tokenSuffix];
    fileListRaw = regexp(matFiles, token, 'match');
    maskFileList = ~cellfun(@isempty, fileListRaw);
    fileList{iStage} = sort([fileListRaw{maskFileList}]);
    
    % Loop through the files and ...
    nFiles = length(fileList{iStage});
    for jFile = 1:nFiles
        
        fileToLoad = fileList{iStage}{jFile};
        [junk fnOnly] = fileparts(fileToLoad);
        
        fprintf('\t%s ... ', fnOnly)
        
        % Load the file (appropriate variables)
        load(fileToLoad, varsToLoad{:})
        
        % Assign the appropriate output
        completeSims{iStage}.Default{jFile} = Default(end);
        completeSims{iStage}.Override{jFile} = Override;
        
        fprintf('done\n')

    end
    
    fprintf('done\n')
    
end

% Save the combined file
fnSave = checkfilename([dirSens filesep fnSensRoot '.mat']);
[junk fnSaveFile] = fileparts(fnSave);
fprintf('\nSaving %s ...', fnSaveFile)
save(fnSave, 'completeSims')
fprintf('done\n')

end
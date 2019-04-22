function produce_outputs_hb(Opt, Sens, optName, sensName, varargin)

% Default input arguments
doProcessing = true;
doMainFigs = false;
doMainTables = false;
doMainStats = false;
doExtraStats = false;
doExtraFigs = false;

% Process input arguments
nArgs = length(varargin);
if nArgs > 0 && ~isempty(varargin{1})
    doProcessing = varargin{1};
end
if nArgs > 1 && ~isempty(varargin{2})
    doMainFigs = varargin{2};
end
if nArgs > 2 && ~isempty(varargin{3})
    doMainTables = varargin{3};
end
if nArgs > 3 && ~isempty(varargin{4})
    doMainStats = varargin{4};
end
if nArgs > 4 && ~isempty(varargin{5})
    doExtraStats = varargin{5};
end
if nArgs > 5 && ~isempty(varargin{6})
    doExtraFigs = varargin{6};
end

% Add the path if it doesn't exist already
add_src_path('./src_m');

%%

if ispc
    userHome = getenv('USERPROFILE');
else
    userHome = getenv('HOME');
end

if doProcessing
    
    % This uses the old RMS calculation
    dirSens = [userHome filesep ...
                'PhD_Data/Backup/blood_flow/sensitivity/' sensName];
	isO2 = false;
    rms = load_rms(optName, sensName, dirSens, isO2)*100;

    % Work out the number of stages of the optimisation (in this case one
    % stage for each data set)
    nStages = size(Opt,2);
    
    % The number of different mechanisms tested
    nMechs = size(Opt(1).Data, 2)/4;
    
    % Preallocate memory
    StatsFull = cell(nStages,nMechs);
    StatsMean = StatsFull;
    StatsStd = StatsFull;

    for iStage = 1:nStages
        
        nSims = size(Opt(iStage).Data,2)/nMechs;
        
        for jMech = 1:nMechs
            
            fieldNames = fieldnames(Opt(iStage));
            nFields = length(fieldNames);
            
            for kField = 1:nFields
                
                idxs = (jMech - 1)*nSims + 1 : jMech*nSims;
                
                OptIn.(fieldNames{kField}) = ...
                    Opt(iStage).(fieldNames{kField})(:,idxs);
                SensIn.(fieldNames{kField}) = ...
                    Sens(iStage).(fieldNames{kField})(:,idxs);
                
            end
            
            [StatsFull{iStage,jMech},...
             StatsMean{iStage,jMech},...
             StatsStd{iStage,jMech}] = process_set_o2(OptIn,SensIn,...
                                            doMainFigs,doMainTables);
            
        end
        
    end

end

% output_rms_csv(rms)
output_jones_supp(StatsFull, rms)
% output_cmro2_csv(StatsFull{1})
% output_cbf_cmro2_csv(StatsFull{1})
% output_phase_corr(StatsFull{1})


end
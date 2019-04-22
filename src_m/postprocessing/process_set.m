function StatsFull = process_set(filename,varargin)

% Default input arguments
doMainFigs = true;
doMainTables = true;

% Process input arguments
if nargin > 0 && ~isempty(varargin{1})
    doMainFigs = varargin{1};
end
if nargin > 1 && ~isempty(varargin{2})
    doMainTables = varargin{2};
end

% list of paths to add
newPathArray = {'./bin'};
% save current path and add new paths
pathExisting = addpath(newPathArray{:});

load(filename)

if doMainFigs
    % Setup the appropriate figure extension(s) and path
    FIG_EXT = {'fig','eps'};
    FIG_PATH = './figs/';

    % Setup the appropriate figure names
    isTopDown = size(DataSens,1) > 14;
    if isTopDown
        FIG_LIST = {'topdown_combined'};
        FIG_NAMES = strcat(FIG_PATH,{'figure002'});
    else
        FIG_LIST = {'bottomup_combined'};
        FIG_NAMES = strcat(FIG_PATH,{'figure003'});
    end
else
    FIG_LIST = [];
end


% List of variables to perform analysis on.
variables = {'F','V','D','u'};
% Column indices of the variables to analyse (e.g. col 1 = arteries).
idx_var = {1:5,1:5,1:4,1:3,1:3};

% Extract the number of simulations (e.g. Mandeville 6s and 30s) and number
% of runs (i.e. number of parameter sensitivity analysis runs).
[nRuns nSims] = size(DataSens);

% Loop through the simulation types
for iSim = 1:nSims
    
    % Assume FV loop is first
    isFVLoop = iSim == 1; 

    if ~isFVLoop

        % Loop through the variables that we want to extract
        for jVar = 1:length(variables)

            % Start with the optimal simulations first...
            tempOpt = DataOpt(iSim).(variables{jVar});

            try 

                % Then the sensitivity simulations...
                 tempSens = reshape(...
                                [DataSens(:,iSim).(variables{jVar})],...
                                size(DataOpt(iSim).(variables{jVar}),1)...
                                ,[],nRuns);

                % And add them into the same data structure.
                CombinedFull(iSim).(variables{jVar}) = cat(3,tempOpt,...
                                                                tempSens);

            catch ME

                disp(['***** Error in ********'])
                strError = getReport(ME);
                disp(strError)

            end

            % Calculate the statistical metrics
           [StatsOpt(iSim).(variables{jVar})...
            StatsFull(iSim).(variables{jVar})...
            StatsStd(iSim).(variables{jVar})...
            StatsMean(iSim).(variables{jVar})...
            StatsMed(iSim).(variables{jVar})] = find_metrics(...
                                    DataOpt(iSim).t,...
                                    CombinedFull(iSim).(variables{jVar}));

        end
        
        % Create summary statistics of the composite values.
        CombinedStd(iSim).(variables{jVar}) = std(...
                                CombinedFull(iSim).(variables{jVar}),0,3);
        CombinedMean(iSim).(variables{jVar}) = mean(...
                                CombinedFull(iSim).(variables{jVar}),3);

    else

        % Combine Structures
        Default = [DefaultOpt DefaultSens];
        Data = [DataOpt(:,iSim); DataSens(:,iSim)];
        Constants = [ConstantsOpt(:,iSim); ConstantsSens(:,iSim)];
        Params = [ParamsOpt(:,iSim); ParamsSens(:,iSim)];
        Controls = [ControlsOpt(:,iSim); ControlsSens(:,iSim)];
        
        % Calculate alpha for the fv loop simulation
        [StatsOpt StatsFull StatsStd StatsMean StatsMed] = find_alpha(...
                            Default,Data,Constants,Params,Controls);
        
        % Cleanup structures that are no longer useful
        clear Default Data Constants Params Controls

    end
        
end

% Produce table formatted for LaTeX
if doMainTables
    make_tex_tables(StatsOpt,StatsStd)
% make_tex_tables(StatsMean,StatsStd)
% make_tex_tables(StatsMed,StatsStd)
end

% Loop through and plot each of the figures.
if ~isempty(FIG_LIST)
    for iFig = 1:length(FIG_LIST)
        plot_results(ConstantsOpt,ParamsOpt,ControlsOpt,DataOpt,...
                        FIG_LIST{iFig},SIM_LIST,FIG_EXT,FIG_NAMES{iFig})
    end;
end

% restore old path
path(pathExisting);

end
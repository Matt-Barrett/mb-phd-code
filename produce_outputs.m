function produce_outputs(Opt,Sens,optName,sensName,varargin)

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
    % dirSens = [userHome filesep ...
    %             'PhD_Data/Backup/blood_flow/sensitivity/v4_002_sens001'];
    dirSens = [userHome filesep ...
                'PhD_Data/Backup/blood_flow/sensitivity/' sensName(8:end)];
    rms = load_rms(optName,sensName,dirSens);
    
    % This uses the new RMS calculation (from calc_new_rms)
    % rmsName = [sensName '_rmsNew'];
    % load(rmsName);
    % rms = rms/100;

    % Work out the number of stages of the optimisation (in this case one
    % stage for each data set)
    nStages = size(Opt,2);
    
    % The number of different mechanisms tested
    nMechs = 5;
    
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
                                        
            % Add in RMS values
            [StatsFull{iStage,jMech},...
             StatsMean{iStage,jMech},...
             StatsStd{iStage,jMech}] = insert_rms(rms,iStage,jMech,...
                                             StatsFull{iStage,jMech},...
                                             StatsMean{iStage,jMech},...
                                             StatsStd{iStage,jMech});
                                         
            % Produce the statistics for the different mechanisms
            if doMainStats
                
                if jMech > 1
                    
                    % Compare the different mechanisms to the default one
                    [Sig{iStage,jMech-1} PDiff{iStage,jMech-1}] = ...
                            produce_stats(StatsFull(iStage,[1,jMech]));
                    
                    if jMech == 2
                        
                        % Output the data in csv form
                        output_csv_r(StatsMean(iStage,1:jMech),...
                                        StatsStd(iStage,1:jMech),...
                                        PDiff{iStage,jMech-1},iStage);
                                
                    end
                            
                end

            end
                                    
        end
        
        if doMainFigs
            
            % Setup the appropriate figure extension(s) and path
            FIG_EXT = {'fig','eps'};
            FIG_PATH = './figs/';

            % Setup the appropriate figure names
            switch iStage
                case 1
                    
                    SIM_LIST = {'vazquez2008_control_cap',...
                        'vazquez2008_vasodilated_cap',...
                        'vazquez2008_control',...
                        'vazquez2008_vasodilated',...
                        'vazquez2008_control_all',...
                        'vazquez2008_vasodilated_all',...
                        'vazquez2008_control_leak',...
                        'vazquez2008_vasodilated_leak',...
                        'vazquez2008_control_p50',...
                        'vazquez2008_vasodilated_p50'};
                    FIG_LIST = {'vazquez2008_main','vazquez2008_supp'};
                    FIG_NAMES = {'figure003a','figureS001a'};
                    
                    CSV_FUN = @output_vazquez2008_csv;
                    R_FILE = './src_r/vazquez2008.r';
                    
                case 2
                    
                    SIM_LIST = {'vazquez2010_cap',...
                        'vazquez2010',...
                        'vazquez2010_all',...
                        'vazquez2010_leak',...
                        'vazquez2010_p50'};
                    FIG_LIST = {'vazquez2010_main','vazquez2010_supp'};
                    FIG_NAMES = {'figure004a','figureS002a'};
                    
                    CSV_FUN = @output_vazquez2010_csv;
                    R_FILE = './src_r/vazquez2010.r';
                    
            end
            
            figDir = './figs/';
            figNames = strcat(figDir,FIG_NAMES);
            
            % Loop through and plot each of the figures.
            if ~isempty(FIG_LIST)
                for iFig = 1:length(FIG_LIST)
                    
                    plot_results(Opt(iStage).Constants,...
                            Opt(iStage).Params,Opt(iStage).Controls,...
                            Opt(iStage).Data,FIG_LIST{iFig},SIM_LIST,...
                            FIG_EXT,figNames{iFig})
                        
                    close(gcf);
                    
                end;
            end
            
            % Produce the R figures
            CSV_FUN(StatsFull(iStage,:))
            sysStr = sprintf('Rscript %s',R_FILE);
            fprintf('\nRunning R file "%s" ...\n\n',R_FILE)
            system(sysStr);
            fprintf('\n... done.\n\n')
            
        end
        
        
    end

end

if doExtraStats
    % Calculate the mech summary etc
    extra_stats_o2(StatsFull);
end

% Produce the additional figures
if doExtraFigs
    
    % The baseline figure (Figure002)
    FIG_EXT = {'fig','eps'};
    FIG_NAMES = {'./figs/figure002'};
    SIM_LIST = {'vovenko1999','yaseen2011','vazquez2010_cap','vazquez2008_control_cap'};
    FIG_LIST = {'baseline_po2'};
    load oxygen_v4_002 Default Override
    defaultIn = Default(end);
    OverrideIn = Override;
    default_simulations(defaultIn,SIM_LIST,FIG_LIST,FIG_EXT,FIG_NAMES,OverrideIn);
    
    % First Supp Figure
    !Rscript ./src_r/vazquez2008_supp.r
    
    % Second Supp Figure
    !Rscript ./src_r/vazquez2010_supp.r
    
    % Adjust the 
    if doMainStats
        nMechs = length(StatsMean);
        for iMech = 1:nMechs

            StatsMeanTmp{iMech} = [StatsMean{:,iMech}];
            StatsMeanTmp{iMech} = StatsMeanTmp{iMech}([1,end]);

            StatsStdTmp{iMech} = [StatsStd{:,iMech}];
            StatsStdTmp{iMech} = StatsStdTmp{iMech}([1,end]);

            if iMech <= nMechs-1

                PDiffTmp{iMech} = [PDiff{:,iMech}];
                PDiffTmp{iMech} = PDiffTmp{iMech}([1,end]);

            end

        end

        % Do actual figure here
        % Produce data for R figure
        output_csv_r(StatsMeanTmp,StatsStdTmp,PDiffTmp,5);
        !Rscript ./src_r/error_fig.r
        !Rscript ./src_r/error_fig_colour.r
    end
    
end

end

function [StatsFull,StatsMean,StatsStd] = insert_rms(rms,iStage,jType,...
                                            StatsFull,StatsMean,StatsStd)

rmsRaw = rms(:,iStage+1,jType);
            
StatsFull(1).RMS.meanActive(1,1,:) = rmsRaw(~isnan(rmsRaw));

[junk,StatsFull(1).RMS,...
 StatsStd(1).RMS,...
 StatsMean(1).RMS,junk] = process_stats(StatsFull(1).RMS);

if length(StatsFull) > 1
    StatsFull(2).RMS = StatsFull(1).RMS;
    StatsStd(2).RMS = StatsStd(1).RMS;
    StatsMean(2).RMS = StatsMean(1).RMS;
end

end


function [StatsFull StatsMed StatsStd] = process_set_o2(Opt,Sens,varargin)

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

% List of variables to perform analysis on.
Stack = dbstack;
if strfind(Stack(2).name,'_hb')
    
    % Variables for hemoglobin
    isHb = true;
    variables = {'F','nHbO','nHbT','ndHb','HbO_spec','dHb_spec','S',...
        'PO2', 'PO2_ss', 'cmro2_pred','JO2'};
    
else
    
    % Variables for oxygen
    isHb = false;
    variables = {'F','PO2','PO2_ss','S','testK'};
    
end

% Column indices of the variables to analyse (e.g. col 1 = arteries).
idx_var = {5,1:5,4};

% Extract the number of simulations (e.g. Mandeville 6s and 30s) and number
% of runs (i.e. number of parameter sensitivity analysis runs).
[nRuns nSims] = size(Sens(1).Data);

% Loop through the simulation types
for iSim = 1:nSims

    % Loop through the variables that we want to extract
    for jVar = 1:length(variables)

        try 
            
            % Start with the optimal simulations first...
            tempOpt = Opt.Data(iSim).(variables{jVar});

            % Then the sensitivity simulations...
             tempSens = reshape(...
                            [Sens.Data(:,iSim).(variables{jVar})],...
                            size([Opt.Data(:,iSim).(variables{jVar})],1)...
                            ,[],nRuns);

        catch ME
            
            try
                
                % Start with the optimal simulations first...
                tempOpt = Opt.Params(iSim).metabolism.(variables{jVar});

                % Then the sensitivity simulations...
                tempSens = zeros(1,size(tempOpt,2),nRuns);
                for kRun = 1:nRuns
                    tempSens(1,:,kRun) = ...
                        Sens.Params(kRun,iSim).metabolism.(variables{jVar});
                end
                
            catch ME2
                
                disp(['***** Error in ********'])
                strError = getReport(ME2);
                disp(strError)
                
            end
            
        end
        
        try 
            
            % And add them into the same data structure.
            CombinedFull(iSim).(variables{jVar}) = cat(3,tempOpt,tempSens);
            
        catch ME3
            
            disp(['***** Error in ********'])
            strError = getReport(ME3);
            disp(strError)
                
        end
        
        isO2Var = ...
            ~isempty(regexpi(variables{jVar},'O2','once')) || ...
            ~isempty(regexpi(variables{jVar},'Hb','once')) || ...
            strcmp(variables{jVar},'S');
        
        if ~isO2Var
            tStim = Opt.Params(1,iSim).vasodilation.t_stim;
            riseVar = 'vasodilation';
        else
            tStim = Opt.Params(1,iSim).metabolism.t_stim;
            
            tempTRise = [Sens.Params(:,iSim).metabolism];
            riseVar = 'metabolism';
        end
        
        tempTRise = [Sens.Params(:,iSim).(riseVar)];
        tRise = [Opt.Params(1,iSim).(riseVar).t_rise, ...
                [tempTRise(:).t_rise]];
            
        % Calculate the statistical metrics
       [StatsOpt(iSim).(variables{jVar})...
        StatsFull(iSim).(variables{jVar})...
        StatsStd(iSim).(variables{jVar})...
        StatsMean(iSim).(variables{jVar})...
        StatsMed(iSim).(variables{jVar})] = find_metrics(...
                                Opt.Data(:,iSim).t,...
                                CombinedFull(iSim).(variables{jVar}),...
                                tStim,tRise,isHb);

    end

    % Create summary statistics of the composite values.
    CombinedStd(iSim).(variables{jVar}) = std(...
                            CombinedFull(iSim).(variables{jVar}),0,3);
    CombinedMean(iSim).(variables{jVar}) = mean(...
                            CombinedFull(iSim).(variables{jVar}),3);
        
end

end
function run_sims_post(SimsOpt, simsSens, filenameRaw, sim_list,...
                            figList, figFormats, figNames, doCombine)

% Add the path if it doesn't exist already
add_src_path('./src_m');

%% Run the sensitivity analysis simulations

nStages = length(sim_list);

% Opt = repmat(struct(),1,nStages);

for iStage = 1:nStages
    
    if doCombine
        sims_temp = [sim_list{iStage:end}];
    else
        sims_temp = sim_list{iStage};
    end
    
    validFigList = ~isempty(figList) && iscell(figList);
    validFigNames = ~isempty(figNames) && iscell(figNames);
    
    nCombs = size(simsSens{iStage}.Default,2);
    
    for jComb = 1:nCombs
        
        if doCombine
            doOpt = (jComb == 1);
        else
            doOpt = (jComb == 1);
        end
        
        if doOpt
            
            try

            fprintf('Stage %d, Optimal simulation...',iStage);
            
            if validFigNames
                figNamesIn = strcat(figNames{iStage},...
                    sprintf('_%d_opt',iStage));
            else
                figNamesIn = figNames;
            end
            
            if validFigList
                figListIn = figList{iStage};
            else
                figListIn = [];
            end

            [Opt(iStage).Data(jComb,:),...
             Opt(iStage).Constants(jComb,:),...
             Opt(iStage).Params(jComb,:),...
             Opt(iStage).Controls(jComb,:)] = ...
                                default_simulations(...
                                    SimsOpt.Default,sim_list{iStage},...
                                    figListIn,figFormats,...
                                    figNamesIn,SimsOpt.Override);
                                
            for fig = 1:length(figList)
                close(gcf)
            end

            fprintf(' done.\n')
            
            catch ME1
                
                fprintf(' ERROR!\n')
                getReport(ME1)
                
            end

        end
        
        try
            
            fprintf('Stage %d, Combination %d ...',iStage,jComb);
            
            if validFigNames
                figNamesIn = strcat(figNames{iStage},...
                    sprintf('_%d_%d',iStage,jComb));
            else
                figNamesIn = figNames;
            end
            
            if validFigList
                figListIn = figList{iStage};
            else
                figListIn = [];
            end

            [simsSens{iStage}.Data(jComb,:),...
             simsSens{iStage}.Constants(jComb,:),...
             simsSens{iStage}.Params(jComb,:),...
             simsSens{iStage}.Controls(jComb,:)] = default_simulations(...
                                simsSens{iStage}.Default{jComb},...
                                sims_temp,figListIn,figFormats,...
                                figNamesIn,simsSens{iStage}.Override{jComb});
                            
            for fig = 1:length(figList)
                close(gcf)
            end
                            
            fprintf(' done.\n')
                            
        catch ME2
            
            fprintf(' ERROR!\n')
            
        end
                            
    end
    
    fprintf('\n')
                                
end

%% Transform the sensitivity analysis simulations

fieldList = {'Data','Constants','Params','Controls'};
nFields = length(fieldList);

if doCombine
    Sens = cat_simssens_docombine(simsSens, sim_list, fieldList, ...
                                    nFields, nStages);
else
    Opt = Opt(1);
    Sens = cat_simssens_dontcombine(simsSens, fieldList, nFields ,nStages);
end
    

%% Save the file

filename = checkfilename(filenameRaw);
save(filename);
                                
end

function Sens = cat_simssens_docombine(simsSens, sim_list, ...
                                        fieldList, nFields, nStages)

tempCell = [fieldList; cell(1,nFields)];
Sens = repmat(struct(tempCell{:}),1,nStages);

for iStage = 1:nStages

    nSims = size(sim_list{iStage},2);

    for jStage = 1:iStage

        for kField = 1:nFields

            Sens(iStage).(fieldList{kField}) = [...
                Sens(iStage).(fieldList{kField}); ...
                simsSens{jStage}.(fieldList{kField})(:,1:nSims)];

            simsSens{jStage}.(fieldList{kField}) = ...
                simsSens{jStage}.(fieldList{kField})(:,nSims+1:end);

        end

    end

end
    
end

function Sens = cat_simssens_dontcombine(simsSens,fieldList,nFields,nStages)

tempCell = [fieldList; cell(1,nFields)];
Sens = struct(tempCell{:});

for iStage = 1:nStages

    nSims = size(simsSens{iStage}.Data,2);

    for jField = 1:nFields

        Sens.(fieldList{jField}) = [Sens.(fieldList{jField}); ...
            simsSens{iStage}.(fieldList{jField})(:,1:nSims)];

    end


end

end
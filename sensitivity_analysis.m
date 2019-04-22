function sensitivity_analysis(varargin)

% Add the path if it doesn't exist already
add_src_path('./src_m');

%% Input Processing

nArgs = length(varargin);

validDefault = (nArgs > 0) && ~isempty(varargin{1});
if validDefault
    DefaultIn = varargin{1};
else
    DefaultIn = default_properties;
end

validOverride = (nArgs > 1);
if validOverride
    OverrideIn = varargin{2};
else
    OverrideIn = [];
end
    
validFilename = (nArgs > 2);
if validFilename
    fnPart = varargin{3};
else
    fnPart = 'test_001';
end

validCombinations = (nArgs > 3);
if validCombinations
    combinationsFun = varargin{4};
else
    combinationsFun = @oxygen_sens_combs;
end

validCompleteFun = (nArgs > 4);
if validCompleteFun
    completeFun = varargin{5};
else
    completeFun = @(Default,Override,fnSens,startFrom) ...
        oxygen_complete(Default,Override,fnSens,startFrom);
end

doDebug = false;
hasDoDebug = (nArgs > 5) && ~isempty(varargin{6});
if hasDoDebug
    doDebug = varargin{6};
end

fnDir = './simulations/sensitivity/';
fnBase = [fnDir fnPart];
fnFull = [fnBase '.mat'];
fnLog = checkfilename([fnBase '.log']);

% DefaultCombs = cell(1,nStages);
% OverrideCombs = DefaultCombs;

[combinations startFrom nStages] = combinationsFun();

%% Loop through and run the simulations

% Warn if debug mode is enabled
warn_debug(dbstack,mfilename,doDebug)

fid = fopen(fnLog,'a');
fprintf(fid,'Log file started at %s\n\n',datestr(now,0));
strBorder = repmat('%',1,75);
isFirst = true;

for iStage = 1:nStages
    
    fprintf(fid,'%s\n\nStage %d\n\n',strBorder,iStage);
    
    countRows = 1;
    
    nVars = size(combinations{iStage},1);
    
    for jVar = 1:nVars
        
        isDef = combinations{iStage}{jVar,1};
        isRel = combinations{iStage}{jVar,2};
        fieldNames = combinations{iStage}{jVar,5};
        
        varName = sprintf('%s.',fieldNames{:});
        
        if isDef
            varName = ['Default.' varName(1:end-1)];
        else
            varName = ['Override.' varName(1:end-1)];
        end
        
        fprintf(fid,'%s\n',varName);
        
        nIdx = length(combinations{iStage}{jVar,4});
        
        for kIdx = 1:nIdx
            
            idx = combinations{iStage}{jVar,4}(kIdx);
            
            fprintf(fid,'\tIndex: %d\n',kIdx);
            
            nPerts = 2*length(combinations{iStage}{jVar,3});
            
            for lPert = 1:nPerts
                
                fprintf(fid,'\t\tPertubation: %d: ',lPert);
                
                Default = DefaultIn;
                Override = OverrideIn;
                
                idxPert = ceil(lPert/2);
                changeBy = ((-1)^(lPert)).* ...
                    combinations{iStage}{jVar,3}(idxPert);
                
                % Assign the changes to a clean structure
                if isDef

                    [Default newVal oldVal] = assign_val(Default,fieldNames,...
                                                    idx,changeBy,isRel);

                else

                    try

                        % This should work where the override exists
                        [Override newVal oldVal] = assign_val(Override,...
                                            fieldNames,idx,changeBy,isRel);

                    catch ME1

                        [Constants Params] = setup_problem(fieldNames{1},...
                                                        Default,Override);

                        try

                            % This should work where override does not 
                            % exist and the field is from params
                            [Override.(fieldNames{1}).(fieldNames{2}) ...
                             newVal oldVal] = assign_val(...
                                    Params.(fieldNames{2}),...
                                    fieldNames(3:end),idx,changeBy,isRel);

                        catch ME2

                            % This should work where override does not 
                            % exist and the field is from constants
                            [Override.(fieldNames{1}).(fieldNames{2}) ...
                             newVal oldVal] = assign_val(...
                                    Constants.(fieldNames{2}),...
                                    fieldNames(3:end),idx,changeBy,isRel);

                        end

                    end
                    
                end
                
                fprintf(fid,'Value %5.2f (was %5.2f)... ',newVal,oldVal);
                
                try
                    
                    fnSens = [fnBase sprintf('_%d',iStage,jVar,kIdx,lPert)];
                    % fprintf('%s\n',fnSens);

                    % Perform the optimisation
                    [DefaultOut OverrideOut] = completeFun(Default,...
                                        Override,fnSens,startFrom(iStage));
                    
                    % % More debugging options, to test the simulations
                    % % actually run at baseline
                    % SIM_LIST = {'vazquez2008_control_cap','vazquez2010_cap'};
                    % [DefaultOut OverrideOut] = default_simulations(...
                    %     Default,SIM_LIST,[],[],[],Override);

                    % % For debugging only
                    % DefaultOut = 1:3;
                    % OverrideOut = 5;
                    % if jVar == 6
                    %     DefaultOut = [];
                    % end

                    completeSims{iStage}.Default{countRows} = DefaultOut(end);
                    completeSims{iStage}.Override{countRows} = OverrideOut;
                    
                    % Check the filename and directory before first save
                    if isFirst
                        fnFull = checkfilename(fnFull);
                        isFirst = false;
                    end
                    
                    save(fnFull)
                    
                    fprintf(fid,'done (%s).\n',datestr(now,13));

                catch ME3
                    
                    % Do somthing about the exception, or at least display
                    % something about it in the log file
                    
                    fprintf(fid,'ERROR!!! (%s).\n',datestr(now,13));
                    
                    dateForm = 'yyyy_mm_dd__HH_MM_SS';
                    dateStrNow = datestr(now,dateForm);
                    fnError = [fnFull(1:end-4) '_' dateStrNow];
                    fnError = checkfilename(fnError);
                    save(fnError)
                    
                end
                
                countRows = countRows + 1;
        
            end
        
        end
        
        fprintf(fid,'\n');
    
    end
    
    fprintf(fid,'\n');

end

fprintf(fid,'%s\n\n',strBorder);
fprintf(fid,'Log file finished at %s\n',datestr(now,0));
fclose(fid); 

end

function [StructOut newVal oldVal] = assign_val(StructIn,fieldNames,idx,...
                                                    changeBy,isRel)

StructOut = StructIn;

isTerminal = length(fieldNames) == 1;

if isTerminal
    
    oldVal = StructIn.(fieldNames{1})(idx);
    
    if isRel
        newVal = oldVal.*(1 + changeBy);
    else
        newVal = oldVal + changeBy;
    end
    
    StructOut.(fieldNames{1})(idx) = newVal;
    
else
    
    % Recursively call this function to move 
    [StructOut.(fieldNames{1}) newVal oldVal] = assign_val(...
            StructIn.(fieldNames{1}),fieldNames(2:end),idx,changeBy,isRel);
    
end

end
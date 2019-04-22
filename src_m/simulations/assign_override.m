function ParamsOut = assign_override(ParamsIn,sim,Override,validFields)

% Replace fields in ParamsIn with Override, and output as ParamsOut

ParamsOut = ParamsIn;

% Check that the appropriate override field exists
doOverride = isfield(Override,sim) && ~isempty(Override.(sim));

if doOverride
    
    paramFields = fieldnames(Override.(sim));
    
    for iParamField = 1:length(paramFields)
        
        isValidField = any(strcmp(paramFields{iParamField},validFields));
        if ~isValidField
            continue
        end
        
        fieldNames = fieldnames(Override.(sim).(paramFields{iParamField}));
    
        % Loop through and replace fields in ParamsIn with Override, and output
        % as ParamsOut
        for jField = 1:length(fieldNames)
            
            % Check if the fields are themselves structures, then repeat
            % the process for these structures if necessary
            doSubField = isstruct(Override.(sim).(...
                paramFields{iParamField}).(fieldNames{jField}));
            
            if ~doSubField
                
                ParamsOut.(paramFields{iParamField}).(fieldNames{jField}) = ...
                    Override.(sim).(paramFields{iParamField}).(fieldNames{jField});
                
            else
                
                subFieldNames = fieldnames(Override.(sim).(...
                    paramFields{iParamField}).(fieldNames{jField}));
                
                for kSubFieldName = 1:length(subFieldNames)
                    
                    ParamsOut.(paramFields{iParamField}).(...
                        fieldNames{jField}).(subFieldNames{kSubFieldName}) = ...
                        Override.(sim).(paramFields{iParamField}).(...
                        fieldNames{jField}).(subFieldNames{kSubFieldName});
                    
                end
                
            end

        end
    
    end
    
end
        
end
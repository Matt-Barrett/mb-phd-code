function output_jones_data()

load jones2002

stimList = {'0.4mA', '0.8mA', '1.2mA','1.6mA'};
stimNamesList = {'0.4 mA', '0.8 mA', '1.2 mA','1.6 mA'};
nStims = length(stimList);

varList = {'raw_CBF', 'raw_HbO', 'raw_dHb'};
varNamesList = {'CBF', 'HbO', 'dHb'};
nVars = length(varList);

fracIncl = 1;
exclOutside = [10 20];

filename = './csv/jones_data.csv';
fprintf('\nWriting "%s" ... ', filename)

fID = fopen(filename,'w');
fprintf(fID,'variable\ttype\tstim\tN\tval\tsd\tse\tpval\terrval\tstar\n');

for iStim = 1:nStims
    
    idxStim = strcmp({Jones2002(:).name}, stimList{iStim});
    stimName = stimNamesList{iStim};
    
    for jVar = 1:nVars
        
        dataTmp = Jones2002(idxStim).(varList{jVar});
        
        meanActive = calc_mean_active(dataTmp(:,1), dataTmp(:,2), ...
            exclOutside, fracIncl);
        
        varName = varNamesList{jVar};
        
        fprintf(fID, '%s\tdata\t%s\t%d\t%6.4f\t%d\t%d\t%d\t%d\t%s\n', varName, ...
            stimName, 1, meanActive,  NaN, NaN ,NaN, NaN, '');
        
    end    
end

fprintf(fID,'\n');
fclose(fID);

fprintf('done.\n')

end


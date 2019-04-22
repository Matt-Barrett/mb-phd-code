function output_cmro2_csv(StatsFull)

filename = './csv/cmro2_increase.csv';
columnNames = {'id','cmro2','type','stim'};
namesFormatted = sprintf('%s\t',columnNames{:});

nStims = size(StatsFull,2);
stimNames = {'0.4 mA','0.8 mA','1.2 mA','1.6 mA'};

typeVar = {'S','cmro2_pred','JO2'};
typeNames = {'model','calc','extracted'};
typeCols = [4, 1, 4];
nTypes = length(typeVar);

fprintf('\nWriting "%s" ... ',filename)

fID = fopen(filename,'w');
fprintf(fID,'%s\n',namesFormatted(1:end-1));

for iStim = 1:nStims
    for jType = 1:nTypes
        
        
        cmro2 = 100*StatsFull(iStim).(typeVar{jType}).meanActive(:,typeCols(jType));
        nVals = length(cmro2);
        id = 1:nVals;
        type = typeNames{jType};
        stim = stimNames{iStim};
        
        matFPrintF = [id; cmro2'];
        
        strFormat = ['%d\t%6.4f\t' type '\t' stim '\n'];
        fprintf(fID,strFormat,matFPrintF);
        
        
    end
end

fprintf(fID,'\n');
fclose(fID);

fprintf('done.\n')

end
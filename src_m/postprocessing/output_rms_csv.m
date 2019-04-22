function output_rms_csv(rms)

filename = './csv/hb_error.csv';
columnNames = {'id','error','type','stim'};
namesFormatted = sprintf('%s\t',columnNames{:});

nStims = size(rms,3);
stimNames = {'0.4 mA','0.8 mA','1.2 mA','1.6 mA'};

typeCols = [2 3];
typeNames = {'adj','raw'};
nTypes = length(typeCols);

fprintf('\nWriting "%s" ... ',filename)

fID = fopen(filename,'w');
fprintf(fID,'%s\n',namesFormatted(1:end-1));

for iStim = 1:nStims
    for jType = 1:nTypes
        
        rmsInd = rms(:,typeCols(jType),iStim);
        id = 1:length(rmsInd);
        type = typeNames{jType};
        stim = stimNames{iStim};
        
        matFPrintF = [id; rmsInd'];
        
        strFormat = ['%d\t%6.4f\t' type '\t' stim '\n'];
        fprintf(fID,strFormat,matFPrintF);
        
    end
end


fprintf(fID,'\n');
fclose(fID);

fprintf('done.\n')

end
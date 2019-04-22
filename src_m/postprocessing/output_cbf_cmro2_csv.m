function output_cbf_cmro2_csv(StatsFull)

filename = './csv/cbf_cmro2.csv';
columnNames = {'id','cbf','cmro2','metric','stim'};
namesFormatted = sprintf('%s\t',columnNames{:});

nStims = size(StatsFull,2);
stimNames = {'0.4 mA','0.8 mA','1.2 mA','1.6 mA'};

metricVar = {'meanActive','auc'};
metricNames = {'peak','auc'};
nMetrics = length(metricVar);

fprintf('\nWriting "%s" ... ',filename)

fID = fopen(filename,'w');
fprintf(fID,'%s\n',namesFormatted(1:end-1));

for iStim = 1:nStims
    for jMetric = 1:nMetrics
        
        cbf = 100*StatsFull(iStim).F.(metricVar{jMetric})(:,end);
        cmro2 = 100*StatsFull(iStim).S.(metricVar{jMetric})(:,end);
        nVals = length(cmro2);
        id = 1:nVals;
        metric = metricNames{jMetric};
        stim = stimNames{iStim};
        
        matFPrintF = [id; cbf'; cmro2'];
        
        strFormat = ['%d\t%8.4f\t%8.4f\t' metric '\t' stim '\n'];
        fprintf(fID,strFormat,matFPrintF);
        
        
    end
end

fprintf(fID,'\n');
fclose(fID);

fprintf('done.\n')

end
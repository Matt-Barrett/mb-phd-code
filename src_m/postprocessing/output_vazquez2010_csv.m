function output_vazquez2010_csv(StatsFull)

output_vq2010(StatsFull,'main');

output_vq2010(StatsFull,'supp');

end

function output_vq2010(StatsFull,mode)

switch mode
    case 'main'
        
        isSupp = false;
        
        filename = './csv/vazquez2010_data.csv';
        sourceCols = 1:2;
        sourceNames = {'CapPerm','NoMech'};
        
        varList = {'F','PO2','PO2','PO2_ss','S'};
        varNames = {'CBF','PO2 (Art)','PO2 (Vei)','PO2 (Tis)','CMRO2'};
        varCols = [5 1 3 1 4];
        varSources = {1,[1,2],[1,2],[1,2],[1,2]};
        
    case 'supp'
        
        isSupp = true;
        
        filename = './csv/vazquez2010_suppdata.csv';
        sourceCols = 1:5;
        sourceNames = {'CapPerm','NoMech','AllPerm','Leak','P50'};
        
        varList = {'PO2','PO2','PO2_ss','S'};
        varNames = {'PO2 (Art)','PO2 (Vei)','PO2 (Tis)','CMRO2'};
        varCols = [1 3 1 4];
        varSources = {[1,3:5],[1,3:5],[1,3:5],[1,3:5]};
        
end

columnNames = {'id','val','var','source'};
namesFormatted = sprintf('%s\t',columnNames{:});

nVars = length(varList);
varMetric = 'meanActive';

fprintf('\nWriting "%s" ... ',filename)

fID = fopen(filename,'w');
% fID = 0;
fprintf(fID,'%s\n',namesFormatted(1:end-1));

for iVar = 1:nVars
    
    nSources = length(varSources{iVar});
    
    for jSource = 1:nSources
        
        varNameFull = varNames{iVar};
        
        sourceNum = varSources{iVar}(jSource);
        sourceNameFull = sourceNames{sourceNum};
        if ~isSupp
            sourceNameFull = ['Model (' sourceNameFull ')'];
        end
        sourceCol = sourceCols(sourceNum);

        var = varList{iVar};
        varCol = varCols(iVar);

        vals = StatsFull{sourceCol}.(var).(varMetric)(:,varCol);

        id = 1:length(vals);

        matFPrintF = [id; (100*vals)'];
        strFormat = ['%d\t%8.4f\t' varNameFull '\t' sourceNameFull '\n'];
        fprintf(fID,strFormat,matFPrintF);
            
    end
end

fprintf(fID,'\n');
fclose(fID);

fprintf('done.\n')

end
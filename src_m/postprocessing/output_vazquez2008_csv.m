function output_vazquez2008_csv(StatsFull)

output_vq2008(StatsFull,'main');

output_vq2008(StatsFull,'supp');

end

function output_vq2008(StatsFull,mode)

switch mode
    case 'main'
        
        isSupp = false;
        
        filename = './csv/vazquez2008_data.csv';
        sourceCols = 1:2;
        sourceNames = {'CapPerm','NoMech'};
        
        varList = {'F','PO2_ss','S'};
        varNames = {'CBF','Tis PO2','CMRO2'};
        varCols = [5 1 4];
        varSources = {1,[1,2],[1,2]};
        varConds = {[1,2],[1,2],1};
        
    case 'supp'
        
        isSupp = true;
        
        filename = './csv/vazquez2008_suppdata.csv';
        sourceCols = 1:5;
        sourceNames = {'CapPerm','NoMech','AllPerm','Leak','P50'};
        
        varList = {'PO2_ss','S'};
        varNames = {'Tis PO2','CMRO2'};
        varCols = [1 4];
        varSources = {[1,3:5],[1,3:5]};
        varConds = {[1,2],1};
        
end

columnNames = {'id','val','var','source'};
namesFormatted = sprintf('%s\t',columnNames{:});

nVars = length(varList);
varMetric = 'meanActive';

condCols = [1 2];
condNames = {'Ctrl','SNP'};

fprintf('\nWriting "%s" ... ',filename)

fID = fopen(filename,'w');
% fID = 0;
fprintf(fID,'%s\n',namesFormatted(1:end-1));

for iVar = 1:nVars
    
    nSources = length(varSources{iVar});
    
    for jSource = 1:nSources
        
        sourceNum = varSources{iVar}(jSource);
        nConds = length(varConds{iVar});
        
        for kCond = 1:nConds
            
            condName = condNames{varConds{iVar}(kCond)};
            
            varNameFull = varNames{iVar};
            addCond = nConds > 1;
            if addCond
                varNameFull = [varNameFull ' (' condName ')'];
            end
            
            sourceNameFull = sourceNames{sourceNum};
            if ~isSupp
                sourceNameFull = ['Model (' sourceNameFull ')'];
            end
            sourceCol = sourceCols(sourceNum);
            
            condCol = condCols(kCond);
            
            var = varList{iVar};
            varCol = varCols(iVar);
            
            vals = StatsFull{sourceCol}(condCol).(var).(varMetric)(:,varCol);
            
            if any(isnan(vals))
                test = true;
            end
            
            id = 1:length(vals);
            
            matFPrintF = [id; (100*vals)'];
            strFormat = ['%d\t%8.4f\t' varNameFull '\t' sourceNameFull '\n'];
            fprintf(fID,strFormat,matFPrintF);
            
        end
    end
end

fprintf(fID,'\n');
fclose(fID);

fprintf('done.\n')

end
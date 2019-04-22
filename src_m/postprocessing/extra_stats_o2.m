function extra_stats_o2(StatsFull)

nData = size(StatsFull,1);
nMechs = 4;

dataNames = {'Masamoto et al. (2008)','Vazquez et al. (2010)'};
mechNames = {'CapPerm','AllPerm','Leak','P50'};
varNames = {'g2','gAll','jLeak','phi'};

simCol = [1 3 4 5];
mechKCol = [3 4 1 2];

filename = './figs/mech_summary.txt';
fID = fopen(filename,'w');
fprintf('Writing file "%s" ... ', filename)

for iData = 1:nData
    
    fprintf(fID,'\n%s\n',dataNames{iData});
    
    for jSim = 1:nMechs
        
        colMech = simCol(jSim);
        colK = mechKCol(jSim);
        
        tempStruct = StatsFull{iData,colMech};
        dataK = tempStruct(1).testK.peak_abs(:,colK);
        
        if jSim < 4
            dataForS = tempStruct(1).F.meanActive(:,5);
        else
            dataForS = tempStruct(1).S.meanActive(:,4);
        end
        
        if jSim ~= 3
            dataVar = dataK.*dataForS;
        else
            dataVar = -dataK.*dataForS;
        end
        
        medK = median(dataK);
        stdK = std(dataK);
        
        medData = median(dataVar);
        stdData = std(dataVar);
        
        if jSim < 3
            strHeading = '\n\t\tk%s\t%s\n';
        else
            strHeading = '\n\t\tk%s\t\t%s\n';
        end
        
        fprintf(fID,strHeading,mechNames{jSim},varNames{jSim});
        fprintf(fID,'Median\t%1.3f\t\t%1.3f\n',medK,medData);
        fprintf(fID,'StDev\t%1.3f\t\t%1.3f\n',stdK,stdData);
        
    end

end

fclose(fID);
fprintf('done.\n')

end
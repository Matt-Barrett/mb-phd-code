function output_csv_r(StatsMean,StatsStd,PDiff,stage)

% CBF (Control),   0.48000,   0.23000,1.00000,Vazquez 2008,1,1
% CBF (SNP),   0.02000,   0.02000,1.00000,Vazquez 2008,2,1
% PO2 (Control),   0.32000,   0.12000,1.00000,Vazquez 2008,3,1
% PO2 (SNP),   -0.12000,   0.09000,1.00000,Vazquez 2008,4,1

columnNames = {'grp','val','sd','p','name','grp_order','name_order'};
namesFormatted = sprintf('%s,',columnNames{:});
idxNames = {'Art','Cap','Vei','Tis'};

[varsToUse varsNames  idxToUse sim types simNames typeNames dataMean...
    dataSD filename] = plot_vars(stage);

fprintf('\nWriting "%s" ... ',filename)

fID = fopen(filename,'w');
fprintf(fID,'%s\n',namesFormatted(1:end-1));

grp_order = 1;
nVars = length(varsToUse);
for iVar = 1:nVars
    
    nIdxs = length(idxToUse{iVar});
    
    for jIdx = 1:nIdxs
    
        nSims = length(sim{iVar});
        for kSim = 1:nSims

            nTypes = length(types{iVar});
            for lType = 1:nTypes

                typeNum = types{iVar}(lType);
                simNum = sim{iVar}(kSim);

                isData = (typeNum == 1);
                if isData

                    numMean = dataMean(grp_order);
                    numSD = dataSD(grp_order);
                    numP = 1;

                else

                    numMean = StatsMean{typeNum-1}(simNum).(varsToUse{iVar}...
                        ).meanActive(idxToUse{iVar}(jIdx));
                    numSD = StatsStd{typeNum-1}(simNum).(varsToUse{iVar}...
                        ).meanActive(idxToUse{iVar}(jIdx));

                    doP = typeNum > 2;
                    if doP
                        if ~iscell(PDiff)
                            numP = PDiff(simNum).(varsToUse{iVar}...
                                ).meanActive(idxToUse{iVar}(jIdx));
                        else
                            numP = PDiff{typeNum-2}(simNum).(varsToUse{iVar}...
                                ).meanActive(idxToUse{iVar}(jIdx));
                        end
                    else
                        numP = 1;
                    end

                end
                
                if (stage == 2) || (stage == 4)
                    
                    doType = nIdxs > 1;
                    if doType
                        strGroup = sprintf('%s (%s)',varsNames{iVar},...
                                        idxNames{idxToUse{iVar}(jIdx)});
                    else
                        strGroup =  sprintf('%s',varsNames{iVar});
                    end
                    
                else

                    doType = (iVar < 3) && (stage ~= 5);
                    if doType
                        strGroup = sprintf('%s (%s)',varsNames{iVar},...
                                            simNames{simNum});
                    elseif stage == 5
                        strGroup = sprintf('%s',simNames{simNum});
                    else
                        strGroup =  sprintf('%s',varsNames{iVar});
                    end
                    
                end

                fprintf(fID,'%s,%10.5f,%10.5f,%6.5f,%s,%d,%d\n',...
                    strGroup,100*numMean,100*numSD,numP,...
                    typeNames{typeNum},grp_order,typeNum);

            end

            isEnd = (kSim == nSims);
            if ~isEnd
                grp_order = grp_order + 1;
            end

        end
        
        grp_order = grp_order + 1;
    
    end
        
end

fprintf(fID,'\n');
fclose(fID);

fprintf('done.\n')

end

function [varsToUse varsNames idxToUse sim types simNames typeNames ...
            dataMean dataSD filename] = plot_vars(stage)
        
fracIncl = 1;

exclOutside_2008 = [5 10];
load vazquez2008
F_c = (calc_mean_active(vazquez2008.F.control(:,1),...
            vazquez2008.F.control(:,2),exclOutside_2008,...
            fracIncl)./vazquez2008.baseline.F(1)) - 1;
F_v = (calc_mean_active(vazquez2008.F.vasodilated(:,1),...
            vazquez2008.F.vasodilated(:,2),exclOutside_2008,...
            fracIncl)./vazquez2008.baseline.F(2)) - 1;
PO2_c_2008 = (calc_mean_active(vazquez2008.PO2.control(:,1),...
            vazquez2008.PO2.control(:,2),exclOutside_2008,...
            fracIncl)./vazquez2008.baseline.PO2(1)) - 1;
PO2_v_2008 = (calc_mean_active(vazquez2008.PO2.vasodilated(:,1),...
            vazquez2008.PO2.vasodilated(:,2),exclOutside_2008,...
            fracIncl)./vazquez2008.baseline.PO2(2)) - 1;
dataMean_2008 = [F_c; F_v; PO2_c_2008; PO2_v_2008];
dataSD_2008 = [0.23; 0.02; 0.12; 0.09]./sqrt(5);

load vazquez2010
exclOutside_2010 = [5 20];
FF_2010 = calc_mean_active(Vazquez2010.LDF(:,1),...
            Vazquez2010.LDF(:,2),exclOutside_2010,fracIncl) - 1;
PO2_a = calc_mean_active(Vazquez2010.PaO2_med(:,1),...
            Vazquez2010.PaO2_med(:,2),exclOutside_2010,fracIncl) - 1;
PO2_v = calc_mean_active(Vazquez2010.PvO2_med(:,1),...
            Vazquez2010.PvO2_med(:,2),exclOutside_2010,fracIncl) - 1;
PO2_t = calc_mean_active(Vazquez2010.PtO2(:,1),...
            Vazquez2010.PtO2(:,2),exclOutside_2010,fracIncl) - 1;
dataMean_2010 = [FF_2010; PO2_a; PO2_v; PO2_t];
dataSD_2010 = [NaN; 0.0314/sqrt(6); 0.1399/sqrt(6); 0.1158/sqrt(9)];

switch stage
    case 1
        
        dataMean = dataMean_2008;
        dataSD = dataSD_2008;

        idxToUse = {5, 1, 4, 1};
        sim = {[1 2],[1 2], 1, 1};
        types ={[1 2],[1 2 3],[2 3],[2 3]};

        simNames = {'Ctrl','SNP'};
        typeNames = {'Masamoto (2008)','Model (CapPerm)','Model (NoMech)'};
        
        varsToUse = {'F','PO2_ss','S'};
        varsNames = {'CBF','Tis PO2','CMRO2','Error'};
        
        filename = './figs/vazquez2008_data.csv';

    case 2
        
        dataMean = dataMean_2010;
        dataSD = dataSD_2010;
        
        idxToUse = {5, [1 3], 1, 4, 1};
        sim = {1, 1, 1, 1, 1};
        types ={[1 2],[1 2 3],[1 2 3],[2 3],[2 3]};

        simNames = {'Ctrl','SNP'};
        typeNames = {'Vazquez (2010)','Model (CapPerm)','Model (NoMech)'};
        
        varsToUse = {'F','PO2','PO2_ss','S'};
        varsNames = {'CBF','PO2','PO2 (Tis)','CMRO2','Error'};
        
        filename = './figs/vazquez2010_data.csv';
        
    case 3
        
        dataMean = dataMean_2008(3:end);
        dataSD = dataSD_2008(3:end);

        idxToUse = {1, 4};
        sim = {[1 2], 1};
        types ={1:5,2:5};

        simNames = {'Ctrl','SNP'};
        typeNames = {'Data','CapPerm','AllPerm','Leak','P50'};
        
        varsToUse = {'PO2_ss','S'};
        varsNames = {'Tis PO2','CMRO2'};
        
        filename = './figs/vazquez2008_suppdata.csv';
        
    case 4
        
        dataMean = dataMean_2010(2:end);
        dataSD = dataSD_2010(2:end);
        
        idxToUse = {[1 3], 1, 4};
        sim = {1, 1, 1};
        types ={1:5,1:5,2:5};

        simNames = {'Ctrl','SNP'};
        typeNames = {'Data','CapPerm','AllPerm','Leak','P50'};
        
        varsToUse = {'PO2','PO2_ss','S'};
        varsNames = {'PO2','PO2 (Tis)','CMRO2'};
        
        filename = './figs/vazquez2010_suppdata.csv';
        
    case 5
        
        dataMean = [];
        dataSD = [];
        
        idxToUse = {1};
        sim = {[1 2]};
        types ={2:6};

        simNames = {'Masamoto (2008)','Vazquez (2010)'};
        typeNames = {'Data','CapPerm','NoMech','AllPerm','Leak','P50'};
        
        varsToUse = {'RMS'};
        varsNames = {'',''};
        
        filename = './figs/error_data.csv';
        
    otherwise
        
        warning('OutputCSV:UnknownStage','Unknown Stage')
        
end

end
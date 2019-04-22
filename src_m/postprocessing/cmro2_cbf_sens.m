function cmro2_cbf_sens(optName)

% Load optimal values
defVars = {'Default','Override'};
load(optName, defVars{:});
DefaultIn = Default(end);

% Setup the simulation params
sim_list = {'jones2002_04_adj', 'jones2002_08_adj', ...
    'jones2002_12_adj', 'jones2002_16_adj'};
simNames = {'0.4 mA', '0.8 mA', '1.2 mA', '1.6 mA'};
fig_list = {};
figFormats = [];
figNames = [];

% pickSims = [1];
% sim_list = sim_list(pickSims);
% simNames = simNames(pickSims);
% fig_list = {'jones2002_04'};
% figFormats = {'png'};
% figNames = sim_list;

% Setup the sensitivity params
varStimList = {'S','S'};
varStimIdx = [4, 1];
varStimNames = {'CMRO2','CBF'};
simAdjList = {...
    'jones2002_04_cmro2_adj', 'jones2002_04_cbf'; ...
    'jones2002_08_cmro2_adj', 'jones2002_08_cbf'; ...
    'jones2002_12_cmro2_adj', 'jones2002_12_cbf'; ...
    'jones2002_16_cmro2_adj', 'jones2002_16_cbf'};
typeAdjList = {'metabolism','vasodilation'};
varAdjList = {{'A_ss'},{'A_peak','A_ss'}};
% varMetricList = {'nHbO','ndHb'};
% varMetricIdx = [4, 4];
varMetricList = {'nHbO','ndHb','PO2'};
varMetricIdx = [4, 4, 4];
nVarMetric = 1 + length(varMetricList);

nVals = 9;
scaleConst = linspace(0,2,nVals);

fracIncl = 1;
exclOutside = [10 20];

nVars = length(varStimList);
activeChange = zeros(nVals,nVars,nVarMetric);

dataCell = [];
dataStim = [];
dataSim = [];

nStims = length(sim_list);

for iSim = 1:nStims

    for jVar = 1:nVars

        % 
        var = varStimList{jVar};
        idx = varStimIdx(jVar);
        simAdj = simAdjList{iSim, jVar};
        typeAdj = typeAdjList{jVar};
        varMetricListAll = [{var},varMetricList];
        varMetricIdxAll = [idx varMetricIdx];

        % Extract out the optimal values
        nVarAdj = length(varAdjList{jVar});
        for jVarAdj = 1:nVarAdj
            varAdj = varAdjList{jVar}{jVarAdj};
            optVal(jVarAdj) = Override.(simAdj).(typeAdj).(varAdj);
        end

        for kVal= 1:nVals

            % Reset the Override everytime
            OverrideIn = Override;

            % Setup the correct override
            for jVarAdj = 1:nVarAdj
                varAdj = varAdjList{jVar}{jVarAdj};
                OverrideIn.(simAdj).(typeAdj).(varAdj) = ...
                    optVal(jVarAdj)*scaleConst(kVal);
            end

            % Run the simulations
            Data(jVar,kVal) = default_simulations(DefaultIn, ...
                sim_list(iSim), fig_list, figFormats, figNames, OverrideIn);
            close all

            % Extract the useful data
            [t0 idxt0] = min(abs(Data(jVar,kVal).t(Data(jVar,kVal).t < 0)));
            for lVarMetric = 1:nVarMetric

                varMetric = varMetricListAll{lVarMetric};
                idxMetric = varMetricIdxAll(lVarMetric);

                baseVal = Data(jVar,kVal).(varMetric)(idxt0,idxMetric);
                activeVal = calc_mean_active(Data(jVar,kVal).t,...
                    Data(jVar,kVal).(varMetric)(:,idxMetric),...
                    exclOutside,fracIncl);
                isZero = (baseVal == 0);
                if ~isZero
                    activeChange(kVal,jVar,lVarMetric) = ...
                        activeVal/baseVal;
                else
                    activeChange(kVal,jVar,lVarMetric) = ...
                        activeVal+1;
                end

            end

        end

        % Normalise each row by the optimal value
        optValMetric = activeChange(ceil(end/2),jVar,:);
        activeChange(:,jVar,:) = bsxfun(@rdivide,...
            activeChange(:,jVar,:),optValMetric);


    end
    
    dataCellTemp = num2cell(reshape(activeChange, [], ...
        size(activeChange, 3), 1));
    dataCell = [dataCell; dataCellTemp];
    dataStimTemp = repmat(varStimNames, size(dataCellTemp, 1)/2, 1);
    dataStim = [dataStim; [dataStimTemp(:)]];
    dataSim = [dataSim; repmat(simNames(iSim), length(dataCellTemp()), 1)];
    

end

% Reorganise the data into a cell for writing
headers = [{'stim'}, varMetricList, {'type'}, {'sim'}];
headersAll = sprintf('%s\t', headers{:});
dataCellAll = [dataCell dataStim dataSim]';

% Write to a file
filename = './csv/cmro2_cbf_sens.csv';
fprintf('\nWriting "%s" ... ',filename)

fID = fopen(filename,'w');
fprintf(fID,'%s\n',headersAll(1:end-1)); % headers
strFormat = [repmat('%6.4f\t',1,nVarMetric) '%s\t%s\n'];
fprintf(fID,strFormat,dataCellAll{:}); % data

fprintf(fID,'\n');
fclose(fID);

fprintf('done.\n')

end

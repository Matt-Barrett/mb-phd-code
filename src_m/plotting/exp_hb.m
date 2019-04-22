function [H_axes rows columns] = exp_hb(P,sim_list,data,constants,...
                                            ExpData,PlotData)
                                        
H_axes = [];
rows= 3;
columns = 1;

doCMRO2 = isfield(ExpData,'cmro2');
doHbO = isfield(ExpData,'raw_HbO') && ~isempty(ExpData.raw_HbO);

legendStr = {'CBF','HbT','dHb'};
if doHbO
    legendStr{end+1} = 'HbO';
end
if doCMRO2
    legendStr{end+1} = 'CMRO_2';
end

% Find the indices (we don't need to display the warning as it's dealt with
% seperately below)
wngState = warning('off','FindDataIndices:CouldntFind');
idx = find_data_indices(sim_list,PlotData.req_sim);
warning(wngState)

% Get rid of the simulations that aren't found
maskNan = isnan(idx);
hasOneSim = sum(maskNan) < length(maskNan);
if hasOneSim
    idx = idx(~maskNan);
else
    strPlotList = sprintf('%s, %s',PlotData.req_sim{:});
    warning('Plot:ExpHB:NoValidSims',['None of the required simulations '...
        '(%s) could be found for plot "%s".'],strPlotList,PlotData.name)
    return
end

[t0 idxt0] = min(abs(data(idx(1)).t));

dHbComp = 4;

% Interpolate the Hb Data
ExpData = interp_hbdata(ExpData);

% Calculate the estimate of cmro2 from the original published data
cmro2_est_orig(:,1) = ExpData.int_CBF(:,1);
cmro2_est_orig(:,2) = ExpData.int_CBF(:,2).*(...
    ExpData.int_dHb(:,2)./ExpData.int_HbT(:,2));

% Calculate the estimate of CMRO2 from my predictions of the data
testCBF = data(idx(1)).F(:,5)/data(idx(1)).F(idxt0(1),5);
testdHb = data(idx(1)).ndHb(:,dHbComp)/data(idx(1)).ndHb(idxt0(1),dHbComp);
testHbT = data(idx(1)).nHbT(:,dHbComp)/data(idx(1)).nHbT(idxt0(1),dHbComp);
testCMRO2 = testCBF.*(testdHb./testHbT);

H_fig = figure;
    H_axes(1) = subplot(rows,columns,[1 columns+1]);
        hold on
            title(PlotData.title,'FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontLabel)
            ylabel('Relative Change (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis(PlotData.axis)
            plot(ExpData(1).raw_CBF(:,1),1+ExpData(1).raw_CBF(:,2)/100,'k--','LineWidth',P.Misc.widthLine)
            plot(ExpData(1).raw_HbT(:,1),1+ExpData(1).raw_HbT(:,2)/100,'m--','LineWidth',P.Misc.widthLine)
            plot(ExpData(1).raw_dHb(:,1),1+ExpData(1).raw_dHb(:,2)/100,'b--','LineWidth',P.Misc.widthLine)
            if doHbO
                plot(ExpData(1).raw_HbO(:,1),1+ExpData(1).raw_HbO(:,2)/100,'r--','LineWidth',P.Misc.widthLine)
            end
%             if doCMRO2
%                 plot(ExpData(1).cmro2(:,1),ExpData(1).cmro2(:,2),'g--','LineWidth',P.Misc.widthLine)
%             end
            plot(cmro2_est_orig(:,1),cmro2_est_orig(:,2),'g--','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).S(:,4)/data(idx(1)).S(idxt0(1),4),'g-','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,testCMRO2,'g:','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).F(:,5)/data(idx(1)).F(idxt0(1),5),'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).nHbT(:,dHbComp)/data(idx(1)).nHbT(idxt0(1),dHbComp),'m-','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).HbT_spec+1,'m:','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).ndHb(:,dHbComp)/data(idx(1)).ndHb(idxt0(1),dHbComp),'b-','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).dHb_spec+1,'b:','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).nHbO(:,dHbComp)/data(idx(1)).nHbO(idxt0(1),4),'r-','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).HbO_spec+1,'r:','LineWidth',P.Misc.widthLine)
            legend(legendStr{:})
        hold off
    H_axes(2) = subplot(rows,columns,columns*2+1);
        hold on
            ylabel('Tissue PO_2 (mmHg)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            xlim(PlotData.axis(1:2))
            plot(data(idx(1)).t,data(idx(1)).PO2(:,4).*constants(idx(1)).reference.PO2_ref,'b-','LineWidth',P.Misc.widthLine)
        hold off
        
end

function ExpData = interp_hbdata(ExpData)

% Setup the (default) timespacing and method to interpolate the hb data
T_DIFF = 0.1; % seconds
METHOD = {'pchip','extrap'};

% Find the variables which have raw_ in their name
namesAll = fieldnames(ExpData);
maskRawNames = strncmp('raw_',namesAll,4);
namesRaw = namesAll(maskRawNames);

% Determine the best timespan to interpolate over
nFieldsRaw = length(namesRaw);
hasValues = false(nFieldsRaw,1);
maxVals = zeros(nFieldsRaw,1);
minVals = maxVals;
for iField = 1:nFieldsRaw
    hasValues(iField) = ~isempty(ExpData.(namesRaw{iField}));
    if hasValues(iField)
        minVals(iField) = min(ExpData.(namesRaw{iField})(:,1));
        maxVals(iField) = max(ExpData.(namesRaw{iField})(:,1));
    end
end

namesRawAdj = namesRaw(hasValues);

% find the max of the minimums and min of the maximums
minVals = minVals(minVals ~= 0);
maxVals = maxVals(maxVals ~= 0);
tspan = [floor(max(minVals)) ceil(min(maxVals))];

% Setup the new variable names
namesSplit = regexp(namesRaw,'_','split');
namesSplit = [namesSplit{:}];
namesSplit = namesSplit(2:2:end);
namesInt = strcat('int_',namesSplit);
namesInt = namesInt(hasValues);

% loop through and interpolate these variables
nFieldsInt = length(namesInt);
for iField = 1:nFieldsInt
    
    % Setup the new timebase
    ExpData.(namesInt{iField})(:,1) = tspan(1):T_DIFF:tspan(2);
    
    % Interpolate the data onto the new timebase
    ExpData.(namesInt{iField})(:,2) = interp1(...
        ExpData.(namesRawAdj{iField})(:,1),...
        ExpData.(namesRawAdj{iField})(:,2),...
        ExpData.(namesInt{iField})(:,1),METHOD{:});
    
    % Rescale the data to make it more useful
    ExpData.(namesInt{iField})(:,2) = 1 + ...
        ExpData.(namesInt{iField})(:,2)./100;
    
end

end
function [H_axes rows cols] = jones2002_hb(P, sim_list, data, isSupp, ...
    doCMRO2)

req_sim = { 'jones2002_04_raw','jones2002_04_adj',...
            'jones2002_08_raw','jones2002_08_adj',...
            'jones2002_12_raw','jones2002_12_adj',...
            'jones2002_16_raw','jones2002_16_adj'};

% We don't care about this warning because we'll deal with it seperately
wngState = warning('off','FindDataIndices:CouldntFind');
idxData = find_data_indices(sim_list,req_sim);
warning(wngState);

% Check which of the simulations we have
hasRaw = all(~isnan(idxData(1:2:end)));
hasAdj = all(~isnan(idxData(2:2:end)));

for iSim = 1:length(idxData)
    doSkip = isnan(idxData(iSim));
    if doSkip
        continue
    end
    [t0(iSim) idxDatat0(iSim)] = min(abs(data(idxData(iSim)).t(...
        data(idxData(iSim)).t < 0)));
end

simNames = {'0.4mA','0.8mA','1.2mA','1.6mA'};
[Jones2002 idxJones] = import_jones(simNames);

if ~isSupp
    rows = 4;
else
    rows = 3;
end
doPO2 = true;
if doPO2
    rows = rows+1;
end
if doCMRO2
    rows = rows+1;
end
cols = 4;

stimTitle = {'0.4 mA','0.8 mA','1.2 mA','1.6 mA'};

tspan = [-10 40];

cbfYLims = [0.95 1.52];
cbfYLabel = 'CBF (a.u.)';
cbfColData = [204, 204, 204]./256;

cmro2YLims = [0.98 1.16];
cmro2YLabel = 'Imp. CMRO2 (a.u.)';
colCMRO2 = [35, 139, 69]./256;


tStimBar = [0 20];
yStimBar = [0.965 0.915 0.885 0.835];
yStimBarPO2 = 0.91;
yStimBarCMRO2 = 0.94;

hbVarNames = {  'nHbO',     'nHbT',     'ndHb';
                'HbO_spec', '', 'dHb_spec';
                'raw_HbO',  'raw_HbT',  'raw_dHb'};
% hbVarNames = {  'HbO_spec', '', 'dHb_spec';
%                 'nHbO',     'nHbT',     'ndHb';
%                 'raw_HbO',  'raw_HbT',  'raw_dHb'};
% hbColours = {'r','b','m'};
hbColours = {[203, 24, 29],[106, 81, 163],[33, 113, 181]};
hbColoursData = {[252, 174, 145],[203, 201, 226],[189, 215, 231]};
hbYLims = {[0.97 1.32],[0.985 1.125],[0.87 1.03]};
hbYLabel = {'HbO (a.u.)','HbT (a.u.)','dHb (a.u.)'};

po2YLims = [0.98 1.3];
po2Colour = [217, 72, 1];
po2YLabel = 'Tissue PO2 (a.u.)';

CMRO2YLims = [0.93 1.28];
CMRO2YLabel = 'CMRO2 (a.u.)';

if hasRaw
    legendOrder = {[1 2],[1 2 3],[1 2],[1 2 3], [1 2]};
    legendStr = {{'Data','Model'},{'Data','Model (Raw)','Model (Adj)'},...
        {'Data','Model'},{'Data','Model (Raw)','Model (Adj)'},...
        {'Model (Raw)','Model (Adj)'}};
    if isSupp
        legendStr(1) = {{'Model (Raw)','Model (Adj)'}};
    end
else
    legendOrder = {[1 2],[1 3],[1 2],[1 3], [1], [1 2 3]};
    legendStr = {{'Data','Model'},{'Data','Model'},...
        {'Data','Model'},{'Data','Model'},{'Model'}, ...
        {'Imposed', 'Calculated', 'Extracted'}};
end
legendLoc = {'East','East','East','East','East','NorthEast'};

lineType = {'-.','-'};

lineProps = {'LineWidth',P.Misc.widthLine};
linePropsData = {'LineWidth',P.Misc.widthLineStim};
lineStimProps = {'LineWidth',P.Misc.widthLineStim};
strStimProps = {'FontSize',P.Axes.FontSize};
labelProps = {'FontWeight',P.Misc.weightFontStrong,...
    'FontSize',P.Misc.sizeFontStrong};
titleProps = {'FontWeight',P.Misc.weightFontStrong,...
    'FontSize',P.Misc.sizeFontLabel};

hFig = figure;
set(hFig, 'Position', get(0,'Screensize')); % Maximize figure.
gap = [0.025 0.025];
marg_h = 0.1;
marg_w = 0.1;
H_axes = tight_subplot(rows, cols, gap, marg_h, marg_w);

doReturn = ~hasAdj && ~hasRaw;
if doReturn
    return
end

cbfSimNum = 2;

% H_axes = zeros(1,rows*cols);
nObsType = 2;
nStims = length(req_sim)/nObsType;
hYLabel = [];

for iStim = 1:nStims
    
    simNum(1) = (iStim-1)*nObsType + 1; % Raw
    simNum(2) = simNum(1) + 1; % Adj
    
    doYLabel = iStim == 1;
    
    % CBF or CMRO2 Plot
    axes(H_axes(iStim)); hold on
    title(stimTitle{iStim},titleProps{:})
    xlim(tspan)
    
    if ~isSupp
        
        % Scale the experimental data
        cbfData = Jones2002(idxJones(iStim)).raw_CBF;
        cbfData(:,2) = 1 + cbfData(:,2)/100;
        
        ylim(cbfYLims)
        if doYLabel, 
            hYLabel(end+1) = ylabel(cbfYLabel,labelProps{:}); 
            set(H_axes(iStim),'YTickLabelMode','auto')
        else
            set(H_axes(iStim),'YTick',[],'YColor','w')
        end
        set(H_axes(iStim),'XTick',[],'XColor','w')
        hLine(1) = plot(cbfData(:,1),cbfData(:,2),'-','Color',cbfColData,...
            linePropsData{:});
        hLine(2) = plot(data(idxData(simNum(cbfSimNum))).t,...
            data(idxData(simNum(cbfSimNum))).F(:,5),'k-',lineProps{:});

        if doYLabel
            plot_legend(hLine(legendOrder{1}),legendStr{1},legendLoc{1});
        end
        hold off
        
    else
        
        ylim(cmro2YLims)
        if doYLabel, 
            hYLabel(end+1) = ylabel(cmro2YLabel,labelProps{:}); 
            set(H_axes(iStim),'YTickLabelMode','auto')
        else
            set(H_axes(iStim),'YTick',[],'YColor','w')
        end
        
        hLineCMRO2(2) = plot(data(idxData(simNum(cbfSimNum))).t,...
            data(idxData(simNum(2))).S(:,4)./...
            data(idxData(simNum(2))).S(idxDatat0(cbfSimNum),4),...
            lineType{2}, 'Color', colCMRO2, lineProps{:});
        if hasRaw
            hLineCMRO2(1) = plot(data(idxData(simNum(cbfSimNum))).t,...
                data(idxData(simNum(1))).S(:,4)./...
                data(idxData(simNum(1))).S(idxDatat0(cbfSimNum),4),...
                lineType{1}, 'Color', colCMRO2, lineProps{:});
        end
        set(H_axes(iStim),'XTick',[],'XColor','w')
        
        if doYLabel
            plot_legend(hLineCMRO2(legendOrder{1}),legendStr{1},legendLoc{1});
        end
        hold off
    
    end
    
    % Hb Plots
    nHbTypes = 3;
    if ~isSupp
        hbTypeArray = 1:nHbTypes;
    else
        hbTypeArray = [1 nHbTypes];
    end
    for jHbNum = 1:length(hbTypeArray)
        
        jHbType = hbTypeArray(jHbNum);
        
        doTimeLabel = (~doPO2) && (jHbType == nHbTypes);
        
        % Setup the plot
%         if ~isSupp
            plotNum = iStim + jHbNum*cols;
%         else
%             plotNum = iStim + (jHbNum-1)*cols;
%         end
        axes(H_axes(plotNum)); hold on
        % H_axes(plotNum) = tight_subplot(rows,cols,plotNum); hold on
        xlim(tspan)
        ylim(hbYLims{jHbType})
        if doYLabel
            hYLabel(end+1) = ylabel(hbYLabel{jHbType},labelProps{:});
            set(H_axes(plotNum),'YTickLabelMode','auto')
        else
            set(H_axes(plotNum),'YTick',[],'YColor','w')
        end
        
        if doTimeLabel
            plot(tStimBar,yStimBar(iStim)*ones(1,2),'k-',lineStimProps{:})
            text(tStimBar(2)+2,yStimBar(iStim),[num2str(tStimBar(2)) 's'],...
                strStimProps{:})
        end
        
        set(H_axes(plotNum),'XTick',[],'XColor','w')
        
        % Scale the experimental data
        hbData = Jones2002(idxJones(iStim)).(hbVarNames{3,jHbType});
            hbData(:,2) = 1 + hbData(:,2)/100;
            
        hLine(1) = plot(hbData(:,1),hbData(:,2),'-',...
                'Color',hbColoursData{jHbType}/256,linePropsData{:});
        
        % Plot the raw and adjusted hemoglobin values
        nObsType2 = sum(~cellfun(@isempty,hbVarNames(:,jHbType)')) - 1;
        for kObsType = 1:nObsType2
            
            isHbT = (nObsType2+1) < length(hbVarNames(:,jHbType)');
            
            doSkip = (((kObsType == 1) && ~hasRaw) || ...
                ((kObsType == 2) && ~hasAdj)) && ~isHbT;
            
            if ~doSkip
                
                if ~isHbT
                    simNumHb = simNum(kObsType);
                    lineTypeUse = lineType{kObsType};
                else
                    simNumHb = simNum(cbfSimNum);
                    lineTypeUse = lineType{end};
                end
                
                hbNormRaw = data(idxData(simNumHb)).(...
                    hbVarNames{kObsType,jHbType})(:,end);

                isRealHb = kObsType == 1;
                if isRealHb
                    hbNormRaw = hbNormRaw/data(idxData(simNumHb)).(...
                        hbVarNames{kObsType,jHbType})(idxDatat0(...
                        simNumHb),end);
                else
                    hbNormRaw = hbNormRaw + 1;
                end

                hLine(kObsType+1) = plot(data(idxData(simNumHb)).t,...
                    hbNormRaw,lineTypeUse,...
                    'Color',hbColours{jHbType}/256,lineProps{:});
                
            end
            
            
        
        end
        
        if doYLabel
            plot_legend(hLine(legendOrder{jHbType+1}),...
                legendStr{jHbType+1},legendLoc{jHbType+1})
        end
        
        hold off
        
    end
    
    % PO2 Plots
%     if ~isSupp
        plotNum = iStim + (length(hbTypeArray)+1)*cols;
%     else
%         plotNum = iStim + length(hbTypeArray)*cols;
%     end
    axes(H_axes(plotNum)); hold on
    xlim(tspan)
    ylim(po2YLims)
    if doYLabel, 
        hYLabel(end+1) = ylabel(po2YLabel,labelProps{:}); 
        set(H_axes(plotNum),'YTickLabelMode','auto')
    else
        set(H_axes(plotNum),'YTick',[],'YColor','w')
    end
    set(H_axes(plotNum),'XTick',[],'XColor','w')
    hLinePO2(1) = plot(data(idxData(simNum(cbfSimNum))).t,...
        data(idxData(simNum(2))).PO2_ss(:,1)./...
        data(idxData(simNum(2))).PO2_ss(idxDatat0(cbfSimNum),1),...
        lineType{2}, 'Color', po2Colour/256, lineProps{:});
    if hasRaw
        hLinePO2(2) = plot(data(idxData(simNum(cbfSimNum))).t,...
            data(idxData(simNum(1))).PO2_ss(:,1)./...
            data(idxData(simNum(1))).PO2_ss(idxDatat0(cbfSimNum),1),...
            lineType{1}, 'Color', po2Colour/256,lineProps{:});
    end
    
    if doPO2 && ~doCMRO2
        plot(tStimBar, yStimBarPO2*ones(1,2),'k-',lineStimProps{:})
        text(tStimBar(2)+2, yStimBarPO2,[num2str(tStimBar(2)) 's'],...
            strStimProps{:})
    else
    end
    
    if doYLabel
        plot_legend(hLinePO2(legendOrder{end-1}), legendStr{end-1}, ...
            legendLoc{end-1});
    end
    
    hold off
    
    
    % CMRO2 Plots
    
    if doCMRO2
        
        plotNumCMRO2 = iStim + (length(hbTypeArray)+2)*cols;

        % Calculate 
        cmro2Imp = data(idxData(simNum(2))).S(:,4)/...
            data(idxData(simNum(2))).S(idxDatat0(cbfSimNum),4);
        cmro2Calc = data(idxData(simNum(2))).cmro2_pred;
        cmro2Ext = data(idxData(simNum(2))).JO2(:,4)./...
            data(idxData(simNum(2))).JO2(idxDatat0(cbfSimNum),4);

        % Top CMRO2 Plot
        axes(H_axes(plotNumCMRO2)); hold on
        xlim(tspan)
        ylim(CMRO2YLims)
        if doYLabel
            hYLabel(end+1) = ylabel(CMRO2YLabel,labelProps{:}); 
            set(H_axes(plotNumCMRO2),'YTickLabelMode','auto')
        else
            set(H_axes(plotNumCMRO2),'YTick',[],'YColor','w')
        end
        set(H_axes(plotNumCMRO2),'XTick',[],'XColor','w')
        hLineCMRO2(2) = plot(data(idxData(simNum(cbfSimNum))).t, ...
            cmro2Calc,'--', 'Color', colCMRO2, lineProps{:});
        hLineCMRO2(3) = plot(data(idxData(simNum(cbfSimNum))).t, ...
            cmro2Ext, ':', 'Color', colCMRO2, lineProps{:});
        hLineCMRO2(1) = plot(data(idxData(simNum(cbfSimNum))).t, ...
            cmro2Imp, 'Color', colCMRO2, lineProps{:});

        if doYLabel
            plot_legend(hLineCMRO2(legendOrder{end}),legendStr{end},...
                legendLoc{end});
        end

        if doCMRO2
            plot(tStimBar, yStimBarCMRO2*ones(1,2),'k-',lineStimProps{:})
            text(tStimBar(2)+2, yStimBarCMRO2,[num2str(tStimBar(2)) 's'],...
                strStimProps{:})
        end

        hold off
    
    end
    
end

% Ensure the yLabels are all horizontally aligned to the same point 
% (prevents issues with subscipts)
% labelPropsOldRef = get(hYLabel(3),{'Position','Extent'});
% 
% if ~isSupp
%     labelXPosRef = labelPropsOldRef{1}(1) - 0.6*labelPropsOldRef{2}(3);
% else
%     labelXPosRef = labelPropsOldRef{1}(1) - 0.6*labelPropsOldRef{2}(3);
% end
% 
% for iYLabel = 1:length(hYLabel)
%     labelPos = get(hYLabel(iYLabel),'Position');
%     labelPos(1) = labelXPosRef;
%     set(hYLabel(iYLabel),'Position',labelPos,...
%         'VerticalAlignment','baseline');
% end

end

function plot_legend(hLine,legendStr,legendLoc)

legend(hLine,legendStr,'Location',legendLoc)

end
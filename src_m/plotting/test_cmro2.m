function [H_axes rows cols] = test_cmro2(P, sim_list, data, params)

req_sim = {'test_dil','test_metab','test_dil_metab'};
        
idxData = find_data_indices(sim_list,req_sim);

for iSim = 1:length(idxData)
    [t0(iSim) idxt0(iSim)] = min(abs(data(idxData(iSim)).t(...
        data(idxData(iSim)).t < 0)));
end

rows = 4;
cols = 3;

tspan = [-10 40];
cbfYLims = [0.92 1.55];
cmro2YLims = [0.93 1.34];
hbYLims = [0.785 1.29];
po2YLims = [0.68 1.41];
tStimBar = [0 params(idxData(2)).metabolism.t_stim];
yStimBar = 0.72;

strTitle = {'CBF only','CMRO2 only','CBF + CMRO2'};

lineProps = {'LineWidth',P.Misc.widthLine};
strStimProps = {'FontSize',P.Axes.FontSize};
lineStimProps = {'LineWidth',P.Misc.widthLineStim};
labelProps = {'FontWeight',P.Misc.weightFontStrong,...
    'FontSize',P.Misc.sizeFontStrong};
titleProps = {'FontWeight',P.Misc.weightFontStrong,...
    'FontSize',P.Misc.sizeFontLabel};

hbColours = {[203, 24, 29],[33, 113, 181],[106, 81, 163]};
colCMRO2 = [35, 139, 69]./256;
colPO2 = [217, 72, 1];

hFig = figure;
set(hFig, 'Position', get(0,'Screensize')); % Maximize figure.
gap = [0.025 0.04];
marg_h = 0.1;
marg_w = 0.1;
H_axes = tight_subplot(rows,cols, gap, marg_h, marg_w);

% Ensure the axes have some labelling: required due to bug in tight_subplot
set(H_axes,'XTickLabelMode','auto','YTickLabelMode','auto')

nSims = length(req_sim);

hasPO2_ss = false(nSims, 1);
for iSim = 1:nSims
    hasPO2_ss(iSim) = ~isempty(data(iSim).PO2_ss);
end
usePO2_ss = all(hasPO2_ss);

for iSim = 1:nSims
    
    isFirst = (iSim == 1);
    doLegend = (iSim == nSims-1);
    
    % Calculate the estimate of CMRO2 from my predictions of the data
    cbf = data(idxData(iSim)).F(:,end)/...
        data(idxData(iSim)).F(idxt0(iSim),end);
    hbo = data(idxData(iSim)).nHbO(:,end)/...
        data(idxData(iSim)).nHbO(idxt0(iSim),end);
    dhb = data(idxData(iSim)).ndHb(:,end)/...
        data(idxData(iSim)).ndHb(idxt0(iSim),end);
    hbt = data(idxData(iSim)).nHbT(:,end)/...
        data(idxData(iSim)).nHbT(idxt0(iSim),end);
    cmro2_act = data(idxData(iSim)).S(:,4)/...
        data(idxData(iSim)).S(idxt0(iSim),4);
    if usePO2_ss
        po2 = data(idxData(iSim)).PO2_ss(:,1)/...
            data(idxData(iSim)).PO2_ss(idxt0(iSim),1);
    else
        po2 = data(idxData(iSim)).PO2(:,4)/...
            data(idxData(iSim)).PO2(idxt0(iSim),4);
    end
    
    axes(H_axes(iSim))
    hold on
    hTitle(iSim) = title(strTitle{iSim},titleProps{:});
    if isFirst, hYLabel(1) = ylabel('CBF (a.u.)',labelProps{:}); end
    xlim(tspan)
    ylim(cbfYLims)
    plot(data(idxData(iSim)).t,cbf,'k-',lineProps{:})
    hold off
    
    axes(H_axes(iSim+cols))
    hold on
    if isFirst, hYLabel(2) = ylabel('CMRO2 (a.u.)',labelProps{:}); end
    xlim(tspan)
    ylim(cmro2YLims)
    plot(data(idxData(iSim)).t,cmro2_act,'-','Color',colCMRO2,lineProps{:})
    plot(data(idxData(iSim)).t,data(idxData(iSim)).cmro2_pred,'--',...
        'Color',colCMRO2,lineProps{:})
    plot(data(idxData(iSim)).t,data(idxData(iSim)).JO2(:,4)./...
        data(idxData(iSim)).JO2(1,4),...
        ':','Color',colCMRO2,lineProps{:});
    if doLegend, legend('Imposed','Calculated','Extracted','Location','NorthEast'), end
    hold off
    
    axes(H_axes(iSim+2*cols))
    hold on
    if isFirst, hYLabel(3) = ylabel('Haemoglobin (a.u.)',labelProps{:}); end
    xlim(tspan)
    ylim(hbYLims)
    plot(data(idxData(iSim)).t,hbo,'-','Color',hbColours{1}/256,lineProps{:})
    plot(data(idxData(iSim)).t,hbt,'-','Color',hbColours{3}/256,lineProps{:})
    plot(data(idxData(iSim)).t,dhb,'-','Color',hbColours{2}/256,lineProps{:})
    if doLegend, legend('HbO','HbT','dHb','Location','NorthEast'), end
    hold off
    
    axes(H_axes(iSim+3*cols))
    hold on
    if isFirst, hYLabel(4) = ylabel('Tissue PO2 (a.u.)',labelProps{:}); end
    % xlabel('Time (s)',labelProps{:})
    xlim(tspan)
    ylim(po2YLims)
    plot(data(idxData(iSim)).t, po2,'-', 'Color', colPO2/256, lineProps{:})
    plot(tStimBar,yStimBar*ones(1,2),'k-',lineStimProps{:})
    text(tStimBar(2)+2,yStimBar,[num2str(tStimBar(2)) 's'],strStimProps{:})
    set(gca,'YTick',0.8:0.2:1.6)
    hold off
    
end

% Remove X Axes from all but the bottom rows
set(H_axes,'XTick',[],'XColor','w')

% Remove Y Axes from all but the first columns
set(H_axes(2:cols:rows*cols),'YTick',[],'YColor','w')
set(H_axes(3:cols:rows*cols),'YTick',[],'YColor','w')

% % Ensure the titles are all vertically aligned to the same point (prevents
% % issues with subscipts)
% titlePropsOld = get(hTitle(3),{'Position','Extent'});
% titlePos = titlePropsOld{1};
% titlePos(2) = titlePropsOld{1}(2) + 0.1*titlePropsOld{2}(4);
% set(hTitle,'Position',titlePos,'VerticalAlignment','baseline');

% % Ensure the yLabels are all horizontally aligned to the same point 
% % (prevents issues with subscipts)
% labelPropsOldRef = get(hYLabel(2),{'Position','Extent'});
% labelXPosRef = labelPropsOldRef{1}(1) - 0.5*labelPropsOldRef{2}(3);
% for iYLabel = 1:length(hYLabel)
%     labelPos = get(hYLabel(iYLabel),'Position');
%     labelPos(1) = labelXPosRef;
%     set(hYLabel(iYLabel),'Position',labelPos,...
%         'VerticalAlignment','baseline');
% end


end
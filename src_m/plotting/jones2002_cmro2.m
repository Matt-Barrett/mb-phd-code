function [H_axes rows cols] = jones2002_cmro2(P,sim_list,data)

req_sim = { 'jones2002_04_adj','jones2002_08_adj',...
            'jones2002_12_adj','jones2002_16_adj'};
        
idxData = find_data_indices(sim_list,req_sim);

for iSim = 1:length(idxData)
    [t0(iSim) idxt0(iSim)] = min(abs(data(idxData(iSim)).t(...
        data(idxData(iSim)).t < 0)));
end

doError = false;

if ~doError
    rows = 1;
else
    rows = 2;
end
cols = 4;
stimTitle = {'0.4 mA','0.8 mA','1.2 mA','1.6 mA'};

tspan = [-10 40];
tLabel = 'Time (s)';

yLimsCMRO2 = [0.98 1.28];
yLimsError = [-0.0499 0.28];
yLabelCMRO2 = 'CMRO2 (a.u.)';
yLabelError = 'Residuals (a.u.)';
colCMRO2 = [35, 139, 69]./256;

tStimBar = [0 20];
if ~doError
    yStimBar = 0.98;
else
    yStimBar = -0.04;
end

lineProps = {'LineWidth',P.Misc.widthLine};
labelProps = {'FontWeight',P.Misc.weightFontStrong,...
    'FontSize',P.Misc.sizeFontStrong};
lineStimProps = {'LineWidth',P.Misc.widthLineStim};
strStimProps = {'FontSize',P.Axes.FontSize};
titleProps = {'FontWeight',P.Misc.weightFontStrong,...
    'FontSize',P.Misc.sizeFontLabel};

hFig = figure;
set(hFig, 'Position', get(0,'Screensize')); % Maximize figure.
gap = [0.025 0.025];
marg_h = [0.18 0.18];
marg_w = 0.1;
H_axes = tight_subplot(rows,cols, gap, marg_h, marg_w);

nStims = cols;
for iStim = 1:nStims
    
    doYLabel = iStim == 1;
    
    % Calculate 
    tt = data(idxData(iStim)).t;
    cmro2Imp = data(idxData(iStim)).S(:,4)/...
        data(idxData(iStim)).S(idxt0(iStim),4);
    cmro2Calc = data(idxData(iStim)).cmro2_pred;
    cmro2Ext = data(idxData(iStim)).JO2(:,4)./...
        data(idxData(iStim)).JO2(idxt0(iStim),4);
    
    % Top CMRO2 Plot
    axes(H_axes(iStim)); hold on
    title(stimTitle{iStim},titleProps{:})
    xlim(tspan)
    ylim(yLimsCMRO2)
    if doYLabel, 
        ylabel(yLabelCMRO2,labelProps{:}); 
        set(H_axes(iStim),'YTickLabelMode','auto')
    else
        set(H_axes(iStim),'YTick',[],'YColor','w')
    end
    set(H_axes(iStim),'XTick',[],'XColor','w')
    hLineTop(2) = plot(tt, cmro2Calc,'--', 'Color', colCMRO2, lineProps{:});
    hLineTop(3) = plot(tt, cmro2Ext, ':', 'Color', colCMRO2, lineProps{:});
    hLineTop(1) = plot(tt, cmro2Imp, 'Color', colCMRO2, lineProps{:});
    
    if ~doError
        plot(tStimBar, yStimBar*ones(1,2), 'k-', lineStimProps{:})
        text(tStimBar(2)+2, yStimBar, [num2str(tStimBar(2)) 's'], strStimProps{:})
    end
    
    if doYLabel
        legend(hLineTop,'Imposed','Calculated','Extracted','Location','East')
    end
    hold off
    
    if doError
    
        % Bottom CMRO2 Plot
        axes(H_axes(iStim+nStims)); hold on
        xlim(tspan)
        ylim(yLimsError)
        if doYLabel, 
            ylabel(yLabelError, labelProps{:}); 
            set(H_axes(iStim+nStims),'YTickLabelMode','auto')
        else
            set(H_axes(iStim+nStims),'YTick',[],'YColor','w')
        end
        set(H_axes(iStim+nStims),'XTick',[],'XColor','w')

        plot(tspan, zeros(size(tspan)), 'k-')

        hLineBot(1) = plot(tt, (cmro2Calc - cmro2Imp)./cmro2Imp, '--', ...
            'Color', colCMRO2, lineProps{:});
        hLineBot(2) = plot(tt, (cmro2Ext - cmro2Imp)./cmro2Imp, ':', ...
            'Color', colCMRO2, lineProps{:});

        if doYLabel
            legend(hLineBot,'Calculated', 'Extracted', 'Location', 'East')
        end

        plot(tStimBar, yStimBar*ones(1,2), 'k-', lineStimProps{:})
        text(tStimBar(2)+2, yStimBar, [num2str(tStimBar(2)) 's'], strStimProps{:})

        hold off
    
    end
    
end

end
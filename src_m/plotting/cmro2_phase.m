function [H_axes rows columns] = cmro2_phase(P, sim_list, data, params)

req_sim = {'jones2002_12_adj'};
idxData = find_data_indices(sim_list,req_sim);

for iSim = 1:length(idxData)
    [t0(iSim) idxt0(iSim)] = min(abs(data(idxData(iSim)).t(...
        data(idxData(iSim)).t < 0)));
end

rows = 1;
columns = 1;

yLims = [0.951 1.35];
tspan = [-5 40];

tStimBar = [0 20];
yStimBar = 0.975;

yPosText = 0.96;

colCMRO2 = [35, 139, 69]./256;

yLabelCMRO2 = 'CMRO2 or CBF (a.u.)';

labelProps = {'FontWeight',P.Misc.weightFontStrong,...
    'FontSize',P.Misc.sizeFontStrong};
lineProps = {'LineWidth',P.Misc.widthLine};
lineStimProps = {'LineWidth',P.Misc.widthLineStim};
strStimProps = {'FontSize',P.Axes.FontSize, 'HorizontalAlignment', 'left'};
titleProps = {'FontWeight',P.Misc.weightFontStrong,...
    'FontSize',P.Misc.sizeFontLabel};

phaselines = [...
    params(idxData).metabolism.t0, ...
    params(idxData).metabolism.t_rise - 1.5, ...
    params(idxData).metabolism.t_stim, ...
    tspan(2)];
strPhases = {'Onset','Plateau','Offset'};

figure, 
H_axes(1) = subplot(rows,columns,1); hold on

    xlim(tspan)
    ylim(yLims)
    ylabel(yLabelCMRO2, labelProps{:}); 
    
    % Calculate 
    tt = data(idxData).t;
    cmro2Imp = data(idxData).S(:,4)/...
        data(idxData).S(idxt0,4);
    cmro2Calc = data(idxData).cmro2_pred;
    cmro2Ext = data(idxData).JO2(:,4)./...
        data(idxData).JO2(idxt0,4);
    cbf = data(idxData).F(:,5)/...
        data(idxData).F(idxt0,5);
    
    hLineTop(3) = plot(tt, cmro2Calc,'--', 'Color', colCMRO2, lineProps{:});
    hLineTop(4) = plot(tt, cmro2Ext, ':', 'Color', colCMRO2, lineProps{:});
    hLineTop(2) = plot(tt, cmro2Imp, 'Color', colCMRO2, lineProps{:});
    hLineTop(1) = plot(tt, cbf, 'k-', lineProps{:});
    
    plot(tStimBar, yStimBar*ones(1,2), 'k-', lineStimProps{:})
    text(tStimBar(2) + 1, yStimBar, [num2str(tStimBar(2)) 's'], strStimProps{:})
    
    for iLine = 1:length(phaselines) - 1
        
%         plot(phaselines(iLine)*ones(1,2), yLims, 'k--')
        
%         xPosText = mean(phaselines(iLine:iLine+1));
%         text(xPosText, yPosText, strPhases{iLine}, ...
%             'HorizontalAlignment', 'center', labelProps{:})
        
    end
    
%     set(H_axes(1),'YTick',[],'YColor','w')
    set(H_axes(1),'XTick',[],'XColor','w')
    
    legend(hLineTop, 'CBF', 'Imposed CMRO2', 'Calculated CMRO2', ...
        'Extracted CMRO2', 'Location', 'NorthEast')
    
    hold off
end
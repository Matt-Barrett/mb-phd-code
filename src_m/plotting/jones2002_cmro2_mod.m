function [H_axes rows cols] = jones2002_cmro2_mod(P,sim_list,data)

req_sim = { 'jones2002_16_nomet','jones2002_16_adj','jones2002_16_met_x2'};
        
idxData = find_data_indices(sim_list,req_sim);

for iSim = 1:length(idxData)
    [t0(iSim) idxt0(iSim)] = min(abs(data(idxData(iSim)).t(...
        data(idxData(iSim)).t < 0)));
end

rows = 1;
cols = 3;

tspan = [-10 40];
tStimBar = [0 20];
yStimBar = 0.835;

yLims = [0.82 1.349];
yLabel = 'Hemoglobin (a.u.)';

simNames = {'1.6mA'};
Jones2002 = import_jones(simNames);

simTitle = {'No CMRO_2','Optimal CMRO_2','2 \times Optimal CMRO_2'};

nHbTypes = 3;
hbColours = {[203, 24, 29],[106, 81, 163],[33, 113, 181]};
hbVarNames = {'HbO_spec','nHbT','dHb_spec'};
hbLineType = {'--','-','--'};
doNormHbVar = [false true false];
hbColoursData = {[252, 174, 145],[203, 201, 226],[189, 215, 231]};
hbDataNames = {'raw_HbO',  'raw_HbT',  'raw_dHb'};
hbLegend = {'HbO','HbT','dHb'};

lineProps = {'LineWidth',P.Misc.widthLine};
linePropsData = {'LineWidth',P.Misc.widthLineStim};
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

nSims = cols;
for iSim = 1:nSims
    
    doYLabel = iSim == 1;
    doLegend  = iSim == nSims;
    modDataT = data(idxData(iSim)).t;
    
    axes(H_axes(iSim)); hold on
    title(simTitle{iSim},titleProps{:})
    xlim(tspan)
    ylim(yLims)
    if doYLabel, 
        ylabel(yLabel,labelProps{:}); 
        set(H_axes(iSim),'YTickLabelMode','auto')
    else
        set(H_axes(iSim),'YTick',[],'YColor','w')
    end
    set(H_axes(iSim),'XTick',[],'XColor','w')
    
	for jHbType = 1:nHbTypes
        
        % Plot the experimental Data
        expData = Jones2002.(hbDataNames{jHbType});
        expData(:,2) = 1 + expData(:,2)/100;
        plot(expData(:,1),expData(:,2),'-',...
            'Color',hbColoursData{jHbType}/256,linePropsData{:});
        
        % Then plot the model predictions
        modData = data(idxData(iSim)).(hbVarNames{jHbType})(:,end);
        if doNormHbVar(jHbType)
            modData = modData./modData(idxt0(iSim));
        else
            modData = modData+1;
        end
        hLine(jHbType) = plot(modDataT,modData,hbLineType{jHbType},...
            'Color',hbColours{jHbType}/256,lineProps{:});
        
    end
    
    plot(tStimBar,yStimBar*ones(1,2),'k-',lineStimProps{:})
    text(tStimBar(2)+2,yStimBar,[num2str(tStimBar(2)) 's'],strStimProps{:})
    
    if doLegend
        legend(hLine,hbLegend{:},'Location','NorthEast')
    end
    
    hold off
    
end

end
function [H_axes rows columns subaxis] = vazquez2008_poster(P,sim_list,...
                                                    data,constants,params)

req_sim = {...
    'vazquez2008_control_cap',  'vazquez2008_vasodilated_cap',...
    'vazquez2008_control_all',  'vazquez2008_vasodilated_all',...
    'vazquez2008_control_leak', 'vazquez2008_vasodilated_leak',...
    'vazquez2008_control_p50',  'vazquez2008_vasodilated_p50',...
    'vazquez2008_control',      'vazquez2008_vasodilated'};
idx = find_data_indices(sim_list,req_sim);

for iSim = 1:length(idx)
    [t0(iSim) idxt0(iSim)] = min(abs(data(idx(iSim)).t(data(idx(iSim)).t<0)));
end

tspan = [-5 70];
rows= 4;
columns = 3;

% [t0 idxt0] = min(abs(data(idx(9)).t));

load vazquez2008;

yLim1 = [0.96 1.55];
yLim2 = [31 46.5];

%%

xLabel = -0.05; yLabel = 1.05;
plotLabel = @(labelStr) text(xLabel,yLabel,labelStr,...
                'FontWeight',P.Misc.weightFontStrong,...
                'FontSize',P.Misc.sizeFontLabel,...
                'Units','normalized','VerticalAlignment','middle',...
                'HorizontalAlignment','right');
        
[colData(1) colData(2) colData(3)] = rgbconv('CCCCCC');
[capPerm(1) capPerm(2) capPerm(3)] = rgbconv('4DAF4A');
[allPerm(1) allPerm(2) allPerm(3)] = rgbconv('377EB8');
[leak(1) leak(2) leak(3)] = rgbconv('984EA3');
[p50(1) p50(2) p50(3)] = rgbconv('E41A1C');
testCol = 0.81*ones(1,3);

idxMechList = 1:4;
mechCol = [capPerm; allPerm; leak; p50];
mechNameList = {'CapPerm','AllPerm','Leak','P50'};
plotLetters = {'A','B','C';'D','E','F';'G','H','I';'J','K','L'};
        
nMechs = length(mechNameList);
for iMech = 1:nMechs
    
    numPlot = (iMech-1)*columns + 1;
    idxMech = 2*idxMechList(iMech)-1;
    mechName = sprintf('Model PO2 (%s)',mechNameList{iMech});
    
    H_axes(numPlot) = subplot(rows,columns,numPlot);
        hold on
            axis([tspan yLim2])
%             plotLabel(plotLetters{iMech,1})
            ylabel(mechNameList{iMech},'FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontLabel,'Color',mechCol(iMech,:))
            if iMech == 1 
                title('Tissue PO2 - Control (mmHg)',...
                    'FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontLabel)
            elseif iMech == nMechs
                xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontStrong)
            end
            
            hPlot1(3) = plot(0,0,'-','LineWidth',P.Misc.widthLine,...
                'Color',testCol);
            plot(vazquez2008.PO2.control(:,1),...
                vazquez2008.PO2.control(:,2),'-',...
                'LineWidth',P.Misc.widthLine*2,'Color',colData);
            hPlot1(1) = plot(data(idx(9)).t,...
                constants(idx(9)).reference.PO2_ref.*...
                data(idx(9)).PO2_ss(:,1),...
                'k-','LineWidth',P.Misc.widthLine);
            hPlot1(2) = plot(data(idx(idxMech)).t,...
                constants(idx(idxMech)).reference.PO2_ref.*...
                data(idx(idxMech)).PO2_ss(:,1),...
                '-','LineWidth',P.Misc.widthLine,'Color',mechCol(iMech,:));
            
            doSubaxis = (iMech == 1);
            if doSubaxis
                subaxis(1).handle = axes('NextPlot', 'add');
                subaxis(1).posn = get(H_axes(numPlot),'Position');
                subaxis(1).xlim = [tspan(1) 40];
                subaxis(1).ylim = [0.95 1.54];
                subaxis(1).subposn = [0.45 0.40 0.5 0.5];
                subaxis(1).adjposn =  subaxis(1).subposn.* ...
                    [subaxis(1).posn(3:4) subaxis(1).posn(3:4)]...
                    + [subaxis(1).posn(1:2) 0 0];
                hold on
                    plot(vazquez2008.F.control(:,1),...
                        vazquez2008.F.control(:,2),'-',...
                        'LineWidth',P.Misc.widthLine*2,'Color',colData);
                    plot(data(idx(9)).t,data(idx(9)).F(:,5),'k-',...
                        'LineWidth',P.Misc.widthLine);
                    text(20,1.3,'CBF (a.u.)','FontSize',P.Misc.sizeFontStrong)
                hold off
                set(subaxis(1).handle,'xlim',subaxis(1).xlim,...
                    'ylim',subaxis(1).ylim,...'YTick',1:0.01:1.03,...
                    'Units', 'normalized', 'Position',subaxis(1).adjposn)
            end
            
%             legend(hPlot1,'Model PO2 (NoMech)',mechName,...
%                 'Masamoto (2008) PO2','Location','NorthEast')
        hold off
        
        
    H_axes(numPlot+1) = subplot(rows,columns,numPlot+1);
        hold on
            axis([tspan yLim2])
%             plotLabel(plotLetters{iMech,2})
            if iMech == 1 
                title('Tissue PO2 - SNP (mmHg)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontLabel)
            elseif iMech == nMechs
                xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontStrong)
            end
            
            plot(vazquez2008.PO2.vasodilated(:,1),...
                vazquez2008.PO2.vasodilated(:,2),...
                '-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(data(idx(10)).t,...
                constants(idx(10)).reference.PO2_ref.*...
                data(idx(10)).PO2_ss(:,1),...
                'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(idxMech+1)).t,...
                constants(idx(idxMech+1)).reference.PO2_ref.*...
                data(idx(idxMech+1)).PO2_ss(:,1),...
                '-','LineWidth',P.Misc.widthLine,'Color',mechCol(iMech,:))
        hold off
        
        doSubaxis = (iMech == 1);
            if doSubaxis
                subaxis(2).handle = axes('NextPlot', 'add');
                subaxis(2).posn = get(H_axes(numPlot+1),'Position');
                subaxis(2).xlim = subaxis(1).xlim;
                subaxis(2).ylim = subaxis(1).ylim;
                subaxis(2).subposn = [0.45 0.15 0.5 0.5];
                subaxis(2).adjposn =  subaxis(2).subposn.* ...
                    [subaxis(2).posn(3:4) subaxis(2).posn(3:4)]...
                    + [subaxis(2).posn(1:2) 0 0];
                hold on
                    plot(vazquez2008.F.vasodilated(:,1),...
                        vazquez2008.F.vasodilated(:,2),'-',...
                        'LineWidth',P.Misc.widthLine*2,'Color',colData);
                    plot(data(idx(10)).t,data(idx(10)).F(:,5),'k-',...
                        'LineWidth',P.Misc.widthLine);
                    text(10,1.2,'CBF (a.u.)','FontSize',P.Misc.sizeFontStrong)
                hold off
                set(subaxis(2).handle,'xlim',subaxis(2).xlim,...
                    'ylim',subaxis(2).ylim,...'YTick',1:0.01:1.03,...
                    'Units', 'normalized', 'Position',subaxis(2).adjposn)
            end
        
        
    H_axes(numPlot+2) = subplot(rows,columns,numPlot+2);
        hold on
            axis([tspan 0.97 1.55])
%             plotLabel(plotLetters{iMech,3})
            if iMech == 1 
                title('Oxygen Consumption (a.u.)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontLabel)
            elseif iMech == nMechs
                xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontStrong)
            end
            
            hPlot3(2) = plot(data(idx(9)).t,...
                data(idx(9)).S(:,4)/data(idx(9)).S(idxt0(5),4),...
                'k-','LineWidth',P.Misc.widthLine);
            hPlot3(3) = plot(data(idx(idxMech)).t,...
                data(idx(idxMech)).S(:,4)/...
                data(idx(idxMech)).S(idxt0(idxMech),4),...
                '-','LineWidth',P.Misc.widthLine,...
                'Color',mechCol(iMech,:));
            
            if iMech == 1
                hPlot3(1) = plot(0,0,'-','LineWidth',P.Misc.widthLine,...
                    'Color',testCol);
                legend(hPlot3(1:2),'Data','Model (NoMech)',...
                    'Location','NorthEast')
            end
            
        hold off
        
end
        
end
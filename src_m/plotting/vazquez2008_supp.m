function [H_axes rows columns] = vazquez2008_supp(P,sim_list,data,...
                                                        constants,params)
                                                
req_sim = {'vazquez2008_control_cap','vazquez2008_vasodilated_cap',...
    'vazquez2008_control_all','vazquez2008_vasodilated_all',...
    'vazquez2008_control_leak','vazquez2008_vasodilated_leak',...
    'vazquez2008_control_p50','vazquez2008_vasodilated_p50'};
idx = find_data_indices(sim_list,req_sim);

simExtra = {'vazquez2008_control_shunt','vazquez2008_vasodilated_shunt'};
wngstate = warning('off','FindDataIndices:CouldntFind');
idxExtra = find_data_indices(sim_list,simExtra);
idx = [idx idxExtra];
warning(wngstate)
doExtra = all(~isnan(idxExtra));

tspan = [-5 70];
rows = 3;
if doExtra, rows = 4; end
columns = 2;

% [t0 idxt0] = min(abs(data(idx(1)).t));

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
[allPerm(1) allPerm(2) allPerm(3)] = rgbconv('7FC97F');
[leak(1) leak(2) leak(3)] = rgbconv('BEAED4');
[p50(1) p50(2) p50(3)] = rgbconv('FDC086');
[shunt(1) shunt(2) shunt(3)] = rgbconv('386CB0');

testCol = 0.81*ones(1,3);

%% Calculate the new PO2_t
                    
%%

idxK = find(~isnan(params(idx(2)).metabolism.testK));

figure        
    H_axes(1) = subplot(rows,columns,1);
        hold on
            axis([tspan yLim2])
            plotLabel('A')
            title('Control','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontLabel)
            ylabel('Tissue PO2 (mmHg)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            hPlot1(3) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(vazquez2008.PO2.control(:,1),vazquez2008.PO2.control(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData);
            hPlot1(1) = plot(data(idx(1)).t,constants(idx(1)).reference.PO2_ref.*data(idx(1)).PO2_ss(:,1),'k-','LineWidth',P.Misc.widthLine);
            hPlot1(2) = plot(data(idx(3)).t,constants(idx(3)).reference.PO2_ref.*data(idx(3)).PO2_ss(:,1),'-','LineWidth',P.Misc.widthLine,'Color',allPerm);
            legend(hPlot1,'Model PO2 (CapPerm)','Model PO2 (AllPerm)','Masamoto (2008) PO2','Location','NorthEast')
        hold off
    H_axes(2) = subplot(rows,columns,2);
        hold on
            axis([tspan yLim2])
            plotLabel('B')
            title('Sodium Nitroprusside','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontLabel)
            plot(vazquez2008.PO2.vasodilated(:,1),vazquez2008.PO2.vasodilated(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(data(idx(2)).t,constants(idx(2)).reference.PO2_ref.*data(idx(2)).PO2_ss(:,1),'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(4)).t,constants(idx(4)).reference.PO2_ref.*data(idx(4)).PO2_ss(:,1),'-','LineWidth',P.Misc.widthLine,'Color',allPerm)
        hold off
    H_axes(3) = subplot(rows,columns,3);
        hold on
            axis([tspan yLim2])
            plotLabel('C')
            ylabel('Tissue PO2 (mmHg)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            hPlot2(3) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(vazquez2008.PO2.control(:,1),vazquez2008.PO2.control(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData);
            hPlot2(1) = plot(data(idx(1)).t,constants(idx(1)).reference.PO2_ref.*data(idx(1)).PO2_ss(:,1),'k-','LineWidth',P.Misc.widthLine);
            hPlot2(2) = plot(data(idx(5)).t,constants(idx(5)).reference.PO2_ref.*data(idx(5)).PO2_ss(:,1),'-','LineWidth',P.Misc.widthLine,'Color',leak);
            legend(hPlot2,'Model PO2 (CapPerm)','Model (Leak)','Masamoto (2008)','Location','NorthEast')
        hold off
    H_axes(4) = subplot(rows,columns,4);
        hold on
            axis([tspan yLim2])
            plotLabel('D')
            plot(vazquez2008.PO2.vasodilated(:,1),vazquez2008.PO2.vasodilated(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(data(idx(2)).t,constants(idx(2)).reference.PO2_ref.*data(idx(2)).PO2_ss(:,1),'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(4)).t,constants(idx(6)).reference.PO2_ref.*data(idx(6)).PO2_ss(:,1),'-','LineWidth',P.Misc.widthLine,'Color',leak)
        hold off
    H_axes(5) = subplot(rows,columns,5);
        hold on
            axis([tspan yLim2])
            plotLabel('E')
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            ylabel('Tissue PO2 (mmHg)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            hPlot3(3) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(vazquez2008.PO2.control(:,1),vazquez2008.PO2.control(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData);
            hPlot3(1) = plot(data(idx(1)).t,constants(idx(1)).reference.PO2_ref.*data(idx(1)).PO2_ss(:,1),'k-','LineWidth',P.Misc.widthLine);
            hPlot3(2) = plot(data(idx(7)).t,constants(idx(7)).reference.PO2_ref.*data(idx(7)).PO2_ss(:,1),'-','LineWidth',P.Misc.widthLine,'Color',p50);
            legend(hPlot3,'Model PO2 (CapPerm)','Model (P50)','Masamoto (2008)','Location','NorthEast')
        hold off
    H_axes(6) = subplot(rows,columns,6);
        hold on
            axis([tspan yLim2])
            plotLabel('F')
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(vazquez2008.PO2.vasodilated(:,1),vazquez2008.PO2.vasodilated(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(data(idx(2)).t,constants(idx(2)).reference.PO2_ref.*data(idx(2)).PO2_ss(:,1),'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(8)).t,constants(idx(8)).reference.PO2_ref.*data(idx(8)).PO2_ss(:,1),'-','LineWidth',P.Misc.widthLine,'Color',p50)
        hold off
    if doExtra
        H_axes(7) = subplot(rows,columns,7);
        hold on
            axis([tspan yLim2])
            plotLabel('E')
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            ylabel('Tissue PO2 (mmHg)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            hPlot3(3) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(vazquez2008.PO2.control(:,1),vazquez2008.PO2.control(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData);
            hPlot3(1) = plot(data(idx(1)).t,constants(idx(1)).reference.PO2_ref.*data(idx(1)).PO2_ss(:,1),'k-','LineWidth',P.Misc.widthLine);
            hPlot3(2) = plot(data(idx(9)).t,constants(idx(9)).reference.PO2_ref.*data(idx(9)).PO2_ss(:,1),'-','LineWidth',P.Misc.widthLine,'Color',shunt);
            legend(hPlot3,'Model PO2 (CapPerm)','Model (Shunt)','Masamoto (2008)','Location','NorthEast')
        hold off
    H_axes(8) = subplot(rows,columns,8);
        hold on
            axis([tspan yLim2])
            plotLabel('F')
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(vazquez2008.PO2.vasodilated(:,1),vazquez2008.PO2.vasodilated(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(data(idx(2)).t,constants(idx(2)).reference.PO2_ref.*data(idx(2)).PO2_ss(:,1),'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(10)).t,constants(idx(10)).reference.PO2_ref.*data(idx(10)).PO2_ss(:,1),'-','LineWidth',P.Misc.widthLine,'Color',shunt)
        hold off
    end
        
end
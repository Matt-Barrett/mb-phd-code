function [H_axes rows columns] = vazquez2008_main(P,sim_list,data,...
                                                        constants,params)
                                                  
req_sim = {'vazquez2008_control_cap','vazquez2008_vasodilated_cap',...
            'vazquez2008_control','vazquez2008_vasodilated'};
idx = find_data_indices(sim_list,req_sim);

tspan = [-5 70];
rows= 2;
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
% [noKData(1) noKData(2) noKData(3)] = rgbconv('636363');
[noKData(1) noKData(2) noKData(3)] = rgbconv('737373');

testCol = 0.81*ones(1,3);

%% Calculate the new PO2_t
                    
%%

idxK = find(~isnan(params(idx(2)).metabolism.testK));

figure
    H_axes(1) = subplot(rows,columns,1);
        hold on
            axis([tspan yLim1])
            plotLabel('A')
            title('Control','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontLabel)
            ylabel('CBF and CMRO2 (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            hPlot1(2) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(vazquez2008.F.control(:,1),vazquez2008.F.control(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData);
            hPlot1(1) = plot(data(idx(1)).t,data(idx(1)).F(:,5),'k-','LineWidth',P.Misc.widthLine);
            hPlot1(3) = plot(data(idx(1)).t,data(idx(1)).S(:,4)./data(idx(1)).S(1,4),'k--','LineWidth',P.Misc.widthLine);
            hPlot1(4) = plot(data(idx(3)).t,data(idx(3)).S(:,4)./data(idx(1)).S(1,4),'--','LineWidth',P.Misc.widthLine,'Color',noKData);
            legend(hPlot1,'Model CBF','Masamoto (2008) CBF','Model CMRO2 (CapPerm)','Model CMRO2 (NoMech)','Location','NorthEast')
%             legend(hPlot1,'Model CBF','Masamoto (2008) CBF','Model CMRO2 (CapPerm)','Model CMRO2 (Shunt)','Location','NorthEast')
        hold off
    H_axes(2) = subplot(rows,columns,2);
        hold on
            axis([tspan yLim1])
            plotLabel('B')
            title('Sodium Nitroprusside','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontLabel)
            plot(vazquez2008.F.vasodilated(:,1),vazquez2008.F.vasodilated(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(data(idx(2)).t,data(idx(2)).F(:,5),'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,data(idx(2)).S(:,4)./data(idx(1)).S(1,4),'k--','LineWidth',P.Misc.widthLine);
            plot(data(idx(4)).t,data(idx(4)).S(:,4)./data(idx(1)).S(1,4),'--','LineWidth',P.Misc.widthLine,'Color',noKData);
        hold off            
    H_axes(3) = subplot(rows,columns,3);
        hold on
            axis([tspan yLim2])
            plotLabel('C')
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            ylabel('Tissue PO2 (mmHg)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            hPlot3(3) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(vazquez2008.PO2.control(:,1),vazquez2008.PO2.control(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData);
            hPlot3(1) = plot(data(idx(1)).t,constants(idx(1)).reference.PO2_ref.*data(idx(1)).PO2_ss(:,1),'k-','LineWidth',P.Misc.widthLine);
            hPlot3(2) = plot(data(idx(3)).t,constants(idx(3)).reference.PO2_ref.*data(idx(3)).PO2_ss(:,1),'-','LineWidth',P.Misc.widthLine,'Color',noKData);
            legend(hPlot3,'Model (CapPerm)','Model (NoMech)','Masamoto (2008)','Location','NorthEast')
%             legend(hPlot3,'Model (CapPerm)','Model (Shunt)','Masamoto (2008)','Location','NorthEast')
        hold off
    H_axes(4) = subplot(rows,columns,4);
        hold on
            axis([tspan yLim2])
            plotLabel('D')
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(vazquez2008.PO2.vasodilated(:,1),vazquez2008.PO2.vasodilated(:,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(data(idx(2)).t,constants(idx(2)).reference.PO2_ref.*data(idx(2)).PO2_ss(:,1),'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(4)).t,constants(idx(1)).reference.PO2_ref.*data(idx(4)).PO2_ss(:,1),'-','LineWidth',P.Misc.widthLine,'Color',noKData)
        hold off
        
end
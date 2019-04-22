function [H_axes rows columns] = vazquez2010_main(P,sim_list,data,...
                                                    constants,params)
                                                
req_sim = {'vazquez2010_cap','vazquez2010'};
idx = find_data_indices(sim_list,req_sim);

tspan = [-5 65];
rows= 2;
columns = 2;

Vazquez2010 = vazquez_2010_saturation(params(1),constants(1));  

for iSim = 1:length(idx)
    [t0(iSim) idxt0(iSim)] = min(abs(data(idx(iSim)).t(data(idx(iSim)).t<0)));
end
                    
%%

xLabel = -0.05; yLabel = 1.05;
plotLabel = @(labelStr) text(xLabel,yLabel,labelStr,...
                'FontWeight',P.Misc.weightFontStrong,...
                'FontSize',P.Misc.sizeFontLabel,...
                'Units','normalized','VerticalAlignment','middle',...
                'HorizontalAlignment','right');

[colData(1) colData(2) colData(3)] = rgbconv('CCCCCC');
[noKData(1) noKData(2) noKData(3)] = rgbconv('636363');
[noKData(1) noKData(2) noKData(3)] = rgbconv('737373');

testCol = 0.81*ones(1,3);

idxK = find(~isnan(params(idx(1)).metabolism.testK));

H_fig = figure;
    H_axes(1) = subplot(rows,columns,1);
        hold on
            axis([tspan 0.98 1.49])
            plotLabel('A')
            ylabel('CBF and CMRO2 (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            hPlot1(2) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(Vazquez2010{8}(:,1),Vazquez2010{8}(:,2),'-','Color',colData,'LineWidth',P.Misc.widthLine*2)
            hPlot1(3) = plot(data(idx(1)).t,data(idx(1)).S(:,4)./data(idx(1)).S(1,4),'k--','LineWidth',P.Misc.widthLine);
            hPlot1(4) = plot(data(idx(1)).t,data(idx(2)).S(:,4)./data(idx(2)).S(1,4),'--','LineWidth',P.Misc.widthLine,'Color',noKData);
            hPlot1(1) = plot(data(idx(1)).t,data(idx(1)).F(:,5),'k-','LineWidth',P.Misc.widthLine);
            legend(hPlot1,'Model CBF','Vazquez (2010) CBF','Model CMRO2 (CapPerm)',...
                'Model CMRO2 (NoMech)','Location','NorthEast');
%             legend(hPlot1,'Model CBF','Vazquez (2010) CBF','Model CMRO2 (CapPerm)',...
%                 'Model CMRO2 (Shunt)','Location','NorthEast');
            grid('on');
            box('on');
        hold off
    H_axes(2) = subplot(rows,columns,2);
        hold on
            axis([tspan 0.97 1.34])
            plotLabel('B')
            ylabel('Tissue PO2 (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            hPlot2(3) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(Vazquez2010{7}(:,1),Vazquez2010{7}(:,2)./Vazquez2010{9}(1,7),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            hPlot2(2) = plot(data(idx(2)).t,data(idx(2)).PO2_ss(:,1)/data(idx(2)).PO2_ss(idxt0(2),1),'-','LineWidth',P.Misc.widthLine,'Color',noKData);
            hPlot2(1) = plot(data(idx(1)).t,data(idx(1)).PO2_ss(:,1)/data(idx(1)).PO2_ss(idxt0(1),1),'k-','LineWidth',P.Misc.widthLine);
            legend(hPlot2,'Model (CapPerm)','Model (NoMech)',...
                'Vazquez (2010)','Location','NorthEast')
%             legend(hPlot2,'Model (CapPerm)','Model (Shunt)',...
%                 'Vazquez (2010)','Location','NorthEast')
        hold off
    H_axes(3) = subplot(rows,columns,3);
        hold on
            axis([tspan 0.98 1.155])
            plotLabel('C')
            ylabel('Arterial PO2 (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            hPlot3(3) = plot(0,0,'--','LineWidth',P.Misc.widthLine,'Color',testCol);
            hPlot3(4) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            hPlot3(5) = plot(0,0,'-.','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(Vazquez2010{1}(:,1),Vazquez2010{1}(:,2)./Vazquez2010{9}(1,1),'--','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(Vazquez2010{2}(:,1),Vazquez2010{2}(:,2)./Vazquez2010{9}(1,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(Vazquez2010{3}(:,1),Vazquez2010{3}(:,2)./Vazquez2010{9}(1,3),'-.','LineWidth',P.Misc.widthLine*2,'Color',colData)
            hPlot3(2) = plot(data(idx(2)).t,data(idx(2)).PO2(:,1)/data(idx(2)).PO2(idxt0(2),1),'-','LineWidth',P.Misc.widthLine,'Color',noKData);
            hPlot3(1) = plot(data(idx(1)).t,data(idx(1)).PO2(:,1)/data(idx(1)).PO2(idxt0(1),1),'k-','LineWidth',P.Misc.widthLine);
            legend(hPlot3,'Model (CapPerm)','Model (NoMech)',...
                'Vazquez (2010) SmArt','Vazquez (2010) MedArt',...
                'Vazquez (2010) LgeArt')
%             legend(hPlot3,'Model (CapPerm)','Model (Shunt)',...
%                 'Vazquez (2010) SmArt','Vazquez (2010) MedArt',...
%                 'Vazquez (2010) LgeArt')
        hold off
    H_axes(4) = subplot(rows,columns,4);
        hold on
            axis([tspan 0.97 1.29])
            plotLabel('D')
            ylabel('Venous PO2 (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            hPlot4(3) = plot(0,0,'--','LineWidth',P.Misc.widthLine,'Color',testCol);
            hPlot4(4) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            hPlot4(5) = plot(0,0,'-.','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(Vazquez2010{4}(:,1),Vazquez2010{4}(:,2)./Vazquez2010{9}(1,4),'--','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(Vazquez2010{5}(:,1),Vazquez2010{5}(:,2)./Vazquez2010{9}(1,5),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(Vazquez2010{6}(:,1),Vazquez2010{6}(:,2)./Vazquez2010{9}(1,6),'-.','LineWidth',P.Misc.widthLine*2,'Color',colData)
            hPlot4(2) = plot(data(idx(2)).t,data(idx(2)).PO2(:,3)/data(idx(2)).PO2(idxt0(2),3),'-','LineWidth',P.Misc.widthLine,'Color',noKData);
            hPlot4(1) = plot(data(idx(1)).t,data(idx(1)).PO2(:,3)/data(idx(1)).PO2(idxt0(1),3),'k-','LineWidth',P.Misc.widthLine);
            legend(hPlot4,'Model (CapPerm)','Model (NoMech)',...
                'Vazquez (2010) SmVen','Vazquez (2010) MedVen',...
                'Vazquez (2010) LgeVen')
%             legend(hPlot4,'Model (CapPerm)','Model (Shunt)',...
%                 'Vazquez (2010) SmVen','Vazquez (2010) MedVen',...
%                 'Vazquez (2010) LgeVen')
        hold off

end
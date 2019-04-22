function [H_axes rows columns] = vazquez2010_supp(P,sim_list,data,...
                                                    constants,params)
                                                
req_sim = {'vazquez2010_cap','vazquez2010_all',...
            'vazquez2010_leak','vazquez2010_p50'};
idx = find_data_indices(sim_list,req_sim);

simExtra = {'vazquez2010_shunt'};
wngstate = warning('off','FindDataIndices:CouldntFind');
idxExtra = find_data_indices(sim_list,simExtra);
warning(wngstate)
doExtra = all(~isnan(idxExtra));
if doExtra, idx = [idx idxExtra]; end

tspan = [-5 65];
rows = 3;
if doExtra, rows = 4; end
columns = 3;

Vazquez2010 = vazquez_2010_saturation(params(1),constants(1));  

for iSim = 1:length(idx)
    [t0(iSim) idxt0(iSim)] = min(abs(data(idx(iSim)).t(data(idx(iSim)).t<0)));
end
                    
%%

xLabel = -0.05; yLabel = 1.07;
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

idxMechList = 2:5;
mechCol = [allPerm; leak; p50; shunt];
mechNameList = {'AllPerm','Leak','P50'};
if doExtra, mechNameList{end+1} = 'Shunt'; end
plotLetters = {'A','B','C';'D','E','F';'G','H','I';'J','K','L'};

H_fig = figure;

nMechs = length(mechNameList);
for iMech = 1:nMechs
    
    numPlot = (iMech-1)*columns + 1;
    idxMech = idxMechList(iMech);
    mechName = sprintf('Model (%s)',mechNameList{iMech});
    
    H_axes(numPlot) = subplot(rows,columns,numPlot);
        hold on
            axis([tspan 0.97 1.34])
            plotLabel(plotLetters{iMech,1})
            ylabel('Tissue PO2 (a.u.)','FontWeight',P.Misc.weightFontStrong,...
                'FontSize',P.Misc.sizeFontStrong)
            if iMech == nMechs
                xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontStrong)
            end
            hPlot2(3) = plot(0,0,'-','LineWidth',P.Misc.widthLine,...
                'Color',testCol);
            plot(Vazquez2010{7}(:,1),...
                Vazquez2010{7}(:,2)./Vazquez2010{9}(1,7),...
                '-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            hPlot2(1) = plot(data(idx(1)).t,...
                data(idx(1)).PO2_ss(:,1)/data(idx(1)).PO2_ss(idxt0(1),1),...
                'k-','LineWidth',P.Misc.widthLine);
            hPlot2(2) = plot(data(idx(idxMech)).t,...
                data(idx(idxMech)).PO2_ss(:,1)/...
                data(idx(idxMech)).PO2_ss(idxt0(idxMech),1),...
                '-','LineWidth',P.Misc.widthLine,...
                'Color',mechCol(iMech,:));
            legend(hPlot2,'Model (CapPerm)',mechName,...
                'Vazquez (2010)','Location','NorthEast')
        hold off
    H_axes(numPlot+1) = subplot(rows,columns,numPlot+1);
        hold on
            axis([tspan 0.98 1.155])
            plotLabel(plotLetters{iMech,2})
            ylabel('Arterial PO2 (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            if iMech == nMechs
                xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontStrong)
            end
            hPlot3(3) = plot(0,0,'--','LineWidth',P.Misc.widthLine,'Color',testCol);
            hPlot3(4) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            hPlot3(5) = plot(0,0,'-.','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(Vazquez2010{1}(:,1),Vazquez2010{1}(:,2)./Vazquez2010{9}(1,1),'--','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(Vazquez2010{2}(:,1),Vazquez2010{2}(:,2)./Vazquez2010{9}(1,2),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(Vazquez2010{3}(:,1),Vazquez2010{3}(:,2)./Vazquez2010{9}(1,3),'-.','LineWidth',P.Misc.widthLine*2,'Color',colData)
            hPlot3(1) = plot(data(idx(1)).t,data(idx(1)).PO2(:,1)/data(idx(1)).PO2(idxt0(1),1),'k-','LineWidth',P.Misc.widthLine);
            hPlot3(2) = plot(data(idx(idxMech)).t,data(idx(idxMech)).PO2(:,1)/data(idx(idxMech)).PO2(idxt0(idxMech),1),'-','LineWidth',P.Misc.widthLine,'Color',mechCol(iMech,:));
            legend(hPlot3,'Model (CapPerm)',mechName,'Vazquez (2010) SmArt','Vazquez (2010) MedArt','Vazquez (2010) LgeArt')
        hold off
    H_axes(numPlot+2) = subplot(rows,columns,numPlot+2);
        hold on
            axis([tspan 0.97 1.29])
            plotLabel(plotLetters{iMech,3})
            ylabel('Venous PO2 (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            if iMech == nMechs
                xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontStrong)
            end
            hPlot4(3) = plot(0,0,'--','LineWidth',P.Misc.widthLine,'Color',testCol);
            hPlot4(4) = plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',testCol);
            hPlot4(5) = plot(0,0,'-.','LineWidth',P.Misc.widthLine,'Color',testCol);
            plot(Vazquez2010{4}(:,1),Vazquez2010{4}(:,2)./Vazquez2010{9}(1,4),'--','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(Vazquez2010{5}(:,1),Vazquez2010{5}(:,2)./Vazquez2010{9}(1,5),'-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(Vazquez2010{6}(:,1),Vazquez2010{6}(:,2)./Vazquez2010{9}(1,6),'-.','LineWidth',P.Misc.widthLine*2,'Color',colData)
            hPlot4(1) = plot(data(idx(1)).t,data(idx(1)).PO2(:,3)/data(idx(1)).PO2(idxt0(1),3),'k-','LineWidth',P.Misc.widthLine);
            hPlot4(2) = plot(data(idx(idxMech)).t,data(idx(idxMech)).PO2(:,3)/data(idx(idxMech)).PO2(idxt0(idxMech),3),'-','LineWidth',P.Misc.widthLine,'Color',mechCol(iMech,:));
            legend(hPlot4,'Model (CapPerm)',mechName,'Vazquez (2010) SmVen','Vazquez (2010) MedVen','Vazquez (2010) LgeVen')
        hold off
end

end
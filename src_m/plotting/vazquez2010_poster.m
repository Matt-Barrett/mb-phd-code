function [H_axes rows columns subaxis] = vazquez2010_poster(P,sim_list,...
                                                    data,constants,params)
                                                
req_sim = {'vazquez2010_cap','vazquez2010_all',...
            'vazquez2010_leak','vazquez2010_p50','vazquez2010'};
idx = find_data_indices(sim_list,req_sim);

tspan = [-5 65];
rows = 4;
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
[capPerm(1) capPerm(2) capPerm(3)] = rgbconv('4DAF4A');
[allPerm(1) allPerm(2) allPerm(3)] = rgbconv('377EB8');
[leak(1) leak(2) leak(3)] = rgbconv('984EA3');
[p50(1) p50(2) p50(3)] = rgbconv('E41A1C');
testCol = 0.81*ones(1,3);

idxMechList = 1:4;
mechCol = [capPerm; allPerm; leak; p50];
mechNameList = {'CapPerm','AllPerm','Leak','P50'};
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
%             plotLabel(plotLetters{iMech,1})
            ylabel(mechNameList{iMech},'FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontLabel,'Color',mechCol(iMech,:))
            if iMech == 1 
                title('Tissue PO2 (a.u.)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontLabel)
            elseif iMech == nMechs
                xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontStrong)
            end
            
            hPlot2(3) = plot(0,0,'-','LineWidth',P.Misc.widthLine,...
                'Color',testCol);
            plot(Vazquez2010{7}(:,1),...
                Vazquez2010{7}(:,2)./Vazquez2010{9}(1,7),...
                '-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            hPlot2(1) = plot(data(idx(5)).t,...
                data(idx(5)).PO2_ss(:,1)/data(idx(5)).PO2_ss(idxt0(5),1),...
                'k-','LineWidth',P.Misc.widthLine);
            hPlot2(2) = plot(data(idx(idxMech)).t,...
                data(idx(idxMech)).PO2_ss(:,1)/...
                data(idx(idxMech)).PO2_ss(idxt0(idxMech),1),...
                '-','LineWidth',P.Misc.widthLine,...
                'Color',mechCol(iMech,:));
            
            doSubaxis = (iMech == 1);
            if doSubaxis
                subaxis(1).handle = axes('NextPlot', 'add');
                subaxis(1).posn = get(H_axes(numPlot),'Position');
                subaxis(1).xlim = [tspan(1) 45];
                subaxis(1).ylim = [0.95 1.5];
                subaxis(1).subposn = [0.6 0.45 0.5 0.5];
                subaxis(1).adjposn =  subaxis(1).subposn.* ...
                    [subaxis(1).posn(3:4) subaxis(1).posn(3:4)]...
                    + [subaxis(1).posn(1:2) 0 0];
                hold on
                    plot(Vazquez2010{8}(:,1),Vazquez2010{8}(:,2),'-',...
                        'Color',colData,'LineWidth',P.Misc.widthLine*2)
                    plot(data(idx(5)).t,data(idx(5)).F(:,5),'k-',...
                        'LineWidth',P.Misc.widthLine);
                    text(3,1.05,'CBF (a.u.)','FontSize',P.Misc.sizeFontStrong)
                hold off
                set(subaxis(1).handle,'xlim',subaxis(1).xlim,...
                    'ylim',subaxis(1).ylim,...'YTick',1:0.01:1.03,...
                    'Units', 'normalized', 'Position',subaxis(1).adjposn)
            end
            
%             legend(hPlot2,'Model (CapPerm)',mechName,...
%                 'Vazquez (2010)','Location','NorthEast')
            
        hold off
        
        
    H_axes(numPlot+1) = subplot(rows,columns,numPlot+1);
        hold on
            axis([tspan 0.97 1.29])
%             plotLabel(plotLetters{iMech,2})
            if iMech == 1 
                title('Venous PO2 (a.u.)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontLabel)
            elseif iMech == nMechs
                xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontStrong)
            end
            
            hPlot4(3) = plot(0,0,'--','LineWidth',P.Misc.widthLine,...
                'Color',testCol);
            hPlot4(4) = plot(0,0,'-','LineWidth',P.Misc.widthLine,...
                'Color',testCol);
            hPlot4(5) = plot(0,0,'-.','LineWidth',P.Misc.widthLine,...
                'Color',testCol);
            
            % plot(Vazquez2010{4}(:,1),...
            %     Vazquez2010{4}(:,2)./Vazquez2010{9}(1,4),...
            %     '--','LineWidth',P.Misc.widthLine*2,'Color',colData)
            plot(Vazquez2010{5}(:,1),...
                Vazquez2010{5}(:,2)./Vazquez2010{9}(1,5),...
                '-','LineWidth',P.Misc.widthLine*2,'Color',colData)
            % plot(Vazquez2010{6}(:,1),...
            %     Vazquez2010{6}(:,2)./Vazquez2010{9}(1,6),...
            %     '-.','LineWidth',P.Misc.widthLine*2,'Color',colData)
            
            hPlot4(1) = plot(data(idx(5)).t,...
                data(idx(5)).PO2(:,3)/data(idx(5)).PO2(idxt0(5),3),...
                'k-','LineWidth',P.Misc.widthLine);
            hPlot4(2) = plot(data(idx(idxMech)).t,...
                data(idx(idxMech)).PO2(:,3)/...
                data(idx(idxMech)).PO2(idxt0(idxMech),3),...
                '-','LineWidth',P.Misc.widthLine,'Color',mechCol(iMech,:));
            
%             legend(hPlot4,'Model (Nomech)',mechName,...
%                 'Vazquez (2010) SmVen','Vazquez (2010) MedVen',...
%                 'Vazquez (2010) LgeVen')
            
        hold off
        
    H_axes(numPlot+2) = subplot(rows,columns,numPlot+2);
        hold on
            axis([tspan 0.97 1.13])
%             plotLabel(plotLetters{iMech,3})
            if iMech == 1 
                title('Oxygen Consumption (a.u.)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontLabel)
            elseif iMech == nMechs
                xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,...
                    'FontSize',P.Misc.sizeFontStrong)
            end
            
            hPlot3(2) = plot(data(idx(5)).t,...
                data(idx(5)).S(:,4)/data(idx(5)).S(idxt0(5),4),...
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
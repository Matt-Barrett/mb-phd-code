function [H_axes rows columns subaxis] = dilation_combined(P,sim_list,...
                                    data,constants,params,controls,isDown)

req_sim = {'flow_volume_loop','mandeville1999_6s','mandeville1999_30s',...
    '1_second','10_seconds','30_seconds'};
idx = find_data_indices(sim_list,req_sim);

rows= 3;
columns = 3;

labels = {'A','B','C','D','E','F','G','H','I'};
xLabel = -0.1; yLabel = 1;
plotLabel = @(iLabel) text(xLabel,yLabel,labels{iLabel},...
                'FontWeight',P.Misc.weightFontStrong,...
                'FontSize',P.Misc.sizeFontLabel,...
                'Units','normalized','VerticalAlignment','middle',...
                'HorizontalAlignment','right');

if isDown
    order = 1:9;
else
    order = [9 7 8 1 2 3 4 5 6];
end

% F-V Loop Stuff
tspan{1} = controls(idx(1)).tspan_dim;
[fit_data data(idx(1))] = extract_FV(constants(idx(1)),params(idx(1)),...
    controls(idx(1)),data(idx(1)));
[alpha_data junk fit_data] = fit_alpha(fit_data,data(idx(1))); clear junk

% Mandeville1999 Stuff
load mandeville1999;
tspan{2} = [-10 70];

% F-D Comp Stuff
load drew2010
tspan{3} = [-5 100]; % controls(idx(1)).tspan_dim;
doSubaxis = max(data(idx(3)).D(:,3)./data(idx(3)).D(1,3)) >= 1.01;
subaxis = [];

figure
    H_axes(1) = subplot(rows,columns,order(1));
        hold on
            axis([0.3 3.2 0.6 2.1])
            plotLabel(order(1))
            xlabel('Flow (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            ylabel('Volume (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(0,0,'ro','LineWidth',P.Misc.widthLine,'MarkerFaceColor','r')
            plot(0,0,'k+','LineWidth',P.Misc.widthLine,'MarkerFaceColor','k')
            plot(0,0,'cv','LineWidth',P.Misc.widthLine,'MarkerFaceColor','c')
            plot(fit_data.F_ss,fit_data.V_grubb(1,:),'r-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_grubb(5,:),'c-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_grubb(4,:),'k-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_ss(1,:)./data(idx(1)).V(1,1),'ro','LineWidth',P.Misc.widthLine,'MarkerFaceColor','r');
            plot(fit_data.F_ss,fit_data.V_ss(5,:)./data(idx(1)).V(1,5),'cv','LineWidth',P.Misc.widthLine,'MarkerFaceColor','c');
            plot(fit_data.F_ss,fit_data.V_ss(4,:)./data(idx(1)).V(1,4),'k+','LineWidth',P.Misc.widthLine,'MarkerFaceColor','k');
            if alpha_data(5) <= 0.001
                axis([0.3 3.2 0.4 3.5])
                alpha_data(5) = 0;
            end;
            legend(['Art. (\alpha = ' num2str(alpha_data(1),3) ')'],...
                ['Total (\alpha = ' num2str(alpha_data(4),3) ')'],...
                ['Cap. + Ven. (\alpha = ' num2str(alpha_data(5),3) ')'],...
                'Location','NorthWest')
        hold off
    H_axes(2) = subplot(rows,columns,order(2));
        hold on
            plotLabel(order(2))
            ylabel('Flow (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan{2} 0.85 1.7]);
            plot(0,0,'k-','LineWidth',P.Misc.widthLine);
            plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',P.Misc.greyLine);
            plot(mandeville1999.rCBF_6s(:,1),mandeville1999.rCBF_6s(:,2)+1,'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(mandeville1999.rCBF_30s(:,1),mandeville1999.rCBF_30s(:,2)+1,'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,(data(idx(2)).F(:,5)/data(idx(2)).F(1,5)),'k-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,(data(idx(3)).F(:,5)/data(idx(3)).F(1,5)),'k-','LineWidth',P.Misc.widthLine);
%             plot([0 6],[0.96 0.96],'k-','LineWidth',P.Misc.widthLineStim)
%             plot([0 30],[0.92 0.92],'k-','LineWidth',P.Misc.widthLineStim)
            legend('Model','Mandeville (1999)')
        hold off
    H_axes(3) = subplot(rows,columns,order(3));
        hold on
            plotLabel(order(3))
            ylabel('Volume (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan{2} 0.98 1.2]);
            plot(0,0,'k-','LineWidth',P.Misc.widthLine);
            plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',P.Misc.greyLine);
            plot(0,0,'ro-','LineWidth',P.Misc.widthLine,'MarkerFaceColor','r');
            plot(0,0,'ms-','LineWidth',P.Misc.widthLine,'MarkerFaceColor','m');
            plot(0,0,'b^-','LineWidth',P.Misc.widthLine,'MarkerFaceColor','b');
            plot(mandeville1999.rCBV_6s(:,1),mandeville1999.rCBV_6s(:,2)+1,'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(mandeville1999.rCBV_30s(:,1),mandeville1999.rCBV_30s(:,2)+1,'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            if max(data(idx(3)).V(:,3)./data(idx(3)).V(1,3)) >= 1.02
                plot(data(idx(3)).t(:),(1+(data(idx(3)).V(:,1)-data(idx(3)).V(1,1))./data(idx(3)).V(1,4)),'r-','LineWidth',P.Misc.widthLine);
                plot(data(idx(3)).t(:),(1+(data(idx(3)).V(:,2)-data(idx(3)).V(1,2))./data(idx(3)).V(1,4)),'m-','LineWidth',P.Misc.widthLine);
                plot(data(idx(3)).t(:),(1+(data(idx(3)).V(:,3)-data(idx(3)).V(1,3))./data(idx(3)).V(1,4)),'b-','LineWidth',P.Misc.widthLine);
                plot(data(idx(3)).t(100:100:end),(1+(data(idx(3)).V(100:100:end,1)-data(idx(3)).V(1,1))./data(idx(3)).V(1,4)),'ro','LineWidth',P.Misc.widthLine,'MarkerFaceColor','r');
                plot(data(idx(3)).t(150:150:end),(1+(data(idx(3)).V(150:150:end,2)-data(idx(3)).V(1,2))./data(idx(3)).V(1,4)),'ms','LineWidth',P.Misc.widthLine,'MarkerFaceColor','m');
                plot(data(idx(3)).t(75:150:end),(1+(data(idx(3)).V(75:150:end,3)-data(idx(3)).V(1,3))./data(idx(3)).V(1,4)),'b^','LineWidth',P.Misc.widthLine,'MarkerFaceColor','b');
                legend('Model Total','Mandeville (1999)','Art.','Cap.','Ven.')
            end
            plot(data(idx(2)).t,(data(idx(2)).V(:,4)./data(idx(2)).V(1,4)),'k-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,(data(idx(3)).V(:,4)./data(idx(3)).V(1,4)),'k-','LineWidth',P.Misc.widthLine);
        hold off
    H_axes(4) = subplot(rows,columns,order(4));
        hold on
            plotLabel(order(4))
            ylabel('Art. Diameter (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan{3} 0.962 1.25]);
            plot(0,0,'r-','LineWidth',P.Misc.widthLine);
            plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',P.Misc.greyLine);
            plot(drew2010.art_1s(:,1),drew2010.art_1s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(drew2010.art_10s(:,1),drew2010.art_10s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(drew2010.art_30s(:,1),drew2010.art_30s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(4)).t,data(idx(4)).D(:,1)./data(idx(4)).D(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(5)).t,data(idx(5)).D(:,1)./data(idx(5)).D(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(6)).t,data(idx(6)).D(:,1)./data(idx(6)).D(1,1),'r-','LineWidth',P.Misc.widthLine);
            legend('Model','Drew (2011)')
        hold off
    H_axes(5) = subplot(rows,columns,order(5));
        hold on
            plotLabel(order(5))
            ylabel('Cap. Diameter (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan{3} 0.962 1.25]);
            plot(data(idx(4)).t,data(idx(4)).D(:,2)./data(idx(4)).D(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(5)).t,data(idx(5)).D(:,2)./data(idx(5)).D(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(6)).t,data(idx(6)).D(:,2)./data(idx(6)).D(1,2),'m-','LineWidth',P.Misc.widthLine);
        hold off
        % subaxis
        if doSubaxis
            subaxis(1).handle = axes('NextPlot', 'add');
            subaxis(1).posn = get(H_axes(5),'Position');
            subaxis(1).xlim = [0 40];
            subaxis(1).ylim = [.998 1.0375];
            subaxis(1).subposn = [0.35 0.49 0.6 0.5];
            subaxis(1).adjposn =  subaxis(1).subposn.* ...
                [subaxis(1).posn(3:4) subaxis(1).posn(3:4)]...
                + [subaxis(1).posn(1:2) 0 0];
            hold on
                plot(data(idx(4)).t,data(idx(4)).D(:,2)./data(idx(4)).D(1,2),'m-','LineWidth',P.Subaxes.LineWidth);
                plot(data(idx(5)).t,data(idx(5)).D(:,2)./data(idx(5)).D(1,2),'m-','LineWidth',P.Subaxes.LineWidth);
                plot(data(idx(6)).t,data(idx(6)).D(:,2)./data(idx(6)).D(1,2),'m-','LineWidth',P.Subaxes.LineWidth);
            hold off
            set(subaxis(1).handle,'xlim',subaxis(1).xlim,...
                'ylim',subaxis(1).ylim,'YTick',1:0.01:1.03,...
                'Units', 'normalized', 'Position',subaxis(1).adjposn)
        end
    H_axes(6) = subplot(rows,columns,order(6));
        if doSubaxis
%             location = 'SouthEast';
%             location = [left bottom width height];
%             location = [0.7766 0.435 0.1250 0.05922];
            location = [0.81 0.45 0.1250 0.05922];
            setLegend = @(hLeg) set(hLeg,'Position',location);
        else
            setLegend = @(hLeg) set(hLeg,'Location','NorthEast');
        end
        hold on
            plotLabel(order(6))
            ylabel('Ven. Diameter (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan{3} 0.962 1.25]);
            plot(0,0,'b-','LineWidth',P.Misc.widthLine);
            plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',P.Misc.greyLine);
            plot(drew2010.vei_1s(:,1),drew2010.vei_1s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(drew2010.vei_10s(:,1),drew2010.vei_10s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(drew2010.vei_30s(:,1),drew2010.vei_30s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(4)).t,data(idx(4)).D(:,3)./data(idx(4)).D(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(5)).t,data(idx(5)).D(:,3)./data(idx(5)).D(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(6)).t,data(idx(6)).D(:,3)./data(idx(6)).D(1,3),'b-','LineWidth',P.Misc.widthLine);
            hLegend = legend('Model','Drew (2011)','Location','East');
        hold off
        % subaxis
        if doSubaxis
            subaxis(2).handle = axes('NextPlot', 'add');
            subaxis(2).posn = get(H_axes(6),'Position');
            subaxis(2).xlim = [0 40];
            subaxis(2).ylim = [.998 1.075];
            subaxis(2).subposn = [0.35 0.49 0.6 0.5];
            subaxis(2).adjposn =  subaxis(2).subposn.* ...
                [subaxis(2).posn(3:4) subaxis(2).posn(3:4)]...
                + [subaxis(2).posn(1:2) 0 0];
            hold on
                plot(drew2010.vei_1s(:,1),drew2010.vei_1s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
                plot(drew2010.vei_10s(:,1),drew2010.vei_10s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
                plot(drew2010.vei_30s(:,1),drew2010.vei_30s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
                plot(data(idx(4)).t,data(idx(4)).D(:,3)./data(idx(4)).D(1,3),'b-','LineWidth',P.Subaxes.LineWidth);
                plot(data(idx(5)).t,data(idx(5)).D(:,3)./data(idx(5)).D(1,3),'b-','LineWidth',P.Subaxes.LineWidth);
                plot(data(idx(6)).t,data(idx(6)).D(:,3)./data(idx(6)).D(1,3),'b-','LineWidth',P.Subaxes.LineWidth);
            hold off
            set(subaxis(2).handle,'xlim',subaxis(2).xlim,...
                'ylim',subaxis(2).ylim,'YTick',1:0.02:1.06,...
                'Units', 'normalized', 'Position',subaxis(2).adjposn)
        end
        setLegend(hLegend);
    H_axes(7) = subplot(rows,columns,order(7));
        hold on
            plotLabel(order(7))
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            ylabel('Art. Velocity (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            axis([tspan{3} 0.9 1.68]);
            plot(data(idx(4)).t,data(idx(4)).U(:,1)./data(idx(4)).U(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(5)).t,data(idx(5)).U(:,1)./data(idx(5)).U(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(6)).t,data(idx(6)).U(:,1)./data(idx(6)).U(1,1),'r-','LineWidth',P.Misc.widthLine);
        hold off
    H_axes(8) = subplot(rows,columns,order(8));
        hold on
            plotLabel(order(8))
            axis([tspan{3} 0.9 1.68]);
            ylabel('Cap. Velocity (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(0,0,'m-','LineWidth',P.Misc.widthLine);
            plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',P.Misc.greyLine);
            plot(drew2010.cap_1s(:,1),drew2010.cap_1s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(drew2010.cap_30s(:,1),drew2010.cap_30s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(4)).t,data(idx(4)).U(:,2)./data(idx(4)).U(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(5)).t,data(idx(5)).U(:,2)./data(idx(5)).U(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(6)).t,data(idx(6)).U(:,2)./data(idx(6)).U(1,2),'m-','LineWidth',P.Misc.widthLine);
            legend('Model','Drew (2011)')
        hold off
    H_axes(9) = subplot(rows,columns,order(9));
        hold on
            plotLabel(order(9))
            axis([tspan{3} 0.9 1.68]);
            ylabel('Ven. Velocity (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(data(idx(4)).t,data(idx(4)).U(:,3)./data(idx(4)).U(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(5)).t,data(idx(5)).U(:,3)./data(idx(5)).U(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(6)).t,data(idx(6)).U(:,3)./data(idx(6)).U(1,3),'b-','LineWidth',P.Misc.widthLine);
        hold off

end
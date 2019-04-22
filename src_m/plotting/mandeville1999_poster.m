function [H_axes rows columns] = mandeville1999_poster(P,sim_list,data)

req_sim = {'mandeville1999_6s','mandeville1999_30s'};
idx = find_data_indices(sim_list,req_sim);

tspan = [-10 70];
rows= 1;
columns = 2;

load mandeville1999;

figure
    H_axes(1) = subplot(rows,columns,1);
        hold on
%             title('Bulk Transient','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            ylabel('Flow (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            if columns == 2
                xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            end
%                     xlabel('Time (s)')
            axis([tspan 0.9 1.7]);
            plot(0,0,'k-','LineWidth',P.Misc.widthLine);
            plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',P.Misc.greyLine);
            plot(mandeville1999.rCBF_6s(:,1),mandeville1999.rCBF_6s(:,2)+1,'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(mandeville1999.rCBF_30s(:,1),mandeville1999.rCBF_30s(:,2)+1,'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,(data(idx(1)).F(:,5)),'k-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,(data(idx(2)).F(:,5)),'k-','LineWidth',P.Misc.widthLine);
            legend('Model','Mandeville (1999)')
        hold off
    H_axes(2) = subplot(rows,columns,2);
        hold on
            ylabel('Volume (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 0.98 1.2]);
            plot(0,0,'k-','LineWidth',P.Misc.widthLine);
            plot(0,0,'-','LineWidth',P.Misc.widthLine,'Color',P.Misc.greyLine);
            plot(0,0,'ro-','LineWidth',P.Misc.widthLine,'MarkerFaceColor','r');
            plot(0,0,'ms-','LineWidth',P.Misc.widthLine,'MarkerFaceColor','m');
            plot(0,0,'b^-','LineWidth',P.Misc.widthLine,'MarkerFaceColor','b');
            plot(mandeville1999.rCBV_6s(:,1),mandeville1999.rCBV_6s(:,2)+1,'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(mandeville1999.rCBV_30s(:,1),mandeville1999.rCBV_30s(:,2)+1,'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            if max(data(idx(2)).V(:,3)./data(idx(2)).V(1,3)) >= 1.02
                plot(data(idx(2)).t(:),(1+(data(idx(2)).V(:,1)-data(idx(2)).V(1,1))./data(idx(2)).V(1,4)),'r-','LineWidth',P.Misc.widthLine);
                plot(data(idx(2)).t(:),(1+(data(idx(2)).V(:,2)-data(idx(2)).V(1,2))./data(idx(2)).V(1,4)),'m-','LineWidth',P.Misc.widthLine);
                plot(data(idx(2)).t(:),(1+(data(idx(2)).V(:,3)-data(idx(2)).V(1,3))./data(idx(2)).V(1,4)),'b-','LineWidth',P.Misc.widthLine);
                plot(data(idx(2)).t(100:100:end),(1+(data(idx(2)).V(100:100:end,1)-data(idx(2)).V(1,1))./data(idx(2)).V(1,4)),'ro','LineWidth',P.Misc.widthLine,'MarkerFaceColor','r');
                plot(data(idx(2)).t(150:150:end),(1+(data(idx(2)).V(150:150:end,2)-data(idx(2)).V(1,2))./data(idx(2)).V(1,4)),'ms','LineWidth',P.Misc.widthLine,'MarkerFaceColor','m');
                plot(data(idx(2)).t(75:150:end),(1+(data(idx(2)).V(75:150:end,3)-data(idx(2)).V(1,3))./data(idx(2)).V(1,4)),'b^','LineWidth',P.Misc.widthLine,'MarkerFaceColor','b');
                legend('Model Total','Mandeville (1999)','Art.','Cap.','Ven.')
            end
            plot(data(idx(1)).t,data(idx(1)).V(:,4)./data(idx(1)).V(1,4),'k-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).V(:,4)./data(idx(2)).V(1,4),'k-','LineWidth',P.Misc.widthLine);
        hold off
        
end
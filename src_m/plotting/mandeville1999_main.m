function [H_axes rows columns] = mandeville1999_main(P,sim_list,data)

req_sim = {'mandeville1999_6s','mandeville1999_30s'};
idx = find_data_indices(sim_list,req_sim);

tspan = [-10 70];
rows= 3;
columns = 1;

load mandeville1999;

stim(:,:,1) =   [0 6 30;
                 0 6 30];
stim(:,:,2) =   [0 0 0;
                 2 2 2];

figure
    H_axes(1) = subplot(rows,columns,1);
        hold on
            ylabel('Stimulus','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
%                     xlabel('Time (s)')
            axis([tspan 0 6]);
            plot(data(idx(1)).t,data(idx(1)).S(:,1),'--','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine);
            plot(data(idx(1)).t,data(idx(1)).S(:,1),'k-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).S(:,1),'k-','LineWidth',P.Misc.widthLine);
%                     line(stim(:,:,1),stim(:,:,2),'LineStyle','--','LineWidth',P.Misc.widthLine,'Color','k')
            legend('Mandeville 1999 ','Model')
        hold off
    H_axes(2) = subplot(rows,columns,2);
        hold on
            ylabel('Flow','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
%                     xlabel('Time (s)')
            axis([tspan 0.9 1.7]);
            plot(mandeville1999.rCBF_6s(:,1),mandeville1999.rCBF_6s(:,2)+1,'--','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,(data(idx(1)).F(:,5)),'k-','LineWidth',P.Misc.widthLine);
            plot(mandeville1999.rCBF_30s(:,1),mandeville1999.rCBF_30s(:,2)+1,'--','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,(data(idx(2)).F(:,5)),'k-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999','Model')
        hold off
    H_axes(3) = subplot(rows,columns,3);
        hold on
            ylabel('Volume','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 0.98 1.2]);
            plot(mandeville1999.rCBV_6s(:,1),mandeville1999.rCBV_6s(:,2)+1,'--','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,(data(idx(1)).V(:,4)),'k-','LineWidth',P.Misc.widthLine);
            plot(mandeville1999.rCBV_30s(:,1),mandeville1999.rCBV_30s(:,2)+1,'--','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,(data(idx(2)).V(:,4)),'k-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,(1+data(idx(2)).V(:,1)-data(idx(2)).V(1,1)),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,(1+data(idx(2)).V(:,2)-data(idx(2)).V(1,2)),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,(1+data(idx(2)).V(:,3)-data(idx(2)).V(1,3)),'b-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999','Model')
        hold off

end
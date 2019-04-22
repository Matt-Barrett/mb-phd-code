function [H_axes rows columns] = yaseen2011_main(P,sim_list,data,...
                                                    constants,params)
                                                
req_sim = {'yaseen2011'};
idx = find_data_indices(sim_list,req_sim);

tspan = [0 11];
rows= 2;
columns = 2;

load yaseen2011

[t0 idxt0] = min(abs(data(idx).t));

H_fig = figure;
    H_axes(1) = subplot(rows,columns,1);
        hold on
            axis([tspan 0.98 1.11])
            ylabel('Flow','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(yaseen2011(1).cbf(:,1),1+yaseen2011(1).cbf(:,2)./100,'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx).t,data(idx).F(:,5),'k-','LineWidth',P.Misc.widthLine);
            legend('Yaseen 2011','Model','Location','NorthEast');
            grid('on');
            box('on');
        hold off
    H_axes(2) = subplot(rows,columns,2);
%         hold on
% %             axis([tspan 0.97 1.295])
%             axis([tspan 0.97 1.35])
%             ylabel('Tissue P_{O2}','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
%             plot(Vazquez2010{7}(:,1),Vazquez2010{7}(:,2)./Vazquez2010{9}(1,7),'-','LineWidth',P.Misc.widthLine,'Color',P.Misc.greyLine)
%             plot(data(idx).t,data(idx).PO2(:,4)/data(idx).PO2(idxt0,4),'g--','LineWidth',P.Misc.widthLine)
%             plot(data(idx).t,ptn/ptn(idxt0),'g-','LineWidth',P.Misc.widthLine)
%             legend('Vazquez 2010 (38mmHg)',...
%                 ['Model (' num2str(constants(idx).reference.PO2_ref*data(idx).PO2(idxt0,4),3) 'mmHg)'],...
%                 sprintf('Model (%3.1fmmHg)',constants(idx).reference.PO2_ref.*ptn_ss),'Location','NorthEast')
%         hold off
    H_axes(3) = subplot(rows,columns,3);
        hold on
            ylabel('Arterial P_{O2}','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 0.99 1.065])
            plot(yaseen2011(1).po2(:,1),1+yaseen2011(1).po2(:,2)./100,'-','LineWidth',P.Misc.widthLine,'Color',P.Misc.greyLine)
            plot(data(idx).t,data(idx).PO2(:,1)/data(idx).PO2(idxt0,1),'r-','LineWidth',P.Misc.widthLine)
            legend('Yaseen 2011',['Model (' num2str(constants(idx).reference.PO2_ref*data(idx).PO2(idxt0,1),3) 'mmHg)'])
        hold off
    H_axes(4) = subplot(rows,columns,4);
        hold on
            ylabel('Venous P_{O2}','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 0.97 1.20])
            plot(yaseen2011(2).po2(:,1),1+yaseen2011(2).po2(:,2)./100,'--','LineWidth',P.Misc.widthLine,'Color',P.Misc.greyLine)
            plot(data(idx).t,data(idx).PO2(:,3)/data(idx).PO2(idxt0,3),'b','LineWidth',P.Misc.widthLine)
            legend('Yaseen 2011',['Model (' num2str(constants(idx).reference.PO2_ref*data(idx).PO2(idxt0,3),3) 'mmHg)'])
        hold off
       
end
function [H_axes rows columns] = flow_diameter_comp(P,sim_list,data)

req_sim = {'1_second','10_seconds','30_seconds'};
idx = find_data_indices(sim_list,req_sim);

tspan = controls(idx(1)).tspan_dim;
rows= 4;
columns = 3;

load drew2010

figure
    H_axes(1) = subplot(rows,columns,1);
        hold on
            ylabel('Diameter','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
%                     xlabel('Time (s)')
            axis([tspan 0.98 1.3]);
            plot(drew2010.art_1s(:,1),drew2010.art_1s(:,2),'k--','LineWidth',P.Misc.widthLine)
            plot(drew2010.art_10s(:,1),drew2010.art_10s(:,2),'k--','LineWidth',P.Misc.widthLine)
            plot(drew2010.art_30s(:,1),drew2010.art_30s(:,2),'k--','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).D(:,1)./data(idx(1)).D(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).D(:,1)./data(idx(2)).D(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).D(:,1)./data(idx(3)).D(1,1),'r-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999 ','Model')
        hold off
    H_axes(2) = subplot(rows,columns,2);
        hold on
            title(['kappa = ' num2str(controls(idx(1)).volume_dep.*...
                params(idx(1)).compliance.kappa) ' & nu = ' ...
                num2str(controls(idx(1)).visco.*...
                params(idx(1)).compliance.nu)],...
                'FontWeight',P.Misc.weightFontStrong,...
                'FontSize',P.Misc.sizeFontStrong)
%                     ylabel('Flow','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
%                     xlabel('Time (s)')
            axis([tspan 0.98 1.3]);
            plot(data(idx(1)).t,data(idx(1)).D(:,2)./data(idx(1)).D(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).D(:,2)./data(idx(2)).D(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).D(:,2)./data(idx(3)).D(1,2),'m-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999','Model')
        hold off
    H_axes(3) = subplot(rows,columns,3);
        hold on
%                     ylabel('Volume','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
%                     xlabel('Time','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 0.98 1.3]);
            plot(drew2010.vei_10s(:,1),drew2010.vei_10s(:,2),'k--','LineWidth',P.Misc.widthLine)
            plot(drew2010.vei_30s(:,1),drew2010.vei_30s(:,2),'k--','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).D(:,3)./data(idx(1)).D(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).D(:,3)./data(idx(2)).D(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).D(:,3)./data(idx(3)).D(1,3),'b-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999','Model')
        hold off
    H_axes(4) = subplot(rows,columns,4);
        hold on
            ylabel('Volume','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
%                     xlabel('Time (s)')
            axis([tspan 0.95 1.4]);
            plot(data(idx(1)).t,data(idx(1)).V(:,1)./data(idx(1)).V(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).V(:,1)./data(idx(2)).V(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).V(:,1)./data(idx(3)).V(1,1),'r-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999 ','Model')
        hold off
    H_axes(5) = subplot(rows,columns,5);
        hold on
%                     ylabel('Flow','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
%                     xlabel('Time (s)')
            axis([tspan 0.95 1.4]);
            plot(data(idx(1)).t,data(idx(1)).V(:,2)./data(idx(1)).V(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).V(:,2)./data(idx(2)).V(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).V(:,2)./data(idx(3)).V(1,2),'m-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999','Model')
        hold off
    H_axes(6) = subplot(rows,columns,6);
        hold on
%                     ylabel('Volume','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
%                     xlabel('Time','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 0.95 1.4]);
            plot(data(idx(1)).t,data(idx(1)).V(:,3)./data(idx(1)).V(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).V(:,3)./data(idx(2)).V(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).V(:,3)./data(idx(3)).V(1,3),'b-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999','Model')
        hold off
    H_axes(7) = subplot(rows,columns,7);
        hold on
            ylabel('Velocity','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
%                     xlabel('Time (s)')
            axis([tspan 0.9 1.6]);
            plot(data(idx(1)).t,data(idx(1)).u(:,1)./data(idx(1)).u(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).u(:,1)./data(idx(2)).u(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).u(:,1)./data(idx(3)).u(1,1),'r-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999 ','Model')
    H_axes(8) = subplot(rows,columns,8);
        hold on
%                     xlabel('Time (s)')
            axis([tspan 0.9 1.6]);
            plot(data(idx(1)).t,data(idx(1)).u(:,2)./data(idx(1)).u(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).u(:,2)./data(idx(2)).u(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).u(:,2)./data(idx(3)).u(1,2),'m-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999 ','Model')
    H_axes(9) = subplot(rows,columns,9);
        hold on
%                     xlabel('Time (s)')
            axis([tspan 0.9 1.6]);
            plot(data(idx(1)).t,data(idx(1)).u(:,3)./data(idx(1)).u(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).u(:,3)./data(idx(2)).u(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).u(:,3)./data(idx(3)).u(1,3),'b-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999 ','Model')
    H_axes(10) = subplot(rows,columns,10);
        hold on
            ylabel('Transit Time','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
%                     xlabel('Time (s)')
            axis([tspan 0.6 1.1]);
            plot(data(idx(1)).t,data(idx(1)).t_t(:,1)./data(idx(1)).t_t(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).t_t(:,1)./data(idx(2)).t_t(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).t_t(:,1)./data(idx(3)).t_t(1,1),'r-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999 ','Model')
    H_axes(11) = subplot(rows,columns,11);
        hold on
%                     xlabel('Time (s)')
            axis([tspan 0.6 1.1]);
            plot(data(idx(1)).t,data(idx(1)).t_t(:,2)./data(idx(1)).t_t(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).t_t(:,2)./data(idx(2)).t_t(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).t_t(:,2)./data(idx(3)).t_t(1,2),'m-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999 ','Model')
    H_axes(11) = subplot(rows,columns,12);
        hold on
%                     xlabel('Time (s)')
            axis([tspan 0.6 1.1]);
            plot(data(idx(1)).t,data(idx(1)).t_t(:,3)./data(idx(1)).t_t(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).t_t(:,3)./data(idx(2)).t_t(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).t_t(:,3)./data(idx(3)).t_t(1,3),'b-','LineWidth',P.Misc.widthLine);
%                     legend('Mandeville 1999 ','Model')

end
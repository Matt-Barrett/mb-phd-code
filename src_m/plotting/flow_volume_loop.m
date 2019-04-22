function [H_axes rows columns] = flow_volume_loop(P,sim_list,data,...
                                                constants,params,controls)

req_sim = {'flow_volume_loop'};
idx = find_data_indices(sim_list,req_sim);

tspan = controls(idx).tspan_dim;
rows = 2;
columns = 2;

% extract flow volume
[fit_data data] = extract_FV(constants(idx),params(idx),controls(idx),data(idx));

% Find alpha value
[alpha_data junk fit_data] = fit_alpha(fit_data,data); clear junk

figure
    H_axes(1) = subplot(rows,columns,3);
        hold on
            ylabel('Flow','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
%                     xlabel('Time (s)')
%                     axis([tspan 0.9 1.7]);
            plot(data(idx(1)).t,(data(idx(1)).F(:,5)),'k-','LineWidth',P.Misc.widthLine);
            plot(fit_data.time,fit_data.F_ss,'k+')
%                     legend('Mandeville 1999','Model')
        hold off
    H_axes(2) = subplot(rows,columns,4);
        hold on
            ylabel('Volume','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            xlabel('Time','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
%                     axis([tspan 0.98 1.2]);
            plot(data(idx(1)).t,(data(idx(1)).V(:,4)),'k-','LineWidth',P.Misc.widthLine);
            plot(data(idx(1)).t,(data(idx(1)).V(:,1)),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(1)).t,(data(idx(1)).V(:,2)),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(1)).t,(data(idx(1)).V(:,3)),'b-','LineWidth',P.Misc.widthLine);
            plot(fit_data.time,fit_data.V_ss(4,:),'k+')
%                     legend('Mandeville 1999','Model')
        hold off
    H_axes(3) = subplot(rows,columns,1:2);
        hold on
            title(['Kappa = ' num2str(params(idx).compliance.kappa) ' alpha = ' num2str(alpha_data,3)],'FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            xlabel('Flow','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            ylabel('Volume','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
%                     axis([tspan 0.98 1.2]);
            plot(fit_data.F_ss,fit_data.V_grubb(1,:),'r-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_grubb(2,:),'m-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_grubb(3,:),'b-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_grubb(5,:),'g-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_grubb(4,:),'k-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_ss(1,:)./data(idx(1)).V(1,1),'r+','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_ss(2,:)./data(idx(1)).V(1,2),'m+','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_ss(3,:)./data(idx(1)).V(1,3),'b+','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_ss(5,:)./data(idx(1)).V(1,5),'g+','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_ss(4,:),'k+','LineWidth',P.Misc.widthLine);
            legend('Art','Cap','Vei','Cap+Vei','Total','Location','NorthWest')
        hold off

end
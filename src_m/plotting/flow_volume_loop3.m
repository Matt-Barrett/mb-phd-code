function [H_axes rows columns] = flow_volume_loop3(P,sim_list,data,...
                                            constants,params,controls)

req_sim = {'flow_volume_loop'};
idx = find_data_indices(sim_list,req_sim);

rows = 1;
columns = 1;
fig_ratio = 1.45; % height/width

% extract flow volume
[fit_data data] = extract_FV(constants(idx),params(idx),...
    controls(idx),data(idx));

% Find alpha value
[alpha_data junk fit_data] = fit_alpha(fit_data,data); clear junk

figure
    H_axes(1) = subplot(rows,columns,1);
        hold on
            axis([0.3 3.2 0.6 2.1])
            xlabel('Flow (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            ylabel('Volume (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(0,0,'ro','LineWidth',P.Misc.widthLine,'MarkerFaceColor','r')
            plot(0,0,'ks','LineWidth',P.Misc.widthLine,'MarkerFaceColor','k')
            plot(0,0,'c^','LineWidth',P.Misc.widthLine,'MarkerFaceColor','c')
            plot(fit_data.F_ss,fit_data.V_grubb(1,:),'r-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_grubb(5,:),'c-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_grubb(4,:),'k-','LineWidth',P.Misc.widthLine);
            plot(fit_data.F_ss,fit_data.V_ss(1,:)./data(idx(1)).V(1,1),'ro','LineWidth',P.Misc.widthLine,'MarkerFaceColor','r');
            plot(fit_data.F_ss,fit_data.V_ss(5,:)./data(idx(1)).V(1,5),'c^','LineWidth',P.Misc.widthLine,'MarkerFaceColor','c');
            plot(fit_data.F_ss,fit_data.V_ss(4,:)./data(idx(1)).V(1,4),'ks','LineWidth',P.Misc.widthLine,'MarkerFaceColor','k');
            if alpha_data(5) <= 0.001
                axis([0.3 3.2 0.4 3.5])
                alpha_data(5) = 0;
            end;
            legend(['Art. (\alpha = ' num2str(alpha_data(1),3) ')'],...
                ['Total (\alpha = ' num2str(alpha_data(4),3) ')'],...
                ['Cap. + Ven. (\alpha = ' num2str(alpha_data(5),3) ')'],...
                'Location','NorthWest')
        hold off
                
end
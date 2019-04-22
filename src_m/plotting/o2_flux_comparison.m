function [H_axes rows columns] = o2_flux_comparison(P,sim_list,data,...
                                                    constants,params)

req_sim = {'vazquez2010'};
idx = find_data_indices(sim_list,req_sim);

tspan = [-5 65];
rows= 1;
columns = 2;

[t0 idxt0] = min(abs(data.t));

H_fig = figure;
    H_axes(1) = subplot(rows,columns,1);
        hold on
            axis([tspan 0 0.3])
            ylabel('Flux (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(data(idx).t,data(idx).JO2(:,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx).t,data(idx).JO2(:,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx).t,data(idx).JO2(:,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx).t,data(idx).JO2(:,5),'k-','LineWidth',P.Misc.widthLine);
            plot(data(idx).t,data(idx).S(:,4),'g-','LineWidth',P.Misc.widthLine);
        hold off
    H_axes(2) = subplot(rows,columns,2);
        hold on
            axis([tspan 0.9 1.08])
            ylabel('Normalised Flux (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(data(idx).t,data(idx).JO2(:,1)./data(idx).JO2(idxt0,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx).t,data(idx).JO2(:,2)./data(idx).JO2(idxt0,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx).t,data(idx).JO2(:,3)./data(idx).JO2(idxt0,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx).t,data(idx).JO2(:,5)./data(idx).JO2(idxt0,5),'k-','LineWidth',P.Misc.widthLine);
        hold off

end
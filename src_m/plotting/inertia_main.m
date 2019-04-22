function [H_axes rows columns] = inertia_main(P,sim_list,data)

req_sim = {'inertia_base'};
idx = find_data_indices(sim_list,req_sim);

tspan = [0.1 200];
[n_sims columns] = size(data);

rows= 2;

colours = {'b' 'g' 'r' 'c' 'm' 'y' 'k'};

H_fig = figure;
    for i = 1:columns
        H_axes(i) = subplot(rows,columns,i);
            set(H_axes(i),'XScale','log','FontSize',P_axes.FontSize)

            hold on
            for j = 1:n_sims-1
                plot(data(j,i).t,data(j,i).F_diff(:,5),colours{j},'LineWidth',P.Misc.widthLine);
            end;
            axis([0.1 200 -0.15 0.3]);
            hold off
        H_axes(i+columns) = subplot(rows,columns,i+columns);
            set(H_axes(i+columns),'XScale','log','FontSize',P_axes.FontSize)
            hold on
            for j = 1:n_sims-1
                plot(data(j,i).t,data(j,i).V_diff(:,4),colours{j},'LineWidth',P.Misc.widthLine);
            end;
            axis([0.1 200 -0.03 0.06]);
            hold off

    end;

        axes(H_axes(1));
            ylabel('Flow Difference (%)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            title('1 Second','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            legend('0','0.01','0.1','10','100')
        axes(H_axes(2));
            title('10 Seconds','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(3));
            title('100 Seconds','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(4));
            ylabel('Volume Difference (%)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(5));
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(6));
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)

end
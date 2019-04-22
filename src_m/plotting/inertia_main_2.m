function [H_axes rows columns] = inertia_main_2(P,sim_list,data)

req_sim = {'inertia_base'};
idx = find_data_indices(sim_list,req_sim);

tspan = [0.1 200];
[columns n_sims] = size(data);

columns = 5;
rows= 2;

colours = {'b' 'g' 'r' 'c' 'm' 'y' 'k'};

H_fig = figure;
    for i = 1:columns
        H_axes(i) = subplot(rows,columns,i);
            set(H_axes(i),'XScale','log','FontSize',P_axes.FontSize)
            hold on
            for j = 1:n_sims
                plot(data(i,j).t,data(i,j).F_diff(:,5),colours{j},'LineWidth',P.Misc.widthLine);
            end;
            axis([0.1 200 -0.1 0.3]);
            hold off
        H_axes(i+columns) = subplot(rows,columns,i+columns);
            set(H_axes(i+columns),'XScale','log','FontSize',P_axes.FontSize)
            hold on
            for j = 1:n_sims
                plot(data(i,j).t,data(i,j).V_diff(:,4),colours{j},'LineWidth',P.Misc.widthLine);
            end;
            axis([0.1 200 -0.03 0.05]);
            hold off

    end;

        axes(H_axes(1));
            ylabel('Flow Difference (%)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            title('0','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            legend('1 second','10 seconds','100 seconds','Location','Best')
        axes(H_axes(2));
            title('0.01','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(3));
            title('0.1','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(4));
            title('10','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(5));
            title('100','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(6));
            ylabel('Volume Difference (%)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(7));
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(8));
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(9));
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
        axes(H_axes(10));
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)

end
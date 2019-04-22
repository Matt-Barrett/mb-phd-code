function [H_axes rows columns subaxis] = ...
                    flow_diameter_comp3(P,sim_list,data)

req_sim = {'1_second','10_seconds','30_seconds'};
idx = find_data_indices(sim_list,req_sim);

tspan = [-5 100]; % controls(idx(1)).tspan_dim;
rows= 2;
columns = 3;

load drew2010

doSubaxis = max(data(idx(3)).D(:,3)./data(idx(3)).D(1,3)) >= 1.01;
subaxis = [];

figure
    H_axes(1) = subplot(rows,columns,1);
        hold on
            title('Arterioles','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            ylabel('Diameter (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            axis([tspan 0.98 1.25]);
            plot(data(idx(1)).t,data(idx(1)).D(:,1)./data(idx(1)).D(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(drew2010.art_1s(:,1),drew2010.art_1s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(drew2010.art_10s(:,1),drew2010.art_10s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(drew2010.art_30s(:,1),drew2010.art_30s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).D(:,1)./data(idx(1)).D(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).D(:,1)./data(idx(2)).D(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).D(:,1)./data(idx(3)).D(1,1),'r-','LineWidth',P.Misc.widthLine);
            legend('Model','Drew (2011)')
        hold off
    H_axes(2) = subplot(rows,columns,2);
        hold on
            title('Capillaries','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 0.98 1.25]);
            plot(data(idx(1)).t,data(idx(1)).D(:,2)./data(idx(1)).D(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).D(:,2)./data(idx(2)).D(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).D(:,2)./data(idx(3)).D(1,2),'m-','LineWidth',P.Misc.widthLine);
        hold off
        % subaxis
        if doSubaxis
            subaxis(1).handle = axes('NextPlot', 'add');
            subaxis(1).posn = get(H_axes(2),'Position');
            subaxis(1).xlim = [0 40];
            subaxis(1).ylim = [.998 1.0375];
            subaxis(1).subposn = [0.35 0.45 0.6 0.5];
            subaxis(1).adjposn =  subaxis(1).subposn.* ...
                [subaxis(1).posn(3:4) subaxis(1).posn(3:4)]...
                + [subaxis(1).posn(1:2) 0 0];
            hold on
                plot(data(idx(1)).t,data(idx(1)).D(:,2)./data(idx(1)).D(1,2),'m-','LineWidth',P.Subaxes.LineWidth);
                plot(data(idx(2)).t,data(idx(2)).D(:,2)./data(idx(2)).D(1,2),'m-','LineWidth',P.Subaxes.LineWidth);
                plot(data(idx(3)).t,data(idx(3)).D(:,2)./data(idx(3)).D(1,2),'m-','LineWidth',P.Subaxes.LineWidth);
            hold off
            set(subaxis(1).handle,'xlim',subaxis(1).xlim,...
                'ylim',subaxis(1).ylim,'YTick',[1:0.01:1.03],...
                'Units', 'normalized', 'Position',subaxis(1).adjposn)
        end
    H_axes(3) = subplot(rows,columns,3);
        hold on
            title('Venules','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 0.98 1.25]);
            plot(data(idx(1)).t,data(idx(1)).D(:,3)./data(idx(1)).D(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(drew2010.vei_1s(:,1),drew2010.vei_1s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(drew2010.vei_10s(:,1),drew2010.vei_10s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(drew2010.vei_30s(:,1),drew2010.vei_30s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).D(:,3)./data(idx(1)).D(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).D(:,3)./data(idx(2)).D(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).D(:,3)./data(idx(3)).D(1,3),'b-','LineWidth',P.Misc.widthLine);
        hold off
        % subaxis
        if doSubaxis
            subaxis(2).handle = axes('NextPlot', 'add');
            subaxis(2).posn = get(H_axes(3),'Position');
            subaxis(2).xlim = [0 40];
            subaxis(2).ylim = [.998 1.065];
            subaxis(2).subposn = [0.35 0.45 0.6 0.5];
            subaxis(2).adjposn =  subaxis(2).subposn.* ...
                [subaxis(2).posn(3:4) subaxis(2).posn(3:4)]...
                + [subaxis(2).posn(1:2) 0 0];
            hold on
                plot(data(idx(1)).t,data(idx(1)).D(:,3)./data(idx(1)).D(1,3),'b-','LineWidth',P.Subaxes.LineWidth);
                plot(data(idx(2)).t,data(idx(2)).D(:,3)./data(idx(2)).D(1,3),'b-','LineWidth',P.Subaxes.LineWidth);
                plot(data(idx(3)).t,data(idx(3)).D(:,3)./data(idx(3)).D(1,3),'b-','LineWidth',P.Subaxes.LineWidth);
            hold off
            set(subaxis(2).handle,'xlim',subaxis(2).xlim,...
                'ylim',subaxis(2).ylim,'YTick',[1:0.02:1.06],...
                'Units', 'normalized', 'Position',subaxis(2).adjposn)
        end
    H_axes(4) = subplot(rows,columns,4);
        hold on
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            ylabel('Velocity (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong);
            axis([tspan 0.9 1.65]);
            plot(data(idx(1)).t,data(idx(1)).u(:,1)./data(idx(1)).u(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).u(:,1)./data(idx(2)).u(1,1),'r-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).u(:,1)./data(idx(3)).u(1,1),'r-','LineWidth',P.Misc.widthLine);
        hold off
    H_axes(5) = subplot(rows,columns,5);
        hold on
            axis([tspan 0.9 1.65]);
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(data(idx(1)).t,data(idx(1)).u(:,2)./data(idx(1)).u(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(drew2010.cap_1s(:,1),drew2010.cap_1s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(drew2010.cap_30s(:,1),drew2010.cap_30s(:,2),'-','Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).u(:,2)./data(idx(1)).u(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).u(:,2)./data(idx(2)).u(1,2),'m-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).u(:,2)./data(idx(3)).u(1,2),'m-','LineWidth',P.Misc.widthLine);
        hold off
    H_axes(6) = subplot(rows,columns,6);
        hold on
            axis([tspan 0.9 1.65]);
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            plot(data(idx(1)).t,data(idx(1)).u(:,3)./data(idx(1)).u(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(2)).t,data(idx(2)).u(:,3)./data(idx(2)).u(1,3),'b-','LineWidth',P.Misc.widthLine);
            plot(data(idx(3)).t,data(idx(3)).u(:,3)./data(idx(3)).u(1,3),'b-','LineWidth',P.Misc.widthLine);
        hold off
        
end
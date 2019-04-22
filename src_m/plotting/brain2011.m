function [h_axes rows columns subaxis] = brain2011(type,sim_list,...
                                        constants,params,controls,data)

% This is very poor practise...sort it out
FontSize_strong = 28; %
FontSize_superstrong = 36;
FontWeight_strong = 'bold';
LineWidth = 5; %
P_legend.Box = 'boxoff';
GreyLine = [0.5 0.5 0.5];
LineWidth_sub = 3.5; %
subaxis = [];
MarkerSize = 10;

switch type
    case 'top_down'
        order = [1 6 2 7 3 8 4 9 5 10];
    case 'bottom_up'
        order = [5 10 4 9 1 6 2 7 3 8];
    otherwise
        % unknown case
end

req_sim = {'flow_volume_loop','mandeville1999_6s','mandeville1999_30s',...
    '1_second','10_seconds','30_seconds'};
idx = data_indices(sim_list,req_sim);

rows = 2;
columns = 5;

% 
tspan{1} = controls(idx(1)).tspan_dim;
tspan{2} = [-10 70];
tspan{3} = [-5 100]; % controls(idx(1)).tspan_dim;

% For F-V
% extract flow volume
[fit_data data] = extract_FV(constants(idx),params(idx),controls(idx),data(idx));
% Find alpha value
[alpha_data junk fit_data] = fit_alpha(fit_data,data); clear junk

% For Mandeville
load mandeville1999;
stim(:,:,1) =   [0 6 30;
                 0 6 30];
stim(:,:,2) =   [0 0 0;
                 2 2 2];
             
% For Drew
load drew2010
             
figure
    h_axes(1) = subplot(rows,columns,order(1));
        hold on
            title('Bulk Steady State','FontWeight',FontWeight_strong,'FontSize',FontSize_superstrong)
            plot(data(idx(1)).t,(data(idx(1)).F(:,5)),'k--','LineWidth',LineWidth);
            plot(data(idx(1)).t,(data(idx(1)).V(:,4)),'k-','LineWidth',LineWidth);
            plot(data(idx(1)).t,(data(idx(1)).V(:,1)),'r-','LineWidth',LineWidth);
            plot(data(idx(1)).t,(data(idx(1)).V(:,2)+data(idx(1)).V(:,3)),'c-','LineWidth',LineWidth);
%             plot(fit_data.time,fit_data.V_ss(4,:),'k+')
            ylabel('Flow or Volume (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            xlabel('Time (s)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            legend('Flow','Volume (Total)','Volume (Art.)','Volume (Cap. + Ven.)','Location','NorthWest')
        hold off
    h_axes(2) = subplot(rows,columns,order(2));
        hold on
            axis([0.3 3.2 0.6 2.1])
            xlabel('Flow (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong);
            ylabel('Volume (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            plot(0,0,'ro','LineWidth',LineWidth,'MarkerFaceColor','r')
            plot(0,0,'ks','LineWidth',LineWidth,'MarkerFaceColor','k')
            plot(0,0,'c^','LineWidth',LineWidth,'MarkerFaceColor','c')
            plot(fit_data.F_ss,fit_data.V_grubb(1,:),'r-','LineWidth',LineWidth);
            plot(fit_data.F_ss,fit_data.V_grubb(5,:),'c-','LineWidth',LineWidth);
            plot(fit_data.F_ss,fit_data.V_grubb(4,:),'k-','LineWidth',LineWidth);
            plot(fit_data.F_ss,fit_data.V_ss(1,:)./data(idx(1)).V(1,1),'ro','LineWidth',LineWidth,'MarkerFaceColor','r','MarkerSize',MarkerSize);
            plot(fit_data.F_ss,fit_data.V_ss(5,:)./data(idx(1)).V(1,5),'c^','LineWidth',LineWidth,'MarkerFaceColor','c','MarkerSize',MarkerSize);
            plot(fit_data.F_ss,fit_data.V_ss(4,:),'ks','LineWidth',LineWidth,'MarkerFaceColor','k','MarkerSize',MarkerSize);
            if alpha_data(5) <= 0.001
                axis([0.3 3.2 0.4 3.5])
                alpha_data(5) = 0;
            end;
            legend(['Art. (\alpha = ' num2str(alpha_data(1),3) ')'],...
                ['Total (\alpha = ' num2str(alpha_data(4),3) ')'],...
                ['Cap. + Ven. (\alpha = ' num2str(alpha_data(5),3) ')'],...
                'Location','NorthWest')
        hold off
    h_axes(3) = subplot(rows,columns,order(3));
        hold on
            title('Bulk Transient','FontWeight',FontWeight_strong,'FontSize',FontSize_superstrong)
            ylabel('Flow (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong);
            xlabel('Time (s)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            axis([tspan{2} 0.9 1.7]);
            plot(0,0,'k-','LineWidth',LineWidth);
            plot(0,0,'-','LineWidth',LineWidth,'Color',GreyLine);
            plot(mandeville1999.rCBF_6s(:,1),mandeville1999.rCBF_6s(:,2)+1,'-','Color',GreyLine,'LineWidth',LineWidth)
            plot(mandeville1999.rCBF_30s(:,1),mandeville1999.rCBF_30s(:,2)+1,'-','Color',GreyLine,'LineWidth',LineWidth)
            plot(data(idx(2)).t,(data(idx(2)).F(:,5)),'k-','LineWidth',LineWidth);
            plot(data(idx(3)).t,(data(idx(3)).F(:,5)),'k-','LineWidth',LineWidth);
            legend('Model','Mandeville (1999)')
        hold off
    h_axes(4) = subplot(rows,columns,order(4));
        hold on
            ylabel('Volume (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong);
            xlabel('Time (s)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            axis([tspan{2} 0.98 1.2]);
            plot(0,0,'k-','LineWidth',LineWidth);
            plot(0,0,'-','LineWidth',LineWidth,'Color',GreyLine);
            plot(0,0,'ro-','LineWidth',LineWidth,'MarkerFaceColor','r','MarkerSize',MarkerSize);
            plot(0,0,'ms-','LineWidth',LineWidth,'MarkerFaceColor','m','MarkerSize',MarkerSize);
            plot(0,0,'b^-','LineWidth',LineWidth,'MarkerFaceColor','b','MarkerSize',MarkerSize);
            plot(mandeville1999.rCBV_6s(:,1),mandeville1999.rCBV_6s(:,2)+1,'-','Color',GreyLine,'LineWidth',LineWidth)
            plot(mandeville1999.rCBV_30s(:,1),mandeville1999.rCBV_30s(:,2)+1,'-','Color',GreyLine,'LineWidth',LineWidth)
            if max(data(idx(3)).V(:,3)./data(idx(3)).V(1,3)) >= 1.02
                plot(data(idx(3)).t(:),(1+data(idx(3)).V(:,1)-data(idx(3)).V(1,1)),'r-','LineWidth',LineWidth);
                plot(data(idx(3)).t(:),(1+data(idx(3)).V(:,2)-data(idx(3)).V(1,2)),'m-','LineWidth',LineWidth);
                plot(data(idx(3)).t(:),(1+data(idx(3)).V(:,3)-data(idx(3)).V(1,3)),'b-','LineWidth',LineWidth);
                plot(data(idx(3)).t(100:100:end),(1+data(idx(3)).V(100:100:end,1)-data(idx(3)).V(1,1)),'ro','LineWidth',LineWidth,'MarkerFaceColor','r');
                plot(data(idx(3)).t(150:150:end),(1+data(idx(3)).V(150:150:end,2)-data(idx(3)).V(1,2)),'ms','LineWidth',LineWidth,'MarkerFaceColor','m');
                plot(data(idx(3)).t(75:150:end),(1+data(idx(3)).V(75:150:end,3)-data(idx(3)).V(1,3)),'b^','LineWidth',LineWidth,'MarkerFaceColor','b');
                legend('Model Total','Mandeville (1999)','Art.','Cap.','Ven.')
            end
            plot(data(idx(2)).t,(data(idx(2)).V(:,4)),'k-','LineWidth',LineWidth);
            plot(data(idx(3)).t,(data(idx(3)).V(:,4)),'k-','LineWidth',LineWidth);
        hold off
    h_axes(5) = subplot(rows,columns,order(5));
        hold on
            title('Arterioles','FontWeight',FontWeight_strong,'FontSize',FontSize_superstrong)
            ylabel('Diameter (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong);
            xlabel('Time (s)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            axis([tspan{3} 0.98 1.25]);
%                     plot(drew2010.art_1s(:,1),drew2010.art_1s(:,2),'-','Color',GreyLine,'LineWidth',LineWidth)
%                     plot(drew2010.art_10s(:,1),drew2010.art_10s(:,2),'-','Color',GreyLine,'LineWidth',LineWidth)
%                     plot(drew2010.art_30s(:,1),drew2010.art_30s(:,2),'-','Color',GreyLine,'LineWidth',LineWidth)
            plot(data(idx(4)).t,data(idx(4)).D(:,1)./data(idx(4)).D(1,1),'r-','LineWidth',LineWidth);
            plot(data(idx(5)).t,data(idx(5)).D(:,1)./data(idx(5)).D(1,1),'r-','LineWidth',LineWidth);
            plot(data(idx(6)).t,data(idx(6)).D(:,1)./data(idx(6)).D(1,1),'r-','LineWidth',LineWidth);
%                     legend('Mandeville 1999 ','Model')
        hold off
    h_axes(6) = subplot(rows,columns,order(6));
        hold on
            xlabel('Time (s)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            ylabel('Velocity (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong);
            axis([tspan{3} 0.9 1.6]);
            plot(data(idx(4)).t,data(idx(4)).u(:,1)./data(idx(4)).u(1,1),'r-','LineWidth',LineWidth);
            plot(data(idx(5)).t,data(idx(5)).u(:,1)./data(idx(5)).u(1,1),'r-','LineWidth',LineWidth);
            plot(data(idx(6)).t,data(idx(6)).u(:,1)./data(idx(6)).u(1,1),'r-','LineWidth',LineWidth);
        hold off
    h_axes(7) = subplot(rows,columns,order(7));
        hold on
            title('Capillaries','FontWeight',FontWeight_strong,'FontSize',FontSize_superstrong)
            xlabel('Time (s)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            ylabel('Diameter (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong);
            axis([tspan{3} 0.98 1.25]);
            plot(data(idx(4)).t,data(idx(4)).D(:,2)./data(idx(4)).D(1,2),'m-','LineWidth',LineWidth);
            plot(data(idx(5)).t,data(idx(5)).D(:,2)./data(idx(5)).D(1,2),'m-','LineWidth',LineWidth);
            plot(data(idx(6)).t,data(idx(6)).D(:,2)./data(idx(6)).D(1,2),'m-','LineWidth',LineWidth);
        hold off
        % subaxis
        if max(data(idx(6)).D(:,3)./data(idx(6)).D(1,3)) >= 1.01
            subaxis(1).handle = axes('NextPlot', 'add');
            subaxis(1).posn = get(h_axes(7),'Position');
            subaxis(1).xlim = [0 40];
            subaxis(1).ylim = [.998 1.0325];
            subaxis(1).subposn = [0.35 0.45 0.6 0.5];
            subaxis(1).adjposn =  subaxis(1).subposn.* ...
                [subaxis(1).posn(3:4) subaxis(1).posn(3:4)]...
                + [subaxis(1).posn(1:2) 0 0];
            hold on
                plot(data(idx(4)).t,data(idx(4)).D(:,2)./data(idx(4)).D(1,2),'m-','LineWidth',LineWidth_sub);
                plot(data(idx(5)).t,data(idx(5)).D(:,2)./data(idx(5)).D(1,2),'m-','LineWidth',LineWidth_sub);
                plot(data(idx(6)).t,data(idx(6)).D(:,2)./data(idx(6)).D(1,2),'m-','LineWidth',LineWidth_sub);
            hold off
            set(subaxis(1).handle,'xlim',subaxis(1).xlim,...
                'ylim',subaxis(1).ylim,'YTick',[1:0.01:1.03],...
                'Units', 'normalized', 'Position',subaxis(1).adjposn)
        end
    h_axes(8) = subplot(rows,columns,order(8));
        hold on
            axis([tspan{3} 0.9 1.6]);
            xlabel('Time (s)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            ylabel('Velocity (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong);
            plot(data(idx(4)).t,data(idx(4)).u(:,2)./data(idx(4)).u(1,2),'m-','LineWidth',LineWidth);
            plot(data(idx(5)).t,data(idx(5)).u(:,2)./data(idx(5)).u(1,2),'m-','LineWidth',LineWidth);
            plot(data(idx(6)).t,data(idx(6)).u(:,2)./data(idx(6)).u(1,2),'m-','LineWidth',LineWidth);
        hold off
    h_axes(9) = subplot(rows,columns,order(9));
        hold on
            title('Venules','FontWeight',FontWeight_strong,'FontSize',FontSize_superstrong)
            xlabel('Time (s)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            ylabel('Diameter (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong);
            axis([tspan{3} 0.98 1.25]);
%                     plot(drew2010.vei_10s(:,1),drew2010.vei_10s(:,2),'-','Color',GreyLine,'LineWidth',LineWidth)
%                     plot(drew2010.vei_30s(:,1),drew2010.vei_30s(:,2),'-','Color',GreyLine,'LineWidth',LineWidth)
            plot(data(idx(4)).t,data(idx(4)).D(:,3)./data(idx(4)).D(1,3),'b-','LineWidth',LineWidth);
            plot(data(idx(5)).t,data(idx(5)).D(:,3)./data(idx(5)).D(1,3),'b-','LineWidth',LineWidth);
            plot(data(idx(6)).t,data(idx(6)).D(:,3)./data(idx(6)).D(1,3),'b-','LineWidth',LineWidth);
        hold off
        % subaxis
        if max(data(idx(6)).D(:,3)./data(idx(6)).D(1,3)) >= 1.01
            subaxis(2).handle = axes('NextPlot', 'add');
            subaxis(2).posn = get(h_axes(9),'Position');
            subaxis(2).xlim = [0 40];
            subaxis(2).ylim = [.998 1.065];
            subaxis(2).subposn = [0.35 0.45 0.6 0.5];
            subaxis(2).adjposn =  subaxis(2).subposn.* ...
                [subaxis(2).posn(3:4) subaxis(2).posn(3:4)]...
                + [subaxis(2).posn(1:2) 0 0];
            hold on
                plot(data(idx(4)).t,data(idx(4)).D(:,3)./data(idx(4)).D(1,3),'b-','LineWidth',LineWidth_sub);
                plot(data(idx(5)).t,data(idx(5)).D(:,3)./data(idx(5)).D(1,3),'b-','LineWidth',LineWidth_sub);
                plot(data(idx(6)).t,data(idx(6)).D(:,3)./data(idx(6)).D(1,3),'b-','LineWidth',LineWidth_sub);
            hold off
            set(subaxis(2).handle,'xlim',subaxis(2).xlim,...
                'ylim',subaxis(2).ylim,'YTick',[1:0.02:1.06],...
                'Units', 'normalized', 'Position',subaxis(2).adjposn)
        end
    h_axes(10) = subplot(rows,columns,order(10));
        hold on
            axis([tspan{3} 0.9 1.6]);
            xlabel('Time (s)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong)
            ylabel('Velocity (a.u.)','FontWeight',FontWeight_strong,'FontSize',FontSize_strong);
            plot(data(idx(4)).t,data(idx(4)).u(:,3)./data(idx(4)).u(1,3),'b-','LineWidth',LineWidth);
            plot(data(idx(5)).t,data(idx(5)).u(:,3)./data(idx(5)).u(1,3),'b-','LineWidth',LineWidth);
            plot(data(idx(6)).t,data(idx(6)).u(:,3)./data(idx(6)).u(1,3),'b-','LineWidth',LineWidth);
        hold off

end
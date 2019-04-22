function [H_axes rows columns] = leithner2010_main(P,sim_list,data,...
                                                    constants)
                                                
req_sim = {'leithner2010_baseline','leithner2010_inhibited',...
            'leithner2010_inhibited2'};
idx = find_data_indices(sim_list,req_sim);

tspan = [-10 40];
rows= 3;
columns = 3;

load leithner2010

for iSim = 1:length(req_sim)
    [t0(iSim) idxt0(iSim)] = min(abs(data(idx(iSim)).t));
end

dHbComp = 4;

H_fig = figure;
    H_axes(1) = subplot(rows,columns,[1 columns+1]);
        hold on
            title('Baseline','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontLabel)
            ylabel('Relative Change (a.u.)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 0.82 1.61])
            plot(Leithner2010(1).cbf(:,1),Leithner2010(1).cbf(:,2),'k--','LineWidth',P.Misc.widthLine)
            plot(Leithner2010(1).cbv(:,1),Leithner2010(1).cbv(:,2),'m--','LineWidth',P.Misc.widthLine)
            plot(Leithner2010(1).dhb(:,1),Leithner2010(1).dhb(:,2),'b--','LineWidth',P.Misc.widthLine)
            plot(Leithner2010(1).cmro2(:,1),Leithner2010(1).cmro2(:,2),'g--','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).F(:,5)/data(idx(1)).F(idxt0(1),5),'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).nHbT(:,dHbComp)/data(idx(1)).nHbT(idxt0(1),dHbComp),'m-','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).HbT_spec+1,'m:','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).ndHb(:,dHbComp)/data(idx(1)).ndHb(idxt0(1),dHbComp),'b-','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).dHb_spec+1,'b:','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).S(:,4)/data(idx(1)).S(idxt0(1),4),'g-','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).dHb_spec+1,'b:','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).nHbO(:,dHbComp)/data(idx(1)).nHbO(idxt0(1),4),'r-','LineWidth',P.Misc.widthLine)
            plot(data(idx(1)).t,data(idx(1)).HbO_spec+1,'r:','LineWidth',P.Misc.widthLine)
            legend()
        hold off
    H_axes(2) = subplot(rows,columns,[2 columns+2]);
        hold on
            title('2/3 CBF Inhibited','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontLabel)
            axis([tspan 0.82 1.61])
            plot(Leithner2010(2).cbf(:,1),Leithner2010(2).cbf(:,2),'k--','LineWidth',P.Misc.widthLine)
            plot(Leithner2010(2).cbv(:,1),Leithner2010(2).cbv(:,2),'m--','LineWidth',P.Misc.widthLine)
            plot(Leithner2010(2).dhb(:,1),Leithner2010(2).dhb(:,2),'b--','LineWidth',P.Misc.widthLine)
            plot(Leithner2010(2).cmro2(:,1),Leithner2010(2).cmro2(:,2),'g--','LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,data(idx(2)).F(:,5)/data(idx(2)).F(idxt0(2),5),'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,data(idx(2)).nHbT(:,dHbComp)/data(idx(2)).nHbT(idxt0(2),dHbComp),'m-','LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,data(idx(2)).HbT_spec+1,'m:','LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,data(idx(2)).ndHb(:,dHbComp)/data(idx(2)).ndHb(idxt0(2),dHbComp),'b-','LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,data(idx(2)).dHb_spec+1,'b:','LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,data(idx(2)).S(:,4)/data(idx(2)).S(idxt0(2),4),'g-','LineWidth',P.Misc.widthLine)
            plot(data(idx(2)).t,data(idx(2)).HbO_spec+1,'r:','LineWidth',P.Misc.widthLine)
        hold off
    H_axes(3) = subplot(rows,columns,[3 columns+3]);
        hold on
            title('All CBF Inhibited','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontLabel)
            axis([tspan 0.82 1.61])
            plot(data(idx(3)).t,data(idx(3)).F(:,5)/data(idx(3)).F(idxt0(3),5),'k-','LineWidth',P.Misc.widthLine)
            plot(data(idx(3)).t,data(idx(3)).nHbT(:,dHbComp)/data(idx(3)).nHbT(idxt0(3),dHbComp),'m-','LineWidth',P.Misc.widthLine)
            plot(data(idx(3)).t,data(idx(3)).HbT_spec+1,'m:','LineWidth',P.Misc.widthLine)
            plot(data(idx(3)).t,data(idx(3)).ndHb(:,dHbComp)/data(idx(3)).ndHb(idxt0(3),dHbComp),'b-','LineWidth',P.Misc.widthLine)
            plot(data(idx(3)).t,data(idx(3)).dHb_spec+1,'b:','LineWidth',P.Misc.widthLine)
            plot(data(idx(3)).t,data(idx(3)).S(:,4)/data(idx(3)).S(idxt0(3),4),'g-','LineWidth',P.Misc.widthLine)
            plot(data(idx(3)).t,data(idx(3)).HbO_spec+1,'r:','LineWidth',P.Misc.widthLine)
            legend('CBF','HbT','dHb','CMRO_2')
        hold off
    H_axes(4) = subplot(rows,columns,columns*2+1);
        hold on
            ylabel('Tissue PO_2 (mmHg)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 15 35])
            plot(data(idx(1)).t,data(idx(1)).PO2(:,4).*constants(idx(1)).reference.PO2_ref,'b-','LineWidth',P.Misc.widthLine)
        hold off
    H_axes(5) = subplot(rows,columns,columns*2+2);
        hold on
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 15 35])
            plot(data(idx(2)).t,data(idx(2)).PO2(:,4).*constants(idx(2)).reference.PO2_ref,'b-','LineWidth',P.Misc.widthLine)
        hold off
    H_axes(6) = subplot(rows,columns,columns*2+3);
        hold on
            xlabel('Time (s)','FontWeight',P.Misc.weightFontStrong,'FontSize',P.Misc.sizeFontStrong)
            axis([tspan 15 35])
            plot(data(idx(3)).t,data(idx(3)).PO2(:,4).*constants(idx(3)).reference.PO2_ref,'b-','LineWidth',P.Misc.widthLine)
        hold off
end
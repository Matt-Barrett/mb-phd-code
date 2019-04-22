function [H_axes rows columns] = o2_hb_sat(P,constants,params,controls)

% Assumes we're using the constants from whatever is the first simulation
idx = 1;

minPO2 = 0;
maxPO2 = 150;
intPO2 = 0.1;
pO2_plot = minPO2:intPO2:maxPO2;
pO2 = pO2_plot./constants(idx).reference.PO2_ref;

% Calculate saturation in the blood
cO2b = PressureContent(pO2,[],{'pressure','blood'},params(idx).gas,controls);
sO2b = cO2b./params(idx).gas.hill.chi;

% Calculate 'saturation' in the blood
cO2t = PressureContent(pO2,[],{'pressure','tissue'},params(idx).gas,controls);
sO2t = cO2t./params(idx).gas.hill.chi;

p50 = params(idx).gas.hill.phi.*constants(idx).reference.PO2_ref;

%%

rows = 1;
columns = 1;

headingStyle = {'FontWeight',P.Misc.weightFontStrong,...
                'FontSize',P.Misc.sizeFontStrong};

figure, H_axes = axes;
hold on
    axis([minPO2 maxPO2 0 1])
    ylabel('Normalised Concentration (a.u.)',headingStyle{:})
    xlabel('Oxygen Tension (mmHg)',headingStyle{:})
    plot(pO2_plot,sO2b,'r-','LineWidth',P.Misc.widthLine)
    plot(pO2_plot,sO2t,'b-','LineWidth',P.Misc.widthLine)
    plot([minPO2 p50],0.5*ones(1,2),'k--')
    plot(p50*ones(1,2),[0 0.5],'k--')
    legend('Blood','Tissue','Location','East')
hold off
                                                
end
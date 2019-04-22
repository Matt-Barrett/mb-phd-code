function scales = calc_devor_scales(Default,Override)

load devor2011
load vazquez2008
load vazquez2010

sim_list = {'vazquez2008_control','vazquez2010'};

fracIncl = 1;

exclOutside(1,:) = [5 10];
tt{1} = vazquez2008.PO2.control(:,1);
yy{1} = vazquez2008.PO2.control(:,2);
basePO2(1) = vazquez2008.baseline.PO2(1);

exclOutside(2,:) = [5 20];
tt{2} = Vazquez2010.PtO2(:,1);
yy{2} = Vazquez2010.PtO2(:,2).*Vazquez2010.baseline.PtO2;
basePO2(2) = Vazquez2010.baseline.PtO2;

exclOutside(3,:) = [5 20];
tt{3} = devor2011.mean(:,1);
yy{3} = devor2011.mean(:,2);
basePO2(3) = devor2011.baseline.pto2;

nSims = length(sim_list);

for iSim = 1:nSims + 1
    
    if iSim <= nSims
    
        % Setup specific Constants/Params/Controls for each simulation.
        [Constants(iSim) Params(iSim) Controls(iSim)] = ...
                            setup_problem(sim_list{iSim},Default,Override);

        % Run the simulation(s) and perform calculations.
        [Constants(iSim) Params(iSim) Data(iSim)] = ...
                solve_problem(Constants(iSim),Params(iSim),Controls(iSim)); 

        % Calculate the mean maximum PO2 value
        deltaCMRO2(iSim) = calc_mean_active(Data(iSim).t,...
                        Data(iSim).S(:,4),exclOutside(iSim,:),fracIncl);
        deltaCMRO2(iSim) = (deltaCMRO2(iSim) - ...
            Params(iSim).metabolism.CMRO2_ss)./...
            Params(iSim).metabolism.CMRO2_ss;
    
    end

    % Calculate the mean maximum PO2 value
    maxPO2(iSim) = calc_mean_active(tt{iSim},yy{iSim},...
        exclOutside(iSim,:),fracIncl);
    
end;

deltaPO2 = maxPO2 - basePO2;

scaleRaw = deltaCMRO2./deltaPO2(1:nSims);

cmro2Raw = scaleRaw.*deltaPO2(3);

scales = cmro2Raw./deltaCMRO2;

end
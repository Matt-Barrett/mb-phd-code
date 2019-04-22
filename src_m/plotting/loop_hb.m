function [H_axes rows columns] = loop_hb(P,sim_list,data,...
                                                constants,params,controls,isFlow)
                                            
if isFlow
    req_sim = {'loop_cbf'};
else
    req_sim = {'loop_cmro2'};
end

rows = 2;
columns = 1;

idx = find_data_indices(sim_list,req_sim);

for iSim = 1:length(idx)
    [t0(iSim) idxt0(iSim)] = min(abs(data(idx(iSim)).t(...
        data(idx(iSim)).t <= 0)));
end

idxTT = find_time_indices(data(idx(iSim)), params(idx(iSim)), isFlow);

tt = data(idx).t(idxTT);
ttCBF = data(idx).F(idxTT,5)./data(idx).F(idxt0,5);
ttCMRO2 = data(idx).S(idxTT,4)./data(idx).S(idxt0,4);
ttHBO = data(idx).nHbO(idxTT,4)./data(idx).nHbO(idxt0,4);
ttDHB = data(idx).ndHb(idxTT,4)./data(idx).ndHb(idxt0,4);
ttPO2 = data(idx).PO2(idxTT,4)./data(idx).PO2(idxt0,4);

if isFlow
    ttXX = ttCBF;
else
    ttXX = ttCMRO2;
end

hFig = figure;
H_axes(1) = subplot(rows, columns, 1); hold on
    ylim([0.2 1.8])
    plot(data(idx).t, data(idx).F(:,5)./data(idx).F(idxt0,5), 'k-')
    plot(tt, ttCBF, 'k+')
    plot(data(idx).t, data(idx).S(:,4)./data(idx).S(idxt0,4), 'k--')
    plot(data(idx).t, data(idx).nHbO(:,4)./data(idx).nHbO(idxt0,4), 'r-')
    plot(data(idx).t, data(idx).ndHb(:,4)./data(idx).ndHb(idxt0,4), 'b-')
    plot(data(idx).t, data(idx).PO2(:,4)./data(idx).PO2(idxt0,4), 'g-')
    plot(data(idx).t, data(idx).PO2_ss(:,1)./data(idx).PO2_ss(idxt0,1), 'g--')
    hold off
H_axes(2) = subplot(rows, columns, 2); hold on
    ylim([0.2 1.8])
    plot(ttXX, ttHBO, 'r+')
    plot(ttXX, ttDHB, 'b+')
    plot(ttXX, ttPO2, 'k+')
    hold off
    
                                            
end

function idxTT = find_time_indices(data, params, isFlow)

% Preallocate memory
if isFlow
    paramField = 'vasodilation';
else
    paramField = 'metabolism';
end

nSteps = sum(params.(paramField).n)+1;
tt = zeros(1,nSteps);
idxTT = tt;

% Loop through each step
for iTime = 1:nSteps

    tt(iTime) = (params.(paramField).t_diff*...
        (iTime + params.(paramField).n(1) - 1));
    
    modTT = data.t - tt(iTime);
    [tt(iTime) idxTT(iTime)] = min(abs(modTT(modTT <= 0)));
    
end

end
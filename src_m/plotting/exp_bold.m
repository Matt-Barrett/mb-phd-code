function [H_axes rows columns] = exp_bold(P, sim_list, data, constants,...
                                            ExpData, PlotData)
                                        
H_axes = [];
rows = 1;
columns = 2;

% Find the indices (we don't need to display the warning as it's dealt with
% seperately below)
wngState = warning('off','FindDataIndices:CouldntFind');
idx = find_data_indices(sim_list,PlotData.req_sim);
warning(wngState)

% Get rid of the simulations that aren't found
maskNan = isnan(idx);
hasOneSim = sum(maskNan) < length(maskNan);
if hasOneSim
    idx = idx(~maskNan);
else
    strPlotList = sprintf('%s, %s',PlotData.req_sim{:});
    warning('Plot:ExpHB:NoValidSims',['None of the required simulations '...
        '(%s) could be found for plot "%s".'],strPlotList,PlotData.name)
    return
end

[t0 idxt0] = min(abs(data(idx(1)).t));

H_fig = figure;
    H_axes(1) = subplot(rows,columns,1);
        hold on
            xlim(PlotData.axis(1:2))
            plot(ExpData(1).raw_CBF(:,1), 1 + ExpData(1).raw_CBF(:,2)/100, 'k-+')
            plot(data(idx).t, data(idx).F(:,5)./data(idx).F(idxt0,5), 'b-')
            plot(data(idx).t, data(idx).S(:,4)./data(idx).S(idxt0,4), 'g-')
        hold off
    H_axes(2) = subplot(rows,columns,2);
        hold on
            xlim(PlotData.axis(1:2))
            plot(ExpData(1).raw_BOLD(:,1), 1+ExpData(1).raw_BOLD(:,2)/100,'k-+','LineWidth',P.Misc.widthLine)
            plot(data(idx).t, 1 + data(idx).B(:,4))
        hold off
        
end
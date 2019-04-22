function [H_axes rows columns] = devor_dynamic(P,sim_list,data,constants)

%% General Stuff

req_sim = {'devor2011_surface','devor2011_mid','devor2011_deep',...
            'devor2011_surface1','devor2011_mid1','devor2011_deep1'};
wngState = warning('off','FindDataIndices:CouldntFind');
idx = find_data_indices(sim_list,req_sim);
warning(wngState);

load devor2011


nSims = length(idx);
tspan = [-3 40];
pO2Lim = [6 29];
rows = 3;
columns = 2;

for iSim = 1:nSims
    [t0(iSim) idxt0(iSim)] = min(abs(data(idx(iSim)).t));
end

%% Calculate new tissue values

iSim = 1;

% ptn_ss = 25./constants(idx(iSim)).reference.PO2_ref;
% % Calculate the new PO2_t
% ptn = calculate_ptn(ptn_ss,[data(idx(iSim)).PO2(:,1:3) data(idx(iSim)).PO2(:,end)],...
%                         idxt0(iSim),constants(idx(iSim)));

nInts = 2;
                    
ptn_ss = [10 devor2011.baseline.pto2 linspace(16.5,25,3)]./...
    constants(idx(iSim)).reference.PO2_ref;
nVals = length(ptn_ss);

simNums = [1:3; 4:6];

% Loop through the interventions types
for iInt = 1:nInts

    % Loop through the required baseline values             
    for jVal = 1:nVals
        
        % Reset the temporary variables
        temp = 1;
        ptnTemp = [];
        
%         testDoSim = [data(idx(simNums(iInt,:))).PO2(idxt0(1),5)] > ptn_ss(jVal);
        
        % Loop through the simulations
        for kSim = simNums(iInt,:)
            
            % Check if the simulation is within the baseline value
            doSim = data(idx(kSim)).PO2(idxt0(kSim),end) <= ptn_ss(jVal);
            
            % Calculate the trace
            if doSim
                
                ptnTemp(:,temp) = calculate_ptn(ptn_ss(jVal),...
                    [data(idx(kSim)).PO2(:,1:3) data(idx(kSim)).PO2(:,end)],...
                    idxt0(kSim),constants(idx(kSim)));
                
                temp = temp+1;
                
            end
            
        end
        
        % Calculate the average traces
        if ~isempty(ptnTemp)
            ptn(:,jVal,iInt) = mean(ptnTemp,2);
        else
            ptn(:,jVal,iInt) = nan(size(data(idx(kSim)).PO2(:,end),1),1);
        end
        
    end
    
    % Calculate
    ptMeanTemp(:,:,iInt) = [data(idx(simNums(iInt,:))).PO2];
    ptMean(:,iInt) = mean(ptMeanTemp(:,[4:5:14],iInt),2);
        
end
                    
%%

labelSyle = {'FontWeight',P.Misc.weightFontStrong,...
             'FontSize',P.Misc.sizeFontStrong};
         
titleStyle = {labelSyle{1:3} P.Misc.sizeFontLabel};

lineStyle = {'-','--','-.'};

lineFormat = {'LineWidth',P.Misc.widthLine};

[colData(1) colData(2) colData(3)] = rgbconv('CCCCCC');
[noKData(1) noKData(2) noKData(3)] = rgbconv('636363');

                    
%% Plot figure

H_fig = figure;
    H_axes(1) = subplot(rows,columns,1);
        hold on
            axis([tspan 0.95 1.25])
            title('Control',titleStyle{:})
            ylabel('CBF and CMRO2 (a.u.)',labelSyle{:})
            plot(data(idx(1)).t,data(idx(1)).F(:,5),'k-',lineFormat{:})
            plot(data(idx(1)).t,data(idx(1)).S(:,4)./data(idx(1)).S(idxt0(4),4),'k--',lineFormat{:})
            legend('Model CBF','Model CMRO2')
        hold off
    H_axes(2) = subplot(rows,columns,2);
        hold on
            axis([tspan 0.95 1.25])
            title('No Vasodilation',titleStyle{:})
            plot(data(idx(4)).t,data(idx(4)).F(:,5),'k-',lineFormat{:})
            plot(data(idx(4)).t,data(idx(4)).S(:,4)./data(idx(4)).S(idxt0(4),4),'k--',lineFormat{:})
        hold off
    H_axes(3) = subplot(rows,columns,[3, 5]);
        hold on
            axis([tspan pO2Lim])
            xlabel('Time (s)',labelSyle{:})
            ylabel('Tissue PO2 (mmHg)',labelSyle{:})
%             for iSim = 1:3
%                 plot(data(idx(iSim)).t,constants(idx(iSim)).reference.PO2_ref.*data(idx(iSim)).PO2(:,3),['b' lineStyle{iSim}],lineFormat{:})
%                 plot(data(idx(iSim)).t,constants(idx(iSim)).reference.PO2_ref.*data(idx(iSim)).PO2(:,4),['r' lineStyle{iSim}],lineFormat{:})
%                 plot(data(idx(iSim)).t,constants(idx(iSim)).reference.PO2_ref.*data(idx(iSim)).PO2(:,end),['k' lineStyle{iSim}],lineFormat{:})
%             end
            plot(devor2011.mean(:,1),devor2011.mean(:,2),'-','Color',colData,lineFormat{:})
            plot(data(idx(iSim)).t,ptn(:,:,1).*constants(idx(iSim)).reference.PO2_ref,'k-',lineFormat{:})
%             plot(data(idx(iSim)).t,ptn(:,2,1).*constants(idx(iSim)).reference.PO2_ref,'k-',lineFormat{:})
%             plot(data(idx(iSim)).t,ptMean(:,1).*constants(idx(iSim)).reference.PO2_ref,'r-',lineFormat{:})
            legend('Devor 2011','Model')
%             plot(data(idx(iSim)).t,constants(idx(iSim)).reference.PO2_ref.*ptn,'g--')
        hold off
    H_axes(4) = subplot(rows,columns,[4, 6]);
        hold on
            axis([tspan pO2Lim])
            xlabel('Time (s)',labelSyle{:})
%             for iSim = 4:6
%                 plot(data(idx(iSim)).t,constants(idx(iSim)).reference.PO2_ref.*data(idx(iSim)).PO2(:,3),['b' lineStyle{iSim-3}],lineFormat{:})
%                 plot(data(idx(iSim)).t,constants(idx(iSim)).reference.PO2_ref.*data(idx(iSim)).PO2(:,4),['g' lineStyle{iSim-3}],lineFormat{:})
%                 plot(data(idx(iSim)).t,constants(idx(iSim)).reference.PO2_ref.*data(idx(iSim)).PO2(:,end),['k' lineStyle{iSim-3}],lineFormat{:})
%             end
            plot(data(idx(iSim)).t,ptn(:,:,2).*constants(idx(iSim)).reference.PO2_ref,'k-',lineFormat{:})
%             plot(data(idx(iSim)).t,ptn(:,2,2).*constants(idx(iSim)).reference.PO2_ref,'k-',lineFormat{:})
%             plot(data(idx(iSim)).t,ptMean(:,2).*constants(idx(iSim)).reference.PO2_ref,'r-',lineFormat{:})
%             legend('Veins','Avg. Tissue','Min. Tissue')
        hold off          

end
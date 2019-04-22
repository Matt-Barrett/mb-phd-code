function [Sig PDiff] = produce_stats(StatsFull)

% List of the variables to compare(assuming both structures are the same)
% listVars = {'alpha','F','V','D','u'}; % blood flow
listVars = {'F','PO2','PO2_ss','S','RMS'}; % oxygen

% Idxs of the variables to compare
% idxVars = {[1,4,5],5,1:4,1:3,1:3}; % blood flow
idxVars = {5,1:5,1,4,1}; % oxygen

% List of the metrics to compare
% listMetrics = fieldnames(StatsFull{1}(2).(listVars{2}))'; % one way
listMetrics = {'meanActive'}; % oxygen
% listMetrics = {'peak_norm','ttp','t50_up','t50_down'}; % blood flow

doPlots = false;
% doPlots = true;

% Loop through the simulations
nSims = length(StatsFull{1});
for iSim = 1:nSims
    
    
    varsToUseIdx = 1:length(listVars);
    
%     if iSim == 1
%         % For the first simulation, only do alpha (assuming it's first)
%         varsToUseIdx = 1;
%         isAlpha = true;
%     else
%         % For the other simulations, do everything but alpha
%         isAlpha = false;
%         nVars = length(listVars);
%         varsToUseIdx = 2:nVars;
%     end
    
    % Loop through the variables
    for jVar = varsToUseIdx
        
        isAlpha = strcmpi(listVars{1},'alpha');
        
        % Loop though the metrics
        for kMetric = listMetrics
            
            % Loop through the idxs (doing first sim alpha only)
            for lIdx = idxVars{jVar}
                
                % Prepare the input arguments
                if isAlpha
                
                    % There is no metric
                    X = StatsFull{1}(iSim).(listVars{jVar})(:,lIdx);
                    Y = StatsFull{2}(iSim).(listVars{jVar})(:,lIdx);
                
                else
                    
                    % There is a metric
                    X = StatsFull{1}(iSim).(listVars{jVar}).(kMetric{:})(:,lIdx);
                    Y = StatsFull{2}(iSim).(listVars{jVar}).(kMetric{:})(:,lIdx);
                    
                end
                
                % For debuging
                doStop = (jVar == 5);
                if doStop
                    disp('')
                end
                
                if doPlots
                    fprintf('Variable "%s", Metric "%s", Index "%d"\n',...
                        listVars{jVar},kMetric{:},lIdx)
                end
                
                % Calculate the statistics
                try
                    [sig pDiff method] = hyp_test(X,Y,doPlots);
                catch ME
                    [sig pDiff method] = deal(NaN);
                end
                
                if doPlots
                    fprintf('\tP-Value "%5.4f", Method "%s"\n',...
                        pDiff,method)
                end
%                 
                % Assign the results
                if isAlpha
                
                    % There is no metric
                    Sig(iSim).(listVars{jVar})(:,lIdx) = sig;
                    PDiff(iSim).(listVars{jVar})(:,lIdx) = pDiff;
                    Method(iSim).(listVars{jVar})(:,lIdx) = {method};
                
                else
                    
                    % There is a metric
                    Sig(iSim).(listVars{jVar}).(kMetric{:})(:,lIdx) = sig;
                    PDiff(iSim).(listVars{jVar}).(kMetric{:})(:,lIdx) = pDiff;
                    Method(iSim).(listVars{jVar}).(kMetric{:})(:,lIdx) = {method};
                    
                end
                
            end
            
            % There are no metrics for alpha, so break out of the kMetric
            % loop after going through once to avoid repeating lIdx calcs.
            if isAlpha, break, end;
                
        end
    
    end
    
end

end
function [StatsOpt StatsFull StatsStd StatsMean StatsMed] = ...
                                    find_metrics(t,data,tStim,varargin)
   

tRise = ones(1,size(data,3));
validTRise = (nargin > 3) && ~isempty(varargin{1});
if validTRise
    tRise = varargin{1};
end

isHb = false;
validIsHb = (nargin > 4) && ~isempty(varargin{2});
if validIsHb
    isHb = varargin{2};
end
    
% This function assumes that the first data point is at baseline.

if size(data,1) > 1
    
    [StatsFull.peak_abs idx_peak] = max(data);
    StatsFull.peak_norm = (StatsFull.peak_abs./data(1,:,:) -1).*100;
    StatsFull.ttp = t(idx_peak);
    
    % Calculate the average 
    fracIncl = 1;
    if isHb
        exclOutside = [10 tStim]; % Hb
    else
        exclOutside = [5 tStim]; % O2
    end

    % Calculate the contribution of each compartment to the total (assuming the
    % total is the last column in the data)
    tempPeak = StatsFull.peak_abs - data(1,:,:);
    StatsFull.peak_contrib = bsxfun(@rdivide,tempPeak(:,1:end-1,:),....
                                                tempPeak(:,end,:));
    
    % Calculate the average dt                                         
    dt = mean(t(2:end)-t(1:end-1));
    
    % Calculate the t50 up and down.
    for iCol = 1:size(data,2)
        for jSim = 1:size(data,3)

            [junk idxt0] = min(abs(t(t<0)));
            baseline = data(idxt0,iCol,jSim);
            meanActive = calc_mean_active(t,data(:,iCol,jSim),exclOutside,fracIncl);
        
            isZero = abs(baseline) < 1E-4;
            if ~isZero
                StatsFull.meanActive(:,iCol,jSim) = (meanActive - baseline)./baseline;
                StatsFull.auc(:,iCol,jSim) = dt.*trapz(data(:,iCol,jSim)./baseline - 1);
            else
                StatsFull.meanActive(:,iCol,jSim) = meanActive;
                StatsFull.auc(:,iCol,jSim) = dt.*trapz(data(:,iCol,jSim));
            end

            try

                % Calculate t50_up and _down
               [StatsFull.t50_up(:,iCol,jSim)...
                StatsFull.t50_down(:,iCol,jSim)] = calculate_t50(t,data(:,iCol,jSim),...
                                                StatsFull.peak_abs(:,iCol,jSim),...
                                                StatsFull.ttp(:,iCol,jSim));

            catch ME1

                StatsFull.t50_up(:,iCol,jSim) = NaN;
                StatsFull.t50_down(:,iCol,jSim) = NaN;

            end
            
            % Calculate the points needed for correllation
            tEnd = 40;
            tEdges = [0 tRise(jSim) tStim tEnd];
            nInts = length(tEdges) - 1;
            nPoints = 8;
            listFields = strcat('corr_',{'onset','plateau','offset'});
            idxPoints = zeros(nInts,nPoints);
            for kInt = 1:nInts
                
                tPointsTemp = linspace(tEdges(kInt),tEdges(kInt+1),nPoints+2);
                for jPoint = 1:nPoints
                    [junk idxPoints(kInt,jPoint)] = min(abs(t - tPointsTemp(jPoint+1)));
                end
                
                if ~isZero
                    StatsFull.(listFields{kInt})(:,iCol,jSim) = 100*(...
                        data(idxPoints(kInt,:),iCol,jSim)./baseline-1);
                else
                    StatsFull.(listFields{kInt})(:,iCol,jSim) = ...
                        data(idxPoints(kInt,:),iCol,jSim);
                end
                
            end
            
            
            

        end;
    end
    
else
    
    StatsFull.peak_abs = data;
    
end

[StatsOpt StatsFull StatsStd StatsMean StatsMed] = process_stats(StatsFull);

end
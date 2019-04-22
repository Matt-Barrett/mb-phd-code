function [tau_up tau_down] = calculate_tau(t,data,peak,ttp)

% normalise data to baseline (for up phase)
normData1 = (data(:) - data(1)) / (peak - data(1));

% normalise data to minimum value (for down phase)
[minData idxMin] = min(data);
normData2 = (data(:) - minData) / (peak - minData);

% Create masks for up phase of data
upperRange = 0.95; lowerRange = 0.05;
maskInRangeUp = ((normData1 < upperRange) & (normData1 > lowerRange))';
maskUp = (t > 0 & t <= ttp);
maskUpExp = maskUp & maskInRangeUp;

% Create masks for down phase of data
maskDown = (t > ttp);

% Eliminate data after the minimum, if the minimum falls after the peak.
minAfterPeak = t(idxMin) > ttp;
maskBeforeEndMin = true(size(maskDown));
if minAfterPeak
    maskBeforeEndMin = (t <= t(idxMin));
end

% Find any peaks in the down phase.  The purpose is to try and deal with
% the cases where the simulation reaches a peak and then decreases (while
% still being stimulated) before returning to baseline.
mpd = 10; mph = 0.5;
s = warning('off','signal:findpeaks:noPeaks'); 
[pksDown,locs] = findpeaks(normData2(maskDown),'minpeakheight',mph,...
                            'minpeakdistance',mpd);
warning(s)

% Adjust the ttp, maskDown, and normalised data according to this new peak
isPeak = ~isempty(pksDown);
if isPeak
    adjustPeak = (length(pksDown) == 1);
    if adjustPeak
        
        tMasked = t(maskDown);
        ttpAdjusted = tMasked(locs);
        maskDown = t > ttpAdjusted;
        normData2 = (normData2(:) - min(normData2)) / (pksDown - min(normData2));
        
    else
        % Shit, there's more than one peak.  Dunno what to do here.
        warning('calculateTau:multiplePeaks',['Multiple peaks found: '...
            'not doing anything'])
    end
end

maskInRangeDown = ((normData2 < upperRange) & (normData2 > lowerRange))';
maskDownExp = maskDown & maskBeforeEndMin & maskInRangeDown;

% Extract the relevant data from the simulations 
dataUp = normData1(maskUpExp) - min(normData1(maskUpExp));
dataDown = normData2(maskDownExp) - min(normData2(maskDownExp));

% Exctract and rescale the relevant time points
tUp = t(maskUpExp)-min(t(maskUpExp));
tDown = t(maskDownExp)-min(t(maskDownExp));

% Define the exponential function to fit to the simulation data
expUp = @(vals) vals(1).*(1-exp(-vals(2).*(tUp-vals(3))));
expDown = @(vals) vals(1).*(exp(-vals(2).*(tDown-vals(3))));

% Define the objective functions for the optimisation
residualsUp = @(vals) expUp(vals) - dataUp';
residualsDown = @(vals) expDown(vals) - dataDown';

% Setup optimisation parameters
x0 = [1 0.1 0];
lb = [0 0 -inf];
ub = [inf inf inf];
options = optimset('Display','none');
% options = optimset('Display','iter'); % for debugging

% Perform optimization
try
    xUp = lsqnonlin(residualsUp,x0,lb,ub,options);
    xDown = lsqnonlin(residualsDown,x0,lb,ub,options);
catch ME
    disp('')
end

% Assign output variables from optimum parameters
tau_up = xUp(2);
tau_down = xDown(2);

% % Plot figures (mainly for debugging)
% figure, hold on,
%     plot(tUp,dataUp,'b-')
%     plot(tUp,expUp(xUp),'r+')
%     plot(tUp,residualsUp(xUp),'g+')
% hold off
% 
% figure, hold on,
%     plot(tDown,dataDown,'b-')
%     plot(tDown,expDown(xDown),'r+')
%     plot(tDown,residualsDown(xDown),'g+')
% hold off

end
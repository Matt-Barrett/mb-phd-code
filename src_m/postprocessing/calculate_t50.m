function [t50_up t50_down] = calculate_t50(t,data,peak,ttp)

METHOD = 'spline';

% normalise data, assuming first point is at baseline
normData = (data(:) - data(1)) / (peak - data(1));

% Create masks for up and down phases of data
upperRange = 0.7; lowerRange = 0.3;
maskInRange = ((normData < upperRange) & (normData > lowerRange))';
maskUp = (t > 0 & t <= ttp);
maskUpSmall = maskUp & maskInRange;
maskDown = (t > ttp & t <= max(t));
maskDownSmall = maskDown & maskInRange;

% Calculate t50_up and down via interpolation
t50_up = interp1(normData(maskUpSmall),t(maskUpSmall),0.5,METHOD);

try
    t50_down = interp1(normData(maskDownSmall),t(maskDownSmall),...
        0.5,METHOD) - ttp;
catch ME
    t50_down = interp1(normData(maskDown),t(maskDown),...
        0.5,METHOD,'extrap') - ttp;
end

end
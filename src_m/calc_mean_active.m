function meanActive = calc_mean_active(tt,yy,exclOutside,varargin)

% The fraction (i.e. 0 < fracIncl <= 1) of observations within the range to
% include.
fracIncl = 1;
if nargin > 3
    fracIncl = varargin{1};
end

% Precalculate some useful values
rangeTT =  exclOutside(2) - exclOutside(1);
minTT = exclOutside(1) + (1-fracIncl).*rangeTT;
maxTT = exclOutside(2) - (1-fracIncl).*rangeTT;

% Calculate the output
maskActive = (tt >= minTT) & (tt <= maxTT);
meanActive = mean(yy(maskActive));

end
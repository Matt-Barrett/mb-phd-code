function wMean = calc_wmean(constants)

% This function returns the value wMean that satisfies the equation:
%               ptx = wMean*px + (1 - wMean)*p0
% where:
%       ptx is the mean tissue pO2 around compartment x
%       px is the mean vessel pO2 
%       p0 is the mean minimum tissue pO2
%
% The function assumes a Krogh cylinder pO2 profile in 3D.

r1 = constants.ss.r1;
r2 = constants.ss.r2;

alpha = (1/4)*(r2^2 - r1^2) - (1/2)*(r2^2)*log(r2/r1);

wMean = 1 - ...
    (1/(8*alpha))*(r2^4-r1^4)/(r2^2-r1^2) - ...
    (1/(4*alpha))*(r2^2-r1^2) + ...
    (1/(2*alpha))*((r2^4)/(r2^2  - r1^2))*log(r2/r1);

end
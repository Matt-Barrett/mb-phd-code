function pt = calculate_pt(pO2,p0,wMean,wPO2)

% pO2 = 1x3 vector of [pO2_a pO2_c pO2_v]
% p0 = scalar 

% Setup a function to calculate the mean tissue PO2 for a particular
% compartment
quadMean = @(px) wMean.*px + (1-wMean).*p0;

% % Create a temporary array
% tempPO2 = [constants.ss.PO2_art constants.ss.PO2_cap constants.ss.PO2_vei];

% Calculate the PO2_t
pt = sum(wPO2.*quadMean(pO2));

end
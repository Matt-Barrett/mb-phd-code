function ptn = calculate_ptn(ptn_ss,pO2,idxt0,constants)

% ptn_ss = scalar
% pO2 = [pO2_a pO2_c pO2_v pO2_0]

% Calculate the new weights (the smallest euclidean distance from the old
% weights
wn = calculate_min_dist(ptn_ss,pO2(idxt0,:),constants);

% Calculate ptn
ptn = sum(bsxfun(@times,wn,pO2),2);

% % This syntax is equivalent, but doesn't use bsxfun.
% ptn =   wn(1).*pO2(:,1) + wn(2).*pO2(:,2) + ...
%             wn(3).*pO2(:,3) + wn(4).*pO2(:,4);


end
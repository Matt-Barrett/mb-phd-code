function wn = calculate_min_dist(ptn,pO2,Constants)

% Pass static arguments to error function.
fun = @(x) errfun_dist(x,ptn,pO2,Constants);

% Initial guess (= baseline weights)
x0 = [Constants.ss.wPO2(1).*Constants.ss.wMean, ...
    (1-Constants.ss.wMean).*sum(Constants.ss.wPO2)];

% % For Debugging
% test1 = fun(x0);

% Set optimisation options;
options = optimset('Display','none');

% Find the point the smallest distance away from baseline.
[xOpt fval exitflag] = lsqnonlin(fun,x0,[],[],options);

% Throw an error/warning if exitflag is bad
if exitflag <= 0
    warning('CalcMinDist:BadExitOpt',['LSQNONLIN exited '...
        'with flag "%01.0f".'],exitflag)
end

% % For Debugging
% test2 = fun(xOpt);

% Assign output weights.
wn([1,4]) = [xOpt(1) xOpt(2)];
wn(3) = calc_w3(ptn,wn,pO2);
wn(2) = calc_w2(wn);

end

function residuals = errfun_dist(x,ptn,pO2,Constants)

wNew(1) = x(1);
wNew(4) = x(2);

% pa = pO2(1);
% pc = pO2(2);
% pv = pO2(3);
% p0 = pO2(4);

wOld(1:3) = Constants.ss.wMean.*Constants.ss.wPO2(1:3);
wOld(4) = 1-sum(wOld(1:3));
% % This is just to check that it's the same as above
% w_old(4) = (1-Constants.ss.weightMean).*sum(Params.compliance.V_ss(1:3));

wNew(3) = calc_w3(ptn,wNew,pO2);

wNew(2) = calc_w2(wNew);

residuals = wNew - wOld;

end

function w3 = calc_w3(ptn,wn,pO2)

% This equation assumes w2 = 1- w1 -w3 - w4) and forces the new weights to
% produce the desired new tissue PO2 value
w3 = (ptn - wn(1)*pO2(1) - (1-wn(1)-wn(4))*pO2(2) - wn(4)*pO2(4))./ ...
        (pO2(3)-pO2(2));

end

function w2 = calc_w2(wn)

w2 = 1 - sum(wn);

end
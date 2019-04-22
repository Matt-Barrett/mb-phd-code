function [constants params] = new_baseline_v2(constants,params,controls)

% Apply new femoral artery PO2
params.o2concin.cO2_in = PressureContent(constants.ss.pO2_raw2(1),[],...
    {'pressure','blood'},params.gas,controls);
constants.ss.cO2_raw2(1) = params.o2concin.cO2_in;

% Calculate new c01
constants.ss.cO2_raw2(2) = constants.ss.cO2_raw2(1) - params.main.c_leak;
constants.ss.pO2_raw2(2) = PressureContent(constants.ss.cO2_raw2(2),[],...
    {'content','blood'},params.gas,controls);

% Calculate new c34
constants.ss.cO2_raw2(5) = PressureContent(constants.ss.pO2_raw2(5),[],...
    {'pressure','blood'},params.gas,controls);

% Calculate new c23 from c3 and c34
constants.ss.pO2_raw2(4) = 2*constants.ss.pO2_mean2(3) - ...
    constants.ss.pO2_raw2(5);
constants.ss.cO2_raw2(4) = PressureContent(constants.ss.pO2_raw2(4),[],...
    {'pressure','blood'},params.gas,controls);

% Calculate new CMRO2
params.metabolism.CMRO2_ss = constants.ss.cO2_raw2(2) - ...
    constants.ss.cO2_raw2(5);

%%

% Setup initial guess (9 equations in 9 unknowns)
x0 = [...
    constants.ss.cO2_raw(2)*1.1;... c12
    constants.ss.pO2_mean(4)*1.1;...pt
    params.main.gO2';...            g1, g2, g3
    params.main.gO2_shunt;...       gs
    constants.ss.cO2_raw(1:2)';...  c12_old, c23_old
    constants.ss.pO2_mean(4)];...   pt_old 

% Setup error function with other parameters
fun = @(X) errfun(X,constants,params,controls);

% Solver options, including debugging versions
options = optimset('Display', 'none');
% options = optimset('MaxFunEvals',10000);
% options = optimset('TolFun',5E-3,'TolX',1E-3,'MaxFunEvals',10000);

% Solve nonlinear equations
[xOpt, fval, exitflag] = fsolve(fun, x0, options);

% Throw a warning if exitflag is bad
if exitflag <= 0
    warning('NewBaseline2:BadExitFSolve',['When calculating new '...
        'initial (baseline) conditions, FSOLVE exited with flag '...
        '"%01.0f".'],exitflag)
end

%%

% Apply new c12 and p12
constants.ss.cO2_raw2(3) = xOpt(1);
constants.ss.pO2_raw2(3) = PressureContent(constants.ss.cO2_raw2(3),[],...
    {'content','blood'},params.gas,controls);

% Apply new pt and ct
constants.ss.pO2_mean2(4) = xOpt(2);
constants.ss.cO2_mean2(4) = PressureContent(constants.ss.pO2_mean2(4),[],...
    {'pressure','tissue'},params.gas,controls);

% Apply new g1, g2, g3
params.main.gO2 = xOpt(3:5)';

% Apply new gs
params.main.gO2_shunt = xOpt(6);

% Apply new c12_old, c23_old 
constants.ss.cO2_raw(2:3) = xOpt(7:8);
constants.ss.pO2_raw(2:3) = PressureContent(constants.ss.cO2_raw(2:3),...
    [],{'content','blood'},params.gas,controls);

% Apply new pt_old
constants.ss.pO2_mean(4) = xOpt(9);
constants.ss.cO2_mean(4) = PressureContent(constants.ss.pO2_mean(4),...
    [],{'pressure','tissue'},params.gas,controls);

% Calculate new old c34 and p34
constants.ss.cO2_raw(4) = constants.ss.cO2_raw(1) - ...
    params.metabolism.CMRO2_ss;
constants.ss.pO2_raw(4) = PressureContent(constants.ss.cO2_raw(4),[],...
    {'content','blood'},params.gas,controls);

% Update mean values
calc_comp_means = @(po2_raw) [mean(po2_raw(1:2)), mean(po2_raw(2:3)),...
    mean(po2_raw(3:4))];
constants.ss.pO2_mean(1:3) = calc_comp_means(constants.ss.pO2_raw);
constants.ss.cO2_mean(1:3) = PressureContent(constants.ss.pO2_mean(1:3),...
    [],{'pressure','blood'},params.gas,controls);
constants.ss.pO2_mean2(1:3) = calc_comp_means(constants.ss.pO2_raw2);
constants.ss.cO2_mean2(1:3) = PressureContent(constants.ss.pO2_mean2(1:3),...
    [],{'pressure','blood'},params.gas,controls);

% Calculate the feasible range for gs
params.main.gO2_shunt_range = calc_gs_range(constants,params);

% Check for gs outside feasible range
isBadGs = (params.main.gO2_shunt < params.main.gO2_shunt_range(1)) || ...
    (params.main.gO2_shunt > params.main.gO2_shunt_range(2));
if isBadGs
    warning('NewBaseline:BadGs',['The shunt conduction coefficient is '...
        'outside the feasible range.'])
end

end

function kk = errfun(X_in,constants,params,controls)

fss = constants.ss.F_ss;

c01 = constants.ss.cO2_raw2(2);
p01 = constants.ss.pO2_raw2(2);

c12 = X_in(1,1);
p12 = PressureContent(c12,[],{'content','blood'},params.gas,controls);

c23 = constants.ss.cO2_raw2(4);
p23 = constants.ss.pO2_raw2(4);

c34 = constants.ss.cO2_raw2(5);

cmro2 = params.metabolism.CMRO2_ss;

p1 = mean([p01 p12]);
p2 = mean([p12 p23]);
p3 = constants.ss.pO2_mean2(3);
pt = X_in(2,1);

g1 = X_in(3,1);
g2 = X_in(4,1);
g3 = X_in(5,1);
gs = X_in(6,1);
go2 = [g1 g2 g3];

% Remember these values in order to compare them to the new ones
go2_old = params.main.gO2;
po2_old = constants.ss.pO2_mean;
cmro2_old = constants.ss.cO2_raw(1) - constants.ss.cO2_raw(4);

% The main equations at the new (higher) femoral artery PO2
kGas(1,1) = fss.*(c01-c12) - g1.*(p1-pt) - gs.*(p1-p3);
kGas(2,1) = fss.*(c12-c23) - g2.*(p2-pt);
kGas(3,1) = fss.*(c23-c34) - g3.*(p3-pt) + gs.*(p1-p3);

% ======================================================================= %
% The main equations at the modified Vovenko femoral artery PO2

c01o = constants.ss.cO2_raw(1);
c12o = X_in(7,1);
c23o = X_in(8,1);
c34o = c01o - cmro2;

p1o = mean(PressureContent([c01o c12o],[],{'content','blood'},...
    params.gas,controls));
p2o = mean(PressureContent([c12o c23o],[],{'content','blood'},...
    params.gas,controls));
p3o = mean(PressureContent([c23o c34o],[],{'content','blood'},...
    params.gas,controls));
pto = X_in(9,1);
po2o = [p1o p2o p3o pto];


kGasO(1,1) = fss.*(c01o-c12o) - g1.*(p1o-pto) - gs.*(p1o-p3o);
kGasO(2,1) = fss.*(c12o-c23o) - g2.*(p2o-pto);
kGasO(3,1) = fss.*(c23o-c34o) - g3.*(p3o-pto) + gs.*(p1o-p3o);

% ======================================================================= %
% Constrain the equations to use the same proportions of flux from each
% compartment as Vovenko

hFun = @(comp) ...
    go2(comp)*(po2o(comp) - po2o(end))/cmro2 - ...
    go2_old(comp)*(po2_old(comp) - po2_old(end))/cmro2_old;

kG(1) = hFun(1);
kG(2) = hFun(2);
kG(3) = hFun(3);

% ======================================================================= %

kk = [kGas; kG'; kGasO];

end

% ======================================================================= %

function gO2_shunt_range = calc_gs_range(constants,params)

params = calculate_gO2(constants,params);

gO2_shunt_range = params.main.gO2_shunt_range;

end

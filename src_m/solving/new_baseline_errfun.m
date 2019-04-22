function k = new_baseline_errfun(x,mode,constants,params,controls)

%% Assign input values

if ~mode.hasMeanArt
    constants.ss.cO2_raw2(3) = x(1);
    constants.ss.pO2_raw2(3) = PressureContent(constants.ss.cO2_raw2(3),[],...
        {'content','blood'},params.gas,controls);
    x = x(2:end);
end

if ~mode.hasMeanVei
    constants.ss.cO2_raw2(4) = x(1);
    constants.ss.pO2_raw2(4) = PressureContent(constants.ss.cO2_raw2(4),[],...
        {'content','blood'},params.gas,controls);
    x = x(2:end);
end

if mode.doC1223
    
    constants.ss.cO2_raw(2:3) = x(1:2);
    constants.ss.pO2_raw(2:3) = PressureContent(constants.ss.cO2_raw(2:3),[],...
        {'content','blood'},params.gas,controls);
    x = x(3:end);
    
    constants.ss.pO2_mean(1) = mean(constants.ss.pO2_raw(1:2));
    constants.ss.pO2_mean(2) = mean(constants.ss.pO2_raw(2:3));
    constants.ss.pO2_mean(3) = mean(constants.ss.pO2_raw(3:4));

end

if ~mode.hasMeanTis && ~mode.hasTis0

    constants.ss.pO2_mean2(end) = x(1);
    constants.ss.cO2_mean2(end) = PressureContent(...
        constants.ss.pO2_mean2(end),[],{'pressure','tissue'},...
        params.gas,controls);

else
    
    constants.ss.pO2_mean(end) = x(1);
    
end
                                        

%% Assign other params

fss = constants.ss.F_ss;
fssn = fss;

cmrO2 = params.metabolism.CMRO2_ss;
cmrO2n = cmrO2;

c01n = constants.ss.cO2_raw2(2);
c12n = constants.ss.cO2_raw2(3);
c23n = constants.ss.cO2_raw2(4);
c34n = constants.ss.cO2_raw2(5);

p1n = mean(constants.ss.pO2_raw2(2:3));
p2n = mean(constants.ss.pO2_raw2(3:4));
p3n = mean(constants.ss.pO2_raw2(4:5));

if ~mode.hasTis0
    ptn = constants.ss.pO2_mean2(end);
else
    ptn = calculate_pt([p1n p2n p3n],constants.ss.pO2_raw2(end),...
        constants.ss.wMean,constants.ss.wPO2);
end

if mode.doCalcGO2
    
    % We don't need to see this warning in the optimisation
    wngState = warning('off','CalculateGO2:NegativeGO2');
    warning('off','CalculateGO2:NoShunt')
    
    % Calculate the new gO2 values
    params = calculate_gO2(constants,params);
    
    % Restore the warning state
    warning(wngState);
    
end

g1 = params.main.gO2(1);
g2 = params.main.gO2(2);
g3 = params.main.gO2(3);
gs = params.main.gO2_shunt;

if mode.doOldEqs
    
    c01 = constants.ss.cO2_raw(1);
    c12 = constants.ss.cO2_raw(2);
    c23 = constants.ss.cO2_raw(3);
    c34 = constants.ss.cO2_raw(4);
    
    p1 = mean(constants.ss.pO2_raw(1:2));
    p2 = mean(constants.ss.pO2_raw(2:3));
    p3 = mean(constants.ss.pO2_raw(3:4));
    pt = constants.ss.pO2_mean(end);
    
end

%% The actual equations

if mode.doOldEqs
    
    k = zeros(1,8);
    
    k(1,5) = fss.*(c01-c12) - g1.*(p1-pt) - gs.*(p1-p3);
    k(1,6) = fss.*(c12-c23) - g2.*(p2-pt);
    k(1,7) = fss.*(c23-c34) - g3.*(p3-pt) + gs.*(p1-p3);
    k(1,8) = g1.*(p1-pt) + g2.*(p2-pt) + g3.*(p3-pt) - cmrO2;
    
else
    
    k = zeros(1,4);
    
end

k(1,1) = fssn.*(c01n-c12n) - g1.*(p1n-ptn) - gs.*(p1n-p3n);
k(1,2) = fssn.*(c12n-c23n) - g2.*(p2n-ptn);
k(1,3) = fssn.*(c23n-c34n) - g3.*(p3n-ptn) + gs.*(p1n-p3n);
k(1,4) = g1.*(p1n-ptn) + g2.*(p2n-ptn) + g3.*(p3n-ptn) - cmrO2n;

end
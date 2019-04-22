function k = ODEs_15i_flow(t,X,Xp,params,controls)

% Unbundle variables and derivatives
F = transpose(X(1:4,1));
V = transpose(X(5:7,1));

F_p = transpose(Xp(1:4,1));
V_p = transpose(Xp(5:7,1));

% Input pressure
if controls.pressure_type > 0
    P = params.pressure.P_ss + params.pressure.fhandle(t,params.pressure);
else
    P = params.pressure.P_ss;
end;

% Stimulus
S  = zeros(size(V));

doVaso = (controls.vasodilation_type > 0);
if controls.vasodilation_type ~= 7
    doVaso = doVaso && (t > params.vasodilation.t0);
else
    doVaso = doVaso && (t > params.vasodilation.step.t0);
end

if doVaso
    S(1) = params.vasodilation.fhandle(t,params.vasodilation);
else
    S(1) = 0;
end;

C = linear_compliance(V,V_p,S,params.compliance,controls);

% Equations
k(1,1) = P - (1/C(1))*V(1)...
    - 0.5*(...
        F(1)*(params.main.l(1)^3)/(V(1)^2)...
    );   
k(2,1) = P - (1/C(2))*V(2)...
    - 0.5*(...
        F(1)*((params.main.l(1)^3)/(V(1)^2))...
      + F(2)*((params.main.l(1)^3)/(V(1)^2) + (params.main.l(2)^3)/(V(2)^2))...
    );    
k(3,1) = P - (1/C(3))*V(3)...
    - 0.5*(...
        F(1)*((params.main.l(1)^3)/(V(1)^2))...
      + F(2)*((params.main.l(1)^3)/(V(1)^2) + (params.main.l(2)^3)/(V(2)^2))...
      + F(3)*((params.main.l(2)^3)/(V(2)^2) + (params.main.l(3)^3)/(V(3)^2))...
    );
k(4,1) = P...
    - 0.5*(...
        F(1)*((params.main.l(1)^3)/(V(1)^2))...
      + F(2)*((params.main.l(1)^3)/(V(1)^2) + (params.main.l(2)^3)/(V(2)^2))...
      + F(3)*((params.main.l(2)^3)/(V(2)^2) + (params.main.l(3)^3)/(V(3)^2))...
      + F(4)*((params.main.l(3)^3)/(V(3)^2))...
    );
k(5,1) = V_p(1) - F(1) + F(2);
k(6,1) = V_p(2) - F(2) + F(3);
k(7,1) = V_p(3) - F(3) + F(4);

return;
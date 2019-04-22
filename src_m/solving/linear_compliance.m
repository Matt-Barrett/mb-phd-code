function C = linear_compliance(V,Vp,S,params,controls)

if numel(params.V_ss) > 3
    params.V_ss = params.V_ss(1:3);
end;

[C_st_lin C_dyn_lin] = compliance(V,Vp,S,params);

C = controls.volume_dep.*C_st_lin + ~controls.volume_dep;

C = C - controls.visco.*C_dyn_lin;

C = params.C_ss.*C;

end

function [C_st_lin C_dyn_lin] = compliance(V,Vp,S,params)

C_st_lin = -1./(params.V_ss.*(params.kappa-1)).*V + ...
    params.kappa./(params.kappa-1) + S;

if nargout > 1
    C_dyn_lin = params.nu.*Vp;
end;

end
function Params = assign_optvals(type,optVals,Params)

% TODO: Check that length of optVals matches required number

switch type
    case 6 % levystim
        
        Params.t_rise = optVals(1);
        Params.A_peak = optVals(2);
        Params.A_ss = optVals(3);
        Params.tau_active = optVals(4);
        Params.tau_passive = optVals(5);
        
    case 9 % pulse_exp
        
        Params.t_rise = optVals(1);
        Params.A_ss = optVals(2);
        Params.tau_passive = optVals(3);
        
    otherwise
        
        warning('AssignOptvals:UnknownType','Unknown Stimulus type %d',...
            type)
        
end

end
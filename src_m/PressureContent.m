function [O2_out CO2_out] = PressureContent(O2_in,CO2_in,type,params,controls)

% THIS FUNCTION ASSUMES THE LAST O2_IN CORRESPONDS TO THE TISSUE
% COMPARTMENT

% type{1}
% content   pressure = f(content)... corresponds to function(1)
% pressure  content = f^-1(pressure)... corresponds to function(2)
% type{2}
% 1...4     the compartment number (art = 1... tissue = 4)
% all       all compartments

% Determine function direction
if strcmp(type{1},'content')
    funct_dir = 1; % forward
elseif strcmp(type{1},'pressure')
    funct_dir = 2; % inverse
end;

% Determine function name, params and evaluate output
   
if strcmpi(type{2},'all')
    
    O2_out = hill(O2_in(1:end-1),funct_dir,params.hill);
    O2_out(end+1) = henry(O2_in(end),funct_dir,params.zeta_O2_tissue);
      
else

    if strcmpi(type{2},'blood')

        O2_out = hill(O2_in,funct_dir,params.hill);

    elseif strcmpi(type{2},'tissue')
        
        O2_out = henry(O2_in,funct_dir,params.zeta_O2_tissue);
        
    else
        
        % unknown method
        error('PressureContent:UnknownType',['Unknown type: use "blood" '...
            'or "tissue"'])
        
    end

end;

end

function result = henry(input,dir,zeta)

if dir == 1
    result = input.*zeta;
elseif dir == 2
    result = input./zeta;
else
    % shit
end
    

end

function result = hill(input,dir,params)

if dir == 1
    result = params.phi.*(params.chi.*(1./input) - 1).^(-1/params.h);
elseif dir == 2
    result = params.chi./(1 + (params.phi./input).^params.h);
else
    % shit
end

end

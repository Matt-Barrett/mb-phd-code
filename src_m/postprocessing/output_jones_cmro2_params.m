function output_jones_cmro2_params(Override)

sims = strcat('jones2002_', {'04', '08', '12', '16'}, '_cmro2_adj');
nSims = length(sims);

params = {'t_rise', 'A_ss', 'tau_passive'};
nParams = length(params);
params_table = zeros(nSims, nParams);

for iSim = 1:nSims
    for jParam = 1:nParams
        params_table(iSim, jParam) = ...
            Override.(sims{iSim}).metabolism.(params{jParam});
    end    
end

end
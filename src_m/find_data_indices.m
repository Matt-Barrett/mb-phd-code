function idx = find_data_indices(sim_list,req_sim)

idx = zeros(size(req_sim));

for i = 1:length(req_sim)
    try
        idx(i) = find(ismember(sim_list,req_sim{i})==1);
    catch
        idx(i) = NaN;
        warning('FindDataIndices:CouldntFind',['Couldn''t find '...
            'simulation "%s"'],req_sim{i})
    end
end;

return
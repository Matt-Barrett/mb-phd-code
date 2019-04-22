function [StatsOpt StatsFull StatsStd StatsMean StatsMed] = ...
                                                process_stats(StatsFull)

order = [3 2 1];
list = fieldnames(StatsFull);

for iField = list'
    
    StatsFull.(iField{:}) = permute(StatsFull.(iField{:}),order);
    StatsOpt.(iField{:}) = StatsFull.(iField{:})(1,:);
    StatsStd.(iField{:}) = std(StatsFull.(iField{:}),0,1);
    StatsMean.(iField{:}) = mean(StatsFull.(iField{:}),1);
    StatsMed.(iField{:}) = median(StatsFull.(iField{:}),1);
    
end

end
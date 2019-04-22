function make_tex_tables(StatsOpt,StatsStd,varargin)


isStats = false;
if nargin > 2
    isStats = varargin{1};
end

var = {'F','V','D','u'};
var_name = {'Flow','Volume','Diameter','Velocity'};
idx = {5,1:4,1:3,1:3};
idx_name = {'Art.','Cap.','Ven.','Total','Total'};
metric = {'peak_norm','ttp','t50_up','t50_down'};
% metric = {'peak_norm','ttp','tau_up','tau_down'};
sim = {2:3,2:3,4:6,4:6};

if ~isStats
    numFormat = '%3.1f(%2.1f)';
else
%     numFormat = '%1.0f(%3.3f)'; % old
    sig = {'n.s.','*','**','***'};
    numFormat = '%s'; % new
end

% Produce additional tables
make_alpha_table(StatsOpt,StatsStd,isStats)
make_art_contr_table(StatsOpt,StatsStd,isStats)

fprintf('\n')

for iVar = 1:length(var)
    
    % Start each variable with a title.
    fprintf(['\t\\emph{' var_name{iVar} '} & & & & \\\\\n'])
    
    for jIdx = 1:length(idx{iVar})
        
        % Start each line with a tab and space
        fmt_str = ['\t\\quad ' idx_name{idx{iVar}(jIdx)} ' & '];
        var_str = '';
        
        for kMetric = 1:length(metric)
            
            % insert & for each new cell
            if kMetric ~= 1, fmt_str = [fmt_str ' & ']; end
            
            for l = 1:length(sim{iVar})
                
                % Insert / to divide simulations
                if l ~= 1, fmt_str = [fmt_str '/']; end
                
                fmt_str = [fmt_str numFormat];
                
                var_type = {'StatsOpt','StatsStd'};
                var_idx = [ '(sim{iVar}(' num2str(l) ')).' var{iVar} ...
                    '.' metric{kMetric} '(idx{iVar}(jIdx))'];
                
                if ~isStats
                    var_str = [var_str var_type{1} var_idx ',' ...
                        var_type{2} var_idx];
                else
                    % This doesn't show the p-values.  Revert to the format
                    % above to display them.
                    var_str = [var_str 'sig{' var_type{1} var_idx '+1}'];
                end
                
                if ~(l == length(sim{iVar}) && kMetric == length(metric))
                    var_str = [var_str ','];
                end
                
            end
            
            % insert \\ for new line
            if kMetric == length(metric), fmt_str = [fmt_str ' \\\\\n'];end
            
        end
        
        % print line
        str = ['fprintf(''' fmt_str ''',' var_str ')'];
        eval(str)
        
    end
end

fprintf('\n')

end

% ----------------------------------------------------------------------- %

function make_alpha_table(StatsOpt,StatsStd,isStats)

labels = {'Art.','Cap. + Vei.','Total'};
idx = [1 5 4];

if ~isStats
    numFormat = '%4.3f(%4.3f)';
else
    numFormat = '%1.0f(%3.4f)';
end

fprintf('\n')

for iIdx = 1:length(labels)
    
    isZero = StatsOpt(1).alpha(idx(iIdx)) <= 0.001;
    if isZero
        StatsOpt(1).alpha(idx(iIdx)) = 0;
    end
    
    str1 = sprintf(['\t%s & ' numFormat ' \\\\'],labels{iIdx},...
        StatsOpt(1).alpha(idx(iIdx)),StatsStd(1).alpha(idx(iIdx)));
    disp(str1)
    
end

fprintf('\n')

end

% ----------------------------------------------------------------------- %

function make_art_contr_table(StatsOpt,StatsStd,isStats)

if ~isStats
    numFormat = '%4.3f(%4.3f)';
else
    return
end

labels = {'Art.','Cap.','Vei.'};
compartments = 1:3;
sims = [2,3];

fprintf('\n')

for iComp = compartments
    for jSim = sims
        
        % Display title for first colum
        if jSim == sims(1)
            fprintf('\t%s & ',labels{iComp})
        end
        
        fprintf(numFormat,StatsOpt(jSim).V.peak_contrib(iComp),...
            StatsStd(jSim).V.peak_contrib(iComp))
        
        if jSim < sims(end)
            % Display divider for different simulations
            fprintf('/')
        else
            % Display end of line
            fprintf(' \\\\\n')
        end
        
        
    end
end

fprintf('\n')

end
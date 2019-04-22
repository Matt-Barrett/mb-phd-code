function [default override history composite] = full_run(varargin)

% varargin{1}   problem   
% varargin{2}   repeats   
% varargin{3}   default   
% varargin{4}   override
% varargin{5}   filename

% Add the path if it doesn't exist already
add_src_path('./src_m');

if nargin == 0
    
    problem = {'jones2002_16_cbf'};
    repeats = {1};
    sim_list= {'jones2002_1.6'};
    fig_list = {'jones2002_1.6'};
    default = default_properties;
    override = struct();
    filename = './simulations/full_run/jones_16_002';
    doDebug = false;
        
else
    
    if nargin > 6
        [problem repeats default override ...
            filename sim_list fig_list] = varargin{1:7};
        if nargin > 7
            doDebug = varargin{8};
        else
            doDebug = false;
        end
    else
        disp(' ')
        disp('*************** Wrong number of arguments! ***************')
        disp(' ')
        return
    end
    
end

stages = length(problem);

% Warn if debug mode is enabled
warn_debug(dbstack,mfilename,doDebug)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step through the stages sequentially and...

for i = 1:stages
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % A - Explore  Param Space
    % as necessary
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % B - Optimise (repeating from different starting values)
    for j = 1:repeats{i}
        
        % reduce the tolerances in optimisation steps
        
        % run optimisation
        % modify this to give 'verbose' option?
        history{i}(j) = find_params(problem{i},default(i),[filename...
            '_' num2str(i) '_' problem{i} ''],override,doDebug);
        
        % Save in current format and tidy up messy internally-created files
        if i == 1 && j == 1
            filename = checkfilename(filename);
            filename = filename(1:end-4);
        end
        save(filename)
        fprintf('Saved %s\n',filename);
        
        if history{i}(j).exitflag >= -1
            
            fnPost = [history{i}(j).filename '_post.mat'];
            delete(fnPost)
            fprintf('deleted %s\n\n',fnPost)
            
        elseif history{i}(j).exitflag < -1
            
            fnError = [history{i}(j).filename '_error.mat'];
            delete(fnError)
            fprintf('deleted %s\n\n',fnError)
            
        end
        
        fprintf('Finished repeat %d of %d\n',j,repeats{i});
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % C - Post Process and update defaults for next stage
    [default(i+1) composite{i} override] = process_optimal(history{i},...
                                        problem{i},repeats{i},override);
    
    disp('Sorted results (composite):')
    disp(num2str(composite{i}))
    disp(' ')
    
    % save before starting next stage
    save([filename '.mat']) 
    disp(['Saved '  filename])
    
    disp(['Finished ' problem{i}])
    disp(' ')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp(' ')
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run default simulations (send newly optimised defaults)
try
    default_simulations(default(stages+1),sim_list,fig_list,[],[],override);
catch ME
    warning('FullRun:ErrorInDefaultSims',['An error occured running '...
        'the default simulations.  Error details follow this warning.'])
    report = getReport(ME);
    disp(report)
end

end

function [DefaultOut Override] = oxygen_complete(varargin)

% Need to make intermediary filenames less shitty (with multiple .mats)
% Need to create a version of this for blood flow (i.e. for first paper)

% Default
% Override
% filename

% Add the path if it doesn't exist already
add_src_path('./src_m');

%% Input Processing

nArgs = nargin;

validDefault = (nArgs > 0) && ~isempty(varargin{1});
if validDefault
    Default = varargin{1};
else
    Default = default_properties;
end

validOverride = (nArgs > 1);
if validOverride
    Override = varargin{2};
else
    Override = [];
end

validFilename = (nArgs > 2) && ~isempty(varargin{3}) && ...
    isdir(fileparts(varargin{3}));
if validFilename
    filename = varargin{3};
else
    filenameNum = '_vX_TEST';
    filename = ['./simulations/full_run/oxygen' filenameNum];
end

validStartFrom = (nArgs > 3) && isscalar(varargin{4}) && (varargin{4} > 0);
if validStartFrom
    startFrom = varargin{4};
else
    startFrom = 1;
end

doDebug = false;
% doDebug = true;
validDebug = (nArgs > 4) && isscalar(varargin{5}) && islogical(varargin{5});
if validDebug
    doDebug = varargin{5};
end

%% Stage 1

sol(1).problem = {...
        'vazquez2008_cbf_baseline',...
        'vazquez2008_cbf_control',...
        'vazquez2008_cbf_dilated',...
        'vazquez2010_cbf'};
sol(1).repeats = {3, 5, 3, 5};
% sol(1).repeats = {2, 20, 3, 20}; % lsq
sol(1).sim_list = {};
sol(1).fig_list = {};
sol(1).filename = [filename '_o2_cbfs'];

%% Stage 2

sol(2).problem = {...
        'vazquez2008_pto2_cap',...
        'vazquez2008_pto2_nomech',...
        'vazquez2008_pto2_leak',...
        'vazquez2008_pto2_p50',...
        'vazquez2008_pto2_all'};
sol(2).repeats = {4, 4, 4, 4, 4};
% sol(2).repeats = {5, 5, 5, 5, 5}; % lsq
sol(2).sim_list = {...
    'vazquez2008_control',...
    'vazquez2008_vasodilated',...
    'vazquez2008_control_cap',...
    'vazquez2008_vasodilated_cap'};
sol(2).fig_list = {...
    'vazquez2008_main'};
sol(2).filename = [filename '_vazquez2008'];

%% Stage 3

sol(3).problem = {...
        'vazquez2010_pto2_cap',...
        'vazquez2010_pto2_nomech',...
        'vazquez2010_pto2_leak',...
        'vazquez2010_pto2_p50',...
        'vazquez2010_pto2_all'};
sol(3).repeats = {4, 4, 4, 4, 4};
% sol(3).repeats = {5, 5, 5, 5, 5}; % lsq
sol(3).sim_list = {...
    'vazquez2010_cap',...
    'vazquez2010'};
sol(3).fig_list = {...
    'vazquez2010_main'};
sol(3).filename = [filename '_vazquez2010'];

%% Solve the complete set of stages

% Warn if debug mode is enabled
warn_debug(dbstack,mfilename,doDebug)

[DefaultOut Override] = complete_stages(sol,Default,Override,...
                                        filename,startFrom,doDebug);

end



function [DefaultOut Override] = hb_complete(varargin)

% Need to make intermediary filenames less shitty (with multiple .mats)
% Need to create a version of this for blood flow (i.e. for first paper)

% Default
% Override
% filename
% startFrom

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
    filenameNum = '_v1_002';
    filename = ['./simulations/full_run/hb' filenameNum];
end

validStartFrom = (nArgs > 3) && isscalar(varargin{4}) && (varargin{4} > 0);
if validStartFrom
    startFrom = varargin{4};
else
    startFrom = 1;
end

doDebug = false;
hasDoDebug = (nArgs > 4) && ~isempty(varargin{5});
if hasDoDebug
    doDebug = varargin{5};
end

%% Stage 1

sol(1).problem = {...
        'jones2002_04_cbf',...
        'jones2002_08_cbf',...
        'jones2002_12_cbf',...
        'jones2002_16_cbf'};
sol(1).repeats = {10, 10, 10, 10};
sol(1).sim_list = {};
sol(1).fig_list = {};
sol(1).filename = [filename '_cbfs'];

%% Stage 2

sol(2).problem = {...
        'jones2002_04_hb_adj',...
        'jones2002_08_hb_adj',...
        'jones2002_12_hb_adj',...
        'jones2002_16_hb_adj'};
sol(2).repeats = {3, 3, 3, 3};
sol(2).sim_list = {'jones2002_04_adj','jones2002_08_adj',...
    'jones2002_12_adj','jones2002_16_adj'};
sol(2).fig_list = {'jones2002_04','jones2002_08',...
    'jones2002_12','jones2002_16'};
sol(2).filename = [filename '_hb_adj'];

%% Stage 3

sol(3).problem = {...
        'jones2002_04_hb_raw',...
        'jones2002_08_hb_raw',...
        'jones2002_12_hb_raw',...
        'jones2002_16_hb_raw'};
sol(3).repeats = {3, 3, 3, 3};
sol(3).sim_list = {'jones2002_04_raw','jones2002_08_raw',...
    'jones2002_12_raw','jones2002_16_raw'};
sol(3).fig_list = {'jones2002_04','jones2002_08',...
    'jones2002_12','jones2002_16'};
sol(3).filename = [filename '_hb_raw'];

%% Solve the complete set of stages

% Warn if debug mode is enabled
warn_debug(dbstack,mfilename,doDebug)

[DefaultOut Override] = complete_stages(sol,Default,Override,...
                                        filename,startFrom,doDebug);

end

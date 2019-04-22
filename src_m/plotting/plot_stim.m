function [H_axes rows columns] = plot_stim(P, varargin)

doPsFrag = false;
if nargin > 1 && ~ isempty(varargin{1})
    doPsFrag = varargin{1};
end

% % list of paths to add
% [junkDir Dir] = fileparts(pwd);
% if strcmpi(Dir,'plotting')
%     newPathArray = {'../','../solving/stimulations'};
% elseif strcmpi(Dir,'bin')
%     newPathArray = {'./solving/stimulations'};
% else
%     newPathArray = {'./bin','./bin/solving/stimulations'};
% end
% % save current path and add new paths
% pathExisting = path; addpath(newPathArray{:})

% Create P if it doesn't already exist
isP = exist('P','var') && ~isempty(P) && isstruct(P);
if ~isP, P = plot_results; end


% Set the stimulus parameters.
params.t0 = 5;
params.t_rise = 3;
params.tau_active = 3;
params.tau_passive = 1;
params.A_peak = 1;
params.A_ss = 0.45;

% Set the 3 stimulations lengths.
t_stim = [params.t_rise+0.5 9 30];

% Produce stimulus values for the 3 stimulations lengths.
n = 201; max_t = 50;
t = linspace(0,max_t,n);
for i = 1:length(t_stim)
    params.t_stim = t_stim(i);
    s(i,:) = levystim(t,params);
end

% Extract the value where middle stimulus ends.
idx = (params.t0+t_stim(2))/(max_t/(n-1))+1;

% Setup function for plotting text
plotText = @(x,y,string) text(x,y,string,'FontSize',P.Axes.FontSize,...
                                'FontName',P.Axes.FontName);
                            
if ~doPsFrag
    labelsStr = {'\tau_{up}', '\tau_{decay}', '\tau_{down}', ...
        {'t_0','t_{max}','t_{end}'}, {'s^*','s_{max}'}};
else
    labelsStr = {'tauup', 'taudecay', 'taudown', ...
        {'t0x','tmax','tend'}, {'ssta','smax'}};
end

% plot
axis_tol = [1.3 1.1];
labelY = sprintf('Stimulus Value (a.u.)\n');
labelX = sprintf('\nTime (a.u.)');
rows = 1; columns = 1;
figure
    H_axes = axes;
        hold on
            l(1) = plot([0 params.t0+params.t_rise],params.A_peak.*ones(1,2));
            l(2) = plot([0 params.t0+t_stim(3)],params.A_ss.*ones(1,2));
            l(3) = plot((params.t0+t_stim(2)).*ones(1,2),[0 s(2,idx)]);
            l(4) = plot((params.t0+params.t_rise).*ones(1,2),[0 params.A_peak]);
            plotText(0.7*params.t0,0.6*params.A_peak,labelsStr{1});
            plotText(params.t0+params.t_rise+params.tau_active,...
                mean([params.A_peak params.A_ss]),labelsStr{2});
            plotText(params.t0+t_stim(2)+1.5*params.tau_passive,...
                0.5*params.A_ss,labelsStr{3});
            plot(t,s([1,3],:),'Color',P.Misc.greyLine,'LineWidth',P.Misc.widthLine) % 1st and 3rd stimulus
            plot(t,s(2,:),'k-','LineWidth',P.Misc.widthLine) % 2nd stimulus
            axis([0 (params.t0 + max(t_stim))*axis_tol(1) 0 params.A_peak*axis_tol(2)])
            ylabel(labelY,'FontSize',P.Misc.sizeFontStrong,'FontWeight',P.Misc.weightFontStrong)
            xlabel(labelX,'FontSize',P.Misc.sizeFontStrong,'FontWeight',P.Misc.weightFontStrong)
            set(gca,'XTick',[params.t0,params.t0+params.t_rise,params.t0+t_stim(2)],...
                'YTick',[params.A_ss,params.A_peak]);
            format_ticks(gca,labelsStr{4},labelsStr{5},...
                [],[],[],[],[],'FontSize',P.Axes.FontSize,...
                'FontName',P.Axes.FontName);
            set(l,'LineStyle','--','Color',P.Misc.greyLine)
        hold off

% % restore old path
% path(pathExisting);

end

function Pout = plot_results(constants,params,controls,data,...
                                fig,sim_list,varargin)

% Extract properties from seperate function.
P = setup_properties;

% If fig is not specified, assume we want the properties only, and return.
isFigSpecified = exist('fig','var') && ~isempty(fig);
if ~isFigSpecified
    if nargout > 0
        Pout = P;
    end
    return
end

% Process additional input arguments
if nargin > 6
    format = varargin{1};
    doSave = true;
    if nargin > 7
        filename = varargin{2};
    else
        filename = [P.Misc.fn_root fig];
    end
else
    doSave = false;
end

% Create subaxis in case it isn't produced in the figure
subaxis = [];

switch lower(fig)
    
    case 'bank_horizontal'
        
        doHorizontal = true;
        [H_axes rows columns] = bank_compliance(P,doHorizontal);
        
    case 'bank_thesis'
        
        doHorizontal = true;
        doPsFrag = true;
        [H_axes rows columns] = bank_compliance(P,doHorizontal,[],doPsFrag);
        
    case 'bank_vertical'
        
        [H_axes rows columns] = bank_compliance(P);
        
    case 'baseline_po2'
        
        [H_axes rows columns] = baseline_PO2(P,sim_list,constants,...
                                                params,controls,data);
                                            
        P.Misc.ratio = 1.3;
    
    case 'brain2011_poster'
        
        [H_axes rows columns subaxis] = brain2011('bottom_up',sim_list,...
                                        constants,params,controls,data);
                                    
    case {'bottomup_combined'}
        
        P.Misc.paperSizeMultiple = 3;
        isDown = false;
        
%         P.Misc.sizeFontStrong = 18;
%         P.Axes.FontSize = 14;
        
        correctionFactor1 = sqrt(1.5);
        correctionFactor2 = 1.1;
        P.Misc.sizeFontStrong = P.Misc.sizeFontStrong.*correctionFactor1;
        P.Misc.sizeFontLabel = P.Misc.sizeFontLabel.*correctionFactor1;
        P.Axes.FontSize = P.Axes.FontSize.*correctionFactor2;
        P.Subaxes.FontSize = P.Subaxes.FontSize.*correctionFactor2;
        
        [H_axes rows columns subaxis] = dilation_combined(P,sim_list,...
                                    data,constants,params,controls,isDown);
                                
	case 'calcinaghi2011'
               
        load calcinaghi2011
        ExpData = Calcinaghi2011;
        PlotData.title = 'Calcinaghi et al. (2011)';
        PlotData.req_sim = {'calcinaghi2011'};
        PlotData.axis = [-2 9 0.962 1.078];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
        
    case {'cmro2_phase'}
        
        [H_axes rows columns] = cmro2_phase(P,sim_list,data,params);
                                
    case {'devor_dynamic'}
        
        [H_axes rows columns] = devor_dynamic(P,sim_list,data,constants);
    
    case {'devor_static'}
        
        [H_axes rows columns] = devor_static(P,sim_list,data,constants);
                                
    case 'diameter_comp'
        
        [H_axes rows columns] = diameter_comp(P,sim_list,data);
        
    case 'dunn2003'
               
        load dunn2003
        ExpData = Dunn2003(1);
        PlotData.name = fig;
        PlotData.title = 'Dunn et al. (2003)';
        PlotData.req_sim = {'dunn2003'};
        PlotData.axis = [0 10 0.97 1.07];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
        
    case 'dunn2005_fp'
               
        load dunn2005
        ExpData = Dunn2005(1);
        PlotData.name = fig;
        PlotData.title = 'Dunn et al. (2005) - Forepaw';
        PlotData.req_sim = {'dunn2005_fp_adj','dunn2005_fp_raw'};
        PlotData.axis = [-1 12 0.92 1.15];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
        
    case 'dunn2005_w'
               
        load dunn2005
        ExpData = Dunn2005(2);
        PlotData.name = fig;
        PlotData.title = 'Dunn et al. (2005) - Whisker';
        PlotData.req_sim = {'dunn2005_w_adj','dunn2005_w_raw'};
        PlotData.axis = [-1 12 0.965 1.075];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
                                    
    case 'flow_diameter_comp'
        
        [H_axes rows columns] = flow_diameter_comp(P,sim_list,data);
               
    case 'flow_diameter_comp2'
        
        [H_axes rows columns] = flow_diameter_comp2(P,sim_list,data);
        
    case 'flow_diameter_comp3'
        
        [H_axes rows columns subaxis] = flow_diameter_comp3(P,sim_list,data);
        
    case {'flow_volume_loop'}
        
        [H_axes rows columns] = flow_volume_loop(P,sim_list,data,...
                                                constants,params,controls);
                
    case {'flow_volume_loop2'}
        
        [H_axes rows columns] = flow_volume_loop2(P,sim_list,data,...
                                                constants,params,controls);
        
    case 'flow_volume_loop3'
        
        [H_axes rows columns] = flow_volume_loop3(P,sim_list,data,...
                                            constants,params,controls);
                
    case 'flow_volume_loop4'
        
        [H_axes rows columns] = flow_volume_loop4(P,sim_list,data,...
                                            constants,params,controls);
                                        
    case 'hb_conc'
        
        [H_axes rows columns] = hb_conc(P,sim_list,data,params);
        
    case {'hoge1999_01_ghc_top', 'hoge1999_02_ghc_top', ...
          'hoge1999_03_ghc_top', 'hoge1999_04_ghc_top', ...
          'hoge1999_01_ghc_bottom', 'hoge1999_02_ghc_bottom', ...
          'hoge1999_03_ghc_bottom', 'hoge1999_04_ghc_bottom'}
        
        load hoge1999
        idxData = strcmp({Hoge1999(:).name}, fig); 
        ExpData = Hoge1999(idxData);
        PlotData.name = fig;
        PlotData.title = fig;
        PlotData.req_sim = {fig};
        PlotData.axis = [-30 300 NaN NaN];
        
        [H_axes rows columns] = exp_bold(P, sim_list, data, constants, ...
            ExpData, PlotData);
                                        
    case {'inertia_main'}
        
        [H_axes rows columns] = inertia_main(P,sim_list,data);
                    
    case {'inertia_main_2'}
        
        [H_axes rows columns] = inertia_main_2(P,sim_list,data);
        
    case {'jones2002_04'}
        
        load jones2002
        idx04 = find(strcmp({Jones2002(:).name}, '0.4mA')); 
        ExpData = Jones2002(idx04);
        PlotData.name = fig;
        PlotData.title = 'Jones et al. (2002) - 0.4mA';
        PlotData.req_sim = {'jones2002_04_adj','jones2002_04_raw'};
        PlotData.axis = [-10 40 0.98 1.045];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
        
    case {'jones2002_08'}
        
        load jones2002
        idx08 = find(strcmp({Jones2002(:).name}, '0.8mA'));
        ExpData = Jones2002(idx08);
        PlotData.name = fig;
        PlotData.title = 'Jones et al. (2002) - 0.8mA';
        PlotData.req_sim = {'jones2002_08_adj','jones2002_08_raw'};
        PlotData.axis = [-10 40 0.88 1.24];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
        
    case {'jones2002_12'}
        
        load jones2002
        idx12 = find(strcmp({Jones2002(:).name}, '1.2mA')); 
        ExpData = Jones2002(idx12);
        PlotData.name = fig;
        PlotData.title = 'Jones et al. (2002) - 1.2mA';
        PlotData.req_sim = {'jones2002_12_adj','jones2002_12_raw'};
        PlotData.axis = [-10 40 0.84 1.39];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
        
    case {'jones2002_16'}
        
        load jones2002
        idx16 = find(strcmp({Jones2002(:).name}, '1.6mA')); 
        ExpData = Jones2002(idx16);
        PlotData.name = fig;
        PlotData.title = 'Jones et al. (2002) - 1.6mA';
        PlotData.req_sim = {'jones2002_16_adj','jones2002_16_raw'};
        PlotData.axis = [-10 40 0.82 1.61];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
        
    case {'jones2002_co2_5'}
        
        load jones2002
        idx16 = find(strcmp({Jones2002(:).name}, 'co2_5')); 
        ExpData = Jones2002(idx16);
        PlotData.name = fig;
        PlotData.title = 'Jones et al. (2002) - 5% CO2';
        PlotData.req_sim = {'jones2002_co2_5'};
        PlotData.axis = [-20 180 0.85 1.29];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
        
    case {'jones2002_co2_10'}
        
        load jones2002
        idx16 = find(strcmp({Jones2002(:).name}, 'co2_10')); 
        ExpData = Jones2002(idx16);
        PlotData.name = fig;
        PlotData.title = 'Jones et al. (2002) - 10% CO2';
        PlotData.req_sim = {'jones2002_co2_10'};
        PlotData.axis = [-20 180 0.6 2];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
        
    case 'jones2002_cmro2'
        
        P.Fig.PaperUnits = 'centimeters';
        P.Misc.widthText = 15;
        P.Misc.ratio = 0.9;
        
        [H_axes rows columns] = jones2002_cmro2(P,sim_list,data);
        
    case 'jones2002_cmro2_mod'
        
        P.Fig.PaperUnits = 'centimeters';
        P.Misc.widthText = 15;
        P.Misc.ratio = 0.9;
        
        [H_axes rows columns] = jones2002_cmro2_mod(P,sim_list,data);
        
    case 'jones2002_hb'
        
        P.Fig.PaperUnits = 'centimeters';
        P.Misc.widthText = 15;
        
        isSupp = false;
        doCMRO2 = false;
        [H_axes rows columns] = jones2002_hb(P,sim_list,data, isSupp, doCMRO2);
        
    case 'jones2002_hb_all'
        
        P.Fig.PaperUnits = 'centimeters';
        P.Misc.widthText = 20;
        P.Misc.ratio = 1.2;
        
        isSupp = false;
        doCMRO2 = true;
        [H_axes rows columns] = jones2002_hb(P,sim_list,data, isSupp, ...
            doCMRO2);
        
    case 'jones2002_hb_supp'
        
        P.Fig.PaperUnits = 'centimeters';
        P.Misc.widthText = 15;
        
        isSupp = true;
        doCMRO2 = false;
        [H_axes rows columns] = jones2002_hb(P, sim_list, data, isSupp, doCMRO2);
        
        
    case {'leithner2010_main'}
        
        [H_axes rows columns] = leithner2010_main(P,sim_list,data,...
                                                    constants);
                                                
    case {'loop_cbf'}
        
        isFlow = true;
        [H_axes rows columns] = loop_hb(P, sim_list, data, constants, ...
            params, controls, isFlow);
        
    case {'loop_cmro2'}
        
        isFlow = false;
        [H_axes rows columns] = loop_hb(P, sim_list, data, constants, ...
            params, controls, isFlow);
        
    case {'mandeville1999_main'}
        
        [H_axes rows columns] = mandeville1999_main(P,sim_list,data);
                
    case {'mandeville1999_poster'}
        
        [H_axes rows columns] = mandeville1999_poster(P,sim_list,data);        
                
    case {'mandeville1999_poster_err'}
        
        [H_axes rows columns] = mandeville1999_poster_err(P,sim_list,data);
        
    case {'o2_flux_comparison'}
        
        [H_axes rows columns] = o2_flux_comparison(P,sim_list,data,...
                                                    constants,params);
                                                
    case {'o2_hb_sat'}
        
        [H_axes rows columns] = o2_hb_sat(P,constants,params,controls);
                                                
    case {'prob_dist'}
        
        [H_axes rows columns] = prob_dist(P,sim_list,data,constants);
        
    case {'royl2008'}
        
        load royl2008
        ExpData = Royl2008;
        PlotData.name = fig;
        PlotData.title = 'Royl et al. (2008)';
        PlotData.req_sim = {'royl2008'};
        PlotData.axis = [-5 30 0.96 1.135];
        
        [H_axes rows columns] = exp_hb(P,sim_list,data,constants,ExpData,PlotData);
        
    case {'stimulus'}
        
        [H_axes rows columns] = plot_stim(P);
        
    case {'stimulus_thesis'}
        
        doPsFrag = true;
        [H_axes rows columns] = plot_stim(P, doPsFrag);
        
    case 'test_cmro2'
        
        P.Fig.PaperUnits = 'centimeters';
        P.Misc.widthText = 20;
        
        [H_axes rows columns] = test_cmro2(P, sim_list, data, params);
        
    case {'topdown_combined'}
        
        P.Misc.paperSizeMultiple = 3;
        isDown = true;
        
        correctionFactor1 = sqrt(1.5);
        correctionFactor2 = 1.1;
        P.Misc.sizeFontStrong = P.Misc.sizeFontStrong.*correctionFactor1;
        P.Misc.sizeFontLabel = P.Misc.sizeFontLabel.*correctionFactor1;
        P.Axes.FontSize = P.Axes.FontSize.*correctionFactor2;
        P.Subaxes.FontSize = P.Subaxes.FontSize.*correctionFactor2;
        
        [H_axes rows columns subaxis] = dilation_combined(P,sim_list,...
                                    data,constants,params,controls,isDown);
    
    case {'vazquez2008_main'}
        
        [H_axes rows columns] = vazquez2008_main(P,sim_list,data,...
                                                    constants,params);
                                                
	case {'vazquez2008_poster'}
        
%         P.Misc.paperSizeMultiple = 3;
%         
%         correctionFactor1 = sqrt(3/2);
%         correctionFactor2 = sqrt(3/2);
%         P.Misc.sizeFontStrong = P.Misc.sizeFontStrong.*correctionFactor1;
%         P.Misc.sizeFontLabel = P.Misc.sizeFontLabel.*correctionFactor1;
%         P.Axes.FontSize = P.Axes.FontSize.*correctionFactor2;
%         P.Subaxes.FontSize = P.Subaxes.FontSize.*correctionFactor2;
        
%         P.Misc.ratio = 1.45;
        
        [H_axes rows columns subaxis] = vazquez2008_poster(P,sim_list,...
                                                    data,constants,params);
                                                
    case {'vazquez2008_supp'}
        
        [H_axes rows columns] = vazquez2008_supp(P,sim_list,data,...
                                                    constants,params);
    
    case {'vazquez2010_main'}
        
        [H_axes rows columns] = vazquez2010_main(P,sim_list,data,...
                                                    constants,params);
                                                
	case {'vazquez2010_poster'}
        
%         P.Misc.paperSizeMultiple = 3;
%         
%         correctionFactor1 = sqrt(3/2);
%         correctionFactor2 = sqrt(3/2);
%         P.Misc.sizeFontStrong = P.Misc.sizeFontStrong.*correctionFactor1;
%         P.Misc.sizeFontLabel = P.Misc.sizeFontLabel.*correctionFactor1;
%         P.Axes.FontSize = P.Axes.FontSize.*correctionFactor2;
%         P.Subaxes.FontSize = P.Subaxes.FontSize.*correctionFactor2;
        
%         P.Misc.ratio = 1.45;
        
        [H_axes rows columns subaxis] = vazquez2010_poster(P,sim_list,...
                                                    data,constants,params);
                                                
    case {'vazquez2010_supp'}
        
        P.Misc.paperSizeMultiple = 3;
        
        correctionFactor1 = sqrt(1.5);
        correctionFactor2 = 1.1;
        P.Misc.sizeFontStrong = P.Misc.sizeFontStrong.*correctionFactor1;
        P.Misc.sizeFontLabel = P.Misc.sizeFontLabel.*correctionFactor1;
        P.Axes.FontSize = P.Axes.FontSize.*correctionFactor2;
        P.Subaxes.FontSize = P.Subaxes.FontSize.*correctionFactor2;
        
        [H_axes rows columns] = vazquez2010_supp(P,sim_list,data,...
                                                    constants,params);
        
    case {'vovenko_radial'}
        
        doKrogh = true;
        doPlot = true;
        
        P.Misc.ratio = 1;
        
        [junk H_axes rows columns] = find_p0_vovenko(constants,...
                                                     doKrogh,doPlot,P);
                                                 
    case {'yaseen2011_main'}
        
        [H_axes rows columns] = yaseen2011_main(P,sim_list,data,...
                                                    constants,params);
                                        
    otherwise
        
        warning('PlotResults:UnknownFig',...
            'Unknown Figure "%s". Skipping...',fig)
        return;

end

% Format figure for saving etc
H_fig = format_figure(P,H_axes,rows,columns,subaxis);

% Save figure in the appropriate format
if doSave
    save_figure(H_fig,format,filename)
end

end

% ----------------------------------------------------------------------- %

function P = setup_properties

% Miscellaneous Properties
P.Misc.sizeFontStrong = 14;
P.Misc.sizeFontLabel = 20;
P.Misc.weightFontStrong = 'bold';
P.Misc.widthLine = 2;
P.Misc.widthLineStim = 4;
P.Misc.legendBox = 'boxoff';
P.Misc.gridstate = 'off';
P.Misc.greyLine = [0.5 0.5 0.5];
P.Misc.sizeMarker = 10;
P.Misc.widthText = 522; % Latex textwidth (points)
P.Misc.widthColumn = 252; % Latex textwidth (points)
P.Misc.ratio = 0.5*(1+sqrt(5)); % The width/height (?) ratio 
P.Misc.paperSizeMultiple = 2;
P.Misc.fn_root = './figs/'; % Where all figures are saved.

% % Latex textwidth (points) - from poster?
% P.Misc.widthText = 1566; 
% P.Misc.widthColumn = 756;

% Axes Properties
P.Axes.FontName = 'Arial';
P.Axes.FontSize = 12;
P.Axes.FontWeight = 'demi';
P.Axes.LineWidth = 1;
P.Axes.Box = 'off';

% Subaxes Properties
P.Subaxes.FontName = 'Arial';
P.Subaxes.FontSize = 10;
P.Subaxes.FontWeight = 'demi';
P.Subaxes.LineWidth = 1;
P.Subaxes.Box = 'off';

% Figure properties
P.Fig.Color = 'w';
P.Fig.InvertHardCopy = 'off';
% P.Fig.Renderer = 'OpenGL';
P.Fig.Renderer = 'Painters';
P.Fig.PaperUnits = 'points';

end

% ----------------------------------------------------------------------- %

function H_fig = format_figure(P,H_axes,rows,columns,subaxis)

% Stores the handle of the current figure (assuming it's the one we want)
H_fig = gcf;

% Output EPS and FIG file at appropriate width
if columns == 1 
    width = P.Misc.widthColumn;
else
    width = P.Misc.widthText;
end;

height = (rows*width)/(columns*P.Misc.ratio);

% More Figure Properties
P.Fig.PaperSize = P.Misc.paperSizeMultiple.*[width height];
P.Fig.PaperPosition = [0 0 P.Fig.PaperSize]; % [left bottom width height]

for i = 1:length(H_axes)
    
    try 
        doAxis = ~isnan(H_axes(i));
    catch
        doAxis = true;
    end
    
    if doAxis
        grid(H_axes(i),P.Misc.gridstate)
        set(H_axes(i),P.Axes);
        legend(H_axes(i),P.Misc.legendBox);
    end
    
end;

adjustSubaxes = exist('subaxis','var')==1 && ~isempty(subaxis);
if adjustSubaxes
    for i = 1:length(subaxis)
        grid(subaxis(i).handle,P.Misc.gridstate)
        set(subaxis(i).handle,P.Subaxes); % axes properties
        legend(subaxis(i).handle,P.Misc.legendBox);
    end
end

set(H_fig,P.Fig);

end

% ----------------------------------------------------------------------- %

function save_figure(H_fig,format,filename)

FORMATS = ...
   {'fig',@(fnFull) saveas(H_fig,fnFull);...
    'eps',@(fnFull) print(H_fig,'-depsc2',fnFull);...
    'png',@(fnFull) print(H_fig,'-dpng',fnFull);... % default resolution
    'png100',@(fnFull) print(H_fig,'-dpng','-r100',fnFull);... % 300dpi
    'png300',@(fnFull) print(H_fig,'-dpng','-r300',fnFull);... % 300dpi
    'tif',@(fnFull) print(H_fig,'-dtiff',fnFull);...
    'jpg',@(fnFull) print(H_fig,'-djpeg',fnFull);...
    'bmp',@(fnFull) print(H_fig,'-dbmp16m',fnFull)}; % 24 bit bitmap

for iFormatIn = 1:length(format)
    
    idx = find(strcmpi(format{iFormatIn}, FORMATS(:,1))==true);
    
    if ~isempty(idx)
        
        % Complete the filename, and check it doesn't exist already.
        fn_full = [filename '.' format{iFormatIn}(1:3)];
        fn_full = checkfilename(fn_full,1);
        
        % Save the figure, using the appropriate function handle.
        fprintf('Saving %s ...',fn_full);
        FORMATS{idx,2}(fn_full); %#ok<VUNUS>
        fprintf(' done.\n');
        
    else
        warning('PlotResults:Save:UnknownFormat',...
            'Unknown Format "%s". Skipping...',format{iFormatIn})
    end
    
end

end
function varargout = find_p0_vovenko(constants,varargin)

%% Process input arguments

% Set default arguments
doKrogh = true;
doPlot = false;

if nargin > 1
    if ~isempty(varargin{1})
        doKrogh = varargin{1};
    end
end

if nargin > 2
    if ~isempty(varargin{2})
        
        doPlot = varargin{2};
        
        if doPlot
            
            hasP = nargin > 3 && ~isempty(varargin{3});
            if hasP
                P = varargin{3};
            else
                P = plot_results;
                warning('FindP0Vovenko:NoPlotStruct',...
                        'No plot structure specified.  Assuming default')
            end
            
        end
    end
end

%% Initial guesses

% Partial pressures
pa0 = 70;
pc0 = 50;
pv0 = 40;
p00 = 15;

x0 = [pa0 pc0 pv0 p00];

%% Optimization

if length(constants) > 1
    warning('FindPoVovenko:MultipleSims',['Multiple simulations '...
        'supplied.  Using the first one.'])
end

% Pass static arguments to error function
load vovenko1999
optFun = @(x) errfun_vovenko(x,vovenko1999,constants(1),doKrogh,false,[]);

% % For debugging
% test1 = optFun(x0);

% Set bounds
lb = zeros(size(x0));
ub = inf(size(x0));
ub(1:4) = [80 60 50 25];
ub(end) = 130;

% options = optimset('Display','iter');
options = optimset('Display','none');

% Optimizse
xOpt = lsqnonlin(optFun,x0,lb,ub,options);

%% Plotting

% For debugging and plotting
if doPlot
    [H_axes rows columns] = errfun_vovenko(xOpt,vovenko1999,constants(1),...
                                            doKrogh,doPlot,P); %#ok<NASGU>
end

%% Assign output argument(s)

if ~doPlot
    varargout{1} = xOpt(4);
else
    varargout = {xOpt(4),H_axes,rows,columns}; 
end

end

function varargout = errfun_vovenko(x,vovenko1999,constants,doKrogh,doPlot,P)

% Unwrap dynamic arguments
pO2 = x(1:3);
p0 = x(4);

if ~doKrogh
    
    x2 = constants.ss.r2;
    
    % %%%%% Change this function so that it includes an x1 also?
    
    % Quadratic function
    residualFun = @(rArray,px) ((px-p0)/(x2.^2)).*(rArray-x2).^2+p0;
    
else
    
    x1 = constants.ss.r1*ones(1,3);
    % x1 = [20 6 25]; % estimated from Vovenko
    x2 = constants.ss.r2;
    
    kk = @(px,x1) (p0 - px)/(0.25*(x2^2-x1^2) - 0.5*(x2^2)*log(x2/x1));
    
    % Krogh cylinder model
    residualFun = @(rArray,px,x1) px + ...
                        0.25*kk(px,x1).*((rArray).^2 - x1.^2) - ...
                        0.5*(x2^2).*kk(px,x1).*log((rArray)./x1);
    
end

residuals = [];
nComps = length(vovenko1999);

% Setup for plotting, if necessary
if doPlot
    
    rows = 1;
    columns = nComps;
    H_axes = zeros(1,nComps);
    
    % Setup some property name/value pairs
    lineProps = {   'LineWidth',P.Misc.widthLine,...
                    'MarkerSize',P.Misc.sizeMarker};
    titleProps = {  'FontSize',P.Misc.sizeFontLabel,...
                    'FontWeight',P.Misc.weightFontStrong};
    labelProps = {  'FontSize',P.Misc.sizeFontStrong,...
                    'FontWeight',P.Misc.weightFontStrong};
    
    titleStr = {'Arteries','Capillaries','Veins'};
    
    hFig = figure;
    rFig = linspace(0,x2,100);
    
    if ~doKrogh
        strFit = 'Quadratic Fit';
    else
        strFit = 'Model';
    end
    
end

% Step through the different compartments
for iComp = 1:length(vovenko1999)
    
    % Calculate the raw function value
    if ~doKrogh
        fval = residualFun(vovenko1999(iComp).r,pO2(iComp));
    else
        fval = residualFun(vovenko1999(iComp).r+x1(iComp),pO2(iComp),x1(iComp));
    end
    
    % Plot, if necessary
    if doPlot
        
        if ~doKrogh
            pO2Fig = residualFun(rFig,pO2(iComp));
        else
            pO2Fig = residualFun(rFig,pO2(iComp),x1(iComp));
        end
        
        figure(hFig) 
        
        H_axes(iComp) = subplot(1,nComps,iComp); hold on
            
            title(titleStr{iComp},titleProps{:})
            xlabel('Radial Distance (\mu{m})',labelProps{:})
            ylabel('PO2 (mmHg)',labelProps{:})
            axis([0 x2-x1(1) 0 max(vovenko1999(1).r)*1.1])
            
            plot(vovenko1999(iComp).r,vovenko1999(iComp).po2,...
                'b+',lineProps{:})
            plot(rFig-x1(1),pO2Fig,'r-',lineProps{:})
            plot([0 x2],p0.*ones(1,2),'k:',lineProps{:})            
            
            if iComp ==3
                legend('Vovenko (1999)',strFit,'P_{t0}')
            end
            
        hold off
        
    end
    
    % Calculate the residuals for this compartment.
    residuals0 = fval - vovenko1999(iComp).po2;
    
    % Combine the residuals with the existing ones.
    residuals = [residuals residuals0']; %#ok<AGROW>
    
end

% Assign output arguments
if ~doPlot
    varargout{1} = residuals;
else
    varargout = {H_axes,rows,columns};
end

end
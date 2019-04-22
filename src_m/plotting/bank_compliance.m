function [H_axes rows columns] = bank_compliance(varargin)

%% Process input arguments

if nargin > 0 && ~isempty(varargin{1})
    P = varargin{1};
else
    P = plot_results;
end

doHorizontal = false;
if nargin > 1 && ~ isempty(varargin{2})
    doHorizontal = varargin{2};
end

doOld = false;
if nargin > 2 && ~ isempty(varargin{3})
    doOld = varargin{3};
end

doPsFrag = false;
if nargin > 3 && ~ isempty(varargin{4})
    doPsFrag = varargin{3};
end

% Load the pre-formatted data from Bank et al. (1995)
load bank1995

% Import the field names in the Bank1995 data structure, excluding pressure
strings = fieldnames(bank1995);
strings = strings(~strcmp(strings,'pressure'));

%% Peform calculations

% Input argument-specific calculations
if doHorizontal
    rows= 1; columns = 2;
else
    rows= 2; columns = 1;
end

if doOld
    
    cc = 1:4;
    elemsToUse = 1:11;
    
    % Prepare synthetic data for the plot of my model
    m = -1.8;
    xMin = 0.7;
    xMax = 1.3;
    x_diff = 0.1;
    

    
    yShift = 0.4;
    xShift = 0;
    
else
    
    cc = [1 5 3 6];
    elemsToUse = 3:11;
    
    % Prepare synthetic data for the plot of my model
    m = -6;
    xMin = 0.85;
    xMax = 1.15;
    x_diff = 0.09;
    
%     c = 1-m;
%     x = xMin:x_diff:xMax;
%     y = m.*x + c;
    
    yShift = 0;
    xShift = 0.2;
    
end

c = 1-m;
x = xMin:x_diff:xMax;
y = m.*x + c;

% Fit a linear equation to the experimental data.
for i = 1:length(strings)
    
    p(i,:) = polyfit(bank1995.(strings{i})(elemsToUse,cc(1)),...
                     bank1995.(strings{i})(elemsToUse,cc(2)),1);
    x_fit(:,i) = [bank1995.(strings{i})(:,cc(1))];
    y_fit(:,i) = p(i,1).*x_fit(:,i) + p(i,2);
    
end;

labelY = sprintf('Normalized Compliance (a.u.)\n');
labelX = sprintf('\nNormalized Volume (a.u.)');

%% Produce Plot

if ~doPsFrag
    labelsText = {'s(t)','\kappa', '1'};
else
    labelsText = {'stim','kappa', '1'};
end
        
figure
    H_axes(1) = subplot(rows,columns,1);
        hold on
            
            % Set the axis appropriately for each plot
            if doOld
                axis([8 28 0 0.4])
            else
                axis([10 30 0 1.1])
            end
            
            yAxis = sprintf('Area/Pressure (mm^2/mmHg)');
            
            ylabel(yAxis,...
                   'FontWeight',P.Misc.weightFontStrong,...
                   'FontSize',P.Misc.sizeFontStrong)
            xlabel('Area (mm^2)',...
                   'FontWeight',P.Misc.weightFontStrong,...
                   'FontSize',P.Misc.sizeFontStrong)
            
            % The raw data
            plot(bank1995.dilated(elemsToUse,cc(1)),...
                 bank1995.dilated(elemsToUse,cc(2)),...
                 'ks','MarkerFaceColor','k')
            plot(bank1995.baseline(elemsToUse,cc(1)),...
                 bank1995.baseline(elemsToUse,cc(2)),...
                 'k^','MarkerFaceColor','k')
            plot(bank1995.constricted(elemsToUse,cc(1)),...
                 bank1995.constricted(elemsToUse,cc(2)),...
                 'ko','MarkerFaceColor','k')
             
            % The error bars
            ploterr(bank1995.baseline(elemsToUse,cc(1)),...
                    bank1995.baseline(elemsToUse,cc(2)),...
                    bank1995.baseline(elemsToUse,cc(3)),...
                    bank1995.baseline(elemsToUse,cc(4)),'k+')
            ploterr(bank1995.dilated(elemsToUse,cc(1)),...
                    bank1995.dilated(elemsToUse,cc(2)),...
                    bank1995.dilated(elemsToUse,cc(3)),...
                    bank1995.dilated(elemsToUse,cc(4)),'k+')
            ploterr(bank1995.constricted(elemsToUse,cc(1)),...
                    bank1995.constricted(elemsToUse,cc(2)),...
                    bank1995.constricted(elemsToUse,cc(3)),...
                    bank1995.constricted(elemsToUse,cc(4)),'k+')
            
            % The fitted lines
            plot(x_fit(elemsToUse,1),y_fit(elemsToUse,1),...
                 'k--','LineWidth',P.Misc.widthLine)
            plot(x_fit(elemsToUse,2),y_fit(elemsToUse,2),...
                 'k-','LineWidth',P.Misc.widthLine)
            plot(x_fit(elemsToUse,3),y_fit(elemsToUse,3),...
                 'k:','LineWidth',P.Misc.widthLine)
            
            legend('Dilated','Baseline','Constricted')
            
        hold off
        
    H_axes(2) = subplot(rows,columns,2);
        hold on
            
            if doOld
                axis([0.3 1.7 0 2])
            else
                axis([0.5 1.5 0 2.2])
            end
        
            ylabel(labelY,'FontWeight',P.Misc.weightFontStrong,...
                          'FontSize',P.Misc.sizeFontStrong)
            xlabel(labelX,'FontWeight',P.Misc.weightFontStrong,...
                          'FontSize',P.Misc.sizeFontStrong)
            
            
            % Data
            plot(x+xShift,y+yShift,'k--','LineWidth',P.Misc.widthLine)
            plot(x,y,'k-','LineWidth',P.Misc.widthLine)
            plot(x-xShift,y-yShift,'k:','LineWidth',P.Misc.widthLine)
            
            % Annotations
            t(1) = text(mean(x(end-1:end)) - 0.01, y(end-1) + ...
                1*yShift + 3*xShift, labelsText{1}, ...
                'HorizontalAlignment', 'right');
%             t(1) = text(x(end-1) - 0.08 + 0.3*xShift, y(end-1) + ...
%                 1*yShift + 3*xShift, labelsText{1});
            set(t,'FontSize',P.Misc.sizeFontStrong)
            l(1) = line([0,1],[1,1]);
            l(2) = line([1,1],[0,1]);
            l(3) = line([x(length(x)),-c/m],[y(length(y)),0]);
            yShift = -m*xShift; xShift = 0; 
            l(4) = line([mean(x(end-1:end)) mean(x(end-1:end))+xShift],[mean(y(end-1:end)) mean(y(end-1:end))+yShift]);
            
            % Formatting
            set(gca,'XTick',[1, -c/m],...
                'YTick',[1]);
            format_ticks(gca,{labelsText{3},labelsText{2}},{labelsText{3}},...
                [],[],[],[],[],'FontSize',P.Misc.sizeFontStrong,...
                'FontName',P.Axes.FontName);
            set(l,'LineStyle','--','Color',P.Misc.greyLine)
            legend('Dilated','Baseline','Constricted')
            
        hold off

end


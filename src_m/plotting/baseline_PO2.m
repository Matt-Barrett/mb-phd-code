function [H_axes rows columns] = baseline_PO2(P,sim_list,constants,...
                                                params,controls,data)

doNewFig = false;
                                            
%% General Stuff
req_sim = {'vazquez2010_cap','vazquez2008_control_cap','yaseen2011','vovenko1999'};
idx = find_data_indices(sim_list,req_sim);

rows= 3;
columns = 4;
H_axes(1:rows*columns) = NaN;

[t0 idxt0] = deal(zeros(1,length(req_sim)));
nSims = length(idx);
for iSim = 1:nSims
    [t0(iSim) idxt0(iSim)] = min(abs(data(idx((iSim))).t));
end

% Get the experimental data from a subfunction
expData = getexpdata;

% Setup some property name/value pairs
lineProps = {   'LineWidth',P.Misc.widthLine,...
                'MarkerSize',P.Misc.sizeMarker};
titleProps = {  'FontSize',P.Misc.sizeFontLabel,...
                'FontWeight',P.Misc.weightFontStrong};
axesProps = {   'FontName',P.Axes.FontName,...
                'FontSize',P.Axes.FontSize,...
                'FontWeight',P.Axes.FontWeight};
labelProps = {  'FontSize',P.Misc.sizeFontStrong,...
                'FontWeight',P.Misc.weightFontStrong};

calcCompMeans = @(PO2) [mean(PO2(:,2:3),2) mean(PO2(:,3:4),2) mean(PO2(:,4:5),2)];

yLimits = [30 140];


grey1 = [rgbconv('BDBDBD')];
grey2 = [rgbconv('969696')];
grey3 = [rgbconv('525252')];
grey4 = [rgbconv('252525')];

% colourLines = {'b','g','r','m'};
colourLines = {grey1,grey3,grey2,grey4};
lineShapes = {'o','^','s','d'};

%
nPoints = 5;
rangeXOffset = 0.4;
offsetXRaw = linspace(-rangeXOffset,rangeXOffset,nPoints);
offsetXMean = [offsetXRaw(1) mean(offsetXRaw(2:3)) ...
    mean(offsetXRaw(3:4)) mean(offsetXRaw(4:5))];
offsetXRaw = offsetXRaw(2:end);

%% Graph Dimensions

extBorder = 0.1;
fracLeftFig = 0.45;
intGapMajor = 0.04;

intGapMinor = 0.02;
fracArt = 0.45;
fracVei = 0.38;

fracRightFig = 1-fracLeftFig;
fracCap = 1 - fracArt - fracVei;

fracLeftFigAdj = fracLeftFig*(1-2*extBorder-intGapMajor);
fracArtAdj = fracArt*fracRightFig*(1-2*extBorder-intGapMajor-2*intGapMinor);
fracCapAdj = fracCap*fracRightFig*(1-2*extBorder-intGapMajor-2*intGapMinor);
fracVeiAdj = fracVei*fracRightFig*(1-2*extBorder-intGapMajor-2*intGapMinor);

posArt = extBorder+fracLeftFigAdj+intGapMajor;
posCap = posArt+fracArtAdj+intGapMinor;
posVei = posCap+fracCapAdj+intGapMinor;

pos(1:4,2) = extBorder;
pos(1:4,4) = 1-2*extBorder;

pos(1,[1,3]) = [extBorder fracLeftFigAdj];
pos(2,[1,3]) = [posArt fracArtAdj];
pos(3,[1,3]) = [posCap fracCapAdj];
pos(4,[1,3]) = [posVei fracVeiAdj];

%% Setup stuff for the first graph

xLabels1 = {sprintf('Vazquez\n(2010)'), sprintf('Masamoto\n(2008)'), ...
            sprintf('Yaseen\n(2011)'), sprintf('Vovenko\n(1999)')};
        
xLabels2 = {sprintf('Fem. Art.'), sprintf('Art.'), ...
            sprintf('Cap.'), sprintf('Vei.')};

for iSim = 1:nSims
    
    PO2data(iSim,:) = constants(idx(iSim)).reference.PO2_ref.*[...
                        params(idx(iSim)).o2concin.PO2_in...
                        data(idx(iSim)).PO2_raw(1,1:end-1)];
                    
end

compMeans = calcCompMeans(PO2data);
compMeans = [PO2data(:,1), compMeans];
PO2data = PO2data(:,2:end);

%% Setup stuff for the second graph

xLimits2 = [-250 0];
xTicks2 = [-150 -100 -50 -0];
xPO2_0 = -210;

xLimits3 = [-5 5];

xLimits4 = [0 420];
xTicks4 = 0:100:400;

yDiam = 22;
yCompLabels = mean([expData{1}.PO2_0 expData{3}.PO2_0]);

%% Plot the Figure
figure
    H_axes(1) = subplot('Position',pos(1,:));
        hold on
        
            title('Model Predictions',titleProps{:})
            ylabel('PO2 (mmHg)',labelProps{:})
            
            if ~doNewFig
                
                axis([0.2 4.8 yLimits])
                format_ticks(H_axes(1),xLabels1,[],1:nSims,[],[],[],[],...
                           'Color','k',axesProps{:});
                
            else
                
                axis([-0.5 0.5 yLimits])
                format_ticks(H_axes(1),xLabels2,[],offsetXMean,[],[],[],[],...
                           'Color','k',axesProps{:});
                
            end

            for iSim = 1:nSims
                
                if ~doNewFig
                    addXVal = iSim;
                else
                    addXVal = 0;
                end

                % Plot end of compartment PO2 values
                plot(addXVal + offsetXRaw,PO2data(iSim,1:end),...
                    'x-',lineProps{:},'Color',colourLines{iSim})

                % Plot femoral artery and mean compartment PO2 values
                plot(addXVal + offsetXMean,compMeans(iSim,:),...
                    lineShapes{iSim},lineProps{:},...
                    'Color',colourLines{iSim},...
                    'MarkerFaceColor',colourLines{iSim})

            end
            
            % Extract the normalised co-ordinates of the 
            [xLine.x1, yLine] = ds2nfu(H_axes(1),nSims + offsetXMean,compMeans(end,:));

            
        hold off
    H_axes(2) = subplot('Position',pos(2,:));
        hold on
        
            ylabel('PO2 (mmHg)',labelProps{:})
            text(mean(xLimits2),yDiam,'Art. Diameter (um)',...
                    'HorizontalAlignment','Center',labelProps{:})
            axis([xLimits2 yLimits])
            format_ticks(H_axes(2),...
                    [{sprintf('Fem. Art.')},...
                        cellfun(@num2str,num2cell(-xTicks2(1:end-1)),...
                        'UniformOutput',false),{''}],...
                    [],[xPO2_0 xTicks2],[],[],[],[],axesProps{:});
%             text(-70,yCompLabels,'Arteries',...
%                 'HorizontalAlignment','Center',labelProps{:})
            
            for iSim = 1:nSims
                
                % Plot femoral artery PO2 values
                plot(xPO2_0,expData{iSim}.PO2_0,...
                    lineShapes{iSim},'Color',colourLines{iSim},...
                    lineProps{:},'MarkerFaceColor',colourLines{iSim})
                
                % Plot the remaining arterial values
                plot(expData{iSim}.D(1,:),expData{iSim}.PO2(1,:),...
                    [lineShapes{iSim} '-'],'Color',colourLines{iSim},...
                    lineProps{:},'MarkerFaceColor',colourLines{iSim})
      
            end
            
            set(H_axes(2),'YTick',[],'YColor','w')
            
            [xLine.x0, junk] = ds2nfu(H_axes(2),xPO2_0,1); clear junk
            [xLine.x2, junk] = ds2nfu(H_axes(2),-20,1); clear junk
            
        hold off
    H_axes(3) = subplot('Position',pos(3,:));
        hold on
        
            title('Experimental Observations',titleProps{:})
            axis([xLimits3 yLimits])
            text(mean(xLimits3),yDiam,'Cap. End',...
                    'HorizontalAlignment','Center',labelProps{:})
            format_ticks(H_axes(3),{sprintf('Art.'),sprintf('Ven.')},...
                    [],[expData{4}.D(2,1) expData{4}.D(2,2)],...
                    [],[],[],[],axesProps{:});
%             text(0,yCompLabels,'Capillaries',...
%                 'HorizontalAlignment','Center',labelProps{:})
            
            for iSim = 1:nSims
                
                % Plot the capillary values
                plot(expData{iSim}.D(2,:),expData{iSim}.PO2(2,:),...
                    [lineShapes{iSim} '-'],'Color',colourLines{iSim},...
                    lineProps{:},'MarkerFaceColor',colourLines{iSim})
                
            end

            set(H_axes(3),'YTick',[],'YColor','w')
            
            [xLine.x3, junk] = ds2nfu(H_axes(3),0,1); clear junk
            
        hold off
    H_axes(4) = subplot('Position',pos(4,:));
        hold on
        
            ylabel('PO2 (mmHg)',labelProps{:})
            text(mean(xLimits4),yDiam,'Ven. Diameter (um)',...
                    'HorizontalAlignment','Center',labelProps{:})
            axis([xLimits4 yLimits])
%             text(200,yCompLabels,'Veins',...
%                 'HorizontalAlignment','Center',labelProps{:})
            format_ticks(H_axes(4),...
                    [{''}, cellfun(@num2str,num2cell(xTicks4(2:end-1)),...
                        'UniformOutput',false), {''}],...
                    [],xTicks4,[],[],[],[],axesProps{:});
            set(H_axes(4),'YAxisLocation','right')
            
            for iSim = 1:nSims
                
                % Plot the venous values
                plot(expData{iSim}.D(3,:),expData{iSim}.PO2(3,:),...
                    [lineShapes{iSim} '-'],'Color',colourLines{iSim},...
                    lineProps{:},'MarkerFaceColor',colourLines{iSim})
                
            end
            
            legendStr = strrep(xLabels1, sprintf('\n'), ' ');
            legend(legendStr{:},'Location','NorthEast')
                
            [xLine.x4, junk] = ds2nfu(H_axes(4),150,1); clear junk
            
        hold off
    
    % Annotation layer (lines across multiple axes)
    xNum = {'x0' 'x2' 'x3' 'x4'};
    lineStr = {'Fem. Art.','Arteries','Capillaries','Veins'};
    for iLine = 1:length(xLine.x1)
        
        % Annotate the lines between plots
        annotation('line',...
            [xLine.x1(iLine) xLine.(xNum{iLine})],...
            yLine(iLine)*ones(1,2),'LineStyle','--','LineWidth',1,...
            'Color',colourLines{end});
        
        % Annotate the 
        widthText = xLine.(xNum{iLine}) - xLine.x1(iLine);
        annotation('textbox',...
            [xLine.x1(iLine) yLine(iLine) widthText 4E-2],...
            'String',lineStr{iLine},'HorizontalAlignment','Center',...
            'EdgeColor','none',labelProps{:});
    
    end
    
    
                                                    
end

function expData = getexpdata

Vovenko.PO2_0 = 85.6;
Vovenko.PO2 = [ 81.2 78.7 75.8 68.3 61.5;
                57.9 40.9 NaN  NaN  NaN;
                38.2 41.1 40.1 39.6 41.3];
% Vovenko.PO2_sd = 
Vovenko.PO2_t = NaN;
Vovenko.D = [   -45 -33 -26 -13 -8;
                -5 5 NaN  NaN  NaN;
                13 31 71 145 258];
% Vovenko.D_sd = 

Vazquez.PO2_0 = 133;
% Vazquez.PO2 = [ 88.1 89.2 77.9; % Uncorrected
%                 NaN  NaN  NaN;
%                 33.3 38.6 36.9];
Vazquez.PO2 = [ 107.4 102 85.8; % Corrected
                NaN  NaN  NaN;
                33.3 39.7 40.3];
% Vazquez.PO2_t = 38;
Vazquez.PO2_t = NaN;
Vazquez.D = [   -128.9 -84 -52.7;
                NaN  NaN  NaN;
                61.9 144.6 361];

% % Correction assuming wall diameter is 15% of vessel diameter, and PO2
% % gradient of 1mmHg/um wall
% Vazquez.PO2 = Vazquez.PO2(1,:) + 0.15*abs(Vazquez.D(1,:))*1; %

Yaseen.PO2_0 = 108.25;
Yaseen.PO2 = [  104.82 64.95;
                NaN NaN;
                50.1 54.4];
Yaseen.D = [    -91.04 -19.22;
                NaN NaN;
                20.23 324.71];
            
Masamoto.PO2_0 = 114;
Masamoto.PO2 = [  NaN NaN;
                NaN NaN;
                0 0];
Masamoto.D = [    NaN NaN;
                NaN NaN;
                0 01];
            
expData = {Vazquez Masamoto Yaseen Vovenko};
            
end
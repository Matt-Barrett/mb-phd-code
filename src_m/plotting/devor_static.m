function [H_axes rows columns] = devor_static(P,sim_list,data,constants)

%% General Stuff

req_sim = {'devor2011_surface','devor2011_mid','devor2011_deep'};
wngState = warning('off','FindDataIndices:CouldntFind');
idx = find_data_indices(sim_list,req_sim);
warning(wngState);

rows = 3;
columns = 2;

%% Setup for looping

nSims = length(req_sim);

p0Plot = 0;
pxPlot = 100;
npPlot = 1000;
ppPlot = linspace(p0Plot,pxPlot,npPlot);

% Initialise variables for loop
np = 200;
nComps = 3;
pO2 = zeros(nComps,np,nSims);
pdf = pO2;
pdfInterp = zeros(nComps,npPlot,nSims);

%% Setup the anonymous functions

maskFun = @(x,ll,ul) (x >= ll) & (x <= ul);

kkFun = @(px,p0,r1,r2) (p0-px)/(0.25*(r2^2-r1^2) - (0.5*r2^2)*log(r2/r1));

yFun = @(px,p0,rr,r1,r2) maskFun(rr,r1,r2).*(px + 0.25*kkFun(px,p0,r1,r2)* ...
                    (rr.^2-r1^2) - 0.5*(kkFun(px,p0,r1,r2)*r2^2)*log(rr./r1));

cdfTotalFun = @(px,p0,r1,r2) 0.5*kkFun(px,p0,r1,r2)* ...
                        ((1/3)*r1^3 - r1*r2^2 + (2/3)*r2^3);

pdfFun = @(px,po,rr,r1,r2) maskFun(rr,r1,r2).*(rr/cdfTotalFun(px,po,r1,r2));

%% Setup Figure

yLabels = {'Shallow','Mid','Deep'};

% Setup some property name/value pairs
lineColours = {'r--','m--','b--'};
lineProps = {   'LineWidth',P.Misc.widthLine,...
                'MarkerSize',P.Misc.sizeMarker};
labelProps = {  'FontSize',P.Misc.sizeFontStrong,...
                'FontWeight',P.Misc.weightFontStrong};
titleProps = {  'FontSize',P.Misc.sizeFontLabel,...
                'FontWeight',P.Misc.weightFontStrong};

hFig = figure;


%% Loop through the simulations

for iSim = 1:nSims
   
    %% Extract some constants to be used later
    
    [t0(iSim) idxt0(iSim)] = min(abs(data(idx(iSim)).t));
    
    r1(iSim) = constants(idx(iSim)).ss.r1;
    r2(iSim) = constants(idx(iSim)).ss.r2;
    
    px(iSim,:) = data(idx(iSim)).PO2(idxt0(iSim),1:3).* ...
                    constants(idx(iSim)).reference.PO2_ref;
    pt(iSim) = data(idx(iSim)).PO2(idxt0(iSim),4).*...
                    constants(idx(iSim)).reference.PO2_ref;
    p0(iSim) = data(idx(iSim)).PO2(idxt0(iSim),end).*...
                    constants(idx(iSim)).reference.PO2_ref;
                
    weight(iSim,:) = constants(idx(iSim)).ss.wPO2;

    rr(iSim,:) = linspace(r1(iSim),r2(iSim),np);
    rrNorm(iSim,:) = (rr(iSim,:) - min(rr(iSim,:)))./ ...
                        (max(rr(iSim,:)) - min(rr(iSim,:)));
                    
    %% Probability Distribution Figures
    
    % Setup the axes
    H_axes(iSim*2) = subplot(rows,columns,iSim*2); hold on
    if iSim == 1
        title('Probability (a.u.)',labelProps{:})
    elseif iSim == nSims
        xlabel('PO_2 (mmHg)',labelProps{:})
    end
    xlim([0 pxPlot]);
    ylim([0 0.14])
                    
	%% Calculate the individual compartment probability distributions
    for jComp = 1:nComps
        
        % Calculate PO2 (as a function of radius)
        pO2(jComp,:,iSim) = yFun(px(iSim,jComp),p0(iSim),rr(iSim,:),...
                                 r1(iSim),r2(iSim));
        
        % Calculate PDF (as a function of radius)
        pdf(jComp,:,iSim) = weight(iSim,jComp).*pdfFun(px(iSim,jComp),...
                                   p0(iSim),rr(iSim,:),r1(iSim),r2(iSim));
        
        % Interpolate the PDF over a uniform PO2 interval
        pdfInterp(jComp,:,iSim) = interp1(pO2(jComp,:,iSim),...
                                    pdf(jComp,:,iSim),ppPlot,'pchip',0);
        
        % Plot the PDF vs (uniform) PO2 for this compartment
        plot(ppPlot,pdfInterp(jComp,:,iSim),lineColours{jComp},lineProps{:})
        
    end
    
    % Calculate and plot the total probability distribution
    pdfTotal(iSim,:) = sum(pdfInterp(:,:,iSim),1);
    plot(ppPlot,pdfTotal(iSim,:),'k-','LineWidth',2)
    if iSim == 1
        legend('Art.','Cap.','Vei.','Total')
        legend boxoff
    end
    
    % Plot the average tissue PO2
    plot(pt(iSim).*ones(1,2),ylim,'k--',lineProps{:})
    
    % Plot the compartment values
    plot(data(idx(iSim)).PO2_raw(idxt0(iSim),1).*ones(1,2).*constants(iSim).reference.PO2_ref,ylim,'r--',lineProps{:})
    plot(data(idx(iSim)).PO2_raw(idxt0(iSim),2).*ones(1,2).*constants(iSim).reference.PO2_ref,ylim,'r:',lineProps{:})
    plot(data(idx(iSim)).PO2_raw(idxt0(iSim),3).*ones(1,2).*constants(iSim).reference.PO2_ref,ylim,'m:',lineProps{:})
    plot(data(idx(iSim)).PO2_raw(idxt0(iSim),4).*ones(1,2).*constants(iSim).reference.PO2_ref,ylim,'b:',lineProps{:})
    
    hold off
    
    %% Radial Distribution Figures
    
    H_axes(iSim*2-1) = subplot(rows,columns,iSim*2-1);
    hold on
        ylabel(yLabels{iSim},titleProps{:})
        if iSim == 1
            title('PO_2 (mmHg)',labelProps{:})
        elseif iSim == nSims
            xlabel('Distance from Vessel (a.u.)',labelProps{:})
        end
        ylim([0 100])
        xlim([0 1])
        plot(rrNorm(iSim,:),pO2(1,:,iSim),'r-',lineProps{:})
        plot(rrNorm(iSim,:),pO2(3,:,iSim),'b-',lineProps{:})
        if iSim == 1
            legend('Art.','Vei.')
            legend boxoff
        end
    hold off
    
end

end
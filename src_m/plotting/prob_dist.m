function [H_axes rows columns] = prob_dist(P,sim_list,data,constants)

%% General Stuff

% Only one sim is required, so they're listed in decreasing preference.
req_sim = {'devor2011_surface','devor2011_mid','devor2011_deep',...
           'vazquez2010','yaseen2011'};
wngState = warning('off','FindDataIndices:CouldntFind');
idx = find_data_indices(sim_list,req_sim);
warning(wngState);

% Pick the first available simulation
idxFirst = find(~isnan(idx),1,'first');
if ~isempty(idxFirst)
    idx = idx(idxFirst);
else
    error('ProbDist:NoSimsFound',['None of the simulations that could '...
        'produce this plot were found'])
end

rows = 2;
columns = 1;

% Extract the t0 and idx
[t0 idxt0] = min(abs(data(idx).t));

%% Setup variables etc

r1 = constants(idx).ss.r1;
r2 = constants(idx).ss.r2;

px = data(idx).PO2(idxt0,1:3).*constants(idx).reference.PO2_ref;
p0 = data(idx).PO2(idxt0,end).*constants(idx).reference.PO2_ref;

weight = constants(idx).ss.wPO2;

p0Plot = 0;
pxPlot = 100; %max(px)*1.2;

np = 200;
npPlot = 1000;

rr = linspace(r1,r2,np);
ppPlot = linspace(p0Plot,pxPlot,npPlot);

%% Setup the anonymous functions

maskFun = @(x,ll,ul) (x >= ll) & (x <= ul);

kkFun = @(px) (p0-px)/(0.25*(r2^2-r1^2) - (0.5*r2^2)*log(r2/r1));

yFun = @(rr,px) maskFun(rr,r1,r2).*(px + 0.25*kkFun(px)*(rr.^2-r1^2) - 0.5*(kkFun(px)*r2^2)*log(rr./r1));

cdfTotalFun = @(px) 0.5*kkFun(px)*((1/3)*r1^3 - r1*r2^2 + (2/3)*r2^3);

pdfFun = @(rr,px) maskFun(rr,r1,r2).*(rr/cdfTotalFun(px));

%% Setup Figure

% Setup some property name/value pairs
lineColours = {'r--','m--','b--'};
lineProps = {   'LineWidth',P.Misc.widthLine,...
                'MarkerSize',P.Misc.sizeMarker};
labelProps = {  'FontSize',P.Misc.sizeFontStrong,...
                'FontWeight',P.Misc.weightFontStrong};

figure;

H_axes(2) = subplot(rows,columns,2);
hold on
ylabel('Probability',labelProps{:})
xlabel('Oxygen Partial Pressure (mmHg)',labelProps{:})
xlim([0 pxPlot]);

%% Loop through compartments

% Initialise variables for loop
nComps = length(px);
pO2 = zeros(nComps,np);
pdf = pO2;
pdfInterp = zeros(nComps,npPlot);

for iComp = 1:nComps
    
    pO2(iComp,:) = yFun(rr,px(iComp));
    pdf(iComp,:) = weight(iComp).*pdfFun(rr,px(iComp));
    pdfInterp(iComp,:) = interp1(pO2(iComp,:),pdf(iComp,:),ppPlot,'pchip',0);
    
    plot(ppPlot,pdfInterp(iComp,:),lineColours{iComp},lineProps{:})
    
end

pdfTotal = sum(pdfInterp,1);

plot(ppPlot,pdfTotal,'k-','LineWidth',2)
legend('Art.','Cap.','Vei.','Total')
% ylim([0 max(pdfTotal)*1.1])
ylim([0 0.1])
hold off

% testCdfFun = @(rr) pdfFun(rr,px(1));
% cdfTest = quad(testCdfFun,r1,r2);
H_axes(1) = subplot(rows,columns,1);
%     hold on
%         plot(rr,cdfTest,'b-',lineProps{:})
%     hold off

end
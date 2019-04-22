function [sig pDiff method] = hyp_test(X,Y,doPlots,tail)

if ~exist('tail','var') || isempty(tail)
    tail = 'both';
end

SIG_LEVELS = [0.05 0.01 0.001];

doPlots = exist('doPlots','var') && ~isempty(doPlots) && doPlots;

if doPlots
    
    % Display normal chart
    figure
    subplot(1,2,1), normplot(X)
    subplot(1,2,2), normplot(Y)

    % Display box plots
    boxData = [X; Y];
    boxGroupsX(1:length(X)) = {'X'};
    boxGroupsY(1:length(Y)) = {'Y'};
    boxGroups = [boxGroupsX boxGroupsY]';
    figure, boxplot(boxData,boxGroups)

end

% Test for normality
s = warning('off','stats:lillietest:OutOfRangeP');
[hNorm1,pNorm1] = lillietest(X);
[hNorm2,pNorm2] = lillietest(Y);
warning(s)
isNormal = ~hNorm1 && ~hNorm2;

if isNormal

    % If normal, test for equal variance
    [hVar pVar] = vartest2(X,Y);
    isSameVar = ~hVar;
    
    if isSameVar
        
        % if equal variance, perform standard t-test
        vartype = 'equal';
        method = 'T-Test Equal';
        
    else
    
        % if unequal variance, perform unequal t-test (welch test)
        vartype = 'unequal';
        method = 'T-Test Unequal';
        
    end
    
    % Perform the t-test with the appropriate variance type
    [hDiff pDiff] = ttest2(X,Y,[],tail,vartype);
    
else
    
    % if not normal, perform Rank-Sum Wilcox-Mann-Whitney U test
    method = 'WMW U-Test';
    [pDiff hDiff] = ranksummatt(X,Y,tail);
    
    if isnan(pDiff)
        pDiff = 1;
    end
    
end;

% Calculate the siginificance of the result
sig = sum(pDiff < SIG_LEVELS);

end
function [figNums] = plotRcDataSNR(mainRcaData,mainNoiseData,rcaSettings,plotSettings,RCtoPlot)
% [figNums] = plotRcData(mainRcaData,mainNoiseData,rcaSettings,plotSettings,RCtoPlot)
%
% Plot modelled after PowerDiva with unfilled squares to
% indicate noise estimates for each bin.
%
% If plotSettings includes parameters for the conditions, then each
% condition will be plotted separately.


if nargin<2, error('You must provide both signal and noise data.'); end
if nargin<3, error('You must provide the rcaSettings struct created when your rca data were created.'); end
if (nargin<4 || isempty(plotSettings)), useSpecialSettings = false; else useSpecialSettings = true; end
if nargin<5, RCtoPlot = 1; end

poolOverBins = true;

separateConds = false;
allCondsInd = 1;
nCond = length(rcaSettings.condsToUse);
if useSpecialSettings
    if plotSettings.showConditions
        separateConds = true;
        allCondsInd = 1:nCond;
    else
        plotSettings.conditionColors = [0 0 0];
    end
    errorType = plotSettings.errorType;
else
    errorType = [];
    plotSettings.conditionColors = [0 0 0];
end

nFreqs = length(rcaSettings.freqsToUse);
nBins = length(rcaSettings.binsToUse);

avgRcaData = aggregateData(mainRcaData,rcaSettings,separateConds,errorType);
avgNoise1Data = aggregateData(mainNoiseData.lowerSideBand,rcaSettings,separateConds,errorType);
avgNoise2Data = aggregateData(mainNoiseData.higherSideBand,rcaSettings,separateConds,errorType);

snrMain = computeSnr(avgRcaData,avgNoise1Data,avgNoise2Data,poolOverBins);

figNums = [];
for f=1:nFreqs
    figure;
    hold on;
    set(gca,'FontSize',28);
    set(gca,'Color','w');
    plot(rcaSettings.binLevels,ones(1,nBins),'k-','LineWidth',2);
    title(rcaSettings.freqLabels{f});
    ylabel('SNR')
    xlabel(plotSettings.xlabel);
    rc = RCtoPlot;
    
    for condNum = allCondsInd
        plot(rcaSettings.binLevels,snrMain(:,f,rc,condNum),'ko-','LineWidth',3,'Color',plotSettings.conditionColors(condNum,:));
    end
    set(gca,'XTick',plotSettings.xTick);
    %set(gca,'XTickLabel',round(rcaSettings.binLevels*10)./10);
    ylim([0 plotSettings.ymax]);
    figNums = [figNums,gcf];
        
end






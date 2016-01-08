function [figNums,ampVals,noiseVals,binVals,threshInfo] = plotRcData(mainRcaData,mainNoiseData,rcaSettings,plotSettings,RCtoPlot,plotThreshold)
% [figNums] = plotRcData(mainRcaData,mainNoiseData,rcaSettings,plotSettings,RCtoPlot)
%
% Plot modelled after PowerDiva with squares to
% indicate noise estimates for each bin.
%
% If plotSettings includes parameters for the conditions, then each
% condition will be plotted separately.


if nargin<2, error('You must provide both signal and noise data.'); end
if nargin<3, error('You must provide the rcaSettings struct created when your rca data were created.'); end
if (nargin<4 || isempty(plotSettings)), useSpecialSettings = false; else useSpecialSettings = true; end
if nargin<5, RCtoPlot = 1; end
if nargin<6, plotThreshold = 0; end

poolOverBins = false;

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

if plotThreshold
    threshFitted = zeros(nFreqs,nCond);
    threshVal = nan(nFreqs,nCond);
    slopeVal = nan(nFreqs,nCond);
    fitBinRange = nan(nFreqs,nCond,2);
else
    threshVal = nan;
    slopeVal = nan;
    fitBinRange = nan;
end

avgRcaData = aggregateData(mainRcaData,rcaSettings,separateConds,errorType);
avgNoise1Data = aggregateData(mainNoiseData.lowerSideBand,rcaSettings,separateConds,errorType);
avgNoise2Data = aggregateData(mainNoiseData.higherSideBand,rcaSettings,separateConds,errorType);

[~,noiseLevsMain] = computeSnr(avgRcaData,avgNoise1Data,avgNoise2Data,poolOverBins);

figNums = [];
ampVals = nan(nCond,nBins,nFreqs);
noiseVals = nan(nCond,nBins,nFreqs);

for f=1:nFreqs
    figure;
    binVals = rcaSettings.binLevels{allCondsInd(1)}; % ### use first condition to be plotted.
    if isLogSpaced(binVals)
        set(gca,'XScale','log');
    end
    hold on;
    set(gca,'FontSize',24);
    set(gca,'FontWeight','light');
    set(gca,'Color','w');
    if ~isempty(plotSettings.titleToUse)
        title(plotSettings.titleToUse);
    end
    ylabel('Amplitude (\muVolts)')
    xlabel(plotSettings.xlabel);
    rc = RCtoPlot;
    
    for condNum = allCondsInd
        
        binVals = rcaSettings.binLevels{condNum};

        ampVals(condNum,:,f) = avgRcaData.ampBins(:,f,rc,condNum);
        noiseVals(condNum,:,f) = noiseLevsMain(:,f,rc,condNum);
        
        if isLogSpaced(binVals)
            semilogx(binVals,ampVals(condNum,:,f),'k-','LineWidth',3,'Color',plotSettings.conditionColors(condNum,:));
            semilogx(binVals,noiseVals(condNum,:,f),'ks','Color',plotSettings.conditionColors(condNum,:),'MarkerSize',12)%,...
                %'MarkerFaceColor',plotSettings.conditionColors(condNum,:));
        else            
            plot(binVals,ampVals(condNum,:,f),'k-','LineWidth',3,'Color',plotSettings.conditionColors(condNum,:));
            plot(binVals,noiseVals(condNum,:,f),'ks','Color',plotSettings.conditionColors(condNum,:),'MarkerSize',12)%,...
                %'MarkerFaceColor',plotSettings.conditionColors(condNum,:));
        end
        if ~isempty(errorType)
            lb = ampVals(condNum,:,f)' - avgRcaData.ampErrBins(:,f,rc,condNum,1);
            ub = avgRcaData.ampErrBins(:,f,rc,condNum,2) - ampVals(condNum,:,f)';
            errorbar(binVals,ampVals(condNum,:,f),lb,ub,'Color',plotSettings.conditionColors(condNum,:),'LineWidth',1.5);
        end
        
        if plotThreshold
            clear sweepMatSubjects;
            sweepMatSubjects = constructSweepMatSubjects(mainRcaData,rcaSettings,...
                mainNoiseData.lowerSideBand,mainNoiseData.higherSideBand,rc,condNum,f);
            
            [tThr,tSlp,tLSB,tRSB,~,tYFitPos,tXX] = powerDivaScoring(sweepMatSubjects, rcaSettings.binLevels{condNum});
            threshVal(f,condNum) = tThr;
            slopeVal(f,condNum) = tSlp;
            fitBinRange(f,condNum,:) = [tLSB,tRSB];
            if isnan(tThr)
                fprintf('No threshold could be fitted for CondNum = %d (%s).\n',condNum,rcaSettings.freqLabels{f});
            else
                % save line info to plot after everything else so it's "on top"
                fprintf('Thresh = %1.2f, Slope = %1.2f, Range=[%d,%d] for CondNum = %d (%s).\n',threshVal(f,condNum),slopeVal(f,condNum),fitBinRange(f,condNum,:),condNum,rcaSettings.freqLabels{f});
                threshFitted(f,condNum) = 1;
                saveXX{f,condNum} = tXX;
                saveY{f,condNum} = tYFitPos;
            end
        end
        
    end
    
    if plotThreshold && any(threshFitted(f,:)>0)
        for condNum = 1:nCond
            binVals = rcaSettings.binLevels{condNum};
            if threshFitted(f,condNum)
                if isLogSpaced(binVals)
                    semilogx(saveXX{f,condNum},saveY{f,condNum},'k-','LineWidth',3);
                    semilogx(threshVal(f,condNum),0,'kd','MarkerSize',18,...
                        'MarkerFaceColor',plotSettings.conditionColors(condNum,:),'LineWidth',3);
                else
                    plot(saveXX{f,condNum},saveY{f,condNum},'k-','LineWidth',3);
                    plot(threshVal(f,condNum),0,'kd','MarkerSize',18,...
                        'MarkerFaceColor',plotSettings.conditionColors(condNum,:),'LineWidth',3);
                end
                text(.9*threshVal(f,condNum),.8*max(ylim),sprintf('%2.2f',threshVal(f,condNum)),'Color',plotSettings.conditionColors(condNum,:));
            end
        end
    end
    
    set(gca,'XTick',plotSettings.xTick);
    xlim([binVals(1)-(binVals(2)-binVals(1)) binVals(end)+(binVals(end)-binVals(end-1))])
    %set(gca,'XTickLabel',round(rcaSettings.binLevels*10)./10);
    if ~isempty(plotSettings.ymax)
        ylim([0 plotSettings.ymax]);
    end
    figNums = [figNums,gcf];
    text(0.8*max(xlim),0.8*max(ylim),rcaSettings.freqLabels{f},'FontSize',20);
        
end

if plotThreshold && any(threshFitted(f,:)>0)
    threshInfo.threshFitted = threshFitted;
    threshInfo.xx = saveXX;
    threshInfo.YY = saveY;
    threshInfo.threshVals = threshVal;
    threshInfo.slopeVals = slopeVal;
    threshInfo.fitBinRange = fitBinRange;
end





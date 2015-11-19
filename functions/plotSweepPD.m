function [figNum,plottedVals] = plotSweepPD(pdData,bootData,dataHdr,binLevels,freqNum,dataColor,figHandles)

% PD = use precomputed values from PowerDiva

for k = 1:length(dataHdr)
    switch dataHdr{k}
        case 'iCond'
            condIx = k;
        case 'iTrial'
            trialIx = k;
        case 'iCh'
            chanIx = k;
        case 'iFr'
            freqIx = k;
        case 'iBin'
            binIx = k;
        case 'Sr'
            srIx = k;
        case 'Si'
            siIx = k;
        case 'ampl'
            amplIx = k;
        case 'SNR'
            SNRIx = k;
        case 'Noise'
            noiseIx = k;
        case 'StdErr'
            errorIx = k;
    end
end

nSubj = max(pdData(:,trialIx));

if nargin < 6
    dataColor = 'k';
end

if nargin < 7
    figure;
    set(gcf,'Color','w');
    set(gca,'FontSize',18);
    figNum = gcf;
else
    figNum = figHandles(1);
    figure(figNum);
    if length(figHandles)==4
        subplot(figHandles(2),figHandles(3),figHandles(4));
    elseif length(figHandles)>4
        subplot('position',figHandles(2:end));
    end
end

set(gca,'FontSize',10);
nBins = max(pdData(:,binIx));
meanTrialIx = pdData(:,trialIx) == 0 & pdData(:,binIx)~=0 & pdData(:,freqIx)==freqNum;
meanTrialMat = pdData(meanTrialIx,:);

if range(binLevels) > 10
    semilogx(binLevels,zeros(1,length(binLevels)),'k-','LineWidth',2);
    hold on;
    semilogx(binLevels,meanTrialMat(:,amplIx),'ko-','Color',dataColor,'MarkerFaceColor',dataColor,'LineWidth',2);    
    % if individual data, use errorIx values as CIs, else use bootstrapped
    % ###
    %errorbar(binLevels,meanTrialMat(:,amplIx),meanTrialMat(:,errorIx),'k-','Color',dataColor,'LineWidth',2);
    semilogx(binLevels,meanTrialMat(:,noiseIx),'ks','Color',dataColor);
    set(gca,'TickDir','out');
else
    plot([floor(binLevels(1)) ceil(binLevels(end))],[0 0],'k-','LineWidth',2);
    hold on;
    plot(binLevels,meanTrialMat(:,amplIx),'ko-','Color',dataColor,'MarkerFaceColor',dataColor,'LineWidth',2);
    plot(binLevels,meanTrialMat(:,noiseIx),'ks','Color',dataColor);
    hold on;
end
ylabel('Amplitude (\muV)')
xlabel('Bin Values')
title('Amplitude (\muV)')


hold on;
if ~isempty(bootData)
    for binNum = 1:nBins
        plot([binLevels(binNum) binLevels(binNum)],[meanTrialMat(binNum,amplIx) meanTrialMat(binNum,amplIx)] ...
            +[-1*std(bootData.resampledVectAmplitudes(:,binNum)) std(bootData.resampledVectAmplitudes(:,binNum))],'k-','Color',dataColor,'LineWidth',2);
        hold on;
    end    
    ylabel('Ampl. +/- \sigma')
end

plottedVals = meanTrialMat(:,amplIx);
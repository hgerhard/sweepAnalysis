function [figNum,meanAmp] = plotSweep(pdData,dataHdr,binLevels,freqNum,colorVal,figHandles,errType,withinSubj,extraData,plotSettings)

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
    end
end

if nargin < 5
    colorVal = [0 0 0];
end

if nargin < 6
    figure;
    set(gcf,'Color','w');
    set(gca,'FontSize',18);
    if isLogSpaced(binLevels)
        set(gca,'XScale','log');
    end
    figNum = gcf;
else
    figNum = figHandles(1);    
    set(gcf,'Color','w');
    figure(figNum);
    if length(figHandles)==4
        subplot(figHandles(2),figHandles(3),figHandles(4));
    elseif length(figHandles)>4
        subplot('position',figHandles(2:end));
    end
    if isLogSpaced(binLevels)
        set(gca,'XScale','log');
    end
end
if nargin < 7
    errType = []; % use function's default
end
if nargin < 8
    withinSubj = [];
end
if nargin < 9
    extraData = [];
end
nBins = max(pdData(:,binIx));
if nargin < 10 || isempty(plotSettings)
    plotSettings.markerSize = 6;
    plotSettings.lineWidth = 2;
    plotSettings.markerStr = 'ko-';
    plotSettings.markerFaceColor = colorVal;
    plotSettings.binsToShow = 1:nBins;
end

meanAmp = nan(1,nBins);
medianAmp = nan(1,nBins);
amplErrorRange = nan(2,nBins);
for binNum = 1:nBins
    crntBinRows = pdData(:,binIx)==binNum;
    crntFreqRows = pdData(:,freqIx)==freqNum;
    allowedRows = crntBinRows & crntFreqRows;
    trialNums = pdData(allowedRows,trialIx);
    allowedRows = allowedRows & pdData(:,trialIx)>0; % ### <11 for Francesca
    
    Sr = pdData(allowedRows,srIx);
    Si = pdData(allowedRows,siIx);
    normSrSi = pdData(allowedRows,amplIx);
    noiseLev = pdData(allowedRows,noiseIx);
    allowedData = normSrSi>0; % important because samples with 0 mean are from epochs excluded by PowerDiva
    xyData = [Sr(allowedData) Si(allowedData)];
    
    meanAmp(binNum) = norm(mean(xyData));
    if ~isempty(extraData)
        extraDataCrntBin = extraData(:,binNum);
    else
        extraDataCrntBin = [];
    end
    amplErrorRange(:,binNum) = getErrorEstimates(xyData,withinSubj,errType,extraDataCrntBin);
    medianAmp(binNum) = norm(median(xyData)); 
end

ylabel('Amplitude')
xlabel('Bin Values')

hold on;
for binNum = 1:nBins
    %plot([binLevels(binNum) binLevels(binNum)],[amplErrorRange(1,binNum) amplErrorRange(2,binNum)],'k-','Color',colorVal,'LineWidth',2);
    LB = meanAmp(binNum) - amplErrorRange(1,binNum);
    UB = amplErrorRange(2,binNum) - meanAmp(binNum);
    errorbar(binLevels(binNum),meanAmp(binNum),LB,UB,'k-','Color',colorVal,'LineWidth',plotSettings.lineWidth);
    %errorbarT(h,1,1); %scaling too hard on semilogx
    hold on;
end

if isLogSpaced(binLevels)
    %semilogx(binLevels(plotSettings.binsToShow),zeros(length(plotSettings.binsToShow)),'k-','LineWidth',1)
    semilogx(binLevels(plotSettings.binsToShow),meanAmp(plotSettings.binsToShow),plotSettings.markerStr,'Color',colorVal,...
        'MarkerFaceColor',plotSettings.markerFaceColor,'LineWidth',plotSettings.lineWidth);
    hold on;
    %semilogx(binLevels,meanNoise,'ks','Color',borderColor,'MarkerFaceColor',borderColor);
    set(gca,'TickDir','out');
else
    %plot(binLevels(plotSettings.binsToShow),zeros(length(binLevels)),'k-','LineWidth',1)
    plot(binLevels(plotSettings.binsToShow),meanAmp(plotSettings.binsToShow),plotSettings.markerStr,'Color',colorVal,...
        'MarkerFaceColor',colorVal,'LineWidth',plotSettings.lineWidth)
end
%xlim([binLevels(1) binLevels(end)])



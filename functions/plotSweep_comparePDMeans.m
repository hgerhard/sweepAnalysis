function [figNum,meanAmp] = plotSweep(pdData,bootData,dataHdr,binLevels,freqNum,colorVal,figHandles,errType,withinSubj)

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

nSubj = max(pdData(:,trialIx));

if nargin < 6
    colorVal = repmat(linspace(0,1,nSubj),[3 1])';
end

if nargin < 7
    figure;
    set(gcf,'Color','w');
    set(gca,'FontSize',18);
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
end
if nargin < 8
    errType = []; % use function's default
end
if nargin < 9
    withinSubj = [];
end

nBins = max(pdData(:,binIx));
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
    [~,amplErrorRange(:,binNum)] = getErrorEllipse(xyData,withinSubj,errType);
    medianAmp(binNum) = norm(median(xyData)); 
end

ylabel('Amplitude')
xlabel('Bin Values')

if range(binLevels) > 10
    semilogx(binLevels,meanAmp,'ko-','Color',colorVal,'MarkerFaceColor',colorVal,'LineWidth',2);
    hold on;
    %semilogx(binLevels,meanNoise,'ks','Color',borderColor,'MarkerFaceColor',borderColor);
    set(gca,'TickDir','out');
else
    plot(binLevels,meanAmp,'ko-','Color',colorVal,'MarkerFaceColor',colorVal,'LineWidth',2)
end
xlim([binLevels(1) binLevels(end)])

hold on;
if ~isempty(bootData)
    for binNum = 1:nBins
        plot([binLevels(binNum) binLevels(binNum)],[meanAmp(binNum) meanAmp(binNum)] ...
            +[-2*std(bootData.resampledVectAmplitudes(:,binNum)) 2*std(bootData.resampledVectAmplitudes(:,binNum))],'k-','Color',colorVal,'LineWidth',2);
        hold on;
    end    
    ylabel('Ampl. +/- 2 \sigma')
end

hold on;
for binNum = 1:nBins
    plot([binLevels(binNum) binLevels(binNum)],[amplErrorRange(1,binNum) amplErrorRange(2,binNum)],'k-','Color',colorVal,'LineWidth',2);
    hold on;
end


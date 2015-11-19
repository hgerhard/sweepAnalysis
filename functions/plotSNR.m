function figNum = plotSNR(pdData,dataHdr,binLevels,freqNum,colors,borderColor,figNum)

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
    end
end

nSubj = max(pdData(:,trialIx));

if nargin < 5
    colors = repmat(linspace(0,1,nSubj),[3 1])';
end

if nargin < 6
    borderColor = 'k';
end

if nargin < 7
    figure;
    set(gcf,'Color','w');
    set(gca,'FontSize',18);
    figNum = gcf;
else
    figure(figNum);
    hold on;
end

nBins = max(pdData(:,binIx));
for binNum = 1:nBins
    
    crntBinRows = pdData(:,binIx)==binNum;
    crntFreqRows = pdData(:,freqIx)==freqNum;
    allowedRows = crntBinRows & crntFreqRows;
    SNR(binNum) = mean(pdData(allowedRows,SNRIx));
    SNRstd(binNum) = std(pdData(allowedRows,SNRIx));
        
end

ylabel('SNR (+/-SEM)')
xlabel('Bin values')
set(gca,'YGrid','on')
    
if range(binLevels) > 10
    semilogx(binLevels,SNR,'ko-','Color',borderColor,'MarkerFaceColor',borderColor)
    set(gca,'TickDir','out');
else
    plot(binLevels,SNR,'ko-','Color',borderColor,'MarkerFaceColor',borderColor)
end
hold on;
set(gca,'TickDir','out');
errorbar(binLevels,SNR,SNRstd/sqrt(nSubj),'Color',borderColor);

%plot(binLevels,meanAmp,'ko-','Color',borderColor,'MarkerFaceColor',borderColor)
%plot(1:length(meanAmp),meanAmp,'ko-','Color',borderColor,'MarkerFaceColor',borderColor)
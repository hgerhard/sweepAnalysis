function [figNum,xyData,phaseData] = plotPolarBin(pdData,dataHdr,binLevels,freqNum,colorVal,figNum,binNum)

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
        case 'Phase'
            phaseIx = k;
    end
end

nSubj = max(pdData(:,trialIx));

if nargin < 5
    colorVal = [0.5 0.5 0.5];
end

if nargin < 6 || isempty(figNum)
    figure;
    set(gcf,'Color','w');
    set(gca,'FontSize',18);
    hold on;
    figNum = gcf;
else
    figure(figNum);
end

crntBinRows = pdData(:,binIx)==binNum;
crntFreqRows = pdData(:,freqIx)==freqNum;
allowedRows = crntBinRows & crntFreqRows;

Sr = pdData(allowedRows,srIx);
Si = pdData(allowedRows,siIx);
phaseData = pdData(allowedRows,phaseIx);
normSrSi = pdData(allowedRows,amplIx);
allowedData = normSrSi>0; % important because samples with 0 mean are from epochs excluded by PowerDiva
Sr = Sr(allowedData);
Si = Si(allowedData);
phaseData = phaseData(allowedData);
xyData = [Sr Si];

errorEllipse = getErrorEllipse(xyData);

for k = 1:nSubj
    plot([0 Sr(k)],[0 Si(k)],'k-','Color',colorVal,'LineWidth',1);
    plot(Sr(k),Si(k),'ko','MarkerFaceColor',colorVal,'MarkerEdgeColor',colorVal,'MarkerSize',8);
end
plot([0 mean(Sr)],[0 mean(Si)],'b-','Color','b','LineWidth',2.5);
fill(errorEllipse(:,1),errorEllipse(:,2),'b','EdgeColor','none','FaceAlpha',0.7);

title(sprintf('Bin %d: %2.2f',binNum,binLevels(binNum)));

minX = min(xlim);
maxX = max(xlim);
minY = min(ylim);
maxY = max(ylim);
xlim([ -max([maxX maxY]) max([maxX maxY]) ])
ylim([ -max([maxX maxY]) max([maxX maxY]) ])
minX = min(xlim);
maxX = max(xlim);
minY = min(ylim);
maxY = max(ylim);
plot([minX maxX],[0 0],'k-','LineWidth',1);
plot([0 0],[minY maxY],'k-','LineWidth',1);
axis equal
axis off
%box off


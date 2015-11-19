function [figNum] = plotNumTrials(pdData,bootData,dataHdr,binLevels,freqNum,dataColor,figHandles)

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
    end
end

nSubj = max(pdData(:,trialIx));

if nargin < 6
    dataColor = 'k';
end

if nargin < 7
    figure;
    set(gcf,'Color','w');
    set(gca,'FontSize',10);
    figNum = gcf;
else
    figNum = figHandles(1);
    figure(figNum);
    set(gcf,'Color','w');
    set(gca,'FontSize',10);
    if length(figHandles)==4
        subplot(figHandles(2),figHandles(3),figHandles(4));
    elseif length(figHandles)>4
        subplot('position',figHandles(2:end));
    end
    hold on;
end

set(gca,'FontSize',10);

nBins = max(pdData(:,binIx));
Ntrials = zeros(1,nBins);
totTrials = zeros(1,nBins);
for binNum = 1:nBins
    crntBinRows = pdData(:,binIx)==binNum;
    crntFreqRows = pdData(:,freqIx)==freqNum;
    allowedRows = crntBinRows & crntFreqRows;
    trialNums = pdData(allowedRows,trialIx);
    normSrSi = pdData(allowedRows,amplIx);    
    allowedData = normSrSi>0; % important addition 
    Ntrials(binNum) = sum(allowedData);
    totTrials(binNum) =  length(allowedData);
end

h = bar(totTrials);
set(h,'FaceColor','w')
hold on;
h = bar(Ntrials);
set(h,'FaceColor','w')
set(h,'EdgeColor',dataColor,'LineWidth',1.5);
set(gca,'YTick',[0 max(totTrials)/4 max(totTrials)/2 3*max(totTrials)/4 max(totTrials)])
ylim([0 max(totTrials)])

ylabel('NTrials')
title('NTrials')

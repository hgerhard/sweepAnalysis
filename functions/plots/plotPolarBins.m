function figNum = plotPolarBins(pdData,dataHdr,binLevels,freqNum,colorVal,figNum)

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
        case 'Signal'
            amplIx = k;
    end
end

if nargin < 5 || isempty(colorVal)
    colorVal = [0.5 0.5 0.5];
end

if nargin < 6 || isempty(figNum)
    figure;
    set(gcf,'Color','w');
    set(gca,'FontSize',10);
    subplot(2,5,1);
    hold on;
    figInfo = gcf;
    if ~isnumeric(figInfo)
        figNum = figInfo.Number;
    else
        figNum = figInfo;
    end
else    
    figure(figNum);
end

cnt = 1;
nBins = max(pdData(:,binIx));
xlimits = nan(10,2);
ylimits = nan(10,2);
for binNum = 1:nBins
    
    subplot(2,ceil(nBins/2),cnt);    
    %set(gca,'TickDir','out');
    hold on;
    box off;
    
    crntBinRows = pdData(:,binIx)==binNum;
    crntFreqRows = pdData(:,freqIx)==freqNum;
    allowedRows = crntBinRows & crntFreqRows;
    
    Sr = pdData(allowedRows,srIx);
    Si = pdData(allowedRows,siIx);
    normSrSi = pdData(allowedRows,amplIx);
    allowedData = normSrSi>0; % important because samples with 0 mean are from epochs excluded by PowerDiva
    Sr = Sr(allowedData);
    Si = Si(allowedData);
    xyData = [Sr Si];  
    
    errorEllipse = fitErrorEllipse(xyData);
    
    for k = 1:length(xyData) % which is the number of subjects if this is project data, or the number of trials if individ. subject data
        plot([0 Sr(k)],[0 Si(k)],'k-','Color',colorVal,'LineWidth',1);
        %plot(Sr(k),Si(k),'ko','MarkerFaceColor',colorVal,'MarkerEdgeColor',colorVal,'MarkerSize',6);
    end
    plot([0 mean(Sr)],[0 mean(Si)],'k-','Color',colorVal,'LineWidth',2);
    fill(errorEllipse(:,1),errorEllipse(:,2),colorVal,'EdgeColor','none','FaceAlpha',0.5);
    
    axis tight
    ylimits(cnt,:) = ylim;
    xlimits(cnt,:) = xlim;
    title(sprintf('Bin %d: %2.2f',binNum,binLevels(binNum)));
    
    cnt = cnt + 1;
    
end

minX = min(xlimits(:,1));
maxX = max(xlimits(:,2));
minY = min(ylimits(:,1));
maxY = max(ylimits(:,2));

for cnt = 1:10
    subplot(2,5,cnt);
    hold on;
    xlim([minX maxX])
    ylim([minY maxY])
    plot([minX maxX],[0 0],'k-');
    plot([0 0],[minY maxY],'k-');
end
    
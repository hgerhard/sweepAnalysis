function figNum = plotPolarBins(pdDataMatrix,dataHdr,binLevels,freqNum,colorVal,figNum)
% figNum = plotPolarBins(pdDataMatrix,dataHdr,binLevels,freqNum,colorVal,figNum)
%
% Creates a multipanel plot containing one panel per bin where all of the
% individual samples for the data are plotted in 2D with an error ellipse.

for k = 1:length(dataHdr)
    switch dataHdr{k}
        case 'iBin'
            binIx = k;
    end
end

srIx = 1;
siIx = 2;

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
nBins = max(pdDataMatrix(:,binIx));
xlimits = nan(10,2);
ylimits = nan(10,2);
for binNum = 1:nBins
    
    subplot(2,ceil(nBins/2),cnt);    
    %set(gca,'TickDir','out');
    hold on;
    box off;    
    
    xyData = getXyData(pdDataMatrix,dataHdr,binNum,freqNum);
    Sr = xyData(:,srIx);
    Si = xyData(:,siIx);
    try
        [~,errorEllipse] = fitErrorEllipse(xyData);
    catch
    end
    
    for k = 1:length(xyData) % which is the number of subjects if this is project data, or the number of trials if individ. subject data
        plot([0 Sr(k)],[0 Si(k)],'k-','Color',colorVal,'LineWidth',1);
        %plot(Sr(k),Si(k),'ko','MarkerFaceColor',colorVal,'MarkerEdgeColor',colorVal,'MarkerSize',6);
    end
    plot([0 mean(Sr)],[0 mean(Si)],'k-','Color',colorVal,'LineWidth',2);
    try
        fill(errorEllipse(:,1),errorEllipse(:,2),colorVal,'EdgeColor','none','FaceAlpha',0.5);
    catch
        fprintf('An error ellipse could not be plotted on your data, probably your data do not contain >1 sample?');
    end
    
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
    
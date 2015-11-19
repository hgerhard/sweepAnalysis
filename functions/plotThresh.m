function figNum = plotThresh(pdData1,pdData2,dataHdr,freqNum,borderColor1,borderColor2,condName1,condName2,figNum)

global mybootdata % ###

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
        case 'Thresh'
            threshIx = k;
        case 'Slope'
            slopeIx = k;
    end
end

nSubj = max(pdData1(:,trialIx));

if nargin < 5
    colors = repmat(linspace(0,1,nSubj),[3 1])';
end

if nargin < 6
    borderColor = 'k';
end

if nargin < 9
    figure;
    set(gcf,'Color','w');
    set(gca,'FontSize',18);
    set(gca,'TickDir','out');
    hold on;
    figNum = gcf;
else
    figure(figNum);
end

rowsIx1 = pdData1(:,freqIx)==freqNum & pdData1(:,binIx)==0;
threshData1 = pdData1(rowsIx1,[threshIx slopeIx]);

rowsIx2 = pdData2(:,freqIx)==freqNum & pdData2(:,binIx)==0;
threshData2 = pdData2(rowsIx2,[threshIx slopeIx]);

for s = 1:nSubj
    if ~isnan(threshData1(s,1)) && ~isnan(threshData2(s,1))
        plot([1 2],[threshData1(s,1) threshData2(s,1)],'k-','LineWidth',2)
        hold on;
    end
end

plot(1,threshData1(:,1),'ko','MarkerFaceColor',borderColor1,'MarkerEdgeColor','k','MarkerSize',18)
hold on;
plot(2,threshData2(:,1),'ko','MarkerFaceColor',borderColor2,'MarkerEdgeColor','k','MarkerSize',18)

xlim([0 3])
set(gca,'XTick',[1 2]);
set(gca,'XTickLabel',{condName1 condName2});

ylabel('Threshold Value')
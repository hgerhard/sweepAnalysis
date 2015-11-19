%1) Get Adult data:
clear
load RCA_Adults_Disparity.mat

%%
plotSettings.comparisonName = 'OZ';
%[snrFigNums] = plotSnr(rcaData,noiseData,rcaSettings,plotSettings,comparisonData,comparisonNoiseData);
plotSettings.showConditions = true;

lineStyles = linspecer(4);
adultColors = lineStyles(1:2,:);
infantColors = lineStyles(3:4,:);
plotSettings.conditionColors = adultColors;

plotSettings.errorType = [];%'SEM';
%figNum = plotFreqByComp(rcaData,noiseData,rcaSettings,plotSettings,comparisonData,comparisonNoiseData); % generates the same plot with an extra column for the comparison sensor

plotSettings.xlabel = 'Relative Disparity (arc min)';
plotSettings.titleOn = false;
%plotSettings.xlabel = 'Background Correlation';
plotSettings.ymax = 2.5;
plotSettings.xTick = [0.5 4 8];%[4 8 16 32 64];%
[figNum,ampVals_AdDisp,noiseVals_AdDisp,binVals_AdDisp,threshInfo_AdDisp]  = plotRcData(rcaData,noiseData,rcaSettings,plotSettings,1,1);

%% 2) Get Infant data:
load RCA_Infants_Disparity_11Subjs.mat
plotSettings.comparisonName = 'OZ';
plotSettings.showConditions = true;
plotSettings.conditionColors = infantColors;
plotSettings.errorType = [];%'SEM';
plotSettings.titleOn = false;

plotSettings.xlabel = 'Relative Disparity (arc min)';
plotSettings.ymax = 7;
plotSettings.xTick = [4 8 16 32 64];%
[figNum,ampVals_InfDisp,noiseVals_InfDisp,binVals_InfDisp,threshInfo_InfDisp]  = plotRcData(rcaData,noiseData,rcaSettings,plotSettings,1,1);
%close all;

%% Now we have adult & infant disparity values for RC1 in each case
% scale each group's data by it's overall peak amplitude across all freqs

condNum = 1; % HORIZONTAL!
adultMax = max(ampVals_AdDisp(condNum,:));
infMax = max(ampVals_InfDisp(condNum,:));

ampVals_AdDisp_norm = ampVals_AdDisp./adultMax;
noiseVals_AdDisp_norm = noiseVals_AdDisp./adultMax;

ampVals_InfDisp_norm = ampVals_InfDisp./infMax;
noiseVals_InfDisp_norm = noiseVals_InfDisp./infMax;

%% 3) Some specific settings that work well:

adultXLim = [0.3 10];
adultXTick = [1 10];
adultXTickLabel = {' ' ' '};
babyXTickLabel = {' ' ' ' ' '};
allXTickLabel = {' ' ' ' ' '};
babyXLim = [2 100]; 
allXLim = [0.3 100];
corrXLim = [-0.1 1.1]; % ?
adultYMax = 2.5;
adultYTick = 0:0.5:2.5;
babyYTick = 0:1:7;
allYTick = 0:0.25:1;
babyYMax = 7;
allYMax = 1;
dispXLabel = 'Relative Disparity (arc min)';
corrXLabel = 'Correlation Level';
normYLabel = 'Normalized Amplitude';
absYLabel = 'Amplitude (\muVolts)';
ms = 14;

%% Build through some Disparity plots:
%% Blank figure:
figure;
set(gca,'XScale','log');
hold on;
set(gca,'Color','w');%[.7 .7 .7]);
set(gca,'FontSize',24);
set(gca,'FontName','Helvetica Neue');
set(gca,'FontWeight','light')
xlim(babyXLim);
ylim([0 babyYMax])
set(gca,'XTick',babyXTick);
set(gca,'XTickLabel',babyXTickLabel);

ylabel(absYLabel)
xlabel(dispXLabel)
set(gca,'YTick',babyYTick);
%print -depsc2 FVM2015Figs/AdultHorRelative_Blank.eps
%% Adult data first harmonic:
freqNum = 1;
condNum = 2;
semilogx(binVals_AdDisp,ampVals_AdDisp(condNum,:,freqNum),'-','LineWidth',3,'Color',adultColors(condNum,:))
hold on;
semilogx(binVals_AdDisp,noiseVals_AdDisp(condNum,:,freqNum),'ks','LineWidth',1,'MarkerSize',ms,'Color',adultColors(condNum,:),'MarkerFaceColor',adultColors(condNum,:))
%print -depsc2 FVM2015Figs/DispHor_1.eps
%% Adult data second harmonic:
freqNum = 2;
semilogx(binVals_AdDisp,ampVals_AdDisp(condNum,:,freqNum),'--','LineWidth',3,'Color',adultColors(condNum,:))
semilogx(binVals_AdDisp,noiseVals_AdDisp(condNum,:,freqNum),'ks','LineWidth',3,'Color',adultColors(condNum,:),'MarkerSize',ms)

%% adult data (white/invisible)
freqNum = 1;
condNum = 2;
semilogx(binVals_AdDisp,ampVals_AdDisp(condNum,:,freqNum),'-','LineWidth',3,'Color','w');
hold on;
semilogx(binVals_AdDisp,noiseVals_AdDisp(condNum,:,freqNum),'ks','LineWidth',1,'MarkerSize',ms,'Color','w','MarkerFaceColor','w')

%print -depsc2 FVM2015Figs/DispHor_2.eps

%% Infant data all together:
freqNum = 1;
condNum = 1;
semilogx(binVals_InfDisp,ampVals_InfDisp(condNum,:,freqNum),'-','LineWidth',3,'Color',infantColors(condNum,:))
semilogx(binVals_InfDisp,noiseVals_InfDisp(condNum,:,freqNum),'ks','LineWidth',3,'MarkerSize',ms,'Color',infantColors(condNum,:),'MarkerFaceColor',infantColors(condNum,:))

condNum = 2;
semilogx(binVals_InfDisp,ampVals_InfDisp(condNum,:,freqNum),'-','LineWidth',3,'Color',infantColors(condNum,:))
semilogx(binVals_InfDisp,noiseVals_InfDisp(condNum,:,freqNum),'ks','LineWidth',3,'MarkerSize',ms,'Color',infantColors(condNum,:),'MarkerFaceColor',infantColors(condNum,:))
%print -depsc2 FVM2015Figs/DispHor_InfAdults.eps
%% Adult 1F1 & Baby 2F1 together:

freqNum = 1;
condNum = 1;
semilogx(binVals_AdDisp,ampVals_AdDisp_norm(condNum,:,freqNum),'-','LineWidth',3,'Color',adultColors(condNum,:))
hold on;
semilogx(binVals_AdDisp,noiseVals_AdDisp_norm(condNum,:,freqNum),'ks','LineWidth',1,'MarkerSize',ms,'Color',adultColors(condNum,:),'MarkerFaceColor',adultColors(condNum,:))

freqNum = 2;
semilogx(binVals_InfDisp,ampVals_InfDisp_norm(condNum,:,freqNum),'-','LineWidth',3,'Color',infantColors(condNum,:))
semilogx(binVals_InfDisp,noiseVals_InfDisp_norm(condNum,:,freqNum),'ks','LineWidth',1,'MarkerSize',ms,'Color',infantColors(condNum,:),'MarkerFaceColor',infantColors(condNum,:))

%% Plot threshold fits

freqNum = 1; % for adults
condNum = 1;
semilogx(threshInfo_AdDisp.xx{freqNum,condNum},threshInfo_AdDisp.YY{freqNum,condNum},'k-','LineWidth',3);
semilogx(threshInfo_AdDisp.threshVals(freqNum,condNum),0,'kd','MarkerSize',ms,...
    'MarkerFaceColor',adultColors(condNum,:),'LineWidth',3);

%%
freqNum = 2; % for infants
condNum = 1;
semilogx(threshInfo_InfDisp.xx{freqNum,condNum},threshInfo_InfDisp.YY{freqNum,condNum},'k-','LineWidth',3);
semilogx(threshInfo_InfDisp.threshVals(freqNum,condNum),0,'kd','MarkerSize',ms,...
    'MarkerFaceColor',infantColors(condNum,:),'LineWidth',3);


%% Build through the Ratio Bar Figure: F1/(F1+F2):
%% Blank figure:
figure; 
set(gca,'Color','w');
hold on;
set(gca,'FontSize',24);
ylim([0 1])
xlim([0.5 2.5])
set(gca,'XTick',[1 2]);
set(gca,'YTick',0:0.25:1);
%set(gca,'XTickLabel',{'Adult' 'Infant'});
set(gca,'XTickLabel',{' ' ' '});
set(gca,'YTickLabel',{' ' ' '});
plot([0.5 2.5],[0.5 0.5],'k-','LineWidth',2);
print -depsc2 FVM2015Figs/DispHorBar_Blank.eps
%% Adult data bar first:
condNum = 1;
adultF1 = max(ampVals_AdDisp_norm(condNum,:,1));
adultF2 = max(ampVals_AdDisp_norm(condNum,:,2));
adultRatio = adultF1 / (adultF1 + adultF2);

infantF1 = max(ampVals_InfDisp_norm(condNum,:,1));
infantF2 = max(ampVals_InfDisp_norm(condNum,:,2));
infantRatio = infantF1 / (infantF1 + infantF2);

h = bar([1 2],diag([adultRatio,infantRatio]),'stacked');
set(h(1),'facecolor',adultColors(condNum,:),'LineStyle','none','BarWidth',0.4)
set(h(2),'facecolor','none','LineStyle','none','BarWidth',0.4)
print -depsc2 FVM2015Figs/DispHorBar_1.eps
%% Baby data bar:
set(h(2),'facecolor',infantColors(condNum,:),'LineStyle','none')
print -depsc2 FVM2015Figs/DispHorBar_2.eps
%%






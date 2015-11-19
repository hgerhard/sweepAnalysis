
%2) Make Correlation plots :

clear
load RCA_Adults_Correlation.mat
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

plotSettings.xlabel = 'Background Correlation';
plotSettings.ymax = 7;
plotSettings.xTick = [0 0.5 1];
[figNum,ampVals_AdDisp,noiseVals_AdDisp,binVals_AdDisp]  = plotRcData(rcaData,noiseData,rcaSettings,plotSettings,1);

%%
load RCA_Infants_Correlation_9Subjs.mat
plotSettings.comparisonName = 'OZ';
plotSettings.showConditions = true;
plotSettings.conditionColors = infantColors;
plotSettings.errorType = [];%'SEM';

plotSettings.xlabel = 'Background Correlation';
plotSettings.ymax = 7;
plotSettings.xTick = [0 0.5 1];
[figNum,ampVals_InfDisp,noiseVals_InfDisp,binVals_InfDisp]  = plotRcData(rcaData,noiseData,rcaSettings,plotSettings,1);
%close all;

%% Now we have adult & infant disparity values for RC1 in each case

% scale each group's data by it's overall peak amplitude across all freqs

adultMax = max(ampVals_AdDisp(:));
infMax = max(ampVals_InfDisp(:));

ampVals_AdDisp_norm = ampVals_AdDisp./adultMax;
noiseVals_AdDisp_norm = noiseVals_AdDisp./adultMax;

ampVals_InfDisp_norm = ampVals_InfDisp./infMax;
noiseVals_InfDisp_norm = noiseVals_InfDisp./infMax;
%% Build through the plot:
%% Blank figure:
figure;
hold on;
set(gca,'Color','w');%[.7 .7 .7]);
set(gca,'FontSize',24);
xlim([0 1]) 
ylim([0 1])
set(gca,'XTick',0:0.25:1);
set(gca,'YTick',0:0.2:1);
%% Adult data first harmonic:
freqNum = 1;
condNum = 1;
plot(binVals_AdDisp,ampVals_AdDisp_norm(condNum,:,freqNum),'-','LineWidth',3,'Color',adultColors(condNum,:))
hold on;
plot(binVals_AdDisp,noiseVals_AdDisp_norm(condNum,:,freqNum),'ks','LineWidth',1,'Color',adultColors(condNum,:),'MarkerFaceColor',adultColors(condNum,:))
%% Adult data second harmonic:
freqNum = 2;
plot(binVals_AdDisp,ampVals_AdDisp_norm(condNum,:,freqNum),'--','LineWidth',3,'Color',adultColors(condNum,:))
plot(binVals_AdDisp,noiseVals_AdDisp_norm(condNum,:,freqNum),'ks','LineWidth',1,'Color',adultColors(condNum,:))
%% Infant data all together:
freqNum = 1;
plot(binVals_InfDisp,ampVals_InfDisp_norm(condNum,:,freqNum),'-','LineWidth',3,'Color',infantColors(condNum,:))
plot(binVals_InfDisp,noiseVals_InfDisp_norm(condNum,:,freqNum),'ks','LineWidth',1,'Color',infantColors(condNum,:),'MarkerFaceColor',infantColors(condNum,:))

freqNum = 2;
plot(binVals_InfDisp,ampVals_InfDisp_norm(condNum,:,freqNum),'--','LineWidth',3,'Color',infantColors(condNum,:))
plot(binVals_InfDisp,noiseVals_InfDisp_norm(condNum,:,freqNum),'ks','LineWidth',1,'Color',infantColors(condNum,:))

%% Build through the Ratio Bar Figure: F1/(F1+F2):
%% Blank figure:
figure; 
set(gca,'Color','w');
hold on;
set(gca,'FontSize',24);
ylim([0 1])
xlim([0.5 2.5])
set(gca,'XTick',[1 2]);
%set(gca,'XTickLabel',{'Adult' 'Infant'});
set(gca,'XTickLabel',{' ' ' '});
plot([0.5 2.5],[0.5 0.5],'k-','LineWidth',2);
%% Adult data bar first:
condNum = 1;
adultF1 = max(ampVals_AdDisp_norm(condNum,:,1));
adultF2 = max(ampVals_AdDisp_norm(condNum,:,2));
adultRatio = adultF1 / (adultF1 + adultF2);

infantF1 = max(ampVals_InfDisp_norm(condNum,:,1));
infantF2 = max(ampVals_InfDisp_norm(condNum,:,2));
infantRatio = infantF1 / (infantF1 + infantF2);

h = bar([1 2],diag([adultRatio,infantRatio]),'stacked');
set(h(1),'facecolor',adultColors(condNum,:),'LineStyle','none')
set(h(2),'facecolor','none','LineStyle','none')
%% Baby data bar:
set(h(2),'facecolor',infantColors(condNum,:),'LineStyle','none')

%%






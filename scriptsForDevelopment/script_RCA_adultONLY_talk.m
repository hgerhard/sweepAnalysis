%1) Make Disparity plots first:
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
plotSettings.xTick = [0.5 1 2 4 8];%[4 8 16 32 64];%
[figNum,ampVals_AdDisp,noiseVals_AdDisp,binVals_AdDisp,threshInfo_AdDisp]  = plotRcData(rcaData,noiseData,rcaSettings,plotSettings,1,1);

%% Build through the plot:
%% Blank figure:
figure;
set(gca,'XScale','log');
hold on;
set(gca,'Color','w');%[.7 .7 .7]);
set(gca,'FontSize',24);
set(gca,'FontName','Helvetica');
set(gca,'FontWeight','light')
xlim([0 100]) 
ylim([0 2.5])
ylabel('Amplitude (\muVolts)')
xlabel('Relative Disparity (arc min)')
%set(gca,'XTick',[0.5 1 2 4 8]);
%set(gca,'XTick',[0.5 1 2 4 8 16 32 64]);
set(gca,'YTick',0:0.5:2.5);

freqNum = 1;
condNum = 1;
semilogx(binVals_AdDisp,ampVals_AdDisp(condNum,:,freqNum),'-','LineWidth',3,'Color','w')
hold on;
%print -depsc2 FVM2015Figs/DispHorAdult_Blank.eps

%% Adult data first harmonic:
freqNum = 1;
condNum = 1;
semilogx(binVals_AdDisp,ampVals_AdDisp(condNum,:,freqNum),'-','LineWidth',3,'Color',adultColors(condNum,:))
hold on;
semilogx(binVals_AdDisp,noiseVals_AdDisp(condNum,:,freqNum),'ks','LineWidth',1,'Color',adultColors(condNum,:),'MarkerSize',18,'MarkerFaceColor',adultColors(condNum,:))
%print -depsc2 FVM2015Figs/DispHorAdult_1.eps

%% Adult data second harmonic:
freqNum = 2;
semilogx(binVals_AdDisp,ampVals_AdDisp(condNum,:,freqNum),'--','LineWidth',3,'Color',adultColors(condNum,:))
semilogx(binVals_AdDisp,noiseVals_AdDisp(condNum,:,freqNum),'ks','LineWidth',3,'Color',adultColors(condNum,:),'MarkerSize',18);

%% Adult data vertical:
freqNum = 1;
condNum = 2;
semilogx(binVals_AdDisp,ampVals_AdDisp(condNum,:,freqNum),'-','LineWidth',3,'Color',adultColors(condNum,:))
semilogx(binVals_AdDisp,noiseVals_AdDisp(condNum,:,freqNum),'ks','LineWidth',1,'Color',adultColors(condNum,:),'MarkerFaceColor',adultColors(condNum,:))
%print -depsc2 FVM2015Figs/DispVerticalAdult.eps





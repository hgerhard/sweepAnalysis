%1) Make Disparity plots first:
clear
load RCA_Infants_Disparity_11Subjs.mat
%%
plotSettings.comparisonName = 'OZ';
%[snrFigNums] = plotSnr(rcaData,noiseData,rcaSettings,plotSettings,comparisonData,comparisonNoiseData);
plotSettings.showConditions = true;

lineStyles = linspecer(4);
infantColors = lineStyles(3:4,:);
plotSettings.conditionColors = infantColors;

plotSettings.errorType = [];%'SEM';
%figNum = plotFreqByComp(rcaData,noiseData,rcaSettings,plotSettings,comparisonData,comparisonNoiseData); % generates the same plot with an extra column for the comparison sensor

plotSettings.xlabel = 'Relative Disparity (arc min)';
plotSettings.titleOn = false;
%plotSettings.xlabel = 'Background Correlation';
plotSettings.ymax = 7;
plotSettings.xTick = [4 8 16 32 64];%
[figNum,ampVals_InfDisp,noiseVals_InfDisp,binVals_InfDisp,threshInfo_InfDisp]  = plotRcData(rcaData,noiseData,rcaSettings,plotSettings,1,1);

%% Build through the plot:
%% Blank figure:
figure;
set(gca,'XScale','log');
hold on;
set(gca,'Color','w');%[.7 .7 .7]);
set(gca,'FontSize',24);
set(gca,'FontName','Helvetica');
set(gca,'FontWeight','light')
xlim([2 80]) 
ylim([0 7])
ylabel('Amplitude (\muVolts)')
xlabel('Relative Disparity (arc min)')
set(gca,'XTick',[4 8 16 32 64]);
%set(gca,'YTick',0:0.5:2.5);

freqNum = 1;
condNum = 1;
semilogx(binVals_InfDisp,ampVals_InfDisp(condNum,:,freqNum),'-','LineWidth',3,'Color','w')
hold on;
%print -depsc2 FVM2015Figs/DispHorInfant_Blank.eps
%% First harmonic:
freqNum = 1;
condNum = 1;
semilogx(binVals_InfDisp,ampVals_InfDisp(condNum,:,freqNum),'-','LineWidth',3,'Color',infantColors(condNum,:))
hold on;
semilogx(binVals_InfDisp,noiseVals_InfDisp(condNum,:,freqNum),'ks','LineWidth',1,'Color',infantColors(condNum,:),'MarkerSize',18,'MarkerFaceColor',infantColors(condNum,:))
%print -depsc2 FVM2015Figs/DispHorInfant_1.eps
%% Second harmonic:
freqNum = 2;
semilogx(binVals_InfDisp,ampVals_InfDisp(condNum,:,freqNum),'-','LineWidth',3,'Color',infantColors(condNum,:))
semilogx(binVals_InfDisp,noiseVals_InfDisp(condNum,:,freqNum),'ks','LineWidth',1,'Color',infantColors(condNum,:),'MarkerSize',18,'MarkerFaceColor',infantColors(condNum,:))
%print -depsc2 FVM2015Figs/DispHorInfant_2.eps
%%
freqNum = 2;
condNum = 2;
semilogx(binVals_InfDisp,ampVals_InfDisp(condNum,:,freqNum),'-','LineWidth',3,'Color',infantColors(condNum,:))
semilogx(binVals_InfDisp,noiseVals_InfDisp(condNum,:,freqNum),'ks','LineWidth',1,'Color',infantColors(condNum,:),'MarkerSize',18,'MarkerFaceColor',infantColors(condNum,:))
%print -depsc2 FVM2015Figs/DispVerticalInfant_2F1.eps

%% thresh fits:
freqNum = 2; % for infants
condNum = 1;
semilogx(threshInfo_InfDisp.xx{freqNum,condNum},threshInfo_InfDisp.YY{freqNum,condNum},'k-','LineWidth',3);
semilogx(threshInfo_InfDisp.threshVals(freqNum,condNum),0,'kd','MarkerSize',18,...
    'MarkerFaceColor',infantColors(condNum,:),'LineWidth',3);




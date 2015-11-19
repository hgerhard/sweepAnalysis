%1) Make Disparity plots first:

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

plotSettings.xlabel = 'Disparity (arc min)';
%plotSettings.xlabel = 'Background Correlation';
plotSettings.ymax = 2.5;
plotSettings.xTick = [0.5 4 8];%[4 8 16 32 64];%
[figNum,ampVals_AdDisp,noiseVals_AdDisp,binVals_AdDisp]  = plotRcData(rcaData,noiseData,rcaSettings,plotSettings,1);

%%
load RCA_Infants_Disparity_11Subjs.mat
plotSettings.comparisonName = 'OZ';
plotSettings.showConditions = true;
plotSettings.conditionColors = infantColors;
plotSettings.errorType = [];%'SEM';

plotSettings.xlabel = 'Disparity (arc min)';
plotSettings.ymax = 7;
plotSettings.xTick = [4 8 16 32 64];%
[figNum,ampVals_InfDisp,noiseVals_InfDisp,binVals_InfDisp]  = plotRcData(rcaData,noiseData,rcaSettings,plotSettings,1);
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
%% Build through the plot:
%% Blank figure:
figure;
set(gca,'XScale','log');
hold on;
set(gca,'Color','w');%[.7 .7 .7]);
set(gca,'FontSize',24);
set(gca,'FontName','Helvetica Neue');
xlim([0.4 80]) 
ylim([0 1])
set(gca,'XTick',[0.5 4 8  64]);

ylabel('Normalized Amplitude')
xlabel('Relative Disparity (arc min)')
%set(gca,'XTick',[0.5 1 2 4 8 16 32 64]);
set(gca,'YTick',0:0.2:1);
%print -depsc2 FVM2015Figs/DispHor_Blank.eps
%% Adult data first harmonic:
freqNum = 1;
condNum = 1;
semilogx(binVals_AdDisp,ampVals_AdDisp_norm(condNum,:,freqNum),'-','LineWidth',3,'Color',adultColors(condNum,:))
hold on;
semilogx(binVals_AdDisp,noiseVals_AdDisp_norm(condNum,:,freqNum),'ks','LineWidth',1,'Color',adultColors(condNum,:),'MarkerFaceColor',adultColors(condNum,:))
%print -depsc2 FVM2015Figs/DispHor_1.eps
%% Adult data second harmonic:
%freqNum = 2;
%semilogx(binVals_AdDisp,ampVals_AdDisp_norm(condNum,:,freqNum),'--','LineWidth',3,'Color',adultColors(condNum,:))
%semilogx(binVals_AdDisp,noiseVals_AdDisp_norm(condNum,:,freqNum),'ks','LineWidth',1,'Color',adultColors(condNum,:))
%print -depsc2 FVM2015Figs/DispHor_2.eps

%% Infant data all together:
%freqNum = 1;
%semilogx(binVals_InfDisp,ampVals_InfDisp_norm(condNum,:,freqNum),'-','LineWidth',3,'Color',infantColors(condNum,:))
%semilogx(binVals_InfDisp,noiseVals_InfDisp_norm(condNum,:,freqNum),'ks','LineWidth',1,'Color',infantColors(condNum,:),'MarkerFaceColor',infantColors(condNum,:))

freqNum = 2;
semilogx(binVals_InfDisp,ampVals_InfDisp_norm(condNum,:,freqNum),'-','LineWidth',3,'Color',infantColors(condNum,:))
semilogx(binVals_InfDisp,noiseVals_InfDisp_norm(condNum,:,freqNum),'ks','LineWidth',1,'Color',infantColors(condNum,:),'MarkerFaceColor',infantColors(condNum,:))
print -depsc2 FVM2015Figs/DispHor_InfAdults.eps





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






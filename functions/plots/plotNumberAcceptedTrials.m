function [figNum] = plotNumberAcceptedTrials(pdData,dataHdr,freqNum,plotOpt,figHandles)
% [figNum] = plotNumberAcceptedTrials(pdData,dataHdr,freqNum,plotOpt,figHandles)
%
% Creates a bar plot indicating the number of accepted trials for each bin
% and the total number of trials run for each bin. Accepted trials are
% bars with colored edges whereas total numbers of trials are gray/black
% edged bars.
%
% INPUTS:
%       plotOpt: structure holding options for plots (e.g., colors). Fields and defaults are
%           plotOpt.dataColor = 'k';

for k = 1:length(dataHdr)
    switch dataHdr{k}
        case 'iTrial'
            trialIx = k;
        case 'iFr'
            freqIx = k;
        case 'iBin'
            binIx = k;
        case 'Signal'
            amplIx = k;
    end
end

% set all plot options to default if none specified
if nargin < 4 || isempty(plotOpt)
    plotOpt.dataColor = 'k';
end

% set any missing plot options to default
if ~isfield(plotOpt,'dataColor'); plotOpt.dataColor='k'; end

hexagArrag = false;
if nargin < 5 || isempty(figHandles)
    figure;
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    hold on;
    figInfo = gcf;
    if ~isnumeric(figInfo)
        figNum = figInfo.Number;        
    else
        figNum = figInfo;
    end
else
    figNum = figHandles(1);
    figure(figNum);
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    if length(figHandles)==4
        subplot(figHandles(2),figHandles(3),figHandles(4));
    elseif length(figHandles)>4
        subplot('position',figHandles(2:end));
        hexagArrag = true;
    end
    hold on;
end

nBins = max(pdData(:,binIx));
Ntrials = zeros(1,nBins);
totTrials = zeros(1,nBins);
for binNum = 1:nBins
    crntBinRows = pdData(:,binIx)==binNum;
    crntFreqRows = pdData(:,freqIx)==freqNum;
    allowedRows = crntBinRows & crntFreqRows & pdData(:,trialIx)>0; % do not include the 0th trial which is the mean trial
    normSrSi = pdData(allowedRows,amplIx);    
    acceptedTrials = normSrSi>0; % important because trials with 0 amplitude signify PowerDiva-rejected epochs  
    Ntrials(binNum) = sum(acceptedTrials);
    totTrials(binNum) = length(acceptedTrials);
end

h = bar(totTrials);
set(h,'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9],'LineWidth',1.5);
hold on;
h = bar(Ntrials);
set(h,'FaceColor','w')
set(h,'EdgeColor',plotOpt.dataColor,'LineWidth',1.5);
ylim([0 max(totTrials)])
xlim([0 nBins+1])
box off

if ~hexagArrag
    ylabel('Number of Trials')
    xlabel('Bin Number')
    set(gca,'YTick',[0 max(totTrials)/4 max(totTrials)/2 3*max(totTrials)/4 max(totTrials)])
    set(gca,'XTick',[1 floor(nBins/2) nBins])
else
    set(gca,'YTick',[0 max(totTrials)])
    set(gca,'XTick','')
end
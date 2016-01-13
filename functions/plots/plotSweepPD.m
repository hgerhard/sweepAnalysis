function [figNum,plotNum] = plotSweepPD(plotType,pdData,dataHdr,binLevels,freqNum,errType,dataColor,figHandles)

% [figNum,plotNum] = plotSweepPD(plotType,pdData,dataHdr,binLevels,freqNum,errType,dataColor,figHandles)
%   
% Create a plot that looks like the PowerDiva style plots, using 
% precomputed values from PowerDiva for the means and noise estimates. The
% additional property of this plot is that it also shows errorbars based on
% the desired type of error estimation process specified in errType
% (default 'SEM') for the plotType 'Ampl'
%
% plotTypes: 'Ampl' (amplitude in muV) or 'SNR' for Snr (no errorbars)
%
% This function is only meant to be called once for a particular sweep. The
% logic is that you create a figure and then call this function each time
% you want to plot another sweep (i.e. from a different group or a
% different condition)

for k = 1:length(dataHdr)
    switch dataHdr{k}
        case 'iTrial'
            trialIx = k;
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
        case 'SNR'
            SNRIx = k;
        case 'Noise'
            noiseIx = k;
    end
end

switch plotType
    case {'Ampl','SNR'}
    otherwise
        error('PlotType (parameter 1) must be either ''Ampl'' or ''SNR''');
end
if nargin < 6 || isempty(errType)
    errType = 'SEM';
end

if nargin < 7 || isempty(dataColor)
    dataColor = 'k';
end

hexagArrag = false;
if nargin < 8 || isempty(figHandles)
    figure;
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    figInfo = gcf;
    if ~isnumeric(figInfo)
        figNum = figInfo.Number;        
    else
        figNum = figInfo;
    end
else
    figNum = figHandles(1);
    figure(figNum);
    if length(figHandles)==4
        subplot(figHandles(2),figHandles(3),figHandles(4));
    elseif length(figHandles)>4
        subplot('position',figHandles(2:end));
        hexagArrag = true;
    end
    if isLogSpaced(binLevels)
        set(gca,'XScale','log');
    end
end

if hexagArrag
    mrkrSz = 10;
else
    mrkrSz = 14;
end

nBins = max(pdData(:,binIx));

% Get the mean trial data only (as computed by PowerDiva)
meanTrialRows = pdData(:,trialIx) == 0 & pdData(:,binIx) ~= 0 & pdData(:,freqIx) == freqNum;
meanTrialMat = pdData(meanTrialRows,:);

switch plotType
    case 'Ampl'
        indexToPlot = amplIx;
        % Get the error estimates for confidence intervals on the means
        amplErrorRange = nan(2,nBins);
        for binNum = 1:nBins
            crntBinRows = pdData(:,binIx)==binNum;
            crntFreqRows = pdData(:,freqIx)==freqNum;
            allowedRows = crntBinRows & crntFreqRows;
            trialNums = pdData(allowedRows,trialIx);
            allowedRows = allowedRows & pdData(:,trialIx)>0; % 0th trial is the mean trial
            Sr = pdData(allowedRows,srIx);
            Si = pdData(allowedRows,siIx);
            allowedData = pdData(allowedRows,amplIx)>0; % important because samples with 0 mean are from epochs excluded by PowerDiva
            xyData = [Sr(allowedData) Si(allowedData)];
            
            try
                amplErrorRange(:,binNum) = fitErrorEllipse(xyData,errType);
            catch
            end
        end
        if ~hexagArrag, ylabel('Amplitude (\muV)'), end
    case 'SNR'
        indexToPlot = SNRIx;
        if ~hexagArrag, ylabel('SNR'), end
end


figure(figNum);
% Plot mean data (filled circles):
if isLogSpaced(binLevels)
    hold on;
    plotNum = semilogx(binLevels,meanTrialMat(:,indexToPlot),'ko-','Color',dataColor,'MarkerFaceColor',dataColor,'LineWidth',2);   
    if strcmp(plotType,'Ampl')
        % with noise estimates (empty squares)
        semilogx(binLevels,meanTrialMat(:,noiseIx),'ks','Color',dataColor,'MarkerSize',mrkrSz);
    end
else
    hold on;
    plotNum = plot(binLevels,meanTrialMat(:,indexToPlot),'ko-','Color',dataColor,'MarkerFaceColor',dataColor,'LineWidth',2);
    if strcmp(plotType,'Ampl')
        plot(binLevels,meanTrialMat(:,noiseIx),'ks','Color',dataColor,'MarkerSize',mrkrSz);
    end
end

if strcmp(plotType,'Ampl')
    % Plot error bars on the means (don't use built-in Matlab errorbar
    % function because it makes ugly "tees," the horizontal lines, sometimes)
    for binNum = 1:nBins
        try
            plot([binLevels(binNum) binLevels(binNum)],[amplErrorRange(1,binNum) amplErrorRange(2,binNum)],'k-','Color',dataColor,'LineWidth',2);
        catch
        end
    end
end

set(gca,'XTick',binLevels([1 floor(length(binLevels)/2) end]))
if ~hexagArrag
    xlabel('Bin Values')
    set(gca,'ticklength',1.5*get(gca,'ticklength'))
else
    axis square
    box off
    set(gca,'ticklength',2.5*get(gca,'ticklength'))
end
set(gca,'tickDir','out')

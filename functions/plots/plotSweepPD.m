function [figNum,plotNum,threshInfo] = plotSweepPD(plotType,pdDataMatrix,dataHdr,binLevels,freqNum,errType,plotThreshFit,plotOpt,figHandles)

% function [figNum,plotNum,threshInfo] = plotSweepPD(plotType,pdDataMatrix,dataHdr,binLevels,freqNum,errType,plotThreshFit,plotOpt,figHandles)
%   
% Create a plot that looks like the PowerDiva style plots, using 
% precomputed values from PowerDiva for the means and noise estimates. The
% additional property of this plot is that it also shows errorbars based on
% the desired type of error estimation process specified in errType
% (default 'SEM') for the plotType 'Ampl'
%
% plotTypes: 'Ampl' (amplitude in muV) or 'SNR' for Snr (no errorbars)
% plotOpt: structure holding options for plots (e.g., colors). Fields and defaults are
%       plotOpt.dataColor = 'k';
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

if nargin < 7 || isempty(plotThreshFit), plotThreshFit = 0; end

if plotThreshFit && ~strcmp(plotType,'Ampl')
    fprintf('You can only plot threshold fits if the plotType is set to ''Ampl''.');
    plotThreshFit = 0;
end

% set all plot options to default if non specified
if nargin < 8 || isempty(plotOpt)
    plotOpt.dataColor = 'k';
end

% set any missing plot options to default
if ~isfield(plotOpt,'dataColor'); plotOpt.dataColor='k'; end

hexagArrag = false;
if nargin < 9 || isempty(figHandles)
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

nBins = max(pdDataMatrix(:,binIx));

threshFitted = 0;
threshVal = nan;
slopeVal = nan;
fitBinRange = nan(1,2);

% Get the mean trial data only (as computed by PowerDiva):
meanTrialRows = pdDataMatrix(:,trialIx) == 0 & pdDataMatrix(:,binIx) ~= 0 & pdDataMatrix(:,freqIx) == freqNum;
meanTrialMat = pdDataMatrix(meanTrialRows,:);

switch plotType
    case 'Ampl'
        indexToPlot = amplIx;
        % Get the error estimates for confidence intervals on the means
        amplErrorRange = nan(2,nBins);
        for binNum = 1:nBins
            
            xyData = getXyData(pdDataMatrix,dataHdr,binNum,freqNum);            
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

% Compute threshold & slope (and associated variables) if desired:
if plotThreshFit && strcmp(plotType,'Ampl')
    clear sweepMatSubjects;
    sweepMatSubjects = constructSweepMatSubjects(pdDataMatrix,dataHdr,freqNum);
    
    [threshVal,slopeVal,tLSB,tRSB,~,saveY,saveXX] = powerDivaScoring(sweepMatSubjects, binLevels);
    fitBinRange = [tLSB,tRSB];
    if isnan(threshVal)
        fprintf('No threshold could be fitted.\n');
    else
        % save line info to plot after everything else so it's "on top"
        fprintf('Thresh = %1.2f, Slope = %1.2f, Range=[%d,%d].\n',threshVal,slopeVal,fitBinRange)
        threshFitted = 1;
    end
    
    if threshFitted
        threshInfo.xx = saveXX;
        threshInfo.YY = saveY;
        threshInfo.threshVal = threshVal;
        threshInfo.slopeVal = slopeVal;
        threshInfo.fitBinRange = fitBinRange;
    else
        threshInfo.xx = nan;
        threshInfo.YY = nan;
        threshInfo.threshVal = nan;
        threshInfo.slopeVal = nan;
        threshInfo.fitBinRange = nan;
    end    
end


figure(figNum);
% Plot mean data (filled circles):
if isLogSpaced(binLevels)
    hold on;
    plotNum = semilogx(binLevels,meanTrialMat(:,indexToPlot),'ko-','Color',plotOpt.dataColor,'MarkerFaceColor',plotOpt.dataColor,'LineWidth',2);   
    if strcmp(plotType,'Ampl')
        % with noise estimates (empty squares)
        semilogx(binLevels,meanTrialMat(:,noiseIx),'ks','Color',plotOpt.dataColor,'MarkerSize',mrkrSz);
    end
else
    hold on;
    plotNum = plot(binLevels,meanTrialMat(:,indexToPlot),'ko-','Color',plotOpt.dataColor,'MarkerFaceColor',plotOpt.dataColor,'LineWidth',2);
    if strcmp(plotType,'Ampl')
        plot(binLevels,meanTrialMat(:,noiseIx),'ks','Color',plotOpt.dataColor,'MarkerSize',mrkrSz);
    end
end

% Plot error bars if appropriate:
if strcmp(plotType,'Ampl')
    % don't use built-in Matlab errorbar unction because it makes ugly 
    % "tees," the horizontal lines on top & bottom
    for binNum = 1:nBins
        try
            plot([binLevels(binNum) binLevels(binNum)],[amplErrorRange(1,binNum) amplErrorRange(2,binNum)],'k-','Color',plotOpt.dataColor,'LineWidth',2);
        catch            
            fprintf('Error bars could not be plotted on your data, probably your data do not contain >1 sample.');
        end
    end
end

% Plot linear fit used to extrapolate to the zero-crossing/threshold:
if plotThreshFit && threshFitted    
    if isLogSpaced(binLevels)
        semilogx(saveXX,saveY,'k-','LineWidth',3);
        semilogx(threshVal,0,'kd','MarkerSize',18,...
            'MarkerFaceColor',plotOpt.dataColor,'LineWidth',3);
    else
        plot(saveXX,saveY,'k-','LineWidth',3);
        plot(threshVal,0,'kd','MarkerSize',18,...
            'MarkerFaceColor',plotOpt.dataColor,'LineWidth',3);
    end
    text(threshVal,0.2*max(ylim),sprintf('thresh = %2.2f',threshVal),'Color',plotOpt.dataColor,'FontSize',12);
end

% Make some final plot settings:
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

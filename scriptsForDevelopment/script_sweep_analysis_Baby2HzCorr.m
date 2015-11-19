% Sweep Analysis Outline

% 1. Read in PowerDiva data, get matrix of sweep data
dataDir = '~/Experiments/3DThresh/Data/Baby_2Hz/Correlation/Project_Exp_TEXT_HCN_128_Avg/';
channels = [71 76 70 75 83 74 82];
sweepEstType = 'RLS';
%%
pdData = makeDataStructure(dataDir,channels,sweepEstType);

%% 2. Bootstrap across subject means within each condition & bin
% cd(dataDir);
% load(sprintf('DispSweepData_%s.mat',sweepEstType));
% %load(sprintf('Pilot2Data_%s.mat',sweepEstType));
% nBoot = 1000;
% bootData = bootStrapSweeps(pdData,nBoot);

%% 3. Plots: 

colors = linspace(0.6,0.9,7);
allColors = zeros(7,3,5);
allColors(:,1,1) = colors; % R
allColors(:,2,2) = colors; % G
allColors(:,3,3) = colors; % B
allColors(:,[1 3],4) = repmat(colors',[1 2]); % M
allColors(:,[2 3],5) = repmat(colors',[1 2]); % C
allColors(:,[1 2 3],6) = repmat(colors',[1 3]); % K

colHdr = pdData(1).hdrFields; % hdrFields is the same for all conditions/electrodes

%% Subplot parameters for hexagonal placement
s = 0.25;
b = 0.1;
subplotLoc = [ s/2+b s*2+2*b-.005 s s; ...
    (s/2)+s+2*b s*2+2*b-.005 s s; ...
    
    4*b/5     s+5*b/4 s s; ...
    s+8*b/5+0.002    s+5*b/4 s s; ...
    2*s+5*b/2 s+5*b/4 s s; ...
    
    s/2+b b/2 s s; ...
    (s/2)+s+2*b b/2 s s;];

%%   - Classic sweep plots of power as a fxn of bin value, with error bars
for freqNum = 1:length(pdData(1,1).avFreqs)
    figNum = freqNum;
    for chanNum = 1:length(channels)
        
        condNum = 1;
        figNum = plotSweep( pdData(condNum,chanNum).dataMatr, [], ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(end,:,2), [figNum,subplotLoc(chanNum,:)], 'SEMvector');
        
        condNum = 2;
        plotSweep( pdData(condNum,chanNum).dataMatr, [], ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(end,:,4), [figNum,subplotLoc(chanNum,:)], 'SEMvector');

        %xlim([0 pdData(condNum,chanNum).binLevels(end)+2]) % for disp sweeps 
        %set(gca,'XTick',[0 0.5 1 2 4 8 16 32 64])
        set(gca,'YTick',[0 max(ylim)/4 max(ylim)/2 3*max(ylim)/4 max(ylim)])
        textInset = sprintf('%s: chan. %d',pdData(condNum,chanNum).avFreqs{freqNum},channels(chanNum));
        text(pdData(condNum,chanNum).binLevels(1),max(ylim)-(max(ylim)/10),textInset,'FontSize',14)
        xlabel('')
        ylabel('')
        title('') 
        if chanNum>1
            title('')
        end
        
    end
    %print('-dpsc', '-append', sprintf('BabyCorr2Hz_%s.ps',pdData(condNum,chanNum).avFreqs{freqNum}))
    %close;
end
%%   - Bin by bin polar plots of individ subject data points with means &
%   error regions (from bootstrapping), difference between group data for
%   two comparison conditions; include permutation test results for the
%   comparison

for freqNum = 1:length(pdData(1,1).avFreqs)
    for chanNum = 4 % 75 only
        % Compare conditions 1 & 4
        condNum = 1;
        figNum = plotPolarBins( pdData(condNum,chanNum).dataMatr, [], ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(end,:,condNum) );
        condNum = 4;
        plotPolarBins( pdData(condNum,chanNum).dataMatr, [], ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(1,:,condNum-3), figNum );
        print('-dpsc', '-append', sprintf('SFPilot2Hz_%s.ps',pdData(condNum,chanNum).avFreqs{freqNum}))
        close;
        
        % Compare conditions 2 & 5
        condNum = 2;
        figNum = plotPolarBins( pdData(condNum,chanNum).dataMatr, [], ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(end,:,condNum) );
        condNum = 5;
        plotPolarBins( pdData(condNum,chanNum).dataMatr, [], ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(1,:,condNum-3), figNum );
        print('-dpsc', '-append', sprintf('SFPilot2Hz_%s.ps',pdData(condNum,chanNum).avFreqs{freqNum}))
        close;


        % Compare conditions 3 & 6
        condNum = 3;
        figNum = plotPolarBins( pdData(condNum,chanNum).dataMatr, [], ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(end,:,condNum) );
        condNum = 6;
        plotPolarBins( pdData(condNum,chanNum).dataMatr, [], ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(1,:,condNum-3), figNum );
        print('-dpsc', '-append', sprintf('SFPilot2Hz_%s.ps',pdData(condNum,chanNum).avFreqs{freqNum}))
        close;

    end
end

%%  - Plot of Condition Comparison: Thresholds
freqNum = 1;
for chanNum = 2;%1:length(channels)
    figNum = plotThresh(pdData(1,chanNum).dataMatr,pdData(2,chanNum).dataMatr,colHdr,freqNum,borderColors{1},borderColors{2},...
        pdData(1,chanNum).condName,pdData(2,chanNum).condName);
    figNum = plotThresh(pdData(3,chanNum).dataMatr,pdData(4,chanNum).dataMatr,colHdr,freqNum,borderColors{3},borderColors{4},...
        pdData(3,chanNum).condName,pdData(4,chanNum).condName);
    
    figNum = plotThresh(pdData(1,chanNum).dataMatr,pdData(3,chanNum).dataMatr,colHdr,freqNum,borderColors{1},borderColors{3},...
        pdData(1,chanNum).condName,pdData(3,chanNum).condName);
    plotThresh(pdData(2,chanNum).dataMatr,pdData(4,chanNum).dataMatr,colHdr,freqNum,borderColors{2},borderColors{4},...
        pdData(2,chanNum).condName,pdData(4,chanNum).condName);
end

%%  - Plot of Condition Comparison: SNR
for freqNum = [1 5] %1F1 & 1F2 for now
    for chanNum = 2%1:length(channels)
        
        figNum = plotSNR(pdData(1,chanNum).dataMatr,colHdr,pdData(1,chanNum).binLevels,freqNum,allColors(:,:,1),borderColors{1});
        plotSNR(pdData(2,chanNum).dataMatr,colHdr,pdData(2,chanNum).binLevels,freqNum,allColors(:,:,2),borderColors{2},figNum);
        export_fig(sprintf('~/Experiments/3DThresh/Plots/SNR_C1C2_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        close;
        
        figNum =plotSNR(pdData(3,chanNum).dataMatr,colHdr,pdData(3,chanNum).binLevels,freqNum,allColors(:,:,3),borderColors{3});
        plotSNR(pdData(4,chanNum).dataMatr,colHdr,pdData(4,chanNum).binLevels,freqNum,allColors(:,:,4),borderColors{4},figNum);
        export_fig(sprintf('~/Experiments/3DThresh/Plots/SNR_C3C4_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        close;
        
    end
end



% Sweep Analysis Outline

% 1. Read in PowerDiva data, get matrix of sweep data

%dataDir = '~/Experiments/3DThresh/Data/Pilot2/Project_Exp_TEXT_HCN_128_Avg/';
dataDir = '~/Experiments/3DThresh/Data/Baby_2Hz/Inf963_Exp_TEXT_HCN_128_Avg/';
 
%channels= [66 70 71 72 73 74 75 76 82 83 88]; 
channels = [71 76 70 75 83 74 82];

sweepEstType = 'RLS';
%%
pdData = makeDataStructure(dataDir,channels,sweepEstType);

%% 2. Bootstrap across subject means within each condition & bin

cd(dataDir);
load(sprintf('DispSweepData_%s.mat',sweepEstType));
%load(sprintf('Pilot2Data_%s.mat',sweepEstType));
nBoot = 1000;
bootData = bootStrapSweeps(pdData,nBoot);

%% 3. Plots: 

colors = linspace(0.2,0.7,7);
allColors = zeros(7,3,4);
allColors(:,1,1) = colors; % R
allColors(:,2,2) = colors; % G
allColors(:,3,3) = colors; % B
allColors(:,[1 3],4) = repmat(colors',[1 2]); % M
borderColors = {'r' 'g' 'b' 'm'};

colHdr = pdData(1).hdrFields; % hdrFields is the same for all conditions/electrodes
%%   - Bin by bin polar plots of individ subject data points with means &
%   error regions (from bootstrapping), difference between group data for
%   two comparison conditions; include permutation test results for the
%   comparison

for freqNum = [1 5] %1F1 & 1F2 for now
    for chanNum = 2;%1:length(channels)
        % Compare conditions 1 & 2
        condNum = 1;
        figNum = plotPolarBins( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum} );
        condNum = 2;
        plotPolarBins( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum}, figNum );
        export_fig(sprintf('~/Experiments/3DThresh/Plots/C1vsC2_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        close;
        
        % Compare conditions 3 & 4
        condNum = 3;
        figNum = plotPolarBins( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum} );
        condNum = 4;
        plotPolarBins( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum}, figNum );
        export_fig(sprintf('~/Experiments/3DThresh/Plots/C3vsC4_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        close;
    end
end

%%   - Classic sweep plots of power as a fxn of bin value, with error bars
%   from bootstrapping
for freqNum = [1 5] %1F1 & 1F2 for now
    for chanNum = 2;%1:length(channels)
        
        condNum = 1;
        figNum = plotSweep( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum} );
        
        condNum = 2;
        plotSweep( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum}, figNum);
        
        condNum = 3;
        plotSweep( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum}, figNum );
        
        condNum = 4;
        plotSweep( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum}, figNum);
        
        export_fig(sprintf('~/Experiments/3DThresh/Plots/Sweeps_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
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



% Sweep Analysis Example Script

%% 1. Set parameters specifying which data to process:
dataDir = '~/Experiments/3DThresh/Data/Pilot_3DThreshWithCorr/Proj_Exp_TEXT_HCN_128_Avg/';
channels = [70 75]; % could be e.g.: [66 70 71 72 73 74 75 76 82 83 88];
sweepEstType = 'RLS'; % or 'DFT'
exptName = 'Pilot2'; % optional input to makeDataStructure
condNames = {'HorSwp' 'VerSwp' 'HorCorr' 'VerCorr'}; % optional input to makeDataStructure

%% 2. Read in PowerDiva data to [NumConditions X length(channels)] array of structs containing sweep data & info.:
pdData = makeDataStructure(dataDir,channels,sweepEstType,exptName,condNames);

%% 3. Set some common variables used for plotting:
allColors = [1 0 0; 0 0 1; 0 1 0; 1 0 1; 0 1 1; 0 0 0]; % specify RGB triplets in rows as desired (usually 1 row/condition)
dataMatrixHdr = pdData(1).hdrFields; % hdrFields is the same for all conditions/electrodes

%%   - Classic sweep plots of power as a fxn of bin value, with SEM ellipse error bars
for freqNum = 1 %1F1 & 1F2 for now
    for chanNum = 2;%1:length(channels)
        
        condNum = 1;
        figNum = plotSweep( pdData(condNum,chanNum).dataMatrix, dataMatrixHdr, ...
            pdData(condNum,chanNum).binLevels, freqNum, allColors(condNum,:) );
        
        %[figNum,meanAmp] = plotSweep(pdData,dataHdr,binLevels,freqNum,colorVal,figHandles,errType,withinSubj,extraData,plotSettings)
        
        condNum = 2;
        plotSweep( pdData(condNum,chanNum).dataMatrix, dataMatrixHdr, ...
            pdData(condNum,chanNum).binLevels, freqNum, allColors(condNum,:), figNum );
        %export_fig(sprintf('~/Experiments/3DThresh/Plots/SweepsC1C2_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        %close;
        
        condNum = 3;
        figNum = plotSweep( pdData(condNum,chanNum).dataMatrix, dataMatrixHdr, ...
            pdData(condNum,chanNum).binLevels, freqNum, allColors(condNum,:) );
        
        condNum = 4;
        plotSweep( pdData(condNum,chanNum).dataMatrix, dataMatrixHdr, ...
            pdData(condNum,chanNum).binLevels, freqNum, allColors(condNum,:), figNum  );
        
        %export_fig(sprintf('~/Experiments/3DThresh/Plots/SweepsC3C4_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        %close;
        
    end
end

%%   - Bin by bin polar plots of individ subject data points with means &
%   error regions (from bootstrapping), difference between group data for
%   two comparison conditions; include permutation test results for the
%   comparison

for freqNum = 1%[1 5] %1F1 & 1F2 for now
    for chanNum = 2;%1:length(channels)
        % Compare conditions 1 & 2
        condNum = 1;
        figNum = plotPolarBins( pdData(condNum,chanNum).dataMatrix, bootData(condNum,chanNum,freqNum), ...
            dataMatrixHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum} );
        condNum = 2;
        plotPolarBins( pdData(condNum,chanNum).dataMatrix, bootData(condNum,chanNum,freqNum), ...
            dataMatrixHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum}, figNum );
        %export_fig(sprintf('~/Experiments/3DThresh/Plots/C1vsC2_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        %close;
        
        % Compare conditions 3 & 4
        condNum = 3;
        figNum = plotPolarBins( pdData(condNum,chanNum).dataMatrix, bootData(condNum,chanNum,freqNum), ...
            dataMatrixHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum} );
        condNum = 4;
        plotPolarBins( pdData(condNum,chanNum).dataMatrix, bootData(condNum,chanNum,freqNum), ...
            dataMatrixHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum}, figNum );
        %export_fig(sprintf('~/Experiments/3DThresh/Plots/C3vsC4_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        %close;
    end
end

%%  - Plot of Condition Comparison: Thresholds
freqNum = 1;
for chanNum = 2;%1:length(channels)
    figNum = plotThresh(pdData(1,chanNum).dataMatrix,pdData(2,chanNum).dataMatrix,dataMatrixHdr,freqNum,borderColors{1},borderColors{2},...
        pdData(1,chanNum).condName,pdData(2,chanNum).condName);
    figNum = plotThresh(pdData(3,chanNum).dataMatrix,pdData(4,chanNum).dataMatrix,dataMatrixHdr,freqNum,borderColors{3},borderColors{4},...
        pdData(3,chanNum).condName,pdData(4,chanNum).condName);
    
    figNum = plotThresh(pdData(1,chanNum).dataMatrix,pdData(3,chanNum).dataMatrix,dataMatrixHdr,freqNum,borderColors{1},borderColors{3},...
        pdData(1,chanNum).condName,pdData(3,chanNum).condName);
    plotThresh(pdData(2,chanNum).dataMatrix,pdData(4,chanNum).dataMatrix,dataMatrixHdr,freqNum,borderColors{2},borderColors{4},...
        pdData(2,chanNum).condName,pdData(4,chanNum).condName);
end

%%  - Plot of Condition Comparison: SNR
for freqNum = [1 5] %1F1 & 1F2 for now
    for chanNum = 2%1:length(channels)
        
        figNum = plotSNR(pdData(1,chanNum).dataMatrix,dataMatrixHdr,pdData(1,chanNum).binLevels,freqNum,allColors(:,:,1),borderColors{1});
        plotSNR(pdData(2,chanNum).dataMatrix,dataMatrixHdr,pdData(2,chanNum).binLevels,freqNum,allColors(:,:,2),borderColors{2},figNum);
        export_fig(sprintf('~/Experiments/3DThresh/Plots/SNR_C1C2_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        close;
        
        figNum =plotSNR(pdData(3,chanNum).dataMatrix,dataMatrixHdr,pdData(3,chanNum).binLevels,freqNum,allColors(:,:,3),borderColors{3});
        plotSNR(pdData(4,chanNum).dataMatrix,dataMatrixHdr,pdData(4,chanNum).binLevels,freqNum,allColors(:,:,4),borderColors{4},figNum);
        export_fig(sprintf('~/Experiments/3DThresh/Plots/SNR_C3C4_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        close;
        
    end
end



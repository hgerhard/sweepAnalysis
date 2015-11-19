% Sweep Analysis Outline
path(path,'~/Experiments/3DThresh/Analysis')

% 1. Read in PowerDiva data, get matrix of sweep data

%dataDir = '~/Experiments/3DThresh/Data/Pilot_3DThreshWithCorr/Project_Exp_TEXT_HCN_128_Avg/';
%dataDir = '~/Experiments/3DThresh/Data/Pilot_DisparitySweeps/Project_Exp_TEXT_HCN_128_Avg/';
%dataDir = '~/Experiments/3DThresh/Data/Pilot_ThreeSFs/Project_Exp_TEXT_HCN_128_Avg/';
%dataDir = '~/Experiments/3DThresh/Data/Baby_2Hz/Correlation/Project_Exp_TEXT_HCN_128_Avg/';
dataDir = '~/Experiments/3DThresh/Data/Baby_2Hz/Disparity/Project_Exp_TEXT_HCN_128_Avg/';

channels = [71 76 70 75 83 74 82];

sweepEstType = 'RLS';
%%
pdData = makeDataStructure(dataDir,channels,sweepEstType);
save([dataDir,sweepEstType,'.mat'],'pdData');

%% 2. Bootstrap across subject means within each condition & bin

nBoot = 1000;
bootData = bootStrapSweeps(pdData,nBoot);
save([dataDir,sweepEstType,'_bootData.mat'],'bootData');

%% 3. Plots:

colors = linspace(0.2,0.7,7);
allColors = zeros(7,3,4);
allColors(:,3,1) = colors; % B
allColors(:,1,2) = colors; % R
allColors(:,2,3) = colors; % G
allColors(:,[1 3],4) = repmat(colors',[1 2]); % M
borderColors = {'b' 'r' 'g' 'm'};

colHdr = pdData(1).hdrFields; % hdrFields is the same for all conditions/electrodes
dataHeaders = colHdr;

%%
%  PD style sweep plots arranged hexagonally
s = 0.25;
b = 0.1;
subplotLoc = [ s/2+b s*2+2*b-.005 s s; ...
    (s/2)+s+2*b s*2+2*b-.005 s s; ...
    
    4*b/5     s+5*b/4 s s; ...
    s+8*b/5+0.002    s+5*b/4 s s; ...
    2*s+5*b/2 s+5*b/4 s s; ...
    
    s/2+b b/2 s s; ...
    (s/2)+s+2*b b/2 s s;];


%borderColors = {'b' 'c' 'g' 'r' 'm' 'y'}; %for SF Pilot 3Hz
%borderColors = {'g' 'm'}; %for Baby Corr Expts


for freqNum = 1:length(pdData(1,1).avFreqs)
    figNum = 1;
    for chanNum = 1:length(channels)
        
        condNum = 1;
        figNum = plotSweepPD( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            dataHeaders, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum},[figNum,subplotLoc(chanNum,:)] );
        
        condNum = 2;
        plotSweepPD( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            dataHeaders, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum}, [figNum,subplotLoc(chanNum,:)]);
       
%         if strcmp(exptType,'Disparity')
%             xlim([0 70])
%             set(gca,'XTick',[4 8 16 32 64])
%             set(gca,'XTick',[4 8 16 32 64])
%         end
        xlim([0 pdData(condNum,chanNum).binLevels(end)+2]) % for disp sweeps 
        set(gca,'XTick',[0 1 2 4 8 16 32 64])
        %xlim([-0.015 1.005]) % for corr sweeps
        set(gca,'YTick',[0 max(ylim)/4 max(ylim)/2 3*max(ylim)/4 max(ylim)])
        text(pdData(condNum,chanNum).binLevels(end)-0.1,max(ylim)-(max(ylim)/10),num2str(channels(chanNum)),'FontSize',14)
        text(pdData(condNum,chanNum).binLevels(1),max(ylim)-(max(ylim)/10),pdData(condNum,chanNum).avFreqs{freqNum},'FontSize',10)
        xlabel('')
        ylabel('')
        title('') 
        if chanNum>1
            title('')
        end
        
    end
    print('-dpsc', '-append', sprintf('SweepData_%s.ps',pdData(condNum,chanNum).avFreqs{freqNum}))
    close(figNum);
end



%%   - Classic sweep plots of power as a fxn of bin value, with error bars
%   from bootstrapping
for freqNum = [1 5] %1F1 & 1F2 for now
    for chanNum = 2;%1:length(channels)
        
        condNum = 1;
        figNum = plotSweepPD( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum} );
        
        condNum = 2;
        plotSweepPD( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum}, figNum);
        %export_fig(sprintf('~/Experiments/3DThresh/Plots/SweepsC1C2_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        %close;
        
        condNum = 3;
        figNum = plotSweepPD( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum} );
        
        condNum = 4;
        plotSweepPD( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum}, figNum);
        
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
        figNum = plotPolarBins( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum} );
        condNum = 2;
        plotPolarBins( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum}, figNum );
        %export_fig(sprintf('~/Experiments/3DThresh/Plots/C1vsC2_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        %close;
        
        % Compare conditions 3 & 4
        condNum = 3;
        figNum = plotPolarBins( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum} );
        condNum = 4;
        plotPolarBins( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
            colHdr, pdData(condNum,chanNum).binLevels, freqNum, allColors(:,:,condNum), borderColors{condNum}, figNum );
        %export_fig(sprintf('~/Experiments/3DThresh/Plots/C3vsC4_%s_%s_Chan%d_%s.pdf',pdData(condNum,chanNum).comment,sweepEstType,pdData(condNum,chanNum).channel,pdData(condNum,chanNum).avFreqs{freqNum}))
        %close;
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



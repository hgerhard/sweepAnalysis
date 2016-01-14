% Sweep Analysis Example Script

clearvars; clc;
%% 1. Set parameters specifying which data to process:
setPath;
dataDir = 'exampleData/PowerDivaProProject_Exp_TEXT_HCN_128_Avg/'; % specify directory where RLS or DFT files are
channels = [71 76 70 75 83 74 82]; % this works well for hexagonal plots, but it could be anything, e.g.: [66 70 71 72 73 74 75 76 82 83 88];
sweepEstType = 'RLS'; % or 'DFT'
% 2 optional inputs to makeDataStructure:
exptName = 'DisparityExperiment'; 
condNames = {'HorSwp' 'VerSwp' 'HorCorr' 'VerCorr'}; 

%% 2. Read in PowerDiva data to [ NumConditions X length(channels) ] array of structs containing sweep data & info.:
pdData = makeDataStructure(dataDir,channels,sweepEstType,exptName,condNames);

%% 3. Set the desired colors used for plotting (if not provided to plotting routines, default colors used):
conditionColors = [1 0 0; 0 0 1; 0 1 0; 1 0 1; 0 1 1; 0 0 0]; % specify RGB triplets in rows as desired (1 row/condition)

%% Create sweep plots of amplitude as a function of bin value, with SEM error bars 
%% (OR change 'Ampl' -- the first input parameter -- to 'SNR' for SNR plots without error bars)

% Example) Plot Conditions 1 & 2 for electrode 76 & the 1st frequency component:
freqIxToPlot = 1;
chanIxToPlot = 1; % channels(2) = 76;
condsToPlot = 1:2;

plotThresholdFits = true; % set to false if not desired

figNum = [];
plotNum = nan(1,max(condsToPlot));
for freqNum = freqIxToPlot
    for chanNum = chanIxToPlot
        for condNum = condsToPlot
            
            [figNum,plotNum(condNum)] = plotSweepPD( 'Ampl', pdData(condNum,chanNum).dataMatrix, pdData(condNum,chanNum).hdrFields, ...
                pdData(condNum,chanNum).binLevels, freqNum, 'SEM', plotThresholdFits, conditionColors(condNum,:), figNum );
        end
    end
end

legend(plotNum(~isnan(plotNum)),condNames(condsToPlot),'Location','NorthWest')


%% Create panel of polar plots, one for each bin, showing the individual 2D data points as twigs, 
%% and the combined error ellipse as a transparent surface, to observe how data evolve
%% over the bin levels

% Example) Plot Conditions 1 & 2 for electrode 76 & the 1st frequency component:
freqIxToPlot = 1;
chanIxToPlot = 2; % channels(2) = 76;
condsToPlot = 1:2;

figNum = [];
for freqNum = freqIxToPlot
    for chanNum = chanIxToPlot        
        for condNum = condsToPlot
            
            figNum = plotPolarBins(pdData(condNum,chanNum).dataMatrix,pdData(condNum,chanNum).hdrFields,pdData(condNum,chanNum).binLevels,freqNum,conditionColors(condNum,:),figNum);

        end
    end
end

%% Create bar plots showing how many trials were accepted out of the total number run,
%% for each bin separately. This is mainly useful for checking how well an individual
%% participant did in the experiment. For example, try this for the provided individual 
%% participant data in exampleData/PowerDivaHostSingleSubject_Exp_TEXT_HCN_128_Avg/

freqIxToPlot = 1;
chanIxToPlot = 2; % channels(2) = 76;
condsToPlot = 1:2;

figNum = [];
for freqNum = freqIxToPlot
    for chanNum = chanIxToPlot        
        for condNum = condsToPlot
            plotNumberAcceptedTrials(pdData(condNum,chanNum).dataMatrix,pdData(condNum,chanNum).hdrFields,freqNum,conditionColors(condNum,:),figNum);
        end
    end
end

%% Create a panel of plots arranged hexagonally following the geodesic layout of the net
%% 
%% In this example, 'SNR' is requested, but that can be swapped out for 'Ampl'

subplotLocs = getHexagSubPlotLocations;

chanIxToPlot = 1:length(channels); 
condsToPlot = 1:2;
freqNum = 1;

figNum = 10;
figure(figNum);
clf;
for chanNum = chanIxToPlot
    for condNum = condsToPlot
        
        plotSweepPD( 'Ampl', pdData(condNum,chanNum).dataMatrix, pdData(condNum,chanNum).hdrFields, ...
            pdData(condNum,chanNum).binLevels, freqNum, 'SEM', [], conditionColors(condNum,:), [figNum,subplotLocs(chanNum,:)] );
        set(gca,'YTick',[0 max(ylim)/4 max(ylim)/2 3*max(ylim)/4 max(ylim)])
        if condNum == condsToPlot(end)
            % add text to label channel numbers for each subplot
            text(1.2*pdData(condNum,chanNum).binLevels(1),max(ylim)-(max(ylim)/10),sprintf('%d',channels(chanNum)),'FontSize',14)
        end

    end
end

%% In this example, the number of trials bar plot is shown for each channel:

subplotLocs = getHexagSubPlotLocations;

freqIxToPlot = 1;
chanIxToPlot = 1:length(channels); 
condsToPlot = 2;
freqNum = 1;

figNum = 20;
figure(figNum);
clf;
for chanNum = chanIxToPlot
    for condNum = condsToPlot
        
        plotNumberAcceptedTrials(pdData(condNum,chanNum).dataMatrix,pdData(condNum,chanNum).hdrFields,freqNum,conditionColors(condNum,:),[figNum,subplotLocs(chanNum,:)]);
        if condNum == condsToPlot(end)
            % add text to label channel numbers for each subplot
            text(1.2*pdData(condNum,chanNum).binLevels(1),max(ylim)-(max(ylim)/10),sprintf('%d',channels(chanNum)),'FontSize',14)
        end

    end
end


%% This example shows how to use changeChanNames.m properly
dataDir = 'exampleData/tACS_withResponseExports';

% Just so the user knows the default keys and values provided by
% getSweepDataFlex.m, when creating a new map
[k,v] = getDefaultMap(dataDir, 'RLS');

% Create new map with sample numbers
newmap = containers.Map;
newmap('O1-Cz') = 11;
newmap('O2-Cz') = 12;
chanNameMapPDData = makeDataStructure(dataDir, [11,12], 'RLS', 'Channel Name Map Exp', [], newmap);


%% This example shows how to use appendSegToData.m
% Using example data that has the segFile data
fprintf('Reading data...\n');
[cols, freqs, bins, data, chanDict] = getSweepDataFlex('exampleData/tACS_withResponseExports/RLS_c001.txt');
fprintf('Appending seg info...\n');
[newColHdr, newData] = appendSegToData(cols, data, 'exampleData/tACS_withResponseExports/RTSeg_s002.mat');

% Or, you can read in the data using makeDataStructure.m and then change
% the data matrix of the data
dataDir = 'exampleData/tACS_withResponseExports';

% Create new map with sample numbers
newmap = containers.Map;
newmap('O1-Cz') = 11;
newmap('O2-Cz') = 12;

example_segPdData = makeDataStructure(dataDir, [11, 12], 'RLS', 'Example Exp', [], newmap);

% Let's say we want to look at channel 'O1-Cz' (or 11) and condition 1
% (This would be (1,1) in the PD data structure). Of course, this will be
% different if we want to look at channel 'O2-Cz' and a different condition
[example_segPdData(1,1).hdrFields, example_segPdData(1,1).dataMatrix] = appendSegToData(example_segPdData(1,1).hdrFields, ...
                                                                                        example_segPdData(1,1).dataMatrix, ...
                                                                                        'exampleData/tACS_withResponseExports/RTSeg_s002.mat');


%% This example shows how to use plotGroupComparison.m
% Uncomment sections of this section as desired to test functionality

% Some data that I used to test group plotting
dataDir = 'exampleData/PowerDivaProProject_Exp_TEXT_HCN_128_Avg/';

% Set these data directories as desired
% dataDir1 = '';
% dataDir2 = '';

% So that user knows what channels are in the data file
% Typically user would not have to incorporate this code into their scripts
% because he or she would know which channels are in the data file.
% [k1,v1] = getDefaultMap(dataDir1, 'RLS');
% [k2,v2] = getDefaultMap(dataDir2, 'RLS');

% Creating new map with arbitrary values
% Map will be necessary if data file has different channel naming
% conventions
% newmap = containers.Map;
% newmap('O1-Cz') = 21;
% newmap('O2-Cz') = 22;
% newmap('Oz-Cz') = 23;
% newmap('PO7-Cz') = 24;
% newmap('PO8-Cz') = 25;

% Here, the channels argument is [] because of the different channel naming
% convention. Since you know the default map that getSweepDataFlex.m 
% returns, you can filter channels based on the default values of the map 
% (i.e. 1, 2, 3, etc.) (shown in the second plotGroupComparison example 
% below). It would probably be better to leave the channels argument as [] 
% if you know that the data file uses a different channel naming 
% convention, as shown in the first plotGroupComparison example below.

% First example:
% plotGroupComparison({dataDir1, dataDir2}, {'CVI_NT', 'CVI'}, [], {'Cond1', 'Cond2', 'Cond3', 'Cond4', 'Cond5'}, 'RLS', newmap);
% Second example:
% plotGroupComparison({dataDir1, dataDir2}, {'CVI_NT', 'CVI'}, [2,4], {'Cond1', 'Cond2', 'Cond3', 'Cond4', 'Cond5'}, 'RLS', newmap);

plotGroupComparison({dataDir, dataDir}, {'Group1', 'Group2'}, [71 76 70 75 83 74 82], {'HorSwp' 'VerSwp' 'HorCorr' 'VerCorr'}, 'RLS');

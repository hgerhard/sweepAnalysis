function plotGroupComparison(dataDirs, groupNames, channels, condDesc, sweepEstType, newChanMap)
% plotGroupComparison(dataDirs, groupNames, channels, condDesc, sweepEstType)
%
% dataDirs       : Cell array of group data file directories
% groupNames     : Descriptive names of the groups being compared. The
%                  order of the group names must be consistent with the
%                  array of the data directory paths (cell array)
% channels       : Vector of channel numbers
% condDesc       : Cell array of condition description. Must be consistent
%                  with the array of condition numbers.
% [sweepEstType] : 'RLS' or 'DFT'. If not specified, default is 'RLS'
% [newChanMap]   : Map that maps channel names to numbers
%
% This function assumes you only want to plot one channel, one frequency,
% one condition per group.

    if (nargin < 5) || (isempty(sweepEstType))
        sweepEstType = 'RLS';
        fprintf('No data type specified. Default (RLS) is assumed.\n');
    end

    if (nargin < 6) || (isempty(newChanMap))
        newChanMap = containers.Map;
    end
    
    % Get number of groups we are comparing
    numToCompare = length(dataDirs);

%     % Rows are groups, columns are file names for each data file in the
%     % data directory
%     dataFileInfoStruct = struct([]);
%     for i = 1:numToCompare
%         fileList = dir(sprintf('%s/%s*.txt', dataDirs{i}, sweepEstType));
%         numFiles = length(fileList);
%         dataFileInfoStruct(i).groupName = groupNames{i};
%         dataFileInfoStruct(i).dataDirectory = dataDirs{i};
%         dataFileInfoStruct(i).filenames = cell(1, numFiles);
%         for j = 1:numFiles
%             dataFileInfoStruct(i).filenames{j} = fileList(j).name; %#ok<*AGROW>
%         end
%     end
    
    colors = [1 0 0; 0 0 1; 0 1 0; 1 0 1; 0 1 1; 0 0 0];
    figNum = [];
    plotNum = nan(1, numToCompare);
    plotThresholdFits = true; % set to false if not desired
    oldChannels = channels;
    for i = 1:numToCompare
        fprintf('Plotting for group: %s\n', groupNames{i});
        
        % Get pd data
        currPdData = makeDataStructure(dataDirs{i}, channels, sweepEstType, groupNames{i}, condDesc, newChanMap);
        
        % Get channels to compare
        channels = [];
        for n = 1:size(currPdData, 2)
            % Can do this because channels same for all structs in pd data.
            channels = [channels currPdData(1,n).channel];
        end
        fprintf('Select channel:\n');
        selectedChan = userQuery(channels);
        while length(selectedChan) ~= 1
            fprintf('Select only one channel.\n');
            selectedChan = userQuery(channels);
        end
        selectedChan = selectedChan(1); % Can do this since length == 1
        
        % Get condition to compare
        fprintf('Select condition:\n');
        selectedCond = userQuery(condDesc);
        while length(selectedCond) ~= 1
            fprintf('Select only one condition.\n');
            selectedCond = userQuery(condDesc);
        end
        selectedCond = selectedCond(1); % Can do this since length == 1
        
        % Get plot type
        fprintf('Select plot type:\n');
        plotType = {'Ampl', 'SNR'};
        selectedPlot = userQuery(plotType);
        while length(selectedPlot) ~= 1
            fprintf('Select only one plot type.\n');
            selectedPlot = userQuery(selectedPlot);
        end
        selectedPlot = plotType{selectedPlot(1)}; % Can do this since length == 1
        
        % Get frequency to look at
        fprintf('Select frequency:\n');
        selectedFreq = userQuery(currPdData(selectedCond,selectedChan).freqsAnalyzed);
        while length(selectedFreq) ~= 1
            fprintf('Select only one frequency.\n');
            selectedFreq = userQuery(currPdData(selectedCond,selectedChan).freqsAnalyzed);
        end
        selectedFreq = selectedFreq(1);
        
        % We are plotting each group (no longer each condition, like in the
        % example.m code)
        [figNum, plotNum(i)] = plotSweepPD(selectedPlot, currPdData(selectedCond, selectedChan).dataMatrix, ...
                                                         currPdData(selectedCond, selectedChan).hdrFields,  ...
                                                         currPdData(selectedCond, selectedChan).binLevels,  ...
                                                         selectedFreq, 'SEM', plotThresholdFits, colors(i,:), figNum );

        % Reset channels because they get modified each loop
        channels = oldChannels;
    end
    legend(plotNum(~isnan(plotNum)), groupNames,'Location','NorthWest')
end

function selectedArr = userQuery(listOfValues)
% listOfValues is an array (could be cell or double array)

    % Just check type/class of array contents
    if isfloat(listOfValues(1))
        number = 1;
    else
        number = 0;
    end
    msg = 'Enter the index into this array of values: [';
    for i = 1:length(listOfValues)-1
        if number == 1
            currVal = num2str(listOfValues(i));
        else
            currVal = listOfValues{i};
        end
        msg = [msg, currVal];
        msg = [msg, ', '];
    end
    if number == 1
        currVal = num2str(listOfValues(i+1));
    else
        currVal = listOfValues{i+1};
    end
    msg = [msg, currVal];
    msg = [msg, '], separated by spaces: '];
    fprintf(msg);
    selected = input('', 's');
    selectedIndices = regexp(selected, ' ', 'split');
    selectedArr = zeros(1,length(selectedIndices));
    for i = 1:length(selectedIndices)
        selectedArr(i) = str2double(selectedIndices{i});
    end
end



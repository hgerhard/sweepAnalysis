function pdData = makeDataStructure(dataDir,channels,dataType,exptName,condDesc)
% pdData = makeDataStructure(dataDir,channels,dataType,[exptName],[condDesc])
%  
%   Generates an array of structures of sweep data for later fitting,
%   plotting, etc. The structure contains all the data for the selected
%   channels. Each array entry contains a specified condition & channel.
%   All frequencies are reported in each dataMatrix. The frequency
%   labels are contained in the pdData.freqsAnalyzed field.
% INPUTS:
%   dataDir: path to the files containing the data, typically files like
%       'DFT_c001.txt'
%   channels: vector of channel numbers to keep (hardcoded for 128 channel
%       data ###) between 1-128
%   dataType: string 'DFT' or 'RLS' (default)
%   [exptName]: string containing the experiment name
%   [condDesc]: cell array of strings, one for each condition, indicating
%       their names
%
% Fields of pdData are:
%   dateDataFileRead
%   dateDataFile
%   experimentName
%   path
%   dataFile
%   conditionName
%   conditionNumber
%   channel
%   freqsAnalyzed
%   binLevels
%   dataMatrix

if nargin<3
    dataType = 'RLS';
    print('No data type specified. Default (RLS) is assumed.\n')
end
if nargin<4
    exptName = input('Provide the name of the current experiment>>', 's');
end

nChan = length(channels);
fileList = dir(sprintf('%s/%s*.txt',dataDir,dataType));
nConds = size(fileList,1);

if nargin<5
    condDesc = cell(1,nConds);
end

pdData = struct([]);
for k=1:nConds
    fileCrntCond = fileList(k).name;
    fullPathToFile = [dataDir,'/',fileCrntCond];
    if isempty(condDesc{k})
        conditionName = input(sprintf('Condition stored in file %s (%d/%d). Name the condition>>',fileCrntCond,k,nConds), 's');
    else
        conditionName = condDesc{k};
    end
    fprintf('Loading data in %s (%d/%d)...',fileCrntCond,k,nConds);
    
    [hdrFields, freqsIncl, binLevels, dataMatrix] = getSweepDataFlex(fullPathToFile, channels);
    channelColumn = strcmp(hdrFields,'iCh'); 
    fileInfo = dir(fullPathToFile);

    if size(dataMatrix,1) == 1
        fprintf('ERROR! Data matrix not filled in for %s\n',fileCrntCond);
    else
        for j=1:nChan
            pdData(k,j).dateDataFileRead = date;
            pdData(k,j).dateDataFile = fileInfo.date;
            pdData(k,j).experimentName = exptName;
            pdData(k,j).dataFile = fileCrntCond;
            pdData(k,j).conditionName = conditionName;
            pdData(k,j).conditionNumber = k;
            pdData(k,j).hdrFields = hdrFields;
            pdData(k,j).channel = channels(j);
            pdData(k,j).freqsAnalyzed = freqsIncl;
            pdData(k,j).binLevels = binLevels;
            
            rowIxCrntChan = ismember(int16(dataMatrix(:, channelColumn)),int16(channels(j)));
            pdData(k,j).dataMatrix = dataMatrix(rowIxCrntChan,:);
        end
        fprintf('Done.\n');
    end
end

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    

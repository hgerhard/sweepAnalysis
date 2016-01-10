function [colHdr, freqsAnalyzed, binLevels, dataMatrix, channelNameDict] = getSweepDataFlex(datafile, chanToSave)


%% Imports Sweep Data from a Text File
%
% [colHdr, freqsAnalyzed, binLevels, dataMatrix] = getSweepDataFlex(datafile, [chanToSave])
%
%% Inputs:
% datafile     string containing the full path to the data file 
% chanToSave   the requested electrode(s) to save (OPTIONAL)
%
%% Outputs:
% colHdr          is a string with column fields
% freqsAnalyzed   are the individual frequencies of the VEPs ('1F1' etc.)
% binLevels       are the contrasts or stimulus values used
% dataMatrix      matrix containing the desired data

% column headers of the data file
hdrFields = {
    'iSess'         '%s\t'      0 %1
    'iCond'         '%f\t'      1 %2
    'iTrial'        '%f\t'      1 %3
    'iCh'           '%s\t'      1 %4 This becomes %f later in the function
    'iFr'           '%f\t'      1 %5
    'AF'            '%f\t'      1 %6
    'xF1'           '%f\t'      1 %7
    'xF2'           '%f\t'      1 %8
    'Harm'          '%s\t'      2 %9 
    'FK_Cond'       '%f\t'      1 %10
    'iBin'          '%f\t'      1 %11
    'SweepVal'      '%f\t'      1 %12
    'Sr'            '%f\t'      1 %13
    'Si'            '%f\t'      1 %14
    'N1r'           '%f\t'      1 %15
    'N1i'           '%f\t'      1 %16
    'N2r'           '%f\t'      1 %17
    'N2i'           '%f\t'      1 %18
    'Signal'        '%f\t'      1 %19
    'Phase'         '%f\t'      1 %20
    'Noise'         '%f\t'      1 %21
    'StdErr'        '%f\t'      1 %22
    'PVal'          '%f\t'      1 %23
    'SNR'           '%f\t'     2 %24
    'LSB'           '%f\t'     2 %25
    'RSB'           '%f\t'     2 %26
    'UserSc'        '%s\t'     2 %27
    'Thresh'        '%f\t'     2 %28
    'ThrBin'        '%f\t'     2 %29
    'Slope'         '%f\t'     2 %30
    'ThrInRange'    '%s\t'     2 %31
    'MaxSNR'        '%f\t'     2 };%32

% If the naming convention of the channels in the data set is 'hc%d', the
% returned channelNameDict will be empty. Otherwise, if the naming
% convention of the channels is something other than 'hc%d',
% channelNameDict will not be empty and will map string names to double
% values
channelNameDict = containers.Map;

channelIx = 4;
harmIx = 9;
freqIx = 5;

fid=fopen(datafile);

tline=fgetl(fid); % skip the header line
dati=textscan(fid, [hdrFields{:,2}], 'delimiter', '\t', 'EmptyValue', nan);
% Convert the channel strings into digit only
currIndex = 1;
for i=1:size(dati{1,4})
    currChanName = dati{1,4}{i};
    % Need to make new name for the weird channel naming
    if ~strcmp(currChanName(1:2), 'hc')
        if ~any(strcmp(keys(channelNameDict), currChanName))
            channelNameDict(currChanName) = currIndex;
            currIndex = currIndex + 1;
            chan{1,i} = channelNameDict(currChanName);
        else
            chan{1,i} = channelNameDict(currChanName);
        end
    % Otherwise, just parse channel name
    else
        chan{1,i}=sscanf(dati{1, 4}{i}, 'hc%d'); 
    end
end

dati{1,channelIx}=chan';
%colsToKeep=[2 3 4 5 11 13 14]; % Stefano's columns
colsToKeep=[2 3 4 5 11 19 22 21 24 20 13 14 15 16 17 18];  % Select columns for essential matrix
% 2 iCond; 3 iTrial; 4 iCh; 5 iFr; 11 iBin; 19 Signal; 22 Error; 21 Noise;
% 24 SNR; 20 Phase; 13 Sr; 14 Si; 15:18 = Fourier coefficients for the two
% side band frequencies used for estimating the noise

% Fill in essential matrix
for s=1:length(colsToKeep)
    col=colsToKeep(s);
    if col ~= channelIx
        dataMatrix(:,s)=(dati{1, col}(:));
    else
        if isempty(cell2mat((dati{1, col}(:))))
            colHdr = {};
            freqsAnalyzed ={};
            binLevels= nan;
            dataMatrix = nan;
            fprintf('ERROR! rawdata is empty..\n')
            return;
        else
            dataMatrix(:,s)=cell2mat((dati{1, col}(:)));
        end
    end
end

numBins = max(dataMatrix(:,colsToKeep==11));
binLevels=(dati{1, 12}(2:numBins+1)); % bin level is 'SweepVal' @ 12th column of dati, the first value corresponds to bin 0 "the average bin"
binLevels=binLevels';

if nargin>1 && ~isempty(chanToSave)
    indCh=ismember(int16(dataMatrix(:, 3)),int16(chanToSave(:)));
    dataMatrix=dataMatrix(indCh,:); % Restricts the running matrix to the selected electrodes
end

% This gives me an array of strings containing
% the frequency names, ordered the same way as the iFreq values:
[freqsAnalyzed,tmpIx]=unique(dati{1, harmIx}(:));
freqNum = nan(1,length(freqsAnalyzed));
for f = 1:length(freqsAnalyzed)
    freqNum(f) = dati{1,freqIx}(tmpIx(f));
end
[~,tmpIx] = sort(freqNum);
freqsAnalyzed = freqsAnalyzed(tmpIx);

% indBin=find(dataMatrix(:, 5)>0); % Selects all bins but the 0th one, which is the average over all bins
% dataMatrix=dataMatrix(indBin, :);

% zeroSubjInd=find(dataMatrix(:,2)>0); % Selects all subjects but the 0th one, which is the average over all subjects
% dataMatrix=dataMatrix(zeroSubjInd, :);


for m = 1:length(colsToKeep)
    colHdr{m} = hdrFields{colsToKeep(m),1};
end
end

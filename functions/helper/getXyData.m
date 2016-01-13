function [xyData] = getXyData(pdDataMatrix,dataHdr,binNum,freqNum)
% [xyData] = getXyData(pdDataMatrix,dataHdr,binNum,freqNum)
%
% Return a [N x 2] matrix of Fourier coefficients with the real coefs in the
% first column and the imaginary coefs in the second column. N = number of
% samples.
%
% This is for a specific bin number and frequency number only (so data that
% can be compared)

xyData = [];

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
    end
end

crntBinRows = pdDataMatrix(:,binIx)==binNum;
crntFreqRows = pdDataMatrix(:,freqIx)==freqNum;
allowedRows = crntBinRows & crntFreqRows;
allowedRows = allowedRows & pdDataMatrix(:,trialIx)>0; % 0th trial is the mean trial
Sr = pdDataMatrix(allowedRows,srIx);
Si = pdDataMatrix(allowedRows,siIx);
allowedData = pdDataMatrix(allowedRows,amplIx)>0; % important because samples with 0 mean are from epochs excluded by PowerDiva
xyData = [Sr(allowedData) Si(allowedData)];

if isempty(xyData)
    fprintf('xyData is still empty. Probably you did not export the trial data');
end
    
            
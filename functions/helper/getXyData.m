function [xyData] = getXyData(pdDataMatrix,dataHdr,binNum,freqNum,dataType)
% [xyData] = getXyData(pdDataMatrix,dataHdr,binNum,freqNum,[dataType])
%
% Return a [N x 2] matrix of Fourier coefficients with the real coefs in the
% first column and the imaginary coefs in the second column. N = number of
% samples.
%
% dataType can be:
%   'signal' (default) - will return Fourier coefficients for the signal
%   'N1' - will return Fourier coefficients for noise sideband 1
%   'N2' - will return Fourier coefficients for noise sideband 2
%
% This is for a specific bin number and frequency number only (so data that
% can be compared)

xyData = [];

if nargin<5
    dataType = 'signal';
end

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
        case 'N1r'
            n1rIx = k;
        case 'N2r'
            n2rIx = k;
        case 'N1i'
            n1iIx = k;
        case 'N2i'
            n2iIx = k;
        case 'Signal'
            amplIx = k;
    end
end

switch dataType
    case 'signal'
        ix1 = srIx;
        ix2 = siIx;
    case 'N1'
        ix1 = n1rIx;
        ix2 = n1iIx;
    case 'N2'
        ix1 = n2rIx;
        ix2 = n2iIx;
end

crntBinRows     = pdDataMatrix(:,binIx)  == binNum;
crntFreqRows    = pdDataMatrix(:,freqIx) == freqNum;
allowedRows     = crntBinRows & crntFreqRows;
allowedRows     = allowedRows & pdDataMatrix(:,trialIx)>0; % 0th trial is the mean trial, so don't include it

realVals        = pdDataMatrix(allowedRows,ix1);
imagVals        = pdDataMatrix(allowedRows,ix2);

allowedData     = pdDataMatrix(allowedRows,amplIx)>0; % important because samples with 0 amplitude are epochs excluded by PowerDiva

xyData          = [realVals(allowedData) imagVals(allowedData)];

if isempty(xyData)
    fprintf('xyData is still empty. Probably you did not export the trial data');
end
    
            
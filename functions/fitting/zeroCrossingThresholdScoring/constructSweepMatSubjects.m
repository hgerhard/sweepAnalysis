function [sweepMatSubjects] = constructSweepMatSubjects(pdDataMatrix,dataHdr,freqNum)
% [sweepMatSubjects] = constructSweepMatSubjects(pdDataMatrix,dataHdr,freqNum)
%
% construct a matrix used exclusively by Mark Pettet's function SweepMat.m
% sweepMatSubjects is a 3-D matrix that is NSteps x 6(triad terms) x NSubjects(or NTrials)

for k = 1:length(dataHdr)
    switch dataHdr{k}
        case 'iTrial'
            sampleIx = k;
        case 'iBin'
            binIx = k;
    end
end

nSamples = max(pdDataMatrix(:,sampleIx));
nBins = max(pdDataMatrix(:,binIx));

sweepMatSubjects = nan(nBins,6,nSamples);

% first get the Sr, Si values:
for binNum = 1:nBins
    xyData = getXyData(pdDataMatrix,dataHdr,binNum,freqNum);
    sweepMatSubjects(binNum,1:2,:) = reshape(xyData',[1 2 nSamples]); % transpose is critical!
end

% now get the N1r, N1i values:
for binNum = 1:nBins
    xyData = getXyData(pdDataMatrix,dataHdr,binNum,freqNum,'N1');
    sweepMatSubjects(binNum,3:4,:) = reshape(xyData',[1 2 nSamples]); % transpose is critical!
end

% now get the N2r, N2i values:
for binNum = 1:nBins
    xyData = getXyData(pdDataMatrix,dataHdr,binNum,freqNum,'N2');
    sweepMatSubjects(binNum,5:6,:) = reshape(xyData',[1 2 nSamples]); % transpose is critical!
end


%% example dataset:
load('~/Experiments/NoiseMaskTypical_fromFrancesca/Project_Exp_TEXT_HCN_128_Avg/RLS.mat')
% these data contain only electrode 75

%% get column indices
for k = 1:length(pdData(1,1).hdrFields)
    switch pdData(1,1).hdrFields{k}
        case 'iCond'
            condIx = k;
        case 'iTrial'
            trialIx = k;
        case 'iCh'
            chanIx = k;
        case 'iFr'
            freqIx = k;
        case 'iBin'
            binIx = k;
        case 'Sr'
            srIx = k;
        case 'StdErr'
            stdErrIx = k;
        case 'Si'
            siIx = k;
        case 'ampl'
            amplIx = k;
        case 'SNR'
            SNRIx = k;
        case 'Noise'
            noiseIx = k;
    end
end
%% grab example bin data:
binNum = 9;
condNum = 1;
freqNum = 1;

myData = pdData(condNum).dataMatr; 
colHdr = pdData(condNum).hdrFields;
myData = myData(myData(:,freqIx)==freqNum,:);
myData = myData(myData(:,binIx)==binNum,:);

actSubjIx = 2:36; % there are 36 Ss in this data set and the 1st entry is the avg. subj.

%%
xyData = [myData(actSubjIx,srIx),myData(actSubjIx,siIx)];
[errorEllipse,amplErrorRange] = getErrorEllipse(xyData,false,'SEM',true);


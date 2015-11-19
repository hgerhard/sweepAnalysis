function bootData = bootStrapSweeps(rawData,nBoot,nSubjsToAnalyze,condsToAnalyze,freqsToAnalyze,chansToAnalyze)
%bootData = bootStrapSweeps(rawData,nBoot,[nSubjs])
% NOTE: nSubjsToAnalyze input is only for analysis of bootstrapping effects 
% in terms of number of subjects included.

% ### JUST realized this should have a separate function that handles the
% actual bootstrapping (i.e. the part in the innermost fo loop)

[nCond,nChan] = size(rawData);

dataHdr = rawData(1,1).hdrFields; % same for every cell
for k = 1:length(dataHdr)
    switch dataHdr{k}
        case 'iCond'
            condCol = k;
        case 'iTrial'
            subjCol = k;
        case 'iCh'
            chanCol = k;
        case 'iFr'
            freqCol = k;
        case 'iBin'
            binCol = k;
        case 'Sr'
            srCol = k;
        case 'Si'
            siCol = k;
        case 'ampl'
            amplCol = k;
    end
end

nSubjs = max(rawData(1,1).dataMatr(:,subjCol));
if nargin<3
    nSubjsToAnalyze = nSubjs;
elseif nSubjsToAnalyze > nSubjs
    error('nSubjsToAnalyze is greater than the number of subjects in the datafile.')
end

if nargin < 4
    condsToAnalyze = 1:nCond;
end

if nargin < 6
    chansToAnalyze = 1:nChan;
end

if nSubjsToAnalyze < nSubjs
    % create ix of subjects to keep in the analysis
    subjsToAnalyze = randperm(nSubjs);
    subjsToAnalyze = subjsToAnalyze(1:nSubjsToAnalyze);
else
    subjsToAnalyze = 1:nSubjsToAnalyze;
end

nBins = max(rawData(1,1).dataMatr(:,binCol));
nFreqs = max(rawData(1,1).dataMatr(:,freqCol));

if nargin < 5
    freqsToAnalyze = 1:nFreqs;
end

for condIx = condsToAnalyze
    fprintf('bootstrapping condtion %d/%d...\n',condIx,nCond);
    for chanIx = chansToAnalyze
        fprintf('\tbootstrapping channel %d/%d...\n',chanIx,nChan);
        for freqIx = freqsToAnalyze
            fprintf('\t\tbootstrapping frequency %d/%d...\n',freqIx,nFreqs);
            dataMatr = rawData(condIx,chanIx).dataMatr;
            dataMatr = dataMatr(dataMatr(:,freqCol)==freqIx,:);
            if nSubjsToAnalyze < nSubjs
                dataMatr = dataMatr(ismember(dataMatr(:,subjCol),subjsToAnalyze),:);
            end
            
            for k=1:nBoot
                for binIx=1:nBins
                    bootInd=ceil(rand(nSubjsToAnalyze)*nSubjsToAnalyze);
                    binMatr=dataMatr(dataMatr(:,binCol)==binIx, :);
                    
                    bootVectBuffer=[binMatr(bootInd,srCol), binMatr(bootInd,siCol)];
                    ResampVectAmpl(k,binIx)=norm(mean(bootVectBuffer));
                    ResampVectSr(k,binIx,:) = mean(bootVectBuffer(:,1));
                    ResampVectSi(k,binIx,:) = mean(bootVectBuffer(:,2));
                end
            end
            bootData(condIx,chanIx,freqIx).resampledVectAmplitudes = ResampVectAmpl;
            bootData(condIx,chanIx,freqIx).resampledSr = ResampVectSr;
            bootData(condIx,chanIx,freqIx).resampledSi = ResampVectSi;
            fprintf('\t\tdone.\n');
        end
        fprintf('\tdone.\n');
    end
    fprintf('done.\n');
end

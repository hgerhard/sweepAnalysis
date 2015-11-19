% script_bootstrap_analysis.m

dataDir = '~/Experiments/NoiseMaskTypical_fromFrancesca/Project_Exp_TEXT_HCN_128_Avg/';
channels = 75;
sweepEstType = 'RLS';

pdData = makeDataStructure(dataDir,channels,sweepEstType);
save([dataDir,sweepEstType,'.mat'],'pdData');
%%
nBoot = 1000;
bootData = bootStrapSweeps(pdData,nBoot);
save([dataDir,sweepEstType,'_bootData_allSs.mat'],'bootData');

%%
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

chanNum = 1;
condNum = 1;
freqNum = 1;

[fignum,rawMeans] = plotSweepPD( pdData(condNum,chanNum).dataMatr, bootData(condNum,chanNum,freqNum), ...
        dataHeaders, pdData(condNum,chanNum).binLevels, freqNum, borderColors{condNum});
    
%%

numSubjsToAnalyze = 6:10:36;
nReps = 100;

for k = 1:length(numSubjsToAnalyze)
    tic
    for rep = 1:nReps
        
        resampledVectAmplitudes = ...
            bootStrapSweepsSepOutput(pdData,nBoot,numSubjsToAnalyze(k),condNum,freqNum,chanNum);
        bootAmps(:,:,k,rep) = squeeze(resampledVectAmplitudes);
        bootStds(rep,:,k) = std(bootAmps(:,:,k,rep));
        bootAmpMeans(rep,:,k) = mean(bootAmps(:,:,k,rep));
    
    end
    toc 
    fprintf('Done with %d\n',numSubjsToAnalyze(k))
end
    
%%
figure; 
set(gca,'Color','w');
hold on;
set(gca,'FontSize',18);
colors = {'r' 'g' 'b' 'm'};
for k = 1:length(numSubjsToAnalyze)
    errorbar(mean(bootStds(:,:,k)),std(bootStds(:,:,k)),'Color',colors{k});
    text(10.2, mean(bootStds(:,end,k)), sprintf('N = %d',numSubjsToAnalyze(k)),'FontSize',18,'Color',colors{k});
    hold on;
end
xlabel('Bin Number')
ylabel('mean({ \sigma_{boot} }) \pm std({ \sigma_{boot} })')
set(gca,'XTick',1:10)
    
%%
figure; 
set(gca,'Color','w');
hold on;
set(gca,'FontSize',18);
plot(rawMeans,'k-','LineWidth',2); 
hold on;
colors = {'r' 'g' 'b' 'm'};
for k = 1:length(numSubjsToAnalyze)
    errorbar(mean(bootAmpMeans(:,:,k)),std(bootAmpMeans(:,:,k)),'Color',colors{k});
    text(10.2, mean(bootAmpMeans(:,end,k))+0.5*k-1, sprintf('N = %d',numSubjsToAnalyze(k)),'FontSize',18,'Color',colors{k});
    hold on;
end
xlabel('Bin Number')
ylabel('mean({ \mu_{boot} }) \pm std({ \mu_{boot} })')
set(gca,'XTick',1:10)
      
%% Work on getting actual error across subjects of each mean amplitude
    
tmpData = pdData(condNum,chanNum).dataMatr;
%%
for k = 1:length(pdData(condNum,chanNum).hdrFields)
    switch pdData(condNum,chanNum).hdrFields{k}
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
        case 'Si'
            siIx = k;
        case 'ampl'
            amplIx = k;
        case 'SNR'
            SNRIx = k;
        case 'Noise'
            noiseIx = k;
        case 'StdErr'
            stdErrIx = k;
    end
end
%%
binNum = 10;
    crntBinRows = tmpData(:,binIx)==binNum;
    crntFreqRows = tmpData(:,freqIx)==freqNum;
    allowedRows = crntBinRows & crntFreqRows;
    trialNums = tmpData(allowedRows,trialIx);
    %allowedRows = allowedRows & tmpData(:,trialIx)>0; % ### <11 for Francesca
    Sr = tmpData(allowedRows,srIx);
    Si = tmpData(allowedRows,siIx);
    normSrSi = tmpData(allowedRows,amplIx);
    stdErrs = tmpData(allowedRows,stdErrIx);
    
%%
figure; 
plot(Sr(2:end), Si(2:end),'ko')
hold on;
for k = 2:length(Sr)
    plot([0 Sr(k)],[0 Si(k)],'k-')
end
line([min(xlim) max(xlim)],[0 0],'Color','k')
line([0 0],[min(ylim) max(ylim)],'Color','k')
tX = mean(Sr(2:end));
tY = mean(Si(2:end));
line([0 tX], [0 tY],'Color','b','LineWidth',2);
plot(tX,tY,'bo','MarkerFaceColor','b')

tNSbjs = length(Sr)-1;
% ### CHECK THESE!! SEEM TO BE TOO SMALL.
tNormK1 = (tNSbjs-1)/tNSbjs/(tNSbjs-2) * finv( 0.68, 2, tNSbjs - 2 ); %1 std.
tNormK2 = (tNSbjs-1)/tNSbjs/(tNSbjs-2) * finv( 0.95, 2, tNSbjs - 2 ); %95% CI
tNormK3 = 1 / (tNSbjs-2); %SEM??

[ tEVec, tEVal ] = eig( cov( [Sr(2:end) Si(2:end)] ) );

tNellip = 30;
tTh = linspace( 0, 2*pi, tNellip )';
tXY1 = [ cos(tTh), sin(tTh) ] * sqrt( tNormK1 * tEVal ) * tEVec';		% Error/confidence ellipse
tXY1 = tXY1 + repmat( [tX tY], tNellip, 1 );

tXY2 = [ cos(tTh), sin(tTh) ] * sqrt( tNormK2 * tEVal ) * tEVec';		% Error/confidence ellipse
tXY2 = tXY2 + repmat( [tX tY], tNellip, 1 );

tXY3 = [ cos(tTh), sin(tTh) ] * sqrt( tNormK3 * tEVal ) * tEVec';		% Error/confidence ellipse
tXY3 = tXY3 + repmat( [tX tY], tNellip, 1 );

patch( tXY1(:,1), tXY1(:,2),'b','FaceAlpha',.25)
patch( tXY2(:,1), tXY2(:,2),'b','FaceAlpha',.25)
patch( tXY3(:,1), tXY3(:,2),'r','FaceAlpha',.25)



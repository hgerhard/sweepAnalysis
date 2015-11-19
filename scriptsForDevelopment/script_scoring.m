compNum = 1;
condNum = 1;
freqNum = 1;


[sweepMatSubjects] = constructSweepMatSubjects(rcaData,rcaSettings,noiseData.lowerSideBand,noiseData.higherSideBand,compNum,condNum,freqNum);
tSweepMat = SweepMat( sweepMatSubjects );
[thresh,slope,range]=HybridNewOldScore( tSweepMat)

ampVect = tSweepMat(:,1)
plot(ampVect,'ko-')
y=@(x)slope*x -slope*thresh
y(0:10)
hold on;
plot(0:10,ans,'b-')
plot(0:10,zeros(1,11),'k-')
grid on


[ tThr, tSlp, tLSB, tRSB, tYFit, tYFitAll, tXX] = powerDivaScoring(sweepMatSubjects, rcaSettings.binLevels);
function [ tThr, tSlp, tLSB, tRSB, tYFit, tYFitAllPos, tXX] = powerDivaScoring(sweepMatSubjects, tSweepVal,bounds)
% assumes increasing visibility!

if nargin<3
    [ tThr, tSlp, xRange ] = HybridNewOldScore( SweepMat( sweepMatSubjects ) );
else
    [ tThr, tSlp, xRange ] = HybridNewOldScore( SweepMat( sweepMatSubjects ), bounds );
end


tLSB = xRange( 1 ); 
tRSB = xRange( 2 );

tStartBin = 1;
tNBins = length( tSweepVal );
tEndBin = tNBins;
tStart = tSweepVal( tStartBin );
tEnd = tSweepVal( tEndBin );

tIsLog = isLogSpaced(tSweepVal);

tNBins = length( tSweepVal );
tYFit = tSlp * ( [ tLSB:tRSB ]' - tThr );
tYFitAllPos = tSlp * ( [ 1:tNBins ]' - tThr );
posIx = tYFitAllPos>0;
tYFitAllPos = [0; tYFitAllPos(posIx)];

if tIsLog
    tStart = log10( tStart );
    tEnd = log10( tEnd );
end

tThr = ( tThr - tStartBin ) / ( tEndBin - tStartBin ) * ( tEnd - tStart ) + tStart;

if tIsLog
    % always express threshold in stimulus units, even when semilog
    tThr = 10 ^ tThr;
    % slope of semilog is actually an exponential,
    % so for convenience, leave semilog slope in bin units
    % which are most convenient for plotting.
else
    % otherwise, if linear, also express slope in stimulus units
    tSlp = tSlp / ( tEnd - tStart ) * ( tNBins - 1 );
end
tXX = [tThr tSweepVal(posIx)];
function [ tThr, tSlp, tLSB, tRSB, tYFit, tYFitAllPos, tXX] = powerDivaScoring(sweepMatSubjects, binLevels, bounds)
%
% [ tThr, tSlp, tLSB, tRSB, tYFit, tYFitAllPos, tXX] = powerDivaScoring(sweepMatSubjects, binLevels, [bounds])
%
% Code from Mark Pettet to fit a monotonically increasing function to the
% sweep data stored in sweepMatSubjects in order to extrapolate to zero and
% estimate a neural threshold.
%
% The sweepMatSubjects matrix must be provided. It is a  3-D matrix that is
% NSteps x 6(triad terms) x NSubjects(or NTrials), which is produced via
% the function constructSweepMatSubjects.m. 
%
% The stimulus levels for the sweep must be provided in binLevels.
%
% Optionally provide bounds, a 2-element vector specifying the indices of
% the binLevels encompassing the range of data you wish to fit the function
% to.
%
% Note, the function assumes increasing visibility along the row dimension 
% of sweepMatSubjects and coorespondingly along binLevels. If this is not
% the case, you should reverse the ordering and then mirror the result. A
% future version of the code should handle this automatically.

if nargin<3
    [ tThr, tSlp, xRange ] = HybridNewOldScore( SweepMat( sweepMatSubjects ) );
else
    [ tThr, tSlp, xRange ] = HybridNewOldScore( SweepMat( sweepMatSubjects ), bounds );
end


tLSB = xRange( 1 ); 
tRSB = xRange( 2 );

tStartBin = 1;
tNBins = length( binLevels );
tEndBin = tNBins;
tStart = binLevels( tStartBin );
tEnd = binLevels( tEndBin );

tIsLog = isLogSpaced(binLevels);

tNBins = length( binLevels );
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
tXX = [tThr binLevels(posIx)];
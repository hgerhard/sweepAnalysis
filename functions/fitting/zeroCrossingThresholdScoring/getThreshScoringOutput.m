function [ tThr, tThrStdErr, tSlp, tSlpStdErr, tLSB, tRSB, tYFit, tYFitAllPos, tXX] = getThreshScoringOutput(sweepMatSubjects, binLevels, bounds)
% [ tThr, tThrCI, tSlp, tSlpCI, tLSB, tRSB, tYFit, tYFitAllPos, tXX] = getThreshScoringOutput(sweepMatSubjects, binLevels, [bounds])
%
% Performs powerDivaScoring & jack-knifes the error estimates for the two
% fit parameters (returned in tThrCI and tSlpCI). All other outputs are
% returned from powerDivaScoring.m so see that function's help for more
% info.
%
% Note that jackknifing is performed using fixed bounds on binLevels. This
% following a note from Mark Pettet:
% In most cases, this jackknife ith-deleted samples should re-use the score bounds returned
% for the entire sample.  This way, the error term represents the dispersion of the
% regression estimates.  Otherwise, when coercing new scoring for each deleted estimate,
% the error terms represent the dispersion of the scoring algorithm.


% first apply routine to full dataset
if nargin<3
    [tThr, tSlp, tLSB, tRSB, tYFit, tYFitAllPos, tXX] = powerDivaScoring(sweepMatSubjects, binLevels);
else
    [tThr, tSlp, tLSB, tRSB, tYFit, tYFitAllPos, tXX] = powerDivaScoring(sweepMatSubjects, binLevels, bounds);
end
bounds = [tLSB,tRSB];

tThrStdErr = nan;
tSlpStdErr = nan;

if ~isnan(tThr)
    % now perform jackknifing to get error estimates on tThr & tSlp
    
    nSubj = size(sweepMatSubjects,3); % by definition, 3rd dimension is subject number
    
    subsetIndices = logical( ones( nSubj ) - ones( nSubj ) .* diag( ones( nSubj, 1 ) ) );
    
    for subj = 1:nSubj
        allSubjsButOne = subsetIndices( :, subj );
        [ thresh, slope ] = powerDivaScoring(sweepMatSubjects(:,:,allSubjsButOne), binLevels, bounds);
        subsetThreshVals( subj ) = thresh;
        subsetSlopeVals( subj ) = slope;
    end
    
    tThrStdErr = jackKnifeErr(subsetThreshVals);
    tSlpStdErr = jackKnifeErr(subsetSlopeVals);    
end
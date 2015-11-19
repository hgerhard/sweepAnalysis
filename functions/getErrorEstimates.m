function [amplBounds,errorContour] = getErrorEstimates(xyData,withinSubj,errorType,extraData)

if nargin<2 || isempty(withinSubj)
    withinSubj = false;
end
if nargin<3 || isempty(errorType)
    errorType = 'SEM';
end

meanXy = mean(xyData);
meanXyAmp = norm(meanXy);
N = size(xyData,1);

switch errorType
    case 'SEMvector'
        % amplitude of vector of individual components' SEMs  
        sem_x = std(xyData(:,1))/sqrt(N);
        sem_y = std(xyData(:,2))/sqrt(N);
        sem_vect = [sem_x sem_y];
        sem_mag = norm(sem_vect);      
        amplBounds = [meanXyAmp-sem_mag, meanXyAmp+sem_mag];
        errorContour = []; % circularly symmetric with radius = sem_mag, centered on mean ###
    case 'PDStdErr'
        % use standard error values reported by PowerDiva, *extraData
        % required = standard error values from imported PD export files
        if nargin<4 || isempty(extraData)
            error('You must provide the StdErr values from the output of makeDataStructure.m in a 4th input: extraData');
        else
            amplBounds = [meanXyAmp - extraData, meanXyAmp + extraData]; 
            errorContour = []; % circularly symmetric with radius = stdError, centered on mean ###
        end
    case 'Boot'
        % use bootstrapped error values computed earlier, *extraData 
        % required = bootstrap output 
        if nargin<4 || isempty(extraData)
            error('You must provide the resampledVectAmplitudes from the output of bootStrapSweeps.m in a 4th input: extraData');
        else
            amplBounds = [meanXyAmp - std(extraData), meanXyAmp + std(extraData)];
            errorContour = []; % circulalry symmetric with radius = bootError, centered on mean?? ###
        end
    otherwise
        [errorContour,amplBounds] = getErrorEllipse(xyData,withinSubj,errorType);
end
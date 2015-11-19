%% example call to rcaSweep
clear all; close all; clc

%% setup inputs
% the main input is a cell array of strings which points to a folder of
% DFT/RLS exports for each subject

dataLocation = '../Data/Baby_2Hz/Correlation/';
folders = dir([dataLocation,'Inf*_Exp_TEXT*']);
pathnames = {};
for k = 1:length(folders)
    pathnames{k} = [dataLocation, folders(k).name];
end
freqNames = {'1F1' '2F1' '3F1' '4F1'};
clear k
%%
binsToUse=1:10; % indices of bins to include in analysis (the values must be present in the bin column of all DFT/RLS exports)
freqsToUse=1:4; % indices of frequencies to include in analysis (the values must be present in the frequency column of all DFT/RLS exports)
nReg=7; % RCA regularization constant (7-9 are typical values, but see within-trial eigenvalue plot in rca output)
nComp=3; % number of RCs that you want to look at (3-5 are good values, but see across-trial eigenvalue plot in rca output)
condsToUse = 1:2;
dataType = 'RLS';
chanToCompare = 75;

%% call the function
[rcaData,W,A,covData,noiseData,comparisonData,comparisonNoiseData,rcaSettings]= ...
    rcaSweep(pathnames,binsToUse,freqsToUse,condsToUse,nReg,nComp,dataType,chanToCompare);
%%
plotSettings.comparisonName = 'OZ';
[snrFigNums] = plotSnr(rcaData,noiseData,rcaSettings,plotSettings,comparisonData,comparisonNoiseData);
plotSettings.showConditions = true;
plotSettings.conditionColors = [51 51 204; 204 51 51]./255;
plotSettings.errorType = [];%'SEM';
figNum = plotFreqByComp(rcaData,noiseData,rcaSettings,plotSettings,comparisonData,comparisonNoiseData); % generates the same plot with an extra column for the comparison sensor

%plotSettings.xlabel = 'Disparity (arc min)';
plotSettings.xlabel = 'Background Correlation';
plotSettings.ymax = 7;
plotSettings.xTick = [0 0.5 1];%[4 8 16 32 64];%
%figNum = plotRcData(rcaData,noiseData,rcaSettings,plotSettings,1);

%figNum = plotRcDataSNR(rcaData,noiseData,rcaSettings,plotSettings,1);

%%
for fignum=1:5
    figure(fignum);
    print('-dpsc2','-append',[dataLocation,'RCA9Subjs_Infants_2Hz_Correlation.ps'])
end
%% example call to rcaSweep
clear all; close all; clc

%% setup inputs
% the main input is a cell array of strings which points to a folder of
% DFT/RLS exports for each subject

folders = dir('../Data/Pilot_3DThreshWithCorr/S*TEXT*c1c2');
pathnames = {};
for k = 1:length(folders)
    pathnames{k} = ['../Data/Pilot_3DThreshWithCorr/' folders(k).name];
end
%binLevels = linspace(0,1,10);
binLevels = logspace(log10(0.56),log10(8),10);
freqNames = {'1F1' '2F1' '3F1' '4F1'};
clear k
%%
binsToUse=1:10; % indices of bins to include in analysis (the values must be present in the bin column of all DFT/RLS exports)
freqsToUse=1:4; % indices of frequencies to include in analysis (the values must be present in the frequency column of all DFT/RLS exports)
nReg=7; % RCA regularization constant (7-9 are typical values, but see within-trial eigenvalue plot in rca output)
nComp=3; % number of RCs that you want to look at (3-5 are good values, but see across-trial eigenvalue plot in rca output)

%% call the function
[rcaDataReal,rcaDataImag,binData]=rcaSweep(pathnames,binsToUse,freqsToUse,nReg,nComp,true,binLevels,freqNames);

%%
for fignum=4:6
    figure(fignum);
    print('-dpsc2','-append','RCA_Adults_2Hz_Disparity.ps')
end
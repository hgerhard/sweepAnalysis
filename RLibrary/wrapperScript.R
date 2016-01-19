# Wrapper script
setwd("/Users/Nathan/Desktop/Research/sweepAnalysis/RLibrary");
source("getSweepDataFlex.R");
source("plotSweepData.R");
source("plotBasic.R");
source("plotSingleHist.R");
source("plotMultipleHists.R");
source("plotMultiVarHist.R");
source("getInventoryData.R");

# Acquire data
data = getSweepDataFlex("/Users/Nathan/Desktop/Research/CVIdata/CVI3to34_20150204_1428/Exp_TEXT_PD1010_5_Cz/RLS_c001.txt");
cviData <- getInventoryData("/Users/Nathan/Desktop/Research/CVIdata/CVI_Inventory.xlsx");

# plotSweepData(data$selectedData, data$colsKeptNames, data$freqsAnalyzed, 2);
# plotSingleHist(cviData, "Q51");
# plotBasic(cviData);
# plotMultipleHists(cviData, c(1,2,3,4), 2);
plotMultiVarHist(cviData, c(1,2));


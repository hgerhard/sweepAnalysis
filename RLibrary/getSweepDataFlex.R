getSweepDataFlex <- function(datafile, chanToKeep = c(), condToKeep = c())
{
	allData  <- read.table(datafile, header=TRUE)
	colNames <- colnames(allData)
	colsToKeep <- c(2, 3, 4, 5, 11, 19, 22, 21, 24, 20, 28, 30, 13, 14)
	colsToKeepNames <- c()

	for (i in 1:length(colsToKeep))
	{
		colsToKeepNames[i] = colNames[i]
	}
	if (length(chanToKeep) != 0)
	{
		for (i in 1:length(chanToKeep))
		{
			currChan = chanToKeep[i]
			allData = allData[allData$iCh == currChan]
		}
	}
	if (length(condToKeep) != 0)
	{
		for (i in 1:length(condToKeep))
		{
			currCond = condToKeep[i]
			allData = allData[allData$iCond == currCond]
		}
	}

	returnVals <- list("allData" = allData, "colsKeptNames" = colsToKeepNames)
	return(returnVals)
}
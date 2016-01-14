getSweepDataFlex <- function(datafile, chanToKeep = c())
{
	allData  <- read.table(datafile, stringsAsFactors=TRUE, header=TRUE);
	colNames <- colnames(allData);
	
	# 19 signal, 20 phase
	colsToKeep <- c(2, 3, 4, 5, 7, 9, 11, 12, 19, 20, 21, 22, 24, 28, 30, 13, 14);
	#colsToKeep <- c(2, 3, 4, 5, 7, 12, 19, 20, 21);
	colsToKeepNames <- c();

	# maxFreq <- allData$iFr[which.max(allData$iFr)];
	freqsAnalyzed <- c();
	freqsAnalyzed <- levels(allData$Harm);
	
	allData <- allData[, colsToKeep];

	for (i in 1:length(colsToKeep))
	{
		colsToKeepNames[i] = colNames[colsToKeep[i]];
	}
	
	if (length(chanToKeep) != 0)
	{
		for (i in 1:length(chanToKeep))
		{
			currChan = chanToKeep[i];
			allData = allData[allData$iCh == currChan];
		}
	}

	# Get amplitudes
	# Looks like amplitudes is just the same as "Signal" (column 19 in data)
	amplitudes = c();
	signalReal = allData$Sr;
	signalImag = allData$Si;
	stopifnot(length(signalReal) == length(signalImag));
	stopifnot(length(signalReal) == dim(allData)[1]);
	for (i in 1:dim(allData)[1])
	{
		currAmpl = sqrt(signalReal[i]^2 + signalImag[i]^2);
		amplitudes = c(amplitudes, currAmpl);
	}
	allData$ampl = amplitudes;
	colsToKeepNames = colnames(allData);

	returnVals <- list("selectedData" = allData, "colsKeptNames" = colsToKeepNames, "freqsAnalyzed" = freqsAnalyzed);
	return(returnVals);
}
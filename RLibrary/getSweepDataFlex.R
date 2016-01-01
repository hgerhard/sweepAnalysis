getSweepDataFlex <- function(datafile, chanToKeep = c())
{
	allData  <- read.table(datafile, stringsAsFactors = FALSE, header=TRUE);
	colNames <- colnames(allData);
	
	# 19 signal, 20 phase
	#colsToKeep <- c(2, 3, 4, 5, 11, 19, 22, 21, 24, 20, 28, 30, 13, 14);
	colsToKeep <- c(2, 3, 4, 5, 7, 12, 19, 20, 21);
	colsToKeepNames <- c();

	maxFreq <- allData$iFr[which.max(allData$iFr)];
	freqs <- c();
	for (i in 1:maxFreq)
	{
		freqs = c(freqs, i);
	}
	
	allData <- allData[, colsToKeep];

	for (i in 1:length(colsToKeep))
	{
		colsToKeepNames[i] = colNames[colsToKeep[i]];
	}
	
	# List implementation
	# channelDict = c();
	# currChanNum = 1;
	# for (i in 1:dim(allData)[1])
	# {
		# currChannel = allData$iCh[i];
		# if (currChannel %in% channelDict)
		# {
			# allData$iCh[i] = match(allData$iCh[i], channelDict);
		# }
		# else
		# {
			# channelDict <- c(channelDict, currChannel);
			# allData$iCh[i] = match(allData$iCh[i], channelDict);
		# }
	# }
	
	# Env implementation for map
	channelDict <- new.env(hash=TRUE);
	currChanNum = 1;
	for (i in 1:dim(allData)[1])
	{
		key = allData$iCh[i];
		if (exists(key, channelDict))
		{
			allData$iCh[i] = channelDict[[key]];
		}
		else
		{
			channelDict[[key]] <- currChanNum;
			allData$iCh[i] = channelDict[[key]];
			currChanNum = currChanNum + 1;
		}
	}
	
	if (length(chanToKeep) != 0)
	{
		for (i in 1:length(chanToKeep))
		{
			currChan = chanToKeep[i];
			allData = allData[allData$iCh == currChan];
		}
	}

	returnVals <- list("allData" = allData, "colsKeptNames" = colsToKeepNames, "freqs" = freqs, "channelDict" = channelDict);
	return(returnVals);
}
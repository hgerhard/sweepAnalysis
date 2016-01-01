getInventoryData <- function(datafile)
{
	require(xlsx);
	allData <- read.xlsx(datafile, sheetName = "CVI", stringsAsFactors = FALSE, header = TRUE);
	colHeaders = colnames(allData);
	questionHeaders = colHeaders[7:59];

	# 7:59 is hard coded question indices in the data file
	averageScorePerQuestion = c();
	for (i in 1:dim(allData)[1])
	{
		currData <- suppressWarnings(as.numeric(allData[i, 7:59]));
		currMean <- mean(currData, na.rm = TRUE);
		averageScorePerQuestion = c(averageScorePerQuestion, currMean);
	}
	allData$averageScores <- averageScorePerQuestion

	returnVals <- list("allData" = allData, "questionHeaders" = questionHeaders);
	return(returnVals);
}
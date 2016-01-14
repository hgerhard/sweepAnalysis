getInventoryData <- function(datafile)
{
	require(xlsx);
	allData <- read.xlsx(datafile, sheetName = "CVI", stringsAsFactors = TRUE, header = TRUE);
	colHeaders = colnames(allData);
	questionHeaders = c(colHeaders[7:59]);

	# Convert scores to numbers and translate N/A to empty for now.
	for (i in 1:length(questionHeaders))
	{
		currQuestion = questionHeaders[i];
		allData[[currQuestion]][tolower(allData[[currQuestion]]) == "n/a"] <- "";
		allData[[currQuestion]] <- as.numeric(allData[[currQuestion]]);
	}
	qData <- allData[, 7:59];

	# 7:59 is hard coded question indices in the data file
	averageScorePerSubject = c();
	sdScorePerSubject = c();
	maxScorePerSubject = c();
	minScorePerSubject = c();
	medianScorePerSubject = c();
	for (i in 1:dim(allData)[1])
	{
		currData <- suppressWarnings(as.numeric(allData[i, 7:59]));
		currMean <- mean(currData, na.rm = TRUE);
		currSD <- sd(currData, na.rm = TRUE);
		currMax <- suppressWarnings(max(currData, na.rm = TRUE));
		currMin <- suppressWarnings(min(currData, na.rm = TRUE));
		currMedian <- suppressWarnings(median(currData, na.rm = TRUE));
		averageScorePerSubject = c(averageScorePerSubject, currMean);
		sdScorePerSubject = c(sdScorePerSubject, currSD);
		maxScorePerSubject = c(maxScorePerSubject, currMax);
		minScorePerSubject = c(minScorePerSubject, currMin);
		medianScorePerSubject = c(medianScorePerSubject, currMedian);
	}
	allData$averageScores <- averageScorePerSubject;
	allData$stdScores <- sdScorePerSubject;
	allData$maxScores <- maxScorePerSubject;
	allData$minScores <- minScorePerSubject;
	allData$medianScores <- medianScorePerSubject;

	# Print some summary statistics like 1st quartile, median, mean...
	# for (question in 1:length(questionHeaders))
	# {
		# currQuestion = questionHeaders[question];
		# cat("Question", currQuestion, "\n");
		# currData = allData[[currQuestion]];
		# cat("\n")
		# cat(summary(currData));
		# cat("\n\n");
	# }	

	returnVals <- list("allData" = allData, "questionHeaders" = questionHeaders, "qData" = qData);
	return(returnVals);
}
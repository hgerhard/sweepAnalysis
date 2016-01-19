plotSingleHist <- function(data, questionToPlot)
{
	# data already in data from previous file
	data <- data$qData;
	dev.new();
	currData = data[[questionToPlot]];
	currMax = max(currData, na.rm=TRUE);
	currMin = min(currData, na.rm=TRUE);
	currBreak = seq(0, currMax, 1);
	currTitle = paste(questionToPlot, "Histogram");
	tmp <- hist(currData, main=currTitle, breaks=currBreak, xaxt="n", xlab="Score", ylab="# of Occurrences", freq=TRUE);
	axis(1, at=tmp$mids, currBreak[2:length(currBreak)])
}


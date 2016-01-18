plotMultiVarHist <- function(data, questionPair)
{
	library(RColorBrewer)
	library(MASS)
	source("plotSingleHist.R");
	
	rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
	r <- rf(32)
	
	# Get question only data
	qData <- data$qData;
	qHdrs <- data$questionHeaders
	
	currQs = c();
	for (i in 1:length(questionPair))
	{
		currQs = c(currQs, qHdrs[questionPair[i]]);
	}
	
	qData_filter <- qData[,colnames(qData) %in% currQs];
	colnames(qData_filter) <- c("first", "second")
	
	print(ggplot(qData_filter, aes(x=first, y=second))
	+ labs(x=currQs[1], y=currQs[2])
	+ stat_bin2d(bins=5) + scale_fill_gradientn(colours=r));
	
	plotSingleHist(data, currQs[1]);
	plotSingleHist(data, currQs[2]);
}
plotMultipleHists <- function(data, questions, interval)#, start)
{
	# data		: Data output from getInventoryData.R
	# questions : Questions to plot
	# interval	: Split questions into smaller intervals per figure
	# start     : Starting question
	
	# Get question only data
	qData <- data$qData;
	qHdrs <- data$questionHeaders;
	
	# Add subject number column
	numSubj = dim(qData)[1];
	subjectID = (1:numSubj);
	
	## Get histograms on one plot
	# First reshape data
	qData <- cbind(subjectID, qData);	
	qData_reshape <- reshape(qData, varying=data$questionHeaders, v.names="score", times=data$questionHeaders, timevar="question", direction="long");	
	
	# Plot specific questions
	curr = 1;
	while (curr < length(questions))
	{
		dev.new()
		currQs = c();
		for (i in curr:(curr-1+interval))
		{
			currQs = c(currQs, data$questionHeaders[i]);
		}
		qData_filter <- qData_reshape[qData_reshape$question %in% currQs,]
		print(ggplot(qData_filter, aes(x=score))
		+ geom_histogram() + facet_grid(~question))
		curr <- curr + interval;
	}
	
	# # Do plotting
	# while ((start-1) < numQuestions)
	# {
		# dev.new()
		# qData_filter <- qData_reshape[((start-1)*numSubj+1):((start+interval-1)*numSubj),];
		# print(ggplot(qData_filter, aes(x=score))
		# + geom_histogram() + facet_grid(~question))
		# start <- start + interval;
	# }
}
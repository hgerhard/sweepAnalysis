plotBasic <- function(data)
{
	# Plots correlation/covariance and histograms of scores per question
	
	require(ggplot2);
	require(reshape2);
	library(ggplot2);
	library(reshape2);
	
	# Get question only data
	qData <- data$qData;
	
	# Get covariance/correlation matrix of questionnaire data
	covMat <- cov(qData, use="na.or.complete");
	corrMat <- cor(qData, use="na.or.complete", method="pearson")

	# Plot correlation matrix
	absCorrMat <- abs(corrMat);
	melted_corrMat <- melt(absCorrMat);
	print(ggplot(melted_corrMat, aes(x=Var1,y=Var2,fill=value)) +
	geom_tile(color="white") +
	scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = (max(absCorrMat) + min(absCorrMat)) / 2, limit = c(0,1), space = "Lab", 
	name="Pearson\nCorrelation") +
	theme_minimal() + 
	theme(
	axis.title.x = element_blank(),
	axis.title.y = element_blank(),
	axis.text.x = element_text(angle = 45, vjust = 1, 
	size = 12, hjust = 1)) +
	coord_fixed() +
	ggtitle("Pearson Correlation of Questions"));
}



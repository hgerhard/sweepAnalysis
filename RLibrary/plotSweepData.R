plotSweepData <- function(data, colHdr, freqs, trialNum)
{
	cat("Data dim:", dim(data), "\n");
	
	signalIdx <- grep("Signal", colHdr);
	phaseIdx <- grep("Phase", colHdr);
	sweepValIdx <- grep("SweepVal", colHdr);
	noiseIdx <- grep("Noise", colHdr);
	maxFreq <- length(freqs);
	
	cat("Signal Index:", signalIdx, "\n");
	cat("Phase Index:", phaseIdx, "\n");
	cat("Max Freq:", maxFreq, "\n");
	
	numPerTrial <- maxFreq * 11;
	startingIdx <- numPerTrial * trialNum + 1;
	
	cat("Starting Index:", startingIdx+1, "\n");
	cat("Final Index:", startingIdx+10, "\n");
	cat("data", data[(startingIdx+1):(startingIdx+10), signalIdx], "\n");
	cat("noise", data[(startingIdx+1):(startingIdx+10), noiseIdx], "\n");
	
	signalVals <- data[(startingIdx+1):(startingIdx+10), signalIdx];
	sweepVals <- data[(startingIdx+1):(startingIdx+10), sweepValIdx];
	noiseVals <- data[(startingIdx+1):(startingIdx+10), noiseIdx];
	
	# PLOT
	maxSignalVal = max(signalVals);
	cat("Max Sweep Val:", maxSignalVal, "\n");
	plot(sweepVals, signalVals, log="x", col="red", pch=19, xlab="Log Sweep Values", ylab="Signal", ylim=c(0, maxSignalVal+1));
	lines(sweepVals, signalVals, col="red");
	points(sweepVals, noiseVals, col="blue", pch=19);
	legend('topright', c("Signal Values", "Noise"), lty=c(1,1), col=c("red", "blue"), pt.cex=1);
	
	return(signalVals);
}
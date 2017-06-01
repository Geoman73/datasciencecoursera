corr <- function(directory, threshold = 0) {
  complete_table <- complete("specdata", 1:332)
  nobs <- complete_table$nobs
  idnums <- complete_table$id[nobs > threshold]
  corrdata <- numeric()
  fileList <- list.files(path = directory, pattern = ".csv", full.names = TRUE)
  j <- 1
  for(i in idnums) {
    polldata <- read.csv(fileList[i])
    corrdata[j] <- cor(polldata$sulfate, polldata$nitrate, use="complete.obs")
    j <- j + 1
  }
  result <- corrdata
  return(result)   
}

    

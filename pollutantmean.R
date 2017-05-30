corr <- function(directory, threshold = 0, id = 1:332) {
  fileList <- list.files(path = directory, pattern = ".csv", full.names = TRUE)
  values <- numeric()
  
  for( i in id) {
    data <-read.csv(fileList[i])
    data = na.omit(data)
    if (nrow(data) > threshold) {
      correlationVector = c(correlationVector, cor(data[,2], data[,3]))
    }
    
    
  }
  setwd("C:/Users/George/datasciencecoursera/specdata") 
  return(correlationVector) 
    }



  

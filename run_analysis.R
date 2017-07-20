require(plyr)
library(data.table)
library(dplyr)

###################################################################################################
# This script will:
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement.
# 3. Use descriptive activity names to name the activities in the data set
# 4. Apropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
###################################################################################################

#Set working directory:
setwd("C:/Users/George/datasciencecoursera/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset")

#Reading in data:
features <- read.table("features.txt")
Labels <- read.table("activity_labels.txt", header = FALSE)
subjectTrain <- read.table("train/subject_train.txt", header = FALSE)
yTrain <- read.table("train/y_train.txt", header = FALSE)
xTrain <- read.table("train/X_train.txt", header = FALSE)
subjectTest <- read.table("test/subject_test.txt", header = FALSE)
yTest <- read.table("test/y_test.txt", header = FALSE)
xTest <- read.table("test/X_test.txt", header = FALSE)

# 1. Merge the training and the test sets to create one data set.

#Merge datasets
subjectdata <- rbind(subjectTrain, subjectTest)
activitydata <- rbind(yTrain, yTest)
featuresdata <- rbind(xTrain, xTest)

#Column Names
colnames(subjectdata) <- "Subject"
colnames(activitydata) <- "Activity"
colnames(featuresdata) <- features[,2]

#Big merge
data <- cbind(featuresdata,activitydata,subjectdata)

#2. Extract only the measurements on the mean and standard deviation for each measurement
meanstd <- grep(".*Mean.*|.*Std.*", names(data), ignore.case=TRUE)

addcol <- c(meanstd, 562, 563)

totaldata <- data[,addcol]

#3. Use descriptive activity names to name the activities in the data set
colnames(Labels)  = c('Subject','Activity')
totaldata = merge(totaldata,Labels,by='Subject',all.x=TRUE)

#4. Apropriately labels the data set with descriptive variable names.

names(totaldata)<-gsub("Acc", "Acceleration", names(totaldata))
names(totaldata)<-gsub("Gyro", "Gyromotion", names(totaldata))
names(totaldata)<-gsub("Mag", "Magnitude", names(totaldata))
names(totaldata)<-gsub("^t", "Time", names(totaldata))
names(totaldata)<-gsub("^f", "Frequency", names(totaldata))
names(totaldata)<-gsub("-mean", "Mean", names(totaldata), ignore.case = TRUE)
names(totaldata)<-gsub("-std", "STD", names(totaldata), ignore.case = TRUE)
names(totaldata)<-gsub("Freq\\.", "Frequency", names(totaldata), ignore.case = TRUE)
names(totaldata)<-gsub("angle", "Angle", names(totaldata))
names(totaldata)<-gsub("[Gg]ravity", "Gravity", names(totaldata))
names(totaldata)<-gsub("[Bb]ody[Bb]ody|[Bb]ody)","Body", names(totaldata))
names(totaldata)<-gsub("Jerk", "motion", names(totaldata))


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
totaldata$Subject <- as.factor(totaldata$Subject)
totaldata <- data.table(totaldata)
tidyData <- aggregate(. ~Subject + Activity.y, totaldata, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity.y),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)







# This script does the following:

# Requirement #1:
# Merges the training and the test sets to create one data set.

# Requirement #2:
# Extracts only the measurements on the mean and standard deviation for each measurement. 

# Requirement #3:
# Uses descriptive activity names to name the activities in the data set

# Requirement #4:
# Appropriately labels the data set with descriptive variable names. 

# Requirement #5:
# From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.


# Read in the column headers
features<-read.csv("features.txt")

# Read in the activity labels
activityLabels<-read.csv("activity_labels",header=FALSE,sep=" ")

# Create a vector of the columns whose names contain "mean()" or "std()"
# Note that we are NOT using the meanFreq() columns
matchVec<-sort(c(grep("mean\\(\\)",features$V2,perl=TRUE),grep("std\\(\\)",features$V2,perl=TRUE)))

# Read in the measurement data for the test dataset
# Satisfies requirement #4
testTmp1 <- read.csv("test/X_test.txt",header=FALSE,sep="",col.names=features$V2)

# Read in the activity data for the test dataset
testTmp2 <- read.csv("test/y_test.txt",header=FALSE)

# Read in the subject data for the test dataset
testTmp3 <- read.csv("test/subject_test.txt",header=FALSE)

# Create a data frame containing only the mean() and std() values for the test dataset
# Satisfies requirement #2
test <- testTmp1[,matchVec]

# Add a column containing the activity name for each row
# Satisfies requirement #3
test$activity<-activityLabels[testTmp2$V1,]$V2

# Add a column containing the subject ID for each row
test$subject<-testTmp3$V1

# Add a column stating that each of these rows came from the "test" dataset
test$dataset<-"test"

# Read in the measurement data for the train dataset
# Satisfies requirement #4
trainTmp1 <- read.csv("train/X_train.txt",header=FALSE,sep="",col.names=features$V2)

# Read in the activity data for the train dataset
trainTmp2 <- read.csv("train/y_train.txt",header=FALSE)

# Read in the subject data for the train dataset
trainTmp3 <- read.csv("train/subject_train.txt",header=FALSE)

# Create a data frame containing only the mean() and std() values for the train dataset
# Satisfies requirement #2
train <- trainTmp1[,matchVec]

# Add a column containing the activity name for each row
# Satisfies requirement #3
train$activity<-activityLabels[trainTmp2$V1,]$V2

# Add a column containing the subject ID for each row
train$subject<-trainTmp3$V1

# Add a column stating that each of these rows came from the "train" dataset
train$dataset<-"train"

# Combine the data frames
# (Satisfies requirement #1
allData <- rbind(test,train)

# Use melt() to specify ID and measurement columns
library(reshape2)
meltDF <- melt(allData,id=c("activity","subject"),measure.vars=colnames(allData[,1:length(matchVec)]))

# Use dcast() to average the measurement columns for each set of ID values
# Satisfies requirement #5
tidyDF<-dcast(meltDF,subject+activity~variable,mean)


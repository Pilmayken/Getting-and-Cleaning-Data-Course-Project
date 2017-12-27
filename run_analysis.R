setwd("C:/Users/Carolina/Documents/Data scientist/R Programming/cleaning data/UCI HAR Dataset/")

#Merges the training and the test sets to create one data set.
#read general data and training and assign colnames

features <- read.table("./features.txt", header=FALSE)
activitylabel <- read.table("./activity_labels.txt", header=FALSE)
subjecttrain <- read.table("./train/subject_train.txt", header=FALSE)
xtrain <- read.table("./train/X_train.txt", header=FALSE)
ytrain <- read.table("./train/y_train.txt", header=FALSE)

colnames(activitylabel) <- c("activityId","activityType")
colnames(subjecttrain) <- "subId"
colnames(xtrain) <- features[,2]
colnames(ytrain) <- "activityId"

#merge trainind data

traindata <- cbind(ytrain, subjecttrain, xtrain)

#read test data and assign colnames

subjecttest <- read.table("./test/subject_test.txt", header=FALSE)
xtest <- read.table("./test/X_test.txt", header=FALSE)
ytest <- read.table("./test/y_test.txt", header=FALSE)

colnames(subjecttest) <- "subId"
colnames(xtest) <- features[,2]
colnames(ytest) <- "activityId"

#merge test data

testdata <- cbind(ytest, subjecttest, xtest)

#merge complete

finaldata <- rbind(traindata, testdata)


#Extracts only the measurements on the mean and standard deviation for each measurement.

datameanstd <- finaldata[,grepl("mean|std|subject|activityId", colnames(finaldata))]


#Uses descriptive activity names to name the activities in the data set

library(plyr)
datameanstd <- join(datameanstd, activitylabel, by = "activityId", match = "first")
datameanstd <- datameanstd[,-1]

#Appropriately labels the data set with descriptive variable names.

#Clean data, correct syntax and add names

names(datameanstd) <- gsub("\\(|\\)", "", names(datameanstd), perl  = TRUE)
names(datameanstd) <- make.names(names(datameanstd))

names(datameanstd) <- gsub("Acc", "Accelerometer", names(datameanstd))
names(datameanstd) <- gsub("^t", "Time", names(datameanstd))
names(datameanstd) <- gsub("^f", "Frequency", names(datameanstd))
names(datameanstd) <- gsub("BodyBody", "Body", names(datameanstd))
names(datameanstd) <- gsub("mean", "Mean", names(datameanstd))
names(datameanstd) <- gsub("std", "STD", names(datameanstd))
names(datameanstd) <- gsub("Freq", "Frequency", names(datameanstd))
names(datameanstd) <- gsub("Mag", "Magnitude", names(datameanstd))


#From the data set in step 4, creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.

datameanstd$Subject <- as.factor(datameanstd$Subject)
datameanstd <- data.table(datameanstd)
tidydata <- aggregate(. ~Subject + Activity, datameanstd, mean)
tidydata <- tidydata[order(tidydata$Subject,tidydata$Activity),]
write.table(tidydata, file = "TidyData.txt", row.names = FALSE)

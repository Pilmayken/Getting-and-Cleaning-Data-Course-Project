setwd("C:/Users/Carolina/Documents/Data scientist/R Programming/cleaning data/UCI HAR Dataset/")

#Merges the training and the test sets to create one data set.

# test data:
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/Y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

# train data:
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/Y_train.txt")
subject_train <-read.table("./train/subject_train.txt")

# features and activity
features <- read.table("./features.txt")
activity <- read.table("./activity_labels.txt")

# merges train and test data in one dataset
both_x <- rbind(x_test, x_train)
both_y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)



#Extracts only the measurements on the mean and standard deviation for each measurement.

mean_and_std <- grep("mean\\(\\)|std\\(\\)", features[,2])
both_x <- both_x[,mean_and_std]

#Uses descriptive activity names to name the activities in the data set

both_y[, 1] <- activity[both_y[, 1], 2]

#Appropriately labels the data set with descriptive variable names.

names <- features[mean_and_std, 2] 
names(both_x) <- names 
names(subject) <- "SubjectID"
names(both_y) <- "Activity"

cleaned_data <- cbind(subject, both_y, both_x)


#From the data set in step 4, creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.

cleaned_data <- data.table(cleaned_data)
melted <- melt(cleaned_data, id=c("SubjectID","Activity"))
tidy_data <- dcast(melted, SubjectID+Activity ~ variable, mean)
write.csv(tidy_data, "tidy_data.csv", row.names=FALSE)

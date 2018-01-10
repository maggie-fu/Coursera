## Setup

unzip("./temp/getdata%2Fprojectfiles%2FUCI HAR Dataset.zip")
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
test <- read.table("./UCI HAR Dataset/test/X_test.txt")

# Add column names
variables <- read.table("./UCI HAR Dataset/features.txt")
colnames(train) <- variables$V2
colnames(test) <- variables$V2

# Add labels 
labels_tr <- read.table("./UCI HAR Dataset/train/y_train.txt")
labels_tt <- read.table("./UCI HAR Dataset/test/y_test.txt")
train <- cbind(labels_tr, train)
test <- cbind(labels_tt, test)
colnames(train)[1] <- "activity"
colnames(test)[1] <- "activity"

# Add subjectID
subject_tr <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_tt <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train <- cbind(subject_tr, train)
test <- cbind(subject_tt, test)
colnames(train)[1] <- "subject"
colnames(test)[1] <- "subject"


## Merges the training and the test sets to create one data set.

sets <- rep("train", 7352)
train <- cbind(sets, train)
sets <- rep("test", 2947)
test <- cbind(sets, test)
SS <- rbind(train, test)


## Extracts only the measurements on the mean and standard deviation for each measurement.

ss <- SS[, c(1:3, grep("mean[()]|std[()]", colnames(SS)))]


## Uses descriptive activity names to name the activities in the data set

labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
ss$activity <- gsub(1, labels[1, 2], ss$activity)
ss$activity <- gsub(2, labels[2, 2], ss$activity)
ss$activity <- gsub(3, labels[3, 2], ss$activity)
ss$activity <- gsub(4, labels[4, 2], ss$activity)
ss$activity <- gsub(5, labels[5, 2], ss$activity)
ss$activity <- gsub(6, labels[6, 2], ss$activity)
ss$activity <- tolower(ss$activity)



## Appropriately labels the data set with descriptive variable names.

colnames(ss) <- gsub("^t", "Time", colnames(ss))
colnames(ss) <- gsub("^f", "Frequency", colnames(ss))
colnames(ss) <- gsub("BodyBody", "Body", colnames(ss))
colnames(ss) <- gsub("Acc", "Acceleration", colnames(ss))
colnames(ss) <- gsub("Mag", "Magnitude", colnames(ss))
colnames(ss) <- gsub("[-]mean[(][)]|[-]mean[(][)][-]", "Mean", colnames(ss))
colnames(ss) <- gsub("[-]std[(][)]|[-]std[(][)][-]", "StandDev", colnames(ss))
colnames(ss) <- gsub("[-]", "", colnames(ss))


## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
ss_avg <- ss %>% group_by(subject, activity) %>% summarise_each(funs(mean))
ss_avg <- ss_avg[, -3]
write.table(ss_avg, "wearable.txt", row.names = FALSE) 


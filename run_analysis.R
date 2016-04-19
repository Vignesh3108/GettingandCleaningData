# initialize the download of the file and unzip the file
library(plyr)
rm(list=ls())
dir.create("Week 4")
getwd()
setwd("Week 4")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip")
unzip("Dataset.zip")
setwd("UCI HAR Dataset")

# read the dataset
Activity_labels <- read.table("activity_labels.txt", header = F, sep = " ")
features <- read.table("features.txt", header = F, sep = " ")

subject_test <- read.table("./test/subject_test.txt", header = F, sep = " ")
X_test <- read.table("./test/X_test.txt", header = F, sep = "")
getwd()
y_test <- read.table("./test/y_test.txt", header = F, sep = "")

subject_train <- read.table("./train/subject_train.txt", header = F, sep = " ")
X_train <- read.table("./train/X_train.txt", header = F, sep = "")
y_train <- read.table("./train/y_train.txt", header = F, sep = "")

# convert them to a meaningful Data Frame and name the columns
names(X_test) <- as.vector(features[,2])
names(X_train) <- as.vector(features[,2])
test <- cbind(subject_test, y_test, X_test)
train <- cbind(subject_train, y_train, X_train)
names(test[1]) <- "subject"; names(train)[1] <- "subject"; names(test)[2]<- "activity"; names(train)[2]<- "activity"

# replace the activity lables
test[,2] <- Activity_labels[test[, 2], 2]
train[,2] <- Activity_labels[train[, 2], 2]
names(test)[1] <- names(train)[1]

# join both the data sets
data_final <- rbind(train, test)
ind <- grepl("mean|std", names(data_final), fixed = F)
DataSubFinal <- data_final[, c(1, 2, which(ind))]

summary_stats <- ddply(DataSubFinal, .(subject, activity), colwise(mean))

# rename the Columns
names(summary_stats) <- gsub('^t', 'time', names(summary_stats))
names(summary_stats) <- gsub('^f', 'frequency', names(summary_stats))
names(summary_stats) <- gsub('Acc', 'Accelerometer', names(summary_stats))
names(summary_stats) <- gsub('Gyro','Gyroscope', names(summary_stats))
names(summary_stats) <- gsub('mean[(][)]','Mean',names(summary_stats))
names(summary_stats) <- gsub('std[(][)]','Std',names(summary_stats))
names(summary_stats) <- gsub('-','',names(summary_stats))
write.table(summary_stats, "Tidy.txt", row.names = F)

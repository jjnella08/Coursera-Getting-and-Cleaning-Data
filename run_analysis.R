## run_analysis.R
setwd("C:/Users/allq2d/Coursera-Getting-and-Cleaning-Data")

## get and download the file
if(!dir.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")

## unzip the file into the current directory
unzip("./data/Dataset.zip", exdir = ".")

## Merges the training and the test sets to create one data set.
## 1) load the library that have the needed functions
library(plyr)
library(dplyr)git
library(reshape2)
library(data.table)

## Read the labels and features data into data frames
## Fetures holds the column names
## ActivityLabels holds the activity names
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote = "\"")
features <- read.table("./UCI HAR Dataset/features.txt", quote = "\"")

## make sure these columns are character fields
activityLabels[,2] <- as.character(activityLabels[,2])
features[,2] <- as.character(features[,2])  

## grab only the rows with titles for mean and standard deviation
subFeatures <- grep(".*mean.*|.*std.*", features[,2])

## get the values from the rows to be used as column names
FeatureLAbels <- features[subFeatures,2]

## Read the training and test data into data frames - X has the results, 
## grab only the data where the columns are for mean and Standard deviation
XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")[subFeatures]
XTest <- read.table("UCI HAR Dataset/test/X_test.txt")[subFeatures]

## Read the training and test data into data frames
## Y has the labels, Subject has the subjects
YTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", quote = "\"")
YTest <- read.table("./UCI HAR Dataset/test/y_test.txt", quote = "\"")
SbjtTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote = "\"")
SbjtTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote = "\"")

## Joing the results, labels, and subjects into a single data frame for training data
Train <- cbind(SbjtTrain, YTrain, XTrain)
colnames(Train) <- c("Subject","Activity",FeatureLAbels)

## Joing the results, labels, and subjects into a single data frame for test data
Test <- cbind(SbjtTest, YTest, XTest)
colnames(Test) <- c("Subject","Activity",FeatureLAbels)

## merge both tables
TrainTest <- rbind(Train, Test)

## Change the Subject and Activity values to Charater values to be used in the melt function
TrainTest$Activity <- factor(TrainTest$Activity, levels = activityLabels[,1], labels = activityLabels[,2])
TrainTest$Subject <- as.factor(TrainTest$Subject)

TrainTestMelt <- melt(TrainTest, id=c("Subject","Activity"))
dcast(TrainTestMelt, Subject + Activity ~ variable, fun=mean)

## Create a second independent tidy data set with the average of each 
## variable for each activity and each subject.
write.table(TrainTestMean, "tidy.txt", row.names = FALSE, quote = FALSE)

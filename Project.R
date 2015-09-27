


setwd("Desktop/Coursera/John Hopkins - Data Science Track/4. Getting and cleaning data/Project")
if (!file.exists("data/getdata-projectfiles-UCI HAR Dataset.zip")) {
    download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                  destfile="data/getdata-projectfiles-UCI HAR Dataset.zip",
                  method="curl")
    unzip("data/getdata-projectfiles-UCI HAR Dataset.zip")  
}



##1. Merge the training and the test sets to create one data set.
library(data.table)
#Read features & labels
activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("data/UCI HAR Dataset/features.txt")

#Read Train and Test data
subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")

X_train <- read.table("data/UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("data/UCI HAR Dataset/test/X_test.txt")

Y_train <- read.table("data/UCI HAR Dataset/train/Y_train.txt")
Y_test <- read.table("data/UCI HAR Dataset/test/Y_test.txt")

## 4. Appropriately labels the data set with descriptive variable names.    
#Merge/Name Train and Test data sets
subject_dt <- rbind(subject_train,subject_test)
names(subject_dt)<-"subject_identifier"

X_dt <- rbind(X_train,X_test)
names(X_dt) <- features[,2]

Y_dt <- rbind(Y_train,Y_test)
names(Y_dt) <- "activity"


## 2.Extract only the measurements on the mean and standard deviation for each measurement. 

#Use regex to identify the mean / std features in "features" data frame
mean_std <- grepl("-mean|-std",features[,2]) & !grepl("-meanFreq",features[,2])

X_dt <- X_dt[,mean_std]


## 3. Uses descriptive activity names to name the activities in the data set
Y_dt[,1] <- activity_labels[Y_dt[,1],2]
HAR <- cbind(subject_dt,Y_dt,X_dt)
write.table(HAR, "data/HAR_tidy.txt", row.names=FALSE)


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
melted <- melt(HAR, id=c("subject_identifier","activity"))
HAR_avg <- dcast(melted,subject_identifier + activity ~ variable,mean)

write.table(HAR_avg, "data/HAR_tidy_average.txt", row.names=FALSE)

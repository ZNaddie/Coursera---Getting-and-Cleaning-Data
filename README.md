# Coursera---Getting-and-Cleaning-Data

https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Good luck!


download <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "temp")
unzip("temp")
unlink("temp")

# activity
test_y  <- read.table("./UCI HAR Dataset/test/Y_test.txt" , header = FALSE)
train_y <- read.table("./UCI HAR Dataset/train/Y_train.txt", header = FALSE)

# subjects  
test_sub  <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
train_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# features 
test_X  <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
train_X <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

head(test_y)
head(train_y)
head(test_sub)
head(train_sub)
head(test_X)
head(train_x)

# activity, subject, and features sets combined and merged

activity <- rbind(train_y, test_y)
subject <- rbind(train_sub, test_sub)
features <- rbind(train_x, test_x)

#read in labels
labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
head(labels)

# change factor levels(1-6) to match activity labels (where's the running? aka 7? )
activity$V1 <- factor(activity$V1, levels = as.integer(labels$V1), labels = labels$V2)

# activity and subject columns
names(activity)<- c("activity")
names(subject)<-c("subject")

#  feature columns from features text file
featurestxt <- read.table("./UCI HAR Dataset/features.txt", head=FALSE)
head(featurestxt)
names(features)
names(features)<- featurestxt$V2

#columns with mean and standard deviation data and subsetting
meanstdev<-c(as.character(featurestxt$V2[grep("mean\\(\\)|std\\(\\)", featurestxt$V2)]))
subdata<-subset(features,select=meanstdev)

# data sets +  activity names and labels
subjectactivity <- cbind(subject, activity)
final <- cbind(subdata, subjectactivity)

# time and frequency variables
names(final)<-gsub("^t", "time", names(final))
names(final)<-gsub("^f", "frequency", names(final))

# new data set with subject and activity means
clean <- aggregate(final, by = list(final$subject, final$activity), FUN = mean)
colnames(clean)[1] <- "Subject"
names(clean)[2] <- "Activity"

# avg and stdev for non-aggregated sub and act columns
clean <- clean[1:68]
Looking at data together
head(clean)

# export clean dataset
write.table(cleand, file = "tidy_data.txt", row.name = FALSE)

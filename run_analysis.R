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
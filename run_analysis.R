#step1 downloading dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

# renaming column names and retrieving useful files
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
names(features)
head(features)
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
names(activities)
head(activities)
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
names(subjecttest)
head(subjecttest)
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# merjing the data into one data set
firstjoin <- rbind(xtrain, xtest)
secondjoin<- rbind(ytrain, ytest)
Subjectjoin <- rbind(subjecttrain, subjecttest)
finaljoin <- cbind(Subjectjoin, secondjoin, firstjoin)

cleandata <- finaljoin %>% select(subject, code, contains("mean"), contains("std"))

cleandata$code <- activities[cleandata$code, 2]
# withe the help of gsub and regular expressions trying to remove shortcuts
names(cleandata)[2] = "activity"
names(cleandata)<-gsub("Acc", "Accelerometer", names(cleandata))
names(cleandata)<-gsub("Gyro", "Gyroscope", names(cleandata))
names(cleandata)<-gsub("BodyBody", "Body", names(cleandata))
names(cleandata)<-gsub("-mean()", "Mean", names(cleandata), ignore.case = TRUE)
names(cleandata)<-gsub("-std()", "STD", names(cleandata), ignore.case = TRUE)
names(cleandata)<-gsub("Mag", "Magnitude", names(cleandata))
names(cleandata)<-gsub("-freq()", "Frequency", names(cleandata), ignore.case = TRUE)
names(cleandata)<-gsub("angle", "Angle", names(cleandata))
names(cleandata)<-gsub("gravity", "Gravity", names(cleandata))
names(cleandata)<-gsub("^t", "Time", names(cleandata))
names(cleandata)<-gsub("^f", "Frequency", names(cleandata))
names(cleandata)<-gsub("tBody", "TimeBody", names(cleandata))

#final result obtained

result <- cleandata %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(result, "result.txt", row.name=FALSE)
#verifying the result
str(result)



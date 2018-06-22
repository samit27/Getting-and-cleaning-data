#This R code is written for the course project of Getting and Cleaning data
# download the file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destinationfile <- "./data/UCI HAR Dataset.zip"
download.file (url, destinationfile)

#unzipping the file
unzip(destinationfile, exdir = "./data")

#read the features file
features <- read.table("./data/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# read the activity labels file
activitylabel <- read.table(("./data/UCI HAR Dataset/activity_labels.txt"))
activitylabel[,2] <- as.character(activitylabel[,2])

#Extract only Mean & Std details
wantedfeatures <- grep("mean\\(\\)|std\\(\\)", features[,2])
wantedfeatures.names <- features[wantedfeatures,2]

#Read train data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")[wantedfeatures]
y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Merge train data
train <- cbind(x_train,y_train,subject_train)

#Read test data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")[wantedfeatures]
y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Assign  variable names
names(x_train) <- wantedfeatures.names 
names(y_train) <- "activityId"
names(subject_train) <- "subjectId"

names(x_test) <- wantedfeatures.names 
names(y_test) <- "activityId"
names(subject_test) <- "subjectId"

names(activitylabel) <- c("activityId","activityName")

#Merge train data
trainData <- cbind(y_train, subject_train, x_train)

#Merge test data
testData <- cbind(y_test, subject_test, x_test)

#Merge train and test
allData <- rbind(trainData, testData)

#Add activityName
MeanStdWithActNames <- merge(allData,activitylabel,by='activityId')

#Get averages by activity & subject and Order
avgByActSubj <- aggregate(.~activityId+activityName+subjectId,MeanStdWithActNames,mean)
avgByActSubj <- avgByActSubj[order(avgByActSubj$activityId,avgByActSubj$subjectId),]

#Write the new tidy data set to a text file
write.table(avgByActSubj,"./data/tidy_dataset.txt",row.name=FALSE,quote=FALSE)

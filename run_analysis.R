##load relevant library
library(data.table)
library(dplyr)

##extract data files
traininglabel <- read.table("./UCI HAR Dataset/train/y_train.txt")
testlabel <- read.table("./UCI HAR Dataset/test/y_test.txt")
trainingset <- read.table("./UCI HAR Dataset/train/x_train.txt")
testset <- read.table("./UCI HAR Dataset/test/x_test.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
feature <- read.table("./UCI HAR Dataset/features.txt")

##rename column names to it respective variable names
names(subjecttrain) <- c("subject")
names(subjecttest) <- c("subject")

names(testlabel) <- c("activity")
names(traininglabel) <- c("activity")

names(trainingset) <- feature$V2
names(testset) <- feature$V2

##rename the activity names
testlabel <- replace(testlabel,testlabel==1,"walking-test")
testlabel <- replace(testlabel,testlabel==2,"walkingupstair-test")
testlabel <- replace(testlabel,testlabel==3,"walkingdownstair-test")
testlabel <- replace(testlabel,testlabel==4,"sitting-test")
testlabel <- replace(testlabel,testlabel==5,"standing-test")
testlabel <- replace(testlabel,testlabel==6,"laying-test")

traininglabel <- replace(traininglabel,traininglabel==1,"walking-training")
traininglabel <- replace(traininglabel,traininglabel==2,"walkingupstair-training")
traininglabel <- replace(traininglabel,traininglabel==3,"walkingdownstair-training")
traininglabel <- replace(traininglabel,traininglabel==4,"sitting-training")
traininglabel <- replace(traininglabel,traininglabel==5,"standing-training")
traininglabel <- replace(traininglabel,traininglabel==6,"laying-training")

##extract only mean and standard deviation
testset <- testset[,grep("mean\\(\\)|std\\(\\)",names(testset))]
trainingset <- trainingset[,grep("mean\\(\\)|std\\(\\)",names(trainingset))]

##combine subject, activity and dataset
testsubandact <- cbind(subjecttest,testlabel)
trainsubandact <- cbind(subjecttrain,traininglabel)

testfullset <- cbind(testsubandact,testset)
trainfullset <- cbind(trainsubandact,trainingset)

##combine to only one dataset
runfullset <- rbind(testfullset,trainfullset)

##group data by activty and subject
grouprunfullset <- group_by(runfullset,activity,subject)

##get the average of each variable
meanforeachvar <- summarise_each(tested,funs(mean))

##output the average of each variable into a text file
write.table(meanforeachvar,"run_analysis_assignment.txt",row.names = FALSE)

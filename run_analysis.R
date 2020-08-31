
library(tidyverse)
# download the zip file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                 destfile = "C:/Users/kulad/Documents/getdata_projectfiles_UCI HAR Dataset.zip")


# Features and activity labels
       features <- read.table("~/UCI HAR Dataset/features.txt",             stringsAsFactors = F)
   featurenames <- c(features$V2) # Assigning the names for the final dataset
 activityLabels <- read.table("~/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)

# Read the training data sets
trainData_x   <- read.table("~/UCI HAR Dataset/train/X_train.txt")
trainData_Y   <- read.table("~/UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("~/UCI HAR Dataset/train/subject_train.txt")
names(trainSubjects) <- "SubjectID"

# Combine the columns
   Tab0_train <- bind_cols(trainSubjects,trainData_Y,trainData_x)


testData_x   <- read.table("~/unzip/UCI HAR Dataset/test/X_test.txt")#[featuresonly_MeanSTD]
testData_Y   <- read.table("~/unzip/UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("~/unzip/UCI HAR Dataset/test/subject_test.txt")
names(testSubjects) <- "SubjectID"

Tab0_test    <- bind_cols(testSubjects,testData_Y,testData_x)

# COmbine test and train datasets
        CombinedData  <- bind_rows(Tab0_train, Tab0_test)
  names(CombinedData) <- c('SubjectID', "Activity", featurenames)
CombinedData$Activity <- factor(CombinedData$Activity, 
                           levels = activityLabels[,1], 
                           labels = activityLabels[,2])
# Extract mean and std columns only
    CombinedData <- CombinedData[,grep("^Subject|^Activity|.*mean.*|.*std.*", colnames(CombinedData))]
# Transpose long to wide and calculate the mean
CombinedDataMean <- melt(CombinedData, id = c("SubjectID", "Activity")) %>% 
                                 dcast(SubjectID + Activity ~ variable, mean)

write.table(CombinedDataMean, "tidyData.txt", row.names = FALSE)



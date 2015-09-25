############################################
######## Getting and Cleaning Data #########
############ Course Project ################
############################################

library(reshape2)

#Download the dataset
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","project_data.zip",
              mode="w", method="internal")

#Unzip and import data
dir.create("Project_Data")
unzip("project_data.zip",exdir = "Project_Data")
setwd("./Project_Data/UCI Har Dataset")

#Read in the activity labels
activity_labels = read.table("activity_labels.txt",col.names = c("value","activity"),stringsAsFactors = F)

#Establish shell for tidy dataset for test, train, and combined
test_data = NULL
train_data = NULL
all_data = NULL

#Import data function - since we need to do this multiple times, create function to pull in test/train data
data_aggregate = function(dataset = "test",
                          measures = c("body_acc_x","body_acc_y","body_acc_z",
                                      "body_gyro_x","body_gyro_y","body_gyro_z",
                                      "total_acc_x","total_acc_y","total_acc_z")){
  #Step into data set directory
  setwd(paste0("./",dataset))
  data_in = data.frame("subject" = read.table(paste0("subject_",dataset,".txt"))$V1)
  data_in$dataset = rep(dataset,nrow(data_in))
  
  #add activity labels
  data_in$activity = activity_labes$activity[match(read.table(paste0("y_",dataset,".txt"))$V1,activity_labes$value)]
  
  #Loop through the measurements and add the mean and sd to the tidy dataset
  for(mes in measures){
    cat(paste0(Sys.time()," - Aggregating data for: ",mes,"_",dataset,"\n"))
    data_in[,paste0(mes,"_mean")] = rowMeans(read.table(paste0("./Inertial Signals/",mes,"_",dataset,".txt"),sep=""))
    data_in[,paste0(mes,"_sd")] = apply(read.table(paste0("./Inertial Signals/",mes,"_",dataset,".txt"),sep=""),1,function(x){sd(x)})
  }
  
  #Step back out of data set directory
  setwd("..")
  return(data_in)
}


#Pull in test data
test_data = data_aggregate("test")
#Pull in train data
train_data = data_aggregate("train")

#Merge datasets
all_data = rbind(test_data,train_data)

#recast data into a summary dataset with means for each subject for each activity
data_melt = melt(all_data, id.vars = c("subject","activity","dataset"))
tidy_data = cast(data_melt,subject + activity ~ variable,mean)

#Save tidy dataset
setwd("../../")
write.table(tidy_data,"tidy_data.txt",row.name=FALSE)

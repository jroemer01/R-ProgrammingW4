# Program to analyze and produce a clean dataset from the a wearable data set

# Goals of the assignment
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Steps 
# 1) Load the necessary packages
# 2) Download and unzip the data
# 3) Read the file names and parse into three chucks 
#   a) The activities (y files)
#   b) the data (X files)
#   c) the subjects
# 4) Create a train table that cbinds the activity and subject file
# 5) Create a test table that cbinds the activity and subject file
# 6) Select only the mean and std columns into a new data set



# Need to add logic to test installation status prior to loading
pckgs<-installed.packages()

if (!("dplyr" %in% pckgs[,1])) install.packages("dplyr")
if (!("gdata" %in% pckgs[,1])) install.packages("gdata")

library(dplyr)
library(gdata)

#Need to download the dataset
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipname <- "wearable.zip"
#download.file(fileURL,zipname)

# Get the names of the files
datafilenames<-unzip(zipname, list = TRUE)

#Train rows
train<-grepl("train.[xX]_train.txt",datafilenames$Name)
trainfiles<-datafilenames$Name[train]

#Test rows
test<- grepl("test.[xX]_test.txt",datafilenames$Name)
testfiles<-datafilenames$Name[test]

# Load activity lables
activity_file<-grepl("activity_labels.txt",datafilenames$Name)
my_activity<-datafilenames$Name[activity_file]
activity_labels<-read.table(my_activity)


#Load Features
feature<-grepl("features.txt",datafilenames$Name)
featurestable<-datafilenames$Name[feature]

#Load subject files
subjects<-grepl("subject",datafilenames$Name)
subjectstable<-datafilenames$Name[subjects]



#print(trainfiles)
# UPDATE LATER TO USE DIR AND FILES TO CYCLE THROUGH THE TRAIN AND TEST FOLDERS

#Unzip the file
unzip(zipname)

# Getting the file names from the train and test folders

#Need to extract the data

features<-read.table(featurestable)

#This table has 561 columns and 7352 observations
#
#x_train<-read.table("./train/X_train.txt",header = FALSE)

# The fist step is to assign labels to all the columns
# TO do this we will need to make the features file human readable
# I will create a data table with extra columns that then get pasted together to form the new name
# The tidy column format will be function name then description of the measurement and rate if applicable
# Example Mean Body Acceleration
# t prefix become Time
# f prefix will be Fourier Transform


function_names<-c("std","Mean","-Coeff","\\(\\)","-[XYZ]","^t","^f"
                  ,"gyro","Acc","sma","iqr"
                  ,"-[Aa]r[cC]oeff","[-,][123456789]","-","mean","min","max"
                  ,"mad","entropy","energy","([Bb]ody)\\1+",",[XYZ]","[Mm]ag","Gyro"
                  ,"Jerk","[Ii]nds","[Aa]ngle\\(","$\\)",",","[Gg]ravity","bandsEnergy[1-9]?[1-9]?",
                  "[sS]kewness","[Kk]urtosis","X","Y","Z"," \\)", " t",".1")
#human_functions<-c("Standard Deviation", "Mean", "Coefficient",$Energy[123456789]+)
decode<-c("Standard Deviation ", "Mean ", "Coefficient ","","","Time ","Fast Fourier "
          ,"Gyroscope ","Acceleration ","Signal Magnitude Area ","Interquartile Range "
          ,"Autorregresion Coefficients","","","Mean ","Min ","Max "
          ,"Median Absolute Deviation","Entropy","Energy ","\\1 ","","Magnitude ","Gyroscope "
          ,"Jerk ","Index "," Angle of ","","","Gravity ","Frequency Interval Energy"
          ,"Skewness", "Kurtosis","X ","Y ","Z ",""," Time ","")

# Loop through the elements to update and apply the decodes
x<-1
for (i in function_names) {
   features$V2<-trim(gsub(i,decode[x],features$V2))
  x<-x+1
}




#tidytable_files<-c(trainfiles,testfiles)
test_train<-c("test","train")

file_prefix<-paste(getwd(),"/UCI HAR Dataset/",sep = "")
dim_files<-c("/X_","/y_","/subject_")

# Create the final data set
# Read the Training data set
# should make this into a function
x<-1
for (f in test_train) 
  {
      #print(c("variable f: ",f))
      file_path<-paste(file_prefix,f,dim_files[1],f,".txt",sep="")
      #print(file_path)
      X_data_table<-read.table(file_path)
      
      file_path<-paste(file_prefix,f,dim_files[2],f,".txt",sep="")
      y_data_table<-read.table(file_path)
      y_data_table<- merge.data.frame(activity_labels,y_data_table,by.x = "V1",by.y = "V1" )
      
      
      file_path<-paste(file_prefix,f,dim_files[3],f,".txt",sep="")
      subj_data_table<-read.table(file_path)
      
      #print("got here?")
      
      X_data_table<-cbind(y_data_table,X_data_table)
      X_data_table<-cbind(subj_data_table,X_data_table)
      
    if (x==1)
      {
        tidytable<-X_data_table
        #print("if loop")
      }
    else 
      {
      tidytable<-rbind(tidytable,X_data_table)
      }
    
    #num_obs<-nrow(tidytable)
    #print(num_obs)
    x<- x+1
    
    }
#Assign the names to the Tiday Table
names(tidytable) <- c("Subject","Activity ID","Activity Name",features$V2)


tidytable<-tbl_df(tidytable)

#extract the columns that are mean or standard deviation
keep_columns1<-grep("Mean",names(tidytable))
keep_columns2<-grep("Standard Deviation", names(tidytable))

keep_columns<-c(1,3,keep_columns1,keep_columns2)

final_tidy<-select(tidytable,keep_columns)

# Setting the group by and creating an table with means by the group by for each calculation
# column and then writing it to disk
avg_final<-group_by(final_tidy,"Subject","Activity Name")
avg_final<-summarise_each(avg_final,funs(mean),3:88)
write.table(avg_final, file = "tidy_avg_table.txt")



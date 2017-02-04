<H1> This file contains the steps I used to transform the files provided into a tidy data set

Goals of the assignment
 - Merges the training and the test sets to create one data set.
 - Extracts only the measurements on the mean and standard deviation for each measurement.
 - Use descriptive activity names to name the activities in the data set
 - Appropriately labels the data set with descriptive variable names.
 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Steps 
1) Load the necessary packages
2) Download and unzip the data
3) Read the file names and parse into three chucks 
   a) The activities (y files) - and merge these with the activity labels
   b) the data (X files)
   c) the subjects
4) Create a train table that cbinds the activity and subject file
5) Create a test table that cbinds the activity and subject file
6) Combine the Train and Test tables with rbind
7) Select only the mean and std columns into a new data set
8) Load the features file and use gsub to clean up the names so they are readable.  This was done with two character vecotrs creating paired substitutions
9) Create a new table that is the average of all the data columns and write it out to the working directory

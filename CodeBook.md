<H1> This file contains the steps I used to transform the files provided into a tidy data set </H1>

Goals of the assignment
 - Merges the training and the test sets to create one data set.
 - Extracts only the measurements on the mean and standard deviation for each measurement.
 - Use descriptive activity names to name the activities in the data set
 - Appropriately labels the data set with descriptive variable names.
 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Steps 
 <LI> Load the necessary packages </LI>
- Download and unzip the data
- Read the file names and parse into three chucks 
    - The activities (y files) - and merge these with the activity labels
    - The data (X files)
    - The subjects
- Create a train table that cbinds the activity and subject file
- Create a test table that cbinds the activity and subject file
- Combine the Train and Test tables with rbind
- Select only the mean and std columns into a new data set
- Load the features file and use gsub to clean up the names so they are readable.  This was done with two character vecotrs creating paired substitutions
- Create a new table that is the average of all the data columns and write it out to the working directory

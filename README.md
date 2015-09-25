README 
=================
run_analysis.R is a function for importing data from the UCI Machine Learning Repository. It downloads the dataset, imports the various text files to assemble a tidy dataset. 

### Dependencies

* reshape2 package
* dataset: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### Script description

The script perform=s the following operations:

1. Import the dataset
2. Unzip data package into created directory
3. Open subdirectory within uncompressed dataset
4. Read in the activity labels into a lookup table for later use
5. Establish shell variables for accepting sepearte datasets
6. Define a function "data_aggregate" (defined below) that returns the aggregated data from each of the two datasets ('test' and 'train' groups)
7. Use 'data_aggregate' to pull in data from test and train groups
8. Concatenate two datasets into new 'all_data' dataset.
9. Recast dataset into a summary 'tidy_data' dataset that includes the average values for each variable in the dataset for each subject performing each activity.
10. Return to the start directory
11. Save the tidy dataset.

### data_aggregate()

This function creates a tidy dataset for each of the two datasets by parsing all the text files and aggregating only the mean and standard deviations of each data trace intoa single dataframe.

Inputs:
* dataset (either 'test' or 'train')
* measures (all the measured values, each of which corresponds to a separate data file) 

Output:
* A dataframe with the mean and standard deviation for each of the input 'measures'
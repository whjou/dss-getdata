# dss-getdata
Getting and Cleaning Data Course Project

## Introduction
This repository contains a script to tidy up the data extracted from the project at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. 

## Execution
To run the script, first download the data at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and extract the contents into `~/data` folder under the current R working directory where the script `run_analysis.R` is present, then execute the script. On successful execution, two files will be created in the working directory:
  * `tidydata1.txt` - containing the tidied data set comprising of only measurement means and standard deviations.
  * `tidydata2.txt` - containing the above tidied data set aggregated by activity and subject.

# 
For more details about the tidied data sets, please refer to [CodeBook.md](CodeBook.md).

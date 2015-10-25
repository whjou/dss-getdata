# Assumes data is already in .\data\UCI HAR Dataset\
data_dir          <- "data"
dataset_dir       <- paste(data_dir    , "UCI HAR Dataset" , sep = "\\")
train_dataset_dir <- paste(dataset_dir , "train"           , sep = "\\")
test_dataset_dir  <- paste(dataset_dir , "test"            , sep = "\\")

if (!file.exists(data_dir)) {
  dir.create(data_dir)
}

# Store referenced filenames in more descriptive variables
measurement_label_file <- paste(dataset_dir       , "features.txt"        , sep = "\\")
activity_label_file    <- paste(dataset_dir       , "activity_labels.txt" , sep = "\\")

train_subject_file     <- paste(train_dataset_dir , "subject_train.txt"   , sep = "\\")
train_activity_file    <- paste(train_dataset_dir , "Y_train.txt"         , sep = "\\")
train_measurement_file <- paste(train_dataset_dir , "X_train.txt"         , sep = "\\")

test_subject_file      <- paste(test_dataset_dir  , "subject_test.txt"    , sep = "\\")
test_activity_file     <- paste(test_dataset_dir  , "Y_test.txt"          , sep = "\\")
test_measurement_file  <- paste(test_dataset_dir  , "X_test.txt"          , sep = "\\")

# Read training data set
train_subject     <- read.csv(train_subject_file , header = FALSE, col.names = c("Subject"))
train_activity    <- read.csv(train_activity_file, header = FALSE, col.names = c("Activity"))
train_measurement <- read.csv(
  textConnection(
    gsub("  ", " +", readLines(train_measurement_file))),
  header = FALSE, sep = " ")[,-1]

# Read test data set
test_subject     <- read.csv(test_subject_file , header = FALSE, col.names = c("Subject"))
test_activity    <- read.csv(test_activity_file, header = FALSE, col.names = c("Activity"))
test_measurement <- read.csv(
  textConnection(
    gsub("  ", " +", readLines(test_measurement_file))),
  header = FALSE, sep = " ")[,-1]

# 1. Merges the training and the test data sets to create the merged data set.
merged_subject     <- rbind(train_subject, test_subject)
merged_activity    <- rbind(train_activity, test_activity)
merged_measurement <- rbind(train_measurement, test_measurement)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
measurement_labels           <- read.csv(measurement_label_file, header = FALSE, sep = " ")
# Extract column indices of mean and std measurements. meanFreq() is not considered as a mean measurement.
mean_std_measurement_columns <- grep("(mean|std)[(])", measurement_labels[,2])
# Extract the corresponding labels
mean_std_measurement_labels  <- measurement_labels[mean_std_measurement_columns,]
# Extract the corresponding measurements
merged_mean_std_measurement  <- merged_measurement[,mean_std_measurement_columns]

# 3. Uses descriptive activity names to name the activities in the data set
activity_labels          <- read.csv(activity_label_file   , header = FALSE, sep = " ")
# Substitute activity id with corresponding labels
merged_activity$Activity <- activity_labels[match(merged_activity$Activity, activity_labels$V1), 2]

# 4. Appropriately labels the data set with descriptive variable names.
# Substitute column names of extracted measurments with corresponding labels
colnames(merged_mean_std_measurement) <- mean_std_measurement_labels[,2]

# Merge components of the dataset into one
merged_dataset <- cbind(merged_subject, merged_activity, merged_mean_std_measurement)
# Output to file
write.table(merged_dataset, "tidydata1.txt", row.name=FALSE)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Aggregate data by averaging by activity and subject
tidy_data <- aggregate(. ~ (Activity + Subject), data = merged_dataset, mean)
# Output to file
write.table(tidy_data, "tidydata2.txt", row.name=FALSE)

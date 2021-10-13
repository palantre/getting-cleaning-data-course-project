# Load packages
library(tidyverse)
library(here)

# Read data previously downloaded and uncompressed in data folder

      #  Read in the training set data files
      training_set <- read_table(here::here("data", "train", "X_train.txt"))
      training_activity<- read_table(here::here("data", "train", "y_train.txt"))
      training_subjects <- read_table(here::here("data", "train", "subject_train.txt"))
      
      #  Read in the test set data files
      test_set <- read_table(here::here("data", "test", "X_test.txt"))
      test_activity<- read_table(here::here("data", "test", "y_test.txt"))
      test_subjects <- read_table(here::here("data", "test", "subject_test.txt"))

# Add column names in main datasets using 'features' vector.  
features <- read.table(here::here("data", "features.txt"))
colnames(training_set) <- features[,2]
colnames(test_set) <- features[,2]

# Add column names to activity labels and subject tables.
colnames(training_activity) <- "activity_id"
colnames(test_activity) <- "activity_id"
colnames(training_subjects) <- "subject_id"
colnames(test_subjects) <- "subject_id"

# Merge training and test sets
merge_set <- bind_rows(training_set, test_set)
merge_activity <- bind_rows(training_activity, test_activity)
merge_subjects <- bind_rows(training_subjects, test_subjects)
# Merge main set, activities and subjects
merge_all <- bind_cols(merge_subjects, merge_activity, merge_set)

# Add activity labels combining with activity_labels.txt
activity <- read.table(here::here("data", "activity_labels.txt"))
colnames(activity) <- c("activity_id","activity")
merge_all <- left_join(merge_all, activity)
merge_all <- relocate(merge_all, activity, .after = "activity_id")

# Extract only the measurements on the mean and standard deviation for each measurement
extracted <- select(merge_all, "subject_id", "activity", contains("mean()") | contains("std()"))

#create an independent tidy data set with the average of each variable for each activity and each subject
average <- extracted %>%
      group_by(activity, subject_id) %>%
      summarise_at(vars(4:66), mean)

# Save tidy data set to a csv file
write_csv(average, here::here("data", "tidy_average.csv"))
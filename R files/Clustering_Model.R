.libPaths()


lapply(.libPaths(), list.files)


if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}


# STEP 1. Install and Load the Required Packages ----
## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## naniar ----
if (require("naniar")) {
  require("naniar")
} else {
  install.packages("naniar", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## ggplot2 ----
if (require("ggplot2")) {
  require("ggplot2")
} else {
  install.packages("ggplot2", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## corrplot ----
if (require("corrplot")) {
  require("corrplot")
} else {
  install.packages("corrplot", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## ggcorrplot ----
if (require("ggcorrplot")) {
  require("ggcorrplot")
} else {
  install.packages("ggcorrplot", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
  
}

## dplyr ----
if (require("dplyr")) {
  require("dplyr")
} else {
  install.packages("dplyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## tidyverse ----
if (require("tidyverse")) {
  require("tidyverse")
} else {
  install.packages("tidyverse", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## plumber ----
if (require("plumber")) {
  require("plumber")
} else {
  install.packages("plumber", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# STEP 2. Load the Dataset ----

library(readr)
Training.csv <- read_csv("Training.csv")
View(Training.csv)

str(Training.csv)
dim(Training.csv)
head(Training.csv)
summary(Training.csv)



# STEP 3. Check for Missing Data and Address it ----
# Are there missing values in the dataset?
any_na(Training.csv)

# How many?
n_miss(Training.csv)

# What is the proportion of missing data in the entire dataset?
prop_miss(Training.csv)

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(Training.csv)



# STEP 3 Training and Saving Clustering Algorithm
set.seed(7)

# Select columns 3 and 4 for k-means clustering
columns_for_clustering <- Training.csv[, c(3, 4)]

# Perform k-means clustering
model_to_predict_clusters <- kmeans(Training.csv[, c(3, 4)], centers = 4, nstart = 20)

# Add the cluster assignments to the dataset
Training.csv$cluster <- model_to_predict_clusters$cluster

# Visualize the clustering results (modify this based on your requirements)
# For example, if you want to visualize column 3 against column 4:
plot(productId ~ quantity, 
     data = Training.csv, 
     col = Training.csv$cluster, 
     main = "Customer Segmentation")


train_control <- trainControl(method = "cv", number = 5)

Training.csv  <- Training.csv %>% mutate(cluster = as.factor(cluster))

Training.csv  <- Training.csv %>% select(productId, quantity, cluster)

model_to_predict_clusters <-
  train(cluster ~ ., data = Training.csv, method = "svmRadial",
        metric = "Accuracy", trControl = train_control)



# Saving the k-means model
saveRDS(model_to_predict_clusters, "Training.csv")


# The saved model can then be loaded later
model_to_predict_clusters <- readRDS("Training.csv")


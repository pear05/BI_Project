# Load required packages
if (require("plumber")) {
  require("plumber")
} else {
  install.packages("plumber", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
# Load required packages
library(randomForest)
library(plumber)

# Load your saved Random Forest model
loaded_random_forest_model <- readRDS("Training.csv")

# Define the Plumber API endpoint for your model
# This assumes your Random Forest model is used for disease prediction

#* @apiTitle Disease Prediction Model API
#* @apiDescription Used to predict the disease based on symptoms.

#* @param Symptom_1 Value for Symptom 1
#* @param Symptom_2 Value for Symptom 2
#* @param Symptom_3 Value for Symptom 3
#* @param Symptom_4 Value for Symptom 4
#* @param Symptom_5 Value for Symptom 5
#* @param Symptom_6 Value for Symptom 6
#* @param Symptom_7 Value for Symptom 7
#* @param Symptom_8 Value for Symptom 8

#* @get /predict_disease

predict_disease <- function(Symptom_1, Symptom_2, Symptom_3, Symptom_4,
                            Symptom_5, Symptom_6, Symptom_7, Symptom_8) {
  # Create a data frame using the input symptoms
  input_data <- data.frame(
    Symptom_1 = as.numeric(Symptom_1),
    Symptom_2 = as.numeric(Symptom_2),
    Symptom_3 = as.numeric(Symptom_3),
    Symptom_4 = as.numeric(Symptom_4),
    Symptom_5 = as.numeric(Symptom_5),
    Symptom_6 = as.numeric(Symptom_6),
    Symptom_7 = as.numeric(Symptom_7),
    Symptom_8 = as.numeric(Symptom_8)
  )
  
  # Make a prediction based on the input data using the loaded Random Forest model
  predictions <- predict(loaded_random_forest_model, input_data)
  return(predictions)
}

# Run the plumber API
plumber::plumb("runplumber.R")$run(port=8000)
.libPaths()


lapply(.libPaths(), list.files)


if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# STEP 1. Install and load the required packages ----
## httr ----
if (require("httr")) {
  require("httr")
} else {
  install.packages("httr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## jsonlite ----
if (require("jsonlite")) {
  require("jsonlite")
} else {
  install.packages("jsonlite", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# STEP 2. Generate the URL required to access the API ----

# We set this as a constant port 5022 running on localhost
base_url <- "http://127.0.0.1:5022/"

# We create a named list called "params".
# It contains an element for each parameter we need to specify.
params <- list(arg_productId = 26, arg_quantity = 2)

query_url <- httr::modify_url(url = base_url, query = params)

# This is how the URL looks
# Note: You can go to the URL using a browser and as long as the API is running,
# you will get a response.
print(query_url)

# STEP 3. Make the request for the model prediction through the API ----
# The results of the model prediction through the API can also be obtained in R
model_prediction <- GET(query_url)

# Notice that the result displays additional JSON content, e.g., [[1]]
content(model_prediction)

# We can print the specific result as follows:
content(model_prediction)[[1]]

# However, the response still has some JSON content.

# STEP 4. Parse the response into the right format ----
# We need to extract the results from the default JSON list format into
# a non-list text format:
model_prediction_raw <- content(model_prediction, as = "text",
                                encoding = "utf-8")
jsonlite::fromJSON(model_prediction_raw)

# STEP 5. Enclose everything in a function ----


predict_cluster <- 
  function(arg_productId, arg_quantity) {
    base_url <- "http://127.0.0.1:5022/"
    
    params <- list(arg_productId = arg_productId, arg_quantity = arg_quantity)
    
    query_url <- modify_url(url = base_url, query = params)
    
    model_prediction <- GET(query_url)
    
    model_prediction_raw <- content(model_prediction, as = "text",
                                    encoding = "utf-8")
    
    jsonlite::fromJSON(model_prediction_raw)
  }

get_cluster_prediction(26, 2)



# This is used to split data. Change accordingly to switch your row names etc.
# You WILL need to do post processing! You need to go to excel and delete the row and column names!

library(data.table)
training <- read.csv("C:/Users/Shawn/Desktop/BioInformatics/Keras/Data_Files/Keras_Data/rao_huvec_10kb.prediction.csv", header = TRUE, stringsAsFactors = FALSE)
training <- data.frame(training)
training$class[training$class == "random"] <- "0" # Assigns 0 to the " " class
training$class[training$class == "real"] <- "1" # Assigns 1 to the " " class
training <- training[sample(nrow(training), nrow(training)), ] #randomizes the rows
smp_size <- floor(0.80 * nrow(training)) # .80 training/ .20 testing
train_ind <- sample(seq_len(nrow(training)), size = smp_size)
train <- training[train_ind, ]
test <- training[-train_ind, ]

# output files, be sure to delete the header and the first column in the output!
write.csv(train, file = "train_rao_huvec_10kb_prediction.csv")
write.csv(test, file = "test_rao_huvec_10kb_prediction.csv")

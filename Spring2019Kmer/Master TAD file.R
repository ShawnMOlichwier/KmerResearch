
############################################################################
# Read in our training and testing data
library(data.table)
training <- read.csv('https://raw.githubusercontent.com/OliShawn/KmerResearch/master/Spring2019Kmer/12merFiles/train_sequences_12mer_stride1_tokens.csv.count.csv',header = TRUE)
#training <- training[,names(training) != "DNA"] # use this line if you want to remove the 'name' of each row
training <- training[sample(nrow(training), nrow(training)), ] #randomizes the rows
training$class[training$class == "1"] <- "positive" # Assigns "Positive" to the 1 class
training$class[training$class == "0"] <- "negative" # Assigns 'Negative' to the 0 class
training$class <- factor(training$class)


#Preparing testing data
testing = read.csv("https://raw.githubusercontent.com/OliShawn/KmerResearch/master/Spring2019Kmer/12merFiles/test_sequences_12mer_stride1_tokens.csv.count.csv", header = TRUE)
#testing <- testing[,names(testing) != "DNA"] # use this line if you want to remove the 'name' of each row
testing <- testing[sample(nrow(testing), nrow(testing)), ] #randomizes the rows
testing$class[testing$class == "1"] <- "positive" # Assigns "Positive" to the 1 class
testing$class[testing$class == "0"] <- "negative" # Assigns 'Negative' to the 0 class
testing$class <- factor(testing$class)
#################################################################################

##############################################################################
# Libraries we need to use, majority use caret
suppressMessages(library(caret))
suppressMessages(library(e1071))


#############################################################################
#CARET Random Forest definition
do.RF <- function(training)
{  
  set.seed(313)
  n <- dim(training)[2]
  gridRF <- expand.grid(mtry = seq(from=0,by=as.integer(n/10),to=n)[-1]) #may need to change this depend on your data size
  ctrl.crossRF <- trainControl(method = "cv",number = 10,classProbs = TRUE,savePredictions = TRUE,allowParallel=TRUE)
  rf.Fit <- train(class ~ .,data = training,method = "rf",metric = "Accuracy",preProc = c("center", "scale"),
                  ntree = 200, tuneGrid = gridRF,trControl = ctrl.crossRF)
  rf.Fit
}

#training and testing
rf.Fit <- do.RF(training) #training done here
print(rf.Fit)

Pred <-  predict(rf.Fit,testing)#prediction on the testing set
cm <- confusionMatrix(Pred,testing$class)
print("CM for RF:") 
print(cm)
saveRDS(rf.Fit, "RF.Rds") #saves the model to an rds file
#############################################################################


#############################################################################
#CARET boosted trees definition
do.Boost <- function(training)
{ 
  #trials = number of boosting iterations, or (simply number of trees)
  #winnow = remove unimportant predictors
  gridBoost <- expand.grid(model="tree",trials=seq(from=1,by=2,to=100),winnow=FALSE)
  set.seed(1)
  ctrl.crossBoost <- trainControl(method = "cv",number = 10,classProbs = TRUE,savePredictions = TRUE,allowParallel=TRUE)
  C5.0.Fit <- train(class ~ .,data = training,method = "C5.0",metric = "Accuracy",preProc = c("center", "scale"),
                    tuneGrid = gridBoost,trControl = ctrl.crossBoost)
  
  C5.0.Fit
}
#training
boost.Fit <- do.Boost(training)
print(boost.Fit)

Pred <-  predict(boost.Fit,testing) #prediction on the testing set
cm <- confusionMatrix(Pred,testing$class)
print("CM for Boosted:")
print(cm)
saveRDS(boost.Fit, "Boost.rds") #saves the model to an rds file
############################################################################


############################################################################
#CARET KNN 
#controls
install.packages("knn", dependencies = TRUE)
grid = expand.grid(kmax=c(1:20),distance=2,kernel="optimal")
ctrl.cross <- trainControl(method="cv",number=10, classProbs=TRUE,savePredictions=TRUE)

#training
knnFit.cross <- train(class ~ .,
data = training, # training data
method ="kknn",  # model  
metric="Accuracy", #evaluation metric
preProc=c("center","scale"), # data to be scaled
tuneGrid = grid, # range of parameters to be tuned
trControl=ctrl.cross) # training controls
#print(knnFit.cross)
#plot(knnFit.cross)

#Testing
Pred <- predict(knnFit.cross,testing) #prediction on the testing set
cm<- confusionMatrix(Pred,testing$class)
print("CM for KNN:")
print(cm)
saveRDS(knnFit.cross, "KNN.rds") #saves the model to an rds file
#############################################################################


#############################################################################
#CARET Decision Tree:
#this is based on CARET, but sometimes doesn't run well, use the e1071 instead
do.DT <- function(training)
{
  set.seed(1)
  grid <- expand.grid(cp = 2^seq(from = -30 , to= 0, by = 2) )
  ctrl.cross <- trainControl(method = "cv", number = 5,classProbs = TRUE)
  dec_tree <-   train(class ~ ., data= Data,perProc = c("center", "scale"),
                      method = 'rpart', #rpart for classif. dec tree
                      metric ='Accuracy',
                      tuneGrid= grid, trControl = ctrl.cross
  )
  dec_tree
}
Pred <- predict(do.DT,testing) #prediction on the testing set
cm<- confusionMatrix(Pred,testing$class) #
print("CM for DT:")
print(cm)
saveRDS(do.DT, "DT.rds") #saves the model to an rds file
###############################################################################



################################################################################
#Regularization elastic-net logistic regression:
install.packages("glmnet", repos = "http://cran.us.r-project.org", dependencies = TRUE)
library(glmnet)
x <- training
x$class <- NULL
x <- as.matrix(x)
x
y <- training$class
y
logreg.fit = glmnet(x, y)

Pred <- predict(logreg.fit,testing)
cm<- confusionMatrix(Pred,testing$class)
print("CM for Log Reg:")
print(cm)
saveRDS(do.DT, "LogReg.rds") #saves the model to an rds file
############################################################################





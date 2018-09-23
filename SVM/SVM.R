
# Installilng the packages to be used, only run if it is the first time.
# install.packages("survival")
# install.packages("caret")
# install.packages("kknn")
# install.packages("e1071")


suppressMessages(library(kernlab))
suppressMessages(library(caret))
suppressMessages(library(e1071))

# building various training models with different kernels.
# -----------------------------------------------------------------------------------
# Radial svm from e1071
do.e1071RadialSVM <- function(training)
{
  svm.Fit <- tune.svm(class~., data = training, 
                      cost = 2^seq(from=-4,by = 1, to =6), # cost parameter
                      kernel = "radial", gamma=c(.5,1,2))  # gamma is the kernel parameter 'sigma' in CARET
  svm.Fit
}
# Radial basis kernel svm from CARET
do.RadialKernelSVM <- function(training)
{
  set.seed(1)
  tmpTraining <- training
  tmpTraining$class <- NULL
  sigma=sigest(as.matrix(tmpTraining)) # sigest returns 3 values of sigma 
  grid <- expand.grid(sigma = sigma , C = 2^seq(from=-4,by = 1, to =8)) # set up sigma and cost parameters
  ctrl.cross <- trainControl(method = "cv", number = 5,classProbs = TRUE,savePredictions=TRUE)
  svm.Fit <- train(class ~ ., data= training,perProc = c("center", "scale"),
                   method = 'svmRadial', 
                   metric ='Accuracy',
                   tuneGrid= grid,
                   trControl = ctrl.cross
  )
  svm.Fit
}
# Linear kernel svm
do.LinearKernelSVM <- function(training)
{
  set.seed(1)
  grid <- expand.grid(C = 2^seq(from=-4,by = 1, to =8)) # set up cost parameter. For linear svm it doesn't have kernel parameter.
  print("linear Kernel SVM")
  ctrl.cross <- trainControl(method = "cv", number = 5,classProbs = TRUE,savePredictions=TRUE)
  svm.Fit <- train(class ~ ., data= training,perProc = c("center", "scale"),
                   method = 'svmLinear', 
                   metric ='Accuracy',
                   tuneGrid= grid,
                   trControl = ctrl.cross
  )
  svm.Fit
}
# Polynomial kernel svm
do.PolyKernelSVM <- function(training)
{
  set.seed(1)
  grid <- expand.grid(scale = 1, degree = c(1,2,3), C = 2^seq(from=-4,by = 1, to =8)) # set up sigma and cost parameters
  print("Poly Kernel SVM") 
  ctrl.cross <- trainControl(method = "cv", number = 5,classProbs = TRUE,savePredictions=TRUE)
  svm.Fit <- train(class ~ ., data= training,perProc = c("center", "scale"),
                   method = 'svmPoly', 
                   metric ='Accuracy',
                   tuneGrid= grid, 
                   trControl = ctrl.cross
  )
  svm.Fit
}
# --------------------------------------------------------------------------------------------

# data1 <- read.table("C:/Users/Shawn/Documents/GitHub/KmerResearch/4merTable/Train/4mertable.train.txt",sep=",",header=T)
# head(data1)
# data1$Class <- factor(data1$Class)
suppressMessages(library(caret))
data1 <- read.table("C:/Users/Shawn/Documents/GitHub/KmerResearch/4merTable/Train/4mertable.train.txt",sep=",", header=TRUE)
data1$Class[1]
data1$Class <- factor(data1$Class, labels=c("negative","positive"))
#data1 <- as.matrix(sapply(data1, as.numeric))


# Why do we need to split the data if we already have a training and test set?
# intrain <- createDataPartition(y = data1$Class,p = 0.8,list = FALSE) #split data
# assign("training", data1[intrain,])
# assign("testing",  data1[-intrain,])

#fit svm models using the R functions defined above
svm.poly.Fit<-do.PolyKernelSVM(data1)
svm.linear.Fit<-do.LinearKernelSVM(data1)
svm.radial.Fit<-do.RadialKernelSVM(data1)
print(svm.linear.Fit)
print(svm.poly.Fit)
print(svm.radial.Fit)

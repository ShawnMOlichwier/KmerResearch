
# Installilng the packages to be used, only run if it is the first time.
# install.packages("survival")
# install.packages("caret")
# install.packages("kknn")
# install.packages("e1071")

# Here, we import the data(local) and relabel the
suppressMessages(library(caret))
data1 <- read.table("C:/Users/Shawn/Documents/GitHub/KmerResearch/4merTable/Train/4mertable.train.txt",sep=",", header=TRUE)
data1$Class[1]
data1$Class <- factor(data1$Class, labels=c("negative","positive"))
head(data1) # make sure everything looks ok. Is the last column the correct label?


# intrain <- createDataPartition(y = Data$Class,p = 0.8,list = FALSE) #split data
# assign("training", Data[intrain,])
# assign("testing",  Data[-intrain,])
# training[["Class"]] = factor(training[["Class"]]) #factor the label(class) column
# testing[["Class"]] = factor(testing[["Class"]])


suppressMessages(library(e1071))
#suppressMessages(library(doParallel)) # only if you want to perform parallel processing
#suppressMessages(registerDoParallel(10)) # Registrer a parallel backend for train

grid = expand.grid(kmax=c(1:20),distance=2,kernel="optimal")

ctrl.cross <- trainControl(method="cv",number=10,classProbs=TRUE,savePredictions=TRUE)

suppressMessages(library(kknn))
knnFit.cross <- train(Class ~ .,
                      data = data1, # training data
                      method ="kknn",  # model  
                      metric="Accuracy", #evaluation metric
                      preProc=c("center","scale"), # data to be scaled
                      tuneGrid = grid, # range of parameters to be tuned
                      trControl=ctrl.cross) # training controls

print(knnFit.cross)

plot(knnFit.cross)






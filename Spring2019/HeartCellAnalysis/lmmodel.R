library(dplyr)
library( broom )

# Import data
celldata <- read.csv("C:/Users/Shawn/Desktop/BioInformatics/Spring2019/Heart_Cell/CM_lncRNA_SuperEnhancer_matrix.csv", header = TRUE,  stringsAsFactors = FALSE)
celldata <- data.frame(celldata) # making our table a data.frame
celldata$class[celldata$class == "non_SE"] <- "0" # Assigns 0 to the " " class
celldata$class[celldata$class == "SE"] <- "1" # Assigns 1 to the " " class

#creating an empty data frame for our results
df <- data.frame(DNA=character(), 
                 zvalue=numeric(), 
                 pvalue=numeric(), 
                 stringsAsFactors=FALSE) 

#Loop for log reg of every varaible in the data table
for (i in seq(2, length(celldata)-2)){
    values <- numeric(0) #the temporary holder for our variables we will extract
    DNAcols <- colnames(celldata[i]) # the current name of our column we are analyzing
    tempdata = data.frame(celldata[length(celldata)], celldata[length(celldata)-1], celldata[i])
    tempdata$class = as.numeric(tempdata$class)
    colnames(tempdata) <- c("class", "GC", colnames(celldata[i]))
    model <- glm(class ~ ., family=binomial(link = "logit"),data=tempdata)
    test <- summary(model)
    
    # grabbing the p and z valeus from our iteration
    pvalue <- as.numeric(test$coefficients[,"Pr(>|z|)"][3])
    zvalue <- as.numeric(test$coefficients[,"z value"][3])
    
    # creating a subtable where class == 1, this will allow us to get the number of nonzero entries
    #  for our SE DNA strands
    SE <- filter(tempdata, class == 1)
    SEcount <- colSums(SE != 0)
    SEcount <- as.numeric(SEcount[3])
    
    # creating a subtable where class == 0, this will allow us to get the number of nonzero entries
    #  for our nonSE DNA strands
    nonSE <- filter(tempdata, class == 0)
    nonSEcount <- colSums(nonSE != 0)
    nonSEcount <- as.numeric(nonSEcount[3])
    
    # adding to values for this iteration and adding it to our results data frame (df)
    values <- append(values, DNAcols)
    values <- append(values, zvalue)
    values <- append(values, pvalue)
    values <- append(values, SEcount)
    values <- append(values, nonSEcount)
    values <- t(as.data.frame(values))
    df <- rbind.data.frame(df, values)
}


colnames(df) <- c("Gene", "Zvalue", "Pvalue", "SE_count", "non_SE_count")
write.csv(df, file = "C:\\Users\\Shawn\\Desktop\\BioInformatics\\Spring2019\\Heart_Cell\\lmmodel.csv")
#readrds("C:\\Users\\Shawn\\Desktop\\BioInformatics\\Spring2019\\Heart_Cell\\lmmodel.rds")

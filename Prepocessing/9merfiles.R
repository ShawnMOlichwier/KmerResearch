# Run these the first time if you need to install the biostrings library
Load the library Biostrings

source("https://bioconductor.org/biocLite.R")
biocLite("Biostrings")
# Run these the first time if you need to install the biostrings library
## Import the training file
library("Biostrings")
training.boundary = readDNAStringSet("dm3.kc167.tads.boundary.train.fa.txt")
training.inside = readDNAStringSet("dm3.kc167.tads.inside.train.fa.txt")
testing.boundary = readDNAStringSet("dm3.kc167.tads.boundary.test.fa.txt")
testing.inside = readDNAStringSet("dm3.kc167.tads.inside.test.fa.txt")


#Split file into 9mer
trainb.9mers = oligonucleotideFrequency(training.boundary, width = 9, step = 1, with.labels = TRUE)
rownames(trainb.9mers) <- labels(training.boundary)
trainb.9mers = data.frame(trainb.9mers) #convert matrix to data frame
trainb.9mers = cbind(trainb.9mers, rep(1, nrow(trainb.9mers)))
names(trainb.9mers)[length(trainb.9mers)] <- "Class"

testb.9mers = oligonucleotideFrequency(testing.boundary, width = 9, step = 1, with.labels = TRUE)
rownames(testb.9mers) <- labels(testing.boundary)
testb.9mers = data.frame(testb.9mers) #convert matrix to data frame
testb.9mers = cbind(testb.9mers, rep(0, nrow(testb.9mers)))
names(testb.9mers)[length(testb.9mers)] <- "Class"

testi.9mers = oligonucleotideFrequency(testing.inside, width = 9, step = 1, with.labels = TRUE)
rownames(testi.9mers) <- labels(testing.inside)
testi.9mers = data.frame(testi.9mers) #convert matrix to data frame
testi.9mers = cbind(testi.9mers, rep(0, nrow(testi.9mers)))
names(testi.9mers)[length(testi.9mers)] <- "Class"

traini.9mers = oligonucleotideFrequency(training.inside, width = 9, step = 1, with.labels = TRUE)
rownames(traini.9mers) <- labels(training.inside)
traini.9mers = data.frame(traini.9mers) #convert matrix to data frame
traini.9mers = cbind(traini.9mers, rep(1, nrow(traini.9mers)))
names(traini.9mers)[length(traini.9mers)] <- "Class"

train9mers <- rbind(trainb.9mers, traini.9mers)
test9mers <- rbind(testb.9mers, testi.9mers)


#Write the file out to text:

write.table(train9mers, file = "train_9mer.txt", row.names = TRUE, col.names = TRUE, sep = ',')
write.table(test9mers, file = "test_9mer.txt", row.names = TRUE, col.names = TRUE, sep = ',')

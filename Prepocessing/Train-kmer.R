
source("https://bioconductor.org/biocLite.R")

biocLite("Biostrings")

# Run these the first time if you need to install the biostrings library



library("Biostrings")

# Here we load the files that will run through the Kmer counting package. 

dna1 = readDNAStringSet("C:/Users/lykha/Documents/bioinformatic research/dataset/dm3.kc167.tads.boundary.test.fa")



# Pretty simple application for counting the Kmer Frequency. All of the heavy lifting

# is done in the biostrings library.

kmercounts = oligonucleotideFrequency(dna1, width = 4, step = 1, with.labels = TRUE)

rownames(kmercounts) <- labels(dna1)





#Put "1" as train data in a new column 

kmercounts = data.frame(kmercounts) #convert matrix to data frame
dim(kmercounts)

kmercounts = cbind(kmercounts, rep(1, 1000))

names(kmercounts)[length(kmercounts)] <- "Class" #rename the last column of the data frame
head(kmercounts)


# Finally, we output the matrix of Kmer counts to a text file, for later manipulation

write.table(kmercounts, file = "C:/Users/lykha/Documents/bioinformatic research/4mer/boundary.test.txt", row.names = TRUE, col.names = TRUE, sep = ',')


dna1 = readDNAStringSet("C:/Users/lykha/Documents/bioinformatic research/dataset/dm3.kc167.tads.inside.test.fa")



# Pretty simple application for counting the Kmer Frequency. All of the heavy lifting

# is done in the biostrings library.

kmercounts2 = oligonucleotideFrequency(dna1, width = 4, step = 1, with.labels = TRUE)

rownames(kmercounts2) <- labels(dna1)





#Put "1" as train data in a new column 

kmercounts2 = data.frame(kmercounts2) #convert matrix to data frame

kmercounts2 = cbind(kmercounts2, rep(0, 1000))

names(kmercounts2)[length(kmercounts2)] <- "Class" #rename the last column of the data frame
head(kmercounts2)


# Finally, we output the matrix of Kmer counts to a text file, for later manipulation

write.table(kmercounts, file = "C:/Users/lykha/Documents/bioinformatic research/4mer/inside.test.txt", row.names = TRUE, col.names = TRUE, sep = ',')
dim(kmercounts)
dim(kmercounts2)
train.table = rbind(kmercounts,kmercounts2)
write.table(train.table, file = "C:/Users/lykha/Documents/bioinformatic research/4mer/4mertable.test.txt", row.names = TRUE, col.names = TRUE, sep = ',')
head(train.table)

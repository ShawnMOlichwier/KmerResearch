
#source("https://bioconductor.org/biocLite.R")
#biocLite("Biostrings")

# Run these the first time if you need to install the biostrings library


library("Biostrings")
# Here we load the files that will run through the Kmer counting package. 
dna1 = readDNAStringSet("C:/Users/Shawn/Desktop/BioInformatics/Download_Files/dm3.kc167.tads.inside.test.fa")

# Pretty simple application for counting the Kmer Frequency. All of the heavy lifting
# is done in the biostrings library.
kmercounts = oligonucleotideFrequency(dna1, width = 4, step = 1, with.labels = TRUE)
rownames(kmercounts) <- labels(dna1)


#Put "1" as train data in a new column 
kmercounts = data.frame(kmercounts) #convert matrix to data frame
cbind(kmercounts, rep(1, 14070))
names(kmercounts)[length(kmercounts)] <- "Class" #rename the last column of the data frame

# Finally, we output the matrix of Kmer counts to a text file, for later manipulation
write.table(kmercounts, file = "C:/Users/Shawn/Desktop/BioInformatics/DNA_Text_Files/insideTest", row.names = TRUE, col.names = TRUE, sep = ' ')

#Extra:
kmercounts = read.table('C:/Users/lykha/Documents/Bioinformatics Research/4merTable/inside.train.txt', sep=',')
kmercounts = data.frame(kmercounts) #convert matrix to data frame
cbind(kmercounts, rep(0, 14070))
names(kmercounts)[length(kmercounts)] <- "Class" #rename the last column of the data frame

head(kmercounts)
#Export the file to excel
write.table(kmercounts, file = "C:/Users/lykha/Documents/Bioinformatics Research/4merTable/insideTrain.txt", sep = ',')

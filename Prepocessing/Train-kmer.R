#Install package BioStrings
source("https://bioconductor.org/biocLite.R")
biocLite("Biostrings")
library("Biostrings")

#Import .fa file to R using readDNAStringSet
dna1 = readDNAStringSet("C:/Users/lyv5/Downloads/dm3.kc167.tads.boundary.train.fa")

#Creating the kmer table using oligonucleotideFrequency
kmerscounts = oligonucleotideFrequency(dna1, width = 1000, step = 4)

#Using the dna sequence names as label in the kmer matrix
rownames(kmercounts) <- label(dna1) 

#Put "1" as train data in a new column 
kmercounts = data.frame(kmercounts) #convert matrix to data frame
cbind(kmercounts, rep(1, 14070))
names(kmercounts)[length(kmercounts)] <- "Class" #rename the last column of the data frame

#Export the file to text file
write.table(kmercounts, file = "C:/Users/lyv5/Desktop/BioInformatics/DNA_Text_Files/boundary.train.txt", row.names = TRUE, col.names = TRUE, sep = ',')

# Accurate prediction of boundaries of high resolution

Kmer Research in Python and R

Data: 4mer, 6mer, 9mer and 12mer motif split from fruit fly DNA for TAD prediction.

Link to raw dataset: https://www.ncbi.nlm.nih.gov/gene?Db=gene&Cmd=DetailsSearch&Term=31358

# Input:
Training csv file and testing csv file can be found in data folder.

# Models:
Master_file.R is the combined master code for all of our working models used for feature based prediction.

Package Requirements: R Caret e1071 C5.0 Glmnet Python 3.6 Keras

# All the feature-based machine learning models:

    KNN
    Decision Tree
    Random Forest
    Elastic Net Logistic Regression
    Boosted Tree

# Metrics recored:

    Accuracy
    Sensitivity
    Specifitivity
    F1 Score
    AUC
    Precision
    Recall

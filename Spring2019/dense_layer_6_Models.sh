#!/bin/bash
#SBATCH --job-name=dense_job_rao_gm_name
#SBATCH --output=dense.o.rao_gm.txt #output of your program prints here
#SBATCH --mail-user=shawnolich@gmail.com#email
#SBATCH --error=dense.e.rao_gm.txt #file where any error will be written
#SBATCH --mail-type=ALL

python DenseLayersNN_1_Layer_50_Nodes.py train_rao_gm12878_5kb_prediction.csv test_rao_gm12878_5kb_prediction.csv
python DenseLayersNN_1_Layer_100_Nodes.py train_rao_gm12878_5kb_prediction.csv test_rao_gm12878_5kb_prediction.csv
python DenseLayersNN_1_Layer_200_Nodes.py train_rao_gm12878_5kb_prediction.csv test_rao_gm12878_5kb_prediction.csv
#python DenseLayersNN_1_Layer_300_Nodes.py train_rao_gm12878_5kb_prediction.csv test_rao_gm12878_5kb_prediction.csv

python DenseLayersNN_2_Layer_50_Nodes.py train_rao_gm12878_5kb_prediction.csv test_rao_gm12878_5kb_prediction.csv
python DenseLayersNN_2_Layer_100_Nodes.py train_rao_gm12878_5kb_prediction.csv test_rao_gm12878_5kb_prediction.csv
python DenseLayersNN_2_Layer_200_Nodes.py train_rao_gm12878_5kb_prediction.csv test_rao_gm12878_5kb_prediction.csv
#python DenseLayersNN_2_Layer_300_Nodes.py train_rao_gm12878_5kb_prediction.csv test_rao_gm12878_5kb_prediction.csv

# We only need to change the training and testing data. This will run 6 different models
# and output the results to one output file.

# For convenient output, we also want to change:

# Job name to match the input files
# Output and Error name to match


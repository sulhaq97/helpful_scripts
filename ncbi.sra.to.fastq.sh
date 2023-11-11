#!/bin/bash

##############################################
# Written by Sami Ul Haq     
#                                            
# This script converts SRA to FASTQ files
##############################################

# the following are sbatch parameters
#SBATCH -t 12:00:00
#SBATCH -p himem
#SBATCH --mem=60G
#SBATCH -c 1
#SBATCH -N 1
#SBATCH -o %x-%j.out

module load sratoolkit/3.0.0

# iterate through each directory
for eacho in $(ls -d */)
do
echo "Working with $eacho"
fastq-dump $eacho --split-3 --skip-technical
echo "Done working with $eacho"
done



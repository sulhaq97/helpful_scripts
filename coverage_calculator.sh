#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH -p himem
#SBATCH --mem=60G
#SBATCH -c 1
#SBATCH -N 1
#SBATCH -o %x-%j.out

#################################
# This script takes as input a 	#
# bunch of BAM files		#
# and calculates coverage 	#
# for each BAM file		#
#################################
# Written by Sami Ul Haq	#
# Oct 15, 2020			#
#################################


module load samtools

# baseline cfDNA patients
cd "DIRECTORY_OF_INTEREST"

echo Calculating coverage 

for bamfile in $(ls *.bam)
do
echo Working with file: $bamfile
samtools depth -a $bamfile  |  awk '{sum+=$3} END { print "Average coverage (x) = ",sum/NR}'
echo \n\n
done



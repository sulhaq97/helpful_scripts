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
cd /cluster/projects/scottgroup/data/200725_A00827_0178_BHMVL3DRXX_Lok_Sami/cfDNA_MeDIP

echo Calculating coverage for baseline cfDNA samples 

for bamfile in $(ls *.bam)
do
echo Working with file: $bamfile
samtools depth -a $bamfile  |  awk '{sum+=$3} END { print "Average coverage (x) = ",sum/NR}'
echo \n\n
done


# baseline PBL patients
cd /cluster/projects/scottgroup/data/200725_A00827_0178_BHMVL3DRXX_Lok_Sami/PBL_baseline_MeDIP

echo Calculating coverage for baseline PBL samples

for bamfile in $(ls *.bam)
do
echo Working with file: $bamfile
samtools depth -a $bamfile  |  awk '{sum+=$3} END { print "Average coverage (x) = ",sum/NR}'
echo \n\n
done


# Sami healthy non cancer controls cfDNA
cd /cluster/projects/scottgroup/data/200725_A00827_0178_BHMVL3DRXX_Lok_Sami/Sami_Healthy_Donor_cfDNA

echo Calculating coverage for sami healthy non cancer controls cfDNA

for bamfile in $(ls *.bam)
do
echo Working with file: $bamfile
samtools depth -a $bamfile  |  awk '{sum+=$3} END { print "Average coverage (x) = ",sum/NR}'
echo \n\n
done



#!/bin/bash
# custom file for TH_4396_BASELINE.mkd.bam
#SBATCH -t 60:00:00
#SBATCH --mem=60GB
#SBATCH -p himem
#SBATCH -c 1
#SBATCH -N 1
#SBATCH -o %x-%j.out
 
module load gatk/4.2.5.0
module load igenome-human/hg19
module load java/8
module load samtools
module load picard
 
gatk Mutect2 -R /cluster/tools/data/genomes/human/hg19/iGenomes/Sequence/WholeGenomeFasta/genome.fa -I TH_4396_BASELINE.mkd.bam -I ../PBL_data/TH_4396_PBL.mkd.bam -normal TH_4396_PBL --max-mnp-distance 0 -L ../regions.coding_and_tss.bed --panel-of-normals /cluster/projects/lokgroup/gnomeAD_reference/somatic-b37_Mutect2-WGS-panel-b37.SAMI_RENAMED.vcf.gz --germline-resource /cluster/projects/lokgroup/gnomeAD_reference/af-only-gnomad.raw.sites.SAMI_RENAMED.vcf.gz -O TH_4396_BASELINE.mkd.bam.matched_normal.vcf.gz

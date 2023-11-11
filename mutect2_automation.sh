#!/bin/bash

# FINALIZED SCRIPT
# WRITTEN BY SAMI UL HAQ
# OCT 19 2019
# Revised: July 30, 2020 (by Sami Ul Haq)
# Revised: Feb 25, 2023 (by Sami Ul Haq)

# makes custom scripts for each sequencing sample for hybrid capture

# gets all unique file names
all_files=$(ls *bam | cut -d '_' -f 1,2,3)

#all_files=$(ls CDX*mkd.bam H*mkd.bam SBC*mkd.bam | cut -d '_' -f 1)

echo "Directory is: $(pwd)"

for f in $all_files
do
        echo Working with file id: $f
        echo Making file: $f.sh

        file_prefix=$(echo $f | cut -d '_' -f 1,2)
        echo File prefix is $file_prefix

        # makes the script file and adds shebang
        touch ${f}.sh
        echo '#!/bin/bash' > ${f}.sh
        echo "# custom file for $f" >> ${f}.sh
        # adds the sbatch parameters
        echo "#SBATCH -t 60:00:00" >> ${f}.sh
        echo "#SBATCH --mem=60GB" >> ${f}.sh
        echo "#SBATCH -p himem" >> ${f}.sh
        echo "#SBATCH -c 1" >> ${f}.sh
        echo "#SBATCH -N 1" >> ${f}.sh
        echo "#SBATCH -o %x-%j.out" >> ${f}.sh

        echo " " >> ${f}.sh

        echo "module load gatk/4.2.5.0" >> ${f}.sh
        echo "module load igenome-human/hg19" >> ${f}.sh
        echo "module load java/8" >> ${f}.sh
        echo "module load samtools" >> ${f}.sh
        echo "module load picard" >> ${f}.sh

        echo " " >> ${f}.sh
	
        echo "# BQSR calculation and application to improve sequencing errors" >> ${f}.sh
        echo "gatk BaseRecalibrator -I ${f}.mkd.bam -R /cluster/tools/data/genomes/human/hg19/iGenomes/Sequence/WholeGenomeFasta/genome.fa --known-sites /cluster/projects/lokgroup/gnomeAD_reference/af-only-gnomad.raw.sites.SAMI_RENAMED.vcf.gz -O ${f}.recal_data.table" >> ${f}.sh
        echo "gatk ApplyBQSR -I ${f}.mkd.bam -R /cluster/tools/data/genomes/human/hg19/iGenomes/Sequence/WholeGenomeFasta/genome.fa --bqsr-recal-file ${f}.recal_data.table -O ${f}.mkd.bqsr.bam" >> ${f}.sh
        echo "samtools index ${f}.mkd.bqsr.bam" >> ${f}.sh


        if [ -f "../PBL_data/${file_prefix}_PBL.mkd.bqsr.bam" ]; then
                echo "gatk Mutect2 -R /cluster/tools/data/genomes/human/hg19/iGenomes/Sequence/WholeGenomeFasta/genome.fa -I $f -I ../PBL_data/${file_prefix}_PBL.mkd.bqsr.bam -normal ${file_prefix}_PBL --max-mnp-distance 0 -L ../regions.coding_and_tss.bed --panel-of-normals /cluster/projects/lokgroup/gnomeAD_reference/somatic-b37_Mutect2-WGS-panel-b37.SAMI_RENAMED.vcf.gz --germline-resource /cluster/projects/lokgroup/gnomeAD_reference/af-only-gnomad.raw.sites.SAMI_RENAMED.vcf.gz -O ${f}.matched_normal.vcf.gz" >> ${f}.sh
        else
                echo "gatk Mutect2 -R /cluster/tools/data/genomes/human/hg19/iGenomes/Sequence/WholeGenomeFasta/genome.fa -I $f --max-mnp-distance 0 -L ../regions.coding_and_tss.bed --panel-of-normals /cluster/projects/lokgroup/gnomeAD_reference/somatic-b37_Mutect2-WGS-panel-b37.SAMI_RENAMED.vcf.gz --germline-resource /cluster/projects/lokgroup/gnomeAD_reference/af-only-gnomad.raw.sites.SAMI_RENAMED.vcf.gz -O $f.vcf.gz" >> ${f}.sh
        fi

done
echo "done making scripts!"

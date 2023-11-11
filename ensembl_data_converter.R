# This script converts .gff or .gvf data downloaded from ENSEMBL about genomic features
# and saves them as GRange objects
# The script also renames the chromosome names to "chr1" or "chr2" (originally: 1 or 2)
# Written by Sami Ul Haq

setwd("C:/Users/Sami/OneDrive - UHN/cfMeDIP/data/ENSEMBL Data")

library(GenomicRanges)
library(rtracklayer)

# data downloaded Jun-11-2021
# Using release-104

# homo_sapiens.GRCh38.Regulatory_Build.regulatory_features.20190329 = regulator features
# imported as GRange
regulatory.features.ensembl <- import.gff("homo_sapiens.GRCh38.Regulatory_Build.regulatory_features.20210107.gff")
table(regulatory.features.ensembl$feature_type)

# Need to rename chromosome from "1", "2" to "chr1", "chr2"
regulatory.features.ensembl <- data.frame(regulatory.features.ensembl)
# Subset to 1:22
regulatory.features.ensembl <- subset(regulatory.features.ensembl, regulatory.features.ensembl$seqnames %in% c(1:22))
regulatory.features.ensembl$seqnames <- paste0("chr", regulatory.features.ensembl$seqnames)
regulatory.features.ensembl <- GRanges(regulatory.features.ensembl)

save(regulatory.features.ensembl, file = "regulatory.features.RData")




# clinically associated variants (includes SNPs, indels)
clin.relevant.variants <- import.gff("homo_sapiens_clinically_associated.gvf")
table(clin.relevant.variants$type)

# Need to rename chromosome from "1", "2" to "chr1", "chr2"
clin.relevant.variants <- data.frame(clin.relevant.variants)
# Subset to 1:22
clin.relevant.variants <- subset(clin.relevant.variants, clin.relevant.variants$seqnames %in% c(1:22))
clin.relevant.variants$seqnames <- paste0("chr", clin.relevant.variants$seqnames)
clin.relevant.variants <- GRanges(clin.relevant.variants)

save(clin.relevant.variants, file="clinically.relevant.variants.RData")



# need non-coding genes
non.coding.gene.features <- import.gff3("Homo_sapiens.GRCh38.104.gff3")
table(all.gene.features$type)

# Need to rename chromosome from "1", "2" to "chr1", "chr2"
non.coding.gene.features <- data.frame(non.coding.gene.features)
# Subset to 1:22
non.coding.gene.features <- subset(non.coding.gene.features, non.coding.gene.features$seqnames %in% c(1:22))
non.coding.gene.features$seqnames <- paste0("chr", non.coding.gene.features$seqnames)
non.coding.gene.features <- GRanges(non.coding.gene.features)

save(non.coding.gene.features, file="non.coding.gene.features.RData")



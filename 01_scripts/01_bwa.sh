#!/bin/bash
# use bwa mem to map trimmed reads to reference library

###NOTE THIS SCRIPT REQUIRES THAT YOUR REFERENCE IS ALREADY INDEXED (bwa index REFERENCE)

# Also, note that this script assumes that you have removed adapters from your reads
# if necessary, can use the following git repo (overlappingReads) to use cutadapt to remove your adapters:
# https://github.com/bensutherland/overlappingReads

# global variables (note: point to REFERENCE)
INPUT_FOLDER="02_prepared_data"
#MAPPED_FOLDER="04_mapped"
REFERENCE="02_raw_data/Ssa_ASM_3.6.fasta"

# Map reads using bwa mem 
ls -1 $INPUT_FOLDER/*remadapt*.fastq.gz |
    perl -pe 's/R[12]\.fastq\.gz//' |
    sort -u |
    while read i
    do
        echo $i
        bwa mem -t 8 -T 30 $REFERENCE "$i"R1.fastq.gz "$i"R2.fastq.gz > "$i".aln.sam
        samtools view -Sb -F 4 > "$i".mapped_only.bam
        samtools sort "$i".mapped_only.bam $i
        samtools index $i.bam
    done

# clean up space
#rm ./$TRIMMED_FOLDER/*.sam ./$TRIMMED_FOLDER/*.unsorted.bam
#mv ./$TRIMMED_FOLDER/*.bam ./$TRIMMED_FOLDER/*.bam.bai ./$MAPPED_FOLDER/


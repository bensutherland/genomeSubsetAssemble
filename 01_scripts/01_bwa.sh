#!/bin/bash
# use bwa mem to map trimmed reads to reference library

###NOTE THIS SCRIPT REQUIRES THAT YOUR REFERENCE IS ALREADY INDEXED (bwa index REFERENCE)

# Also, note that this script assumes that you have removed adapters from your reads
# if necessary, can use the following git repo (overlappingReads) to use cutadapt to remove your adapters:
# https://github.com/bensutherland/overlappingReads

# global variables (note: point to REFERENCE)
INPUT_FOLDER="02_prepared_data"
#MAPPED_FOLDER="04_mapped"
REFERENCE="/project/lbernatchez/drobo/users/bensuth/00_resources/Ssa_ASM_3.6.fasta"

# note here that we keep only the mapped reads by using the -F 4 flag in samtools view


# Map reads using bwa mem 
ls -1 $INPUT_FOLDER/*.fastq.gz |
    perl -pe 's/R[12]\.fastq\.gz//' |
    sort -u |
    while read i
    do
        echo $i
        bwa mem -t 10 $REFERENCE "$i"R1.fastq.gz "$i"R2.fastq.gz > $i.sam
        samtools view -Sb -F 4 $i.sam > $i.mapped_only.bam
        samtools sort $i.mapped_only.bam $i.sorted.bam
        samtools index $i.sorted.bam
    done

# clean up space
#rm ./$TRIMMED_FOLDER/*.sam ./$TRIMMED_FOLDER/*.unsorted.bam
#mv ./$TRIMMED_FOLDER/*.bam ./$TRIMMED_FOLDER/*.bam.bai ./$MAPPED_FOLDER/


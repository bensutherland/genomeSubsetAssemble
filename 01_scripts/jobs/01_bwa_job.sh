#!/bin/bash
#$ -N bwa 
#$ -M your.email
#$ -m beas
#$ -pe smp 8
#$ -l h_vmem=80G
#$ -l h_rt=100:00:00
#$ -cwd
#$ -S /bin/bash

time ./01_scripts/01_bwa.sh


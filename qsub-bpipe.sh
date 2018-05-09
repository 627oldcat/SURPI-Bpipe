#!/bin/bash

#PBS -N bpipe
#PBS -V
#PBS -q normal
#PBS -l select=1:ncpus=24:mem=90G
#PBS -l walltime=24:00:00

cd $PBS_O_WORKDIR
bpipe run -r -n 1024 surpi.bpipe ./input/SRR1106123.fastq >run.log 2>&1
